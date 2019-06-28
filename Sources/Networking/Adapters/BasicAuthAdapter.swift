//
//  BasicAuthAdapter.swift
//
//  Created by Filip Gulan on 24/04/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

/// Adapter used for Basic authentication
public struct BasicAuthAdapter: RequestAdapter {

    private let _username: String
    private let _password: String

    /// Adapter used for Basic authentication
    ///
    /// - Parameters:
    ///   - username: Username or email
    ///   - password: Password
    init(username: String, password: String) {
        _username = username
        _password = password
    }

    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        guard let data = "\(_username):\(_password)".data(using: .utf8) else {
            return urlRequest
        }
        var urlRequest = urlRequest
        let credential = data.base64EncodedString(options: [])
        urlRequest.setValue("Basic \(credential)", forHTTPHeaderField: Headers.Key.authorization)
        return urlRequest
    }
}

