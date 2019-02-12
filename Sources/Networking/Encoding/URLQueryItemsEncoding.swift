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
/// add custom query parameters to the url.
public struct URLQueryItemsEncoding: ParameterEncoding {

    private let _items: [URLQueryItem]

    public init(items: [URLQueryItem]) {
        _items = items
    }

    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var newRequest = try urlRequest.asURLRequest()
        newRequest.url = try newRequest.url?.append(_items)
        return newRequest
    }

}
