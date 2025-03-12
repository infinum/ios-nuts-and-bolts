//
//  UserAuthenticatedModel.swift
//  Catalog
//
//  Created by Zvonimir Medak on 10.10.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Foundation

// Example User model
public struct UserAuthenticatedModel: Decodable {
    public let refreshToken: String
    public let accessToken: String
    public let expiresIn: TimeInterval
}
