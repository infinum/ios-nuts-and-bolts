//
//  TokenAdapter.swift
//  Catalog
//
//  Created by Filip Gulan on 16/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

public class TokenAdapter: RequestAdapter {

    private let _token: String

    public init(token: String) {
        _token = token
    }

    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue(_token, forHTTPHeaderField: "Authorization")
        return urlRequest
    }
}
