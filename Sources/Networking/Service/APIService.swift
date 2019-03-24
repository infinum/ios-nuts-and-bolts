//
//  APIService.swift
//  Catalog
//
//  Created by Filip Gulan on 24/03/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire
import CodableAlamofire
import RxSwift

public protocol APIServiceable: class, ReactiveCompatible {

    func request<T: Decodable>(
        _: T.Type, keyPath: String?, decoder: JSONDecoder,
        router: Routable, sessionManager: SessionManager,
        completion: @escaping (Result<T>) -> ()
    ) -> DataRequest

    func requestCompletion(
        router: Routable,
        sessionManager: SessionManager,
        completion: @escaping (Result<Void>) -> ()
    ) -> DataRequest

}

open class APIService: APIServiceable {

    public static var instance = APIService()

    open func request<T: Decodable>(
        _: T.Type,
        keyPath: String? = nil,
        decoder: JSONDecoder = JSONDecoder(),
        router: Routable,
        sessionManager: SessionManager,
        completion: @escaping (Result<T>) -> ()
    ) -> DataRequest {
        return sessionManager
            .request(router)
            .validate()
            .responseDecodableObject { completion($0.result) }
    }

    open func requestCompletion(
        router: Routable,
        sessionManager: SessionManager,
        completion: @escaping (Result<Void>) -> ()
    ) -> DataRequest {
        return sessionManager
            .request(router)
            .validate()
            .response(completionHandler: {
                if let error = $0.error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            })
    }

}
