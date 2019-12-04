//
//  User.swift
//  Catalog
//
//  Created by Mate Masnov on 02/12/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Japx

struct PokedexLogin: JapxEncodable {
    
    let type: String = "session"
    
    let email: String
    let password: String
}
