//
//  Service+Rx.swift
//  Catalog
//
//  Created by Filip Gulan on 16/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

public extension Service {

    func request<T: Decodable>(
        _: T.Type,
        keyPath: String? = nil,
        decoder: JSONDecoder = JSONDecoder(),
        router: Router,
        sessionManager: SessionManager
    ) -> Single<T> {
        return sessionManager.rx.manager
            .map { $0.request(router) }
            .map { $0.validate() }
            .flatMap { $0.rx.responseDecodableObject(keyPath: keyPath, decoder: decoder) }
    }

    func requestCompletion(
        router: Router,
        sessionManager: SessionManager
    ) -> Single<Void> {
        return sessionManager.rx.manager
            .map { $0.request(router) }
            .map { $0.validate() }
            .flatMap { $0.rx.response().andThen(Single.just(())) }
    }

}
