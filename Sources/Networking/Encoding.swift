//
//  Encoding.swift
//
//  Created by Filip Gulan on 10/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

public struct URLQueryEncoding: ParameterEncoding {
    
    private let _params: Parameters
    
    public init(params: Parameters) {
        _params = params
    }
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        return try URLEncoding.queryString.encode(urlRequest, with: _params)
    }
    
}

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
