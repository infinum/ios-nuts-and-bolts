//
//  Observable+TakeUntil.swift
//
//  Created by Filip Gulan on 03/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import RxSwift

public extension ObservableType {
    
    /// Behaves like `take(n)`, but with predicate rather then a fixed number of next events.
    /// It will complete once predicate returns `false`.
    ///
    /// - Parameter predicate: Predicate function that will decide if we should continue or complete
    /// - Returns: Observable of type `E`.
    func takeUntil(predicate: @escaping (E) -> Bool) -> Observable<E> {
        return Observable.create { observer in
            return self.subscribe { event in
                switch event {
                case .next(let value):
                    observer.on(.next(value))
                    if !predicate(value) {
                        observer.on(.completed)
                    }
                case .error(let error):
                    observer.on(.error(error))
                case .completed:
                    observer.on(.completed)
                }
            }
        }
    }
    
}
