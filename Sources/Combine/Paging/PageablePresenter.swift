//
//  PageablePresenter.swift
//  Catalog
//
//  Created by Antonijo Bezmalinovic on 10.01.2023..
//  Copyright (c) 2021 Infinum. All rights reserved.
//

import Foundation
import Combine

@available(iOS 13.0, *)
protocol PageablePresenter {
    
    /// Defines closures for implementator to implement
    typealias PageableResultClosure = (([Pageable], (any Page)?) -> AnyPublisher<any Page, PagingError>)
    typealias HasNextPageClosure = (([Pageable], (any Page)?) -> Bool)

    typealias Container = [Pageable]
    
    /// Defines interface for setting up pagination
    func setupPagination(
        nextPagePublisher: AnyPublisher<Void, Never>,
        reloadPublisher: AnyPublisher<Void, Never>,
        nextPage: @escaping PageableResultClosure,
        hasNextPage: @escaping HasNextPageClosure,
        startingWith: Container
    ) -> AnyPublisher<Container, PagingError>
}

@available(iOS 13.0, *)
extension PageablePresenter {
    
    /// Default generic pagination implementation
    func setupPagination(
        nextPagePublisher: AnyPublisher<Void, Never>,
        reloadPublisher: AnyPublisher<Void, Never>,
        nextPage: @escaping PageableResultClosure,
        hasNextPage: @escaping HasNextPageClosure,
        startingWith: Container = []
    ) -> AnyPublisher<Container, PagingError> {
        
        let items = page(
            loadNextPage: nextPagePublisher,
            reload: reloadPublisher,
            nextPage: nextPage,
            hasNextPage: hasNextPage,
            startingWith: startingWith
        )
        
        return items
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    func page(
        loadNextPage: AnyPublisher<Void, Never>,
        reload: AnyPublisher<Void, Never>,
        nextPage: @escaping PageableResultClosure,
        hasNextPage: @escaping HasNextPageClosure,
        startingWith: Container = []
    ) -> AnyPublisher<Container, PagingError> {
        
        let loadNewEvent = loadNextPage.map { _ in CombinePaging.Event<Container>.nextPage }
        let reloadEvent = reload.map { _ in CombinePaging.Event<Container>.reload }
        let events = CurrentValueSubject<CombinePaging.Event<Container>, Never>(.reload)
            .merge(with: loadNewEvent, reloadEvent)
            .eraseToAnyPublisher()
        
        let nextPage: (_ container: Container, _ lastPage: (any Page)?) -> AnyPublisher<any Page, PagingError> = { container, lastPage in
            return nextPage(container, lastPage)
        }
        
        let accumulator: (_ container: Container, _ page: (any Page)) -> Container = { container, page in
            return container + page.results as! [any Pageable]
        }
        
        let hasNext: (_ container: Container, _ lastPage: (any Page)) -> Bool = { container, lastPage in
            return hasNextPage(container, lastPage)
        }
        
        return CombinePaging
            .page(
                make: nextPage,
                startingWith: startingWith,
                joining: accumulator,
                while: hasNext,
                on: events
            )
            .map(\.container)
            .eraseToAnyPublisher()
    }
}
