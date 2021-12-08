//
//  APIService+Combine.swift
//  Catalog
//
//  Created by Zvonimir Medak on 29.10.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import Foundation
import Combine
import Alamofire

@available(iOS 13, *)
public extension APIServiceable {

    func requestPublisher<T: Decodable>(
        _: T.Type,
        keyPath: String? = nil,
        decoder: JSONDecoder = JSONDecoder(),
        router: Routable,
        session: Session
    ) -> AnyPublisher<T, AFError> {
        return Future<T, AFError> { [unowned self] promise in
            request(
                T.self,
                keyPath: keyPath,
                decoder: decoder,
                router: router,
                session: session,
                completion: { promise($0) }
            )
        }.eraseToAnyPublisher()
    }

    func requestCompletablePublisher(
        router: Routable,
        session: Session
    ) -> AnyPublisher<Void, AFError> {
        return Future<Void, AFError> { [unowned self] promise in
            requestCompletion(
                router: router,
                session: session,
                completion: { promise($0.toCompletableResult) }
            )
        }
        .eraseToAnyPublisher()
    }
}
