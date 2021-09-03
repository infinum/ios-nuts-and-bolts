//
//  JapxRxAlamofire.swift
//  Japx
//
//  Created by Vlaho Poluta on 25/01/2018.
//

#if canImport(Alamofire) && canImport(RxSwift)

import Foundation
import RxSwift
import Alamofire

#if !COCOAPODS
import Japx
import JapxAlamofire
#endif

/// Extension to add `Reactive` capabilities to `DataRequest`
extension DataRequest: ReactiveCompatible {}

/// Extension to add `Reactive` capabilities to `DownloadRequest`
extension DownloadRequest: ReactiveCompatible {}

extension Reactive where Base: DataRequest {
    
    /// Converts a parsed JSON:API object request to `Single`.
    ///
    /// - parameter queue:             The queue on which the completion handler is dispatched. Defaults to `.main` .
    /// - parameter includeList:       The include list for deserializing JSON:API relationships.
    /// - parameter options:           The options specifying how `JapxKit.Decoder` should decode JSON:API into JSON.
    ///
    /// - returns: `Single` of parsed JSON:API object.
    public func responseJSONAPI(
        queue: DispatchQueue = .main,
        includeList: String? = nil,
        options: JapxKit.Decoder.Options = .default
    ) -> Single<Parameters> {
        return Single<Parameters>.create { [weak base] (single) -> Disposable in
            let request = base?.responseJSONAPI(
                queue: queue,
                includeList: includeList,
                options: options
            ) { (response) in
                switch response.result {
                case .success(let value): single(.success(value))
                case .failure(let error): single(.failure(error))
                }
            }
            return Disposables.create { request?.cancel() }
        }
    }
}

extension Reactive where Base: DownloadRequest {
    
    /// Converts a parsed JSON:API object request to `Single`.
    ///
    /// - parameter queue:             The queue on which the completion handler is dispatched. Defaults to `.main` .
    /// - parameter includeList:       The include list for deserializing JSON:API relationships.
    /// - parameter options:           The options specifying how `JapxKit.Decoder` should decode JSON:API into JSON.
    ///
    /// - returns: `Single` of parsed JSON:API object.
    public func responseJSONAPI(
        queue: DispatchQueue = .main,
        includeList: String? = nil,
        options: JapxKit.Decoder.Options = .default
    ) -> Single<Parameters> {
        return Single<Parameters>.create { [weak base] (single) -> Disposable in
            let request = base?.responseJSONAPI(
                queue: queue,
                includeList: includeList,
                options: options
            ) { (response) in
                switch response.result {
                case .success(let value): single(.success(value))
                case .failure(let error): single(.failure(error))
                }
            }
            return Disposables.create { request?.cancel() }
        }
    }
}

#endif
