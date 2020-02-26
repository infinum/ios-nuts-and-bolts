//
//  JapxAlamofire.swift
//  Japx
//
//  Created by Vlaho Poluta on 25/01/2018.
//

import Alamofire
import Foundation

/// `JapxAlamofireError` is the error type returned by JapxAlamofire subspec.
public enum JapxAlamofireError: Error {
    
    /// - invalidKeyPath: Returned when a nested JSON object doesn't exist in parsed JSON:API response by provided `keyPath`.
    case invalidKeyPath(keyPath: String)
}

extension JapxAlamofireError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case let .invalidKeyPath(keyPath: keyPath): return "Nested JSON doesn't exist by keyPath: \(keyPath)."
        }
    }
}

extension DataRequest {

    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter queue:             The queue on which the completion handler is dispatched. Defaults to `.main` .
    /// - parameter includeList:       The include list for deserializing JSON:API relationships.
    /// - parameter options:           The options specifying how `Japx.Decoder` should decode JSON:API into JSON.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseJSONAPI(
        queue: DispatchQueue = .main,
        includeList: String? = nil,
        options: Japx.Decoder.Options = .default,
        completionHandler: @escaping (AFDataResponse<Parameters>) -> Void
    ) -> Self {
        return response(
            queue: queue,
            responseSerializer: JSONAPIResponseSerializer(includeList: includeList, options: options),
            completionHandler: completionHandler
        )
    }
}

extension DownloadRequest {

    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter queue:             The queue on which the completion handler is dispatched. Defaults to `.main` .
    /// - parameter includeList:       The include list for deserializing JSON:API relationships.
    /// - parameter options:           The options specifying how `Japx.Decoder` should decode JSON:API into JSON.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseJSONAPI(
        queue: DispatchQueue = .main,
        includeList: String? = nil,
        options: Japx.Decoder.Options = .default,
        completionHandler: @escaping (AFDownloadResponse<Parameters>) -> Void
    ) -> Self {
        return response(
            queue: queue,
            responseSerializer: JSONAPIResponseSerializer(includeList: includeList, options: options),
            completionHandler: completionHandler
        )
    }
}

public final class JSONAPIResponseSerializer: ResponseSerializer {
    
    public let includeList: String?
    public let options: Japx.Decoder.Options

    /// Creates an instance using the values provided.
    ///
    /// - Parameters:
    ///   - includeList:         The include list for deserializing JSON:API relationships.
    ///   - options:             The options specifying how `Japx.Decoder` should decode JSON:API into JSON.
    public init(
        includeList: String?,
        options: Japx.Decoder.Options
    ) {
        self.includeList = includeList
        self.options = options
    }
    
    public func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> Parameters {
        guard error == nil else { throw error! }
        
        guard var data = data, !data.isEmpty else {
            guard emptyResponseAllowed(forRequest: request, response: response) else {
                throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
            }
            
            return [:]
        }
        
        data = try dataPreprocessor.preprocess(data)
        
        do {
            return try Japx.Decoder.jsonObject(with: data, includeList: includeList, options: options)
        } catch {
            throw AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error))
        }
    }
}
