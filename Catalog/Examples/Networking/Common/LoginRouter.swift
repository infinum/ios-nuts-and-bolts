//
//  LoginRouter.swift
//
//  Created by Filip Gulan on 25/04/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

class LoginRouter: Router {

    static func login(email: String, password: String) -> LoginRouter {
        let params = [
            "email": email,
            "password": password
        ]
//        return LoginRouter(
//            baseUrl: "https://tv-shows.infinum.academy/api",
//            path: "/users/sessions",
//            method: .post,
//            parameters: params,
//            encoding: JSONEncoding.default
//        )

        // Or with custom encoding for each set of params
        let encodedParams = EncodableParams(encoding: JSONEncoding.default, parameters: params)
        return LoginRouter(
            baseUrl: "https://tv-shows.infinum.academy/api",
            path: "/users/sessions",
            method: .post,
            encodableParams: [encodedParams]
        )

        // Or with custom encoding for encodable model
//        let user = User(email: email, password: password)
//        let encodableParams = EncodableParamsCoder(encoding: JSONParameterEncoder.default, parameters: user)
//        return LoginRouter(
//            baseUrl: "https://tv-shows.infinum.academy/api",
//            path: "/users/sessions",
//            method: .post,
//            encodableParams: [encodableParams]
//        )

        // Or with encodable model
//        let user = User(email: email, password: password)
//        return LoginRouter(
//            baseUrl: "https://tv-shows.infinum.academy/api",
//            path: "/users/sessions",
//            method: .post,
//            parameters: user,
//            encoding: JSONParameterEncoder.default
//        )
    }

}

/// Encodable model
private struct User: Encodable {
    let email: String
    let password: String
}
