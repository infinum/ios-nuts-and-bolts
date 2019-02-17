//
//  Service+Japx.swift
//  Catalog
//
//  Created by Filip Gulan on 16/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import Japx

public extension Service {

    func requestJSONAPI<T: Decodable>(
        _: T.Type,
        keyPath: String? = nil,
        includeList: String? = nil,
        decoder: JSONDecoder = JSONDecoder(),
        router: Router,
        sessionManager: SessionManager
    ) -> Single<T> {
        return sessionManager.rx.manager
            .map { $0.request(router) }
            .map { $0.validate() }
            .flatMap {
                $0.rx
                    .responseCodableJSONAPI(
                        includeList: includeList,
                        keyPath: keyPath,
                        decoder: JapxDecoder(jsonDecoder: decoder)
                )
        }
    }

}
