//
//  OAuthCredential.swift
//  Catalog
//
//  Created by Zvonimir Medak on 10.10.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Alamofire

public enum OAuthCredential {
    case user(_ credential: OAuthUserCredential)
    case client(_ credential: OAuthClientCredential)
}

// MARK: - Extensions -

// MARK: AuthenticationCredential confromance

extension OAuthCredential: AuthenticationCredential {

    public var accessToken: String {
        switch self {
        case .user(let credential):
            return credential.accessToken
        case .client(let credential):
            return credential.accessToken
        }
    }

    public var requiresRefresh: Bool {
        switch self {
        case .user(let credential):
            return credential.requiresRefresh
        case .client(let credential):
            return credential.requiresRefresh
        }
    }
}
