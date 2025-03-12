//
//  OAuthClientCredential.swift
//  Catalog
//
//  Created by Zvonimir Medak on 10.10.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Alamofire

public struct OAuthClientCredential: AuthenticationCredential {
    public let accessToken: String
    public let expiration: Date

    // Require refresh if within 5 minutes of expiration, set to time you require
    public var requiresRefresh: Bool { Date(timeIntervalSinceNow: 60 * 5) > expiration }
}
