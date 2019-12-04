//
//  User.swift
//  Catalog
//
//  Created by Mate Masnov on 02/12/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Japx

struct PokedexUser: JapxCodable {
    let id: String
    let type: String = "users"

    let email: String?
    let username: String?
    let password: String?
    let passwordConfirmation: String?
    let authToken: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case email
        case username
        case password
        case passwordConfirmation = "password_confirmation"
        case authToken = "auth-token"
    }
    
    init(id: String, email: String?, username: String? = nil, password: String? = nil, passwordConfirmation: String? = nil, authToken: String? = nil) {
        self.id = id
        self.email = email
        self.username = username
        self.password = password
        self.passwordConfirmation = passwordConfirmation
        self.authToken = authToken
    }
}
