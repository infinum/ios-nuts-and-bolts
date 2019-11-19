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
//            baseUrl: "https://api.infinum.academy/api",
//            path: "/users/sessions",
//            method: .post,
//            parameters: params,
//            encoding: JSONEncoding.default
//        )
        /// Or with custom encoding for each set of params
        let encodedParams = EncodableParams(encoding: JSONEncoding.default, parameters: params)
        return LoginRouter(
            baseUrl: "https://api.infinum.academy/api",
            path: "/users/sessions",
            method: .post,
            encodableParams: [encodedParams]
        )
    }

}
