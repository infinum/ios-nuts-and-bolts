//
//  Routable.swift
//  Catalog
//
//  Created by Filip Gulan on 24/03/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

/// Defines all data needed for making an API request
public protocol Routable: URLRequestConvertible {

    /// Base API url, e.g.: *htttps://www.google.com*
    var baseUrl: String { get }

    /// Path to requested resource, e.g.: *htttps://www.google.com/* **text**
    var path: String { get }

    /// Request method
    var method: HTTPMethod { get }

    /// Request parameters
    var params: Parameters? { get }

    /// Request headers
    var headers: HTTPHeaders? { get }

    /// Paremeter encodings. Add more than one if custom behaviour is needed.
    /// For example, if you have a POST request with body params and URL query items,
    /// you can create custom encoding for query items - to append them
    /// on requesting URL.
    var encoding: [ParameterEncoding] { get }
}

public extension Routable {

    func asURLRequest() throws -> URLRequest {
        let url = try _pathUrl()
        var request = try URLRequest(url: url, method: method, headers: headers)
        try encoding.forEach { request = try $0.encode(request, with: params) }
        return request
    }

}

private extension Routable {

    func _pathUrl() throws -> URL {
        /// Fully specified path wih base URL
        if path.starts(with: "http") {
            return try path.asURL()
        }
        /// If not, append path to current base URL
        return try baseUrl
            .asURL()
            .appendingPathComponent(path)
    }

}
