//
//  ClientAuthenticatedModel.swift
//  Catalog
//
//  Created by Zvonimir Medak on 10.10.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Foundation

// Example ClientModel
public struct ClientAuthenticatedModel: Decodable {
    let accessToken: String
    let tokenType: String
    let expiresIn: TimeInterval
}
