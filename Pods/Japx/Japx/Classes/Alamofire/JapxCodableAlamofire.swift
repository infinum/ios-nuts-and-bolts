//
//  JapxCodableAlamofire.swift
//  Japx
//
//  Created by Vlaho Poluta on 25/01/2018.
//

#if canImport(Alamofire)

import Foundation
import Alamofire

#if !COCOAPODS
import Japx
#endif

extension DataRequest {
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter queue:             The queue on which the completion handler is dispatched. Defaults to `.main` .
    /// - parameter includeList:       The include list for deserializing JSON:API relationships.
    /// - parameter keyPath:           The keyPath where object decoding on parsed JSON should be performed.
    /// - parameter decoder:           The decoder that performs the decoding on parsed JSON into requested type.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseCodableJSONAPI<T: Decodable>(
        queue: DispatchQueue = .main,
        includeList: String? = nil,
        keyPath: String? = nil,
        decoder: JapxDecoder = JapxDecoder(),
        completionHandler: @escaping (AFDataResponse<T>) -> Void
    ) -> Self {
        return response(
            queue: queue,
            responseSerializer: DecodableJSONAPIResponseSerializer(includeList: includeList, keyPath: keyPath, decoder: decoder),
            completionHandler: completionHandler
        )
    }
}

extension DownloadRequest {

    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter queue:             The queue on which the completion handler is dispatched. Defaults to `.main` .
    /// - parameter includeList:       The include list for deserializing JSON:API relationships.
    /// - parameter keyPath:           The keyPath where object decoding on parsed JSON should be performed.
    /// - parameter decoder:           The decoder that performs the decoding on parsed JSON into requested type.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseCodableJSONAPI<T: Decodable>(
        queue: DispatchQueue = .main,
        includeList: String? = nil,
        keyPath: String? = nil,
        decoder: JapxDecoder = JapxDecoder(),
        completionHandler: @escaping (AFDownloadResponse<T>) -> Void
    ) -> Self {
        return response(
            queue: queue,
            responseSerializer: DecodableJSONAPIResponseSerializer(includeList: includeList, keyPath: keyPath, decoder: decoder),
            completionHandler: completionHandler
        )
    }
}

public final class DecodableJSONAPIResponseSerializer<T: Decodable>: ResponseSerializer {
    
    public let includeList: String?
    public let keyPath: String?
    public let decoder: JapxDecoder

    /// Creates an instance using the values provided.
    ///
    /// - Parameters:
    ///   - includeList:    The include list for deserializing JSON:API relationships.
    ///   - keyPath:        The keyPath where object decoding on parsed JSON should be performed.
    ///   - decoder:        The `DataDecoder`. `JapxDecoder()` by default.
    public init(
        includeList: String?,
        keyPath: String?,
        decoder: JapxDecoder
    ) {
        self.includeList = includeList
        self.keyPath = keyPath
        self.decoder = decoder
    }

    public func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> T {
        guard error == nil else { throw error! }
        
        guard let validData = data, validData.count > 0 else {
            throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
        }

        do {
            guard let keyPath = keyPath, !keyPath.isEmpty else  {
                return try decoder.decode(T.self, from: validData, includeList: includeList)
            }
            
            let json = try JapxKit.Decoder.jsonObject(with: validData, includeList: includeList, options: decoder.options)
            guard let jsonForKeyPath = (json as AnyObject).value(forKeyPath: keyPath) else {
                throw JapxAlamofireError.invalidKeyPath(keyPath: keyPath)
            }
            let data = try JSONSerialization.data(withJSONObject: jsonForKeyPath, options: .init(rawValue: 0))
            
            return try decoder.jsonDecoder.decode(T.self, from: data)
        } catch {
            throw AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error))
        }
    }
}

#endif
