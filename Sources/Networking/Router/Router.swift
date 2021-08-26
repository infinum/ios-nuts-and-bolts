//
//  Router.swift
//
//  Created by Filip Gulan on 10/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

/// Base API routing class containing shared logic for all routers.
/// For each new router, for example LoginRouter, just extend this
/// class and fill necessary data
open class Router: Routable {

    open var baseUrl: String
    open var path: String
    open var method: HTTPMethod
    open var headers: HTTPHeaders?
    open var encodableParams: [RequestEncodableParams]

    /// Creates Routable item with given parameters.
    ///
    /// Parameters are passed as EncodableParams in a way to enable
    /// different encoding combinations, e.g.: URL query and POST body
    ///
    /// - Parameters:
    ///   - baseUrl: Base URL
    ///   - path: Path
    ///   - method: Request method, .get by default
    ///   - headers: Request headers, nil by default
    ///   - encodableParams: Request parameters with corresponding encoding
    public init(
        baseUrl: String,
        path: String,
        method: HTTPMethod = .get,
        headers: HTTPHeaders? = nil,
        encodableParams: [RequestEncodableParams]
    ) {
        self.baseUrl = baseUrl
        self.path = path
        self.method = method
        self.headers = headers
        self.encodableParams = encodableParams
    }

    /// Creates Routable item with given parameters.
    ///
    /// - Parameters:
    ///   - baseUrl: Base URL
    ///   - path: Path
    ///   - method: Request method, .get by default
    ///   - headers: Request headers, nil by default
    ///   - parameters: Request parameters, nil by default
    ///   - encoding: Request encodings, [URLEncoding.default] by default
    public init(
        baseUrl: String,
        path: String,
        method: HTTPMethod = .get,
        headers: HTTPHeaders? = nil,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default
    ) {
        self.baseUrl = baseUrl
        self.path = path
        self.method = method
        self.headers = headers
        self.encodableParams = [EncodableParams(encoding: encoding, parameters: parameters)]
    }

    public init<Model: Encodable>(
        baseUrl: String,
        path: String,
        method: HTTPMethod = .get,
        headers: HTTPHeaders? = nil,
        parameters: Model? = nil,
        encoding: ParameterEncoder = URLEncodedFormParameterEncoder.default
    ) {
        self.baseUrl = baseUrl
        self.path = path
        self.method = method
        self.headers = headers
        self.encodableParams = [EncodableParamsCoder(encoding: encoding, parameters: parameters)]
    }
}

/// Convenience initializers which can be used if you have a base URL.
public extension Router {
//    convenience init(
//        path: String,
//        method: HTTPMethod = .get,
//        headers: HTTPHeaders? = nil,
//        encodableParams: EncodableParams...
//    ) {
//        self.init(
//            baseUrl: Constants.baseUrl,
//            path: path,
//            method: method,
//            headers: headers,
//            encodableParams: encodableParams
//        )
//    }

//    convenience init(
//        path: String,
//        method: HTTPMethod = .get,
//        headers: HTTPHeaders? = nil,
//        parameters: Parameters? = nil,
//        encoding: ParameterEncoding = URLEncoding.default
//    ) {
//        self.init(
//            baseUrl: Constants.baseUrl,
//            path: path,
//            method: method,
//            headers: headers,
//            parameters: parameters,
//            encoding: encoding
//        )
//    }
}
