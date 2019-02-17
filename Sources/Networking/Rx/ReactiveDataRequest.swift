//
//  ReactiveDataRequest.swift
//
//  Created by Filip Gulan on 16/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import CodableAlamofire

public extension Reactive where Base == DataRequest {

    func responseDecodableObject<T: Decodable>(
        queue: DispatchQueue? = nil,
        keyPath: String? = nil,
        decoder: JSONDecoder = JSONDecoder()
    ) -> Single<T> {
        return Single<T>
            .create { [weak base] single -> Disposable in
                let request = base?
                    .responseDecodableObject(
                        queue: queue,
                        keyPath: keyPath,
                        decoder: decoder,
                        completionHandler: { (response: DataResponse<T>) in
                            switch response.result {
                            case .success(let value): single(.success(value))
                            case .failure(let error): single(.error(error))
                            }
                    }
                )
                return Disposables.create { request?.cancel() }
            }
    }

    func response(queue: DispatchQueue? = nil) -> Completable {
        return Completable
            .create { [weak base] (completable) -> Disposable in
                let request = base?
                    .response(
                        queue: queue,
                        completionHandler: { (response) in
                            if let error = response.error {
                                completable(.error(error))
                            } else {
                                completable(.completed)
                            }
                    }
                )
                
                return Disposables.create { request?.cancel() }
        }
    }
}

extension SessionManager: ReactiveCompatible {}
public extension Reactive where Base == SessionManager {

    var manager: Single<SessionManager> {
        return Single.just(base)
    }

}
