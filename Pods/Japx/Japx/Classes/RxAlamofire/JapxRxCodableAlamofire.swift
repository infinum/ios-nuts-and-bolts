//
//  RxCodableAlamofire.swift
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

extension Reactive where Base: DataRequest {
    
    /// Converts a parsed and decoded JSON:API object request to `Single` of requested type.
    ///
    /// - parameter queue:             The queue on which the completion handler is dispatched. Defaults to `.main` .
    /// - parameter includeList:       The include list for deserializing JSON:API relationships.
    /// - parameter keyPath:           The keyPath where object decoding on parsed JSON should be performed.
    /// - parameter decoder:           The decoder that performs the decoding on parsed JSON into requested type.
    ///
    /// - returns: `Single` of parsed and decoded JSON:API object of requested type.
    public func responseCodableJSONAPI<T: Decodable>(
        queue: DispatchQueue = .main,
        includeList: String? = nil,
        keyPath: String? = nil,
        decoder: JapxDecoder = JapxDecoder()
    ) -> Single<T> {
        return Single<T>.create { [weak base] (single) -> Disposable in
            let request = base?.responseCodableJSONAPI(
                queue: queue,
                includeList: includeList, keyPath: keyPath,
                decoder: decoder
            ) { (response: AFDataResponse<T>) in
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

    /// Converts a parsed and decoded JSON:API object request to `Single` of requested type.
    ///
    /// - parameter queue:             The queue on which the completion handler is dispatched. Defaults to `.main` .
    /// - parameter includeList:       The include list for deserializing JSON:API relationships.
    /// - parameter keyPath:           The keyPath where object decoding on parsed JSON should be performed.
    /// - parameter decoder:           The decoder that performs the decoding on parsed JSON into requested type.
    ///
    /// - returns: `Single` of parsed and decoded JSON:API object of requested type.
    public func responseCodableJSONAPI<T: Decodable>(
        queue: DispatchQueue = .main,
        includeList: String? = nil,
        keyPath: String? = nil,
        decoder: JapxDecoder = JapxDecoder()
    ) -> Single<T> {
        return Single<T>.create { [weak base] (single) -> Disposable in
            let request = base?.responseCodableJSONAPI(
                queue: queue,
                includeList: includeList,
                keyPath: keyPath,
                decoder: decoder
            ) { (response: AFDownloadResponse<T>) in
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
