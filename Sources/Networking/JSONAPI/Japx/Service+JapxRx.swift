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
        decoder: JapxDecoder = JapxDecoder(jsonDecoder: .init()),
        router: Routable,
        session: Session,
        completion: @escaping (AFResult<T>) -> ()
    ) -> DataRequest {
        return prepareRequest(for: router, session: session)
            .responseCodableJSONAPI(
                includeList: includeList,
                keyPath: keyPath,
                decoder: decoder,
                completionHandler: { completion($0.result) }
            )
    }

}

public extension Reactive where Base: APIServiceable {

    func requestJSONAPI<T: Decodable>(
        _: T.Type,
        includeList: String? = nil,
        keyPath: String? = nil,
        decoder: JapxDecoder = JapxDecoder(jsonDecoder: .init()),
        router: Routable,
        session: Session
    ) -> Single<T> {
        return Single<T>
            .create { [weak base] single -> Disposable in
                let processResult = { (result: AFResult<T>) in
                    single(result.toSingleEvent)
                }
                let request = base?.requestJSONAPI(
                    T.self,
                    includeList: includeList,
                    keyPath: keyPath,
                    decoder: decoder,
                    router: router,
                    session: session,
                    completion: processResult
                )                
                return Disposables.create { request?.cancel() }
        }
    }

}
