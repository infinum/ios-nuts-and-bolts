//
//  APIService.swift
//
//  Created by Filip Gulan on 24/03/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire
import CodableAlamofire
import RxSwift

/// Base protocol for API networking communication.
public protocol APIServiceable: class {

    @discardableResult
    func request<T: Decodable>(
        _: T.Type,
        keyPath: String?,
        decoder: JSONDecoder,
        router: Routable,
        sessionManager: SessionManager,
        completion: @escaping (Result<T>) -> ()
    ) -> DataRequest

    @discardableResult
    func requestCompletion(
        router: Routable,
        sessionManager: SessionManager,
        completion: @escaping (Result<Void>) -> ()
    ) -> DataRequest

}

/// Base API service class containing shared logic for all API calls
open class APIService: APIServiceable {

    public static var instance = APIService()

    @discardableResult
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
            .responseDecodableObject(keyPath: keyPath, decoder: decoder) { completion($0.result) }
    }

    @discardableResult
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

///
/// NB: If you don't use Rx in your project, just remove `ReactiveCompatible`
/// protocol conformance
extension APIService: ReactiveCompatible { }
