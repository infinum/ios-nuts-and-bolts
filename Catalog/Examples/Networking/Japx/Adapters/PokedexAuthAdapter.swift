//
//  PokedexAuthAdapter.swift
//  Catalog
//
//  Created by Mate Masnov on 03/12/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

public struct PokedexTokenAdapter: RequestInterceptor {
    
    private let authToken: String
    private let email: String

    init(authToken: String, email: String) {
        self.authToken = authToken
        self.email = email
    }
    
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.setValue(authorizationHeader, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
}

private extension PokedexTokenAdapter {
    
    var authorizationHeader: String {
        return String(format: "Token token=%@, email=%@", authToken, email)
    }
}
