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

/// Base protocol for API networking communication.
///
/// NB: If you don't use Rx in your project, just remove `ReactiveCompatible`
/// protocol conformance (it is not possible for protocol to conform
/// to another protocol via extension, only in protocol declaration)
public protocol APIServiceable: class, ReactiveCompatible {

    func request<T: Decodable>(
        _: T.Type,
        keyPath: String?,
        decoder: JSONDecoder,
        router: Routable,
        sessionManager: SessionManager,
        completion: @escaping (Result<T>) -> ()
    ) -> DataRequest

    func requestCompletion(
        router: Routable,
        sessionManager: SessionManager,
        completion: @escaping (Result<Void>) -> ()
    ) -> DataRequest

}

/// Base API service class containing shared logic for all API calls
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
