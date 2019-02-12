//
//  Router.swift
//
//  Created by Filip Gulan on 10/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

public struct Router: URLRequestConvertible {
    
    private let _base: String
    private let _path: String
    private let _method: HTTPMethod
    private let _params: Parameters?
    private let _headers: HTTPHeaders?
    private let _encoding: [ParameterEncoding]
    
    public init(
        base: String,
        path: String,
        method: HTTPMethod = .get,
        params: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        encoding: [ParameterEncoding] = [URLEncoding.default]
    ) {
        _base = base
        _path = path
        _method = method
        _params = params
        _headers = headers
        _encoding = encoding
    }
    
/// Insert your base URL here
//    public init(
//        path: String,
//        method: HTTPMethod = .get,
//        params: Parameters? = nil,
//        headers: HTTPHeaders? = nil
//        encoding: [ParameterEncoding] = [URLEncoding.default],
//    ) {
//        self.init(
//            base: Constants.baseUrl,
//            path: path, method: method, params: params,
//            headers: headers, encoding: encoding
//        )
//    }

    public func asURLRequest() throws -> URLRequest {
        let url = try _pathURL()
        var request = try URLRequest(url: url, method: _method, headers: _headers)
        try _encoding.forEach { request = try $0.encode(request, with: _params) }
        return request
    }
    
}

private extension Router {

    func _pathURL() throws -> URL {
        if _path.starts(with: "http") {
            return try _path.asURL()
        }
        return try _base
            .asURL()
            .appendingPathComponent(_path)
    }

}
