//
//  JapxRxAlamofire.swift
//  Japx
//
//  Created by Vlaho Poluta on 25/01/2018.
//

import RxSwift
import Alamofire
import Foundation

/// Extension to add `Reactive` capabilities to `DataRequest`
extension DataRequest: ReactiveCompatible {}

/// Extension to add `Reactive` capabilities to `DownloadRequest`
extension DownloadRequest: ReactiveCompatible {}

extension Reactive where Base: DataRequest {
    
    /// Converts a parsed JSON:API object request to `Single`.
    ///
    /// - parameter queue:             The queue on which the completion handler is dispatched.
    /// - parameter includeList:       The include list for deserializing JSON:API relationships.
    ///
    /// - returns: `Single` of parsed JSON:API object.
    public func responseJSONAPI(queue: DispatchQueue? = nil, includeList: String? = nil) -> Single<Parameters> {
        
        return Single<Parameters>.create { [weak base] (single) -> Disposable in
            let request = base?.responseJSONAPI(queue: queue, includeList: includeList) { (response) in
                switch response.result {
                case .success(let value): single(.success(value))
                case .failure(let error): single(.error(error))
                }
            }
            return Disposables.create { request?.cancel() }
        }
    }
}

extension Reactive where Base: DownloadRequest {
    
    /// Converts a parsed JSON:API object request to `Single`.
    ///
    /// - parameter queue:             The queue on which the completion handler is dispatched.
    /// - parameter includeList:       The include list for deserializing JSON:API relationships.
    ///
    /// - returns: `Single` of parsed JSON:API object.
    public func responseJSONAPI(queue: DispatchQueue? = nil, includeList: String? = nil) -> Single<Parameters> {
        
        return Single<Parameters>.create { [weak base] (single) -> Disposable in
            let request = base?.responseJSONAPI(queue: queue, includeList: includeList) { (response) in
                switch response.result {
                case .success(let value): single(.success(value))
                case .failure(let error): single(.error(error))
                }
            }
            return Disposables.create { request?.cancel() }
        }
    }
}
