//
//  Service+Japx.swift
//
//  Created by Filip Gulan on 16/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import Japx

public extension APIServiceable {

    func requestJSONAPI<T: Decodable>(
        _: T.Type,
        includeList: String? = nil,
        keyPath: String? = nil,
        decoder: JSONDecoder = JSONDecoder(),
        router: Routable,
        sessionManager: SessionManager,
        completion: @escaping (Result<T>) -> ()
    ) -> DataRequest {
        return sessionManager
            .request(router)
            .validate()
            .responseCodableJSONAPI(
                includeList: includeList,
                keyPath: keyPath,
                decoder: JapxDecoder(jsonDecoder: decoder),
                completionHandler: { completion($0.result) }
            )
    }

}

public extension Reactive where Base: APIServiceable {

    func requestJSONAPI<T: Decodable>(
        _: T.Type,
        includeList: String? = nil,
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
                    .requestJSONAPI(
                        T.self,
                        includeList: includeList,
                        keyPath: keyPath,
                        decoder: decoder,
                        router: router,
                        sessionManager: sessionManager,
                        completion: processResult
                    )
                
                return Disposables.create { request?.cancel() }
        }
    }

}
