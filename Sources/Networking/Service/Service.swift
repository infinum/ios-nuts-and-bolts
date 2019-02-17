//
//  Service.swift
//  Catalog
//
//  Created by Filip Gulan on 16/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

public final class Service {
    public static var instance = Service()
}

public extension Service {

    func request<T: Decodable>(
        _: T.Type,
        keyPath: String? = nil,
        decoder: JSONDecoder = JSONDecoder(),
        router: Router,
        sessionManager: SessionManager,
        completion: @escaping (Result<T>) -> ()
    ) -> DataRequest {
        return sessionManager
            .request(router)
            .validate()
            .responseDecodableObject { completion($0.result) }
    }

    func requestCompletion(
        router: Router,
        sessionManager: SessionManager,
        completion: @escaping () -> ()
    ) -> DataRequest {
        return sessionManager
            .request(router)
            .validate()
            .response(completionHandler: { _ in completion() })
    }

}
