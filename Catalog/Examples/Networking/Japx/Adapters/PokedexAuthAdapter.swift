//
//  PokedexAuthAdapter.swift
//  Catalog
//
//  Created by Mate Masnov on 03/12/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

public struct PokedexTokenAdapter: RequestAdapter {
    
    private let _authToken: String
    private let _email: String

    init(authToken: String, email: String) {
        _authToken = authToken
        _email = email
    }
    
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue(_authorizationHeader, forHTTPHeaderField: "Authorization")
        return urlRequest
    }
}

private extension PokedexTokenAdapter {
    
    var _authorizationHeader: String {
        return String(format: "Token token=%@, email=%@", _authToken, _email)
    }
}

