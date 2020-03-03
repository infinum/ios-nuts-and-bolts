//
//  TokenAdapter.swift
//
//  Created by Filip Gulan on 16/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

/// Adapter used for token-based authentication
public struct TokenAdapter: RequestInterceptor {

    private let token: String

    /// Adapter used for token-based authentication
    ///
    /// - Parameter token: Authorization token
    public init(token: String) {
        self.token = token
    }
    
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.setHeader(.authorization(token))
        completion(.success(urlRequest))
    }
}
