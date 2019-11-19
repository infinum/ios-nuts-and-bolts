//
//  URLQueryItemsEncoding.swift
//
//  Created by Filip Gulan on 12/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

/// Appends given query items to query part of the URL.
/// Useful when you have POST request with JSON body but you also need to
/// add custom query items to the url.
public struct URLQueryItemsEncoding: ParameterEncoding {
    
    public static var `default`: URLQueryItemsEncoding { return URLQueryItemsEncoding() }

    public init() { }

    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var newRequest = try urlRequest.asURLRequest()
        if let params = parameters {
            newRequest.url = newRequest.url?.appendingQueryParameters(params)
        }
        return newRequest
    }

}
