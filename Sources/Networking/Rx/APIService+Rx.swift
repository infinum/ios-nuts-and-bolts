//
//  APIService+Rx.swift
//
//  Created by Filip Gulan on 24/03/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

public extension Reactive where Base: APIServiceable {

    func request<T: Decodable>(
        _: T.Type,
        keyPath: String? = nil,
        decoder: JSONDecoder = JSONDecoder(),
        router: Routable,
        sessionManager: SessionManager
    ) -> Single<T> {
        return Single<T>
            .create { [weak base] single -> Disposable in
                let processResult = { (result: Result<T>) in
                    single(result.mapToRxSingleEvent())
                }
                
                let request = base?
                    .request(
                        T.self,
                        keyPath: keyPath,
                        decoder: decoder,
                        router: router,
                        sessionManager: sessionManager,
                        completion: processResult
                    )
                
                return Disposables.create { request?.cancel() }
        }
    }

    func requestCompletion(
        router: Routable,
        sessionManager: SessionManager
    ) -> Completable {
        return Completable
            .create { [weak base] completable -> Disposable in
                let processResult = { (result: Result<Void>) in
                    completable(result.mapToRxCompletableEvent())
                }
                
                let request = base?
                    .requestCompletion(
                        router: router,
                        sessionManager: sessionManager,
                        completion: processResult
                    )
                
                return Disposables.create { request?.cancel() }
        }
    }

}

extension Result {

    func mapToRxSingleEvent() -> SingleEvent<Value> {
        switch self {
        case .success(let value):
            return SingleEvent.success(value)
        case .failure(let error):
            return SingleEvent.error(error)
        }
    }

    func mapToRxCompletableEvent() -> CompletableEvent {
        switch self {
        case .success:
            return CompletableEvent.completed
        case .failure(let error):
            return CompletableEvent.error(error)
        }
    }

}
