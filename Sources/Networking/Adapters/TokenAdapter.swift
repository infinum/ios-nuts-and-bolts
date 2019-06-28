//
//  TokenAdapter.swift
//
//  Created by Filip Gulan on 16/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

/// Adapter used for token-based authentication
public struct TokenAdapter: RequestAdapter {

    private let _token: String

    /// Adapter used for token-based authentication
    ///
    /// - Parameter token: Authorization token
    public init(token: String) {
        _token = token
    }

    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue(_token, forHTTPHeaderField: Headers.Key.authorization)
        return urlRequest
    }
}
