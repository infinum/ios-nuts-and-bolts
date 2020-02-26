//
//  BasicAuthAdapter.swift
//
//  Created by Filip Gulan on 24/04/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

/// Adapter used for Basic authentication
public struct BasicAuthAdapter: RequestInterceptor {

    private let _username: String
    private let _password: String

    /// Adapter used for Basic authentication
    ///
    /// - Parameters:
    ///   - username: Username or email
    ///   - password: Password
    public init(username: String, password: String) {
        _username = username
        _password = password
    }

    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.setHeader(.authorization(username: _username, password: _password))
        completion(.success(urlRequest))
    }
}

