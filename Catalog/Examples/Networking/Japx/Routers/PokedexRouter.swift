//
//  PokedexRouter.swift
//  Catalog
//
//  Created by Mate Masnov on 02/12/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire
import Japx

class PokedexRouter: Router {
    
    static func createUser(email: String, username: String, password: String, passwordConfirmation: String) -> PokedexRouter {
        
        let pokedexUser = PokedexUser(id: "", email: email, username: username, password: password, passwordConfirmation: passwordConfirmation)
        
        let params = try? JapxEncoder().encode(pokedexUser)
        let encodableParam = EncodableParams(encoding: JSONEncoding.default, parameters: params)
        
        return PokedexRouter(
            baseUrl: "https://pokeapi.infinum.co/api/v1",
            path: "/users",
            method: .post,
            encodableParams: [encodableParam]
        )
    }
    
    static func getUser(id: String) -> PokedexRouter {
        
        return PokedexRouter(
            baseUrl: "https://pokeapi.infinum.co/api/v1",
            path: "/users/\(id)",
            method: .get
        )
    }
    
    static func deleteUser(id: String) -> PokedexRouter {
        
        return PokedexRouter(
            baseUrl: "https://pokeapi.infinum.co/api/v1",
            path: "/users/\(id)",
            method: .delete
        )
    }
    
    static func updateUser(id: String, email: String?, username: String?) -> PokedexRouter {
        
        let pokedexUser = PokedexUser(id: id, email: email, username: username)
        
        let params = try? JapxEncoder().encode(pokedexUser)
        let encodableParam = EncodableParams(encoding: JSONEncoding.default, parameters: params)
        
        return PokedexRouter(
            baseUrl: "https://pokeapi.infinum.co/api/v1",
            path: "/users/\(id)",
            method: .put,
            encodableParams: [encodableParam]
        )
    }
}
