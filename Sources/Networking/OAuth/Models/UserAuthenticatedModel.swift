//
//  UserAuthenticatedModel.swift
//  Catalog
//
//  Created by Zvonimir Medak on 10.10.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Foundation

// Example User model
struct UserAuthenticatedModel: Decodable {
    let refreshToken: String
    let accessToken: String
    let expiresIn: TimeInterval
}
