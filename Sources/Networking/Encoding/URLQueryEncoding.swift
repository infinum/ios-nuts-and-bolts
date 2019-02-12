//
//  URLQueryEncoding.swift
//
//  Created by Filip Gulan on 12/02/2019.
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
