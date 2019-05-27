//
//  Headers.swift
//
//  Created by Filip Gulan on 10/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

public enum Headers {

    public enum Key {
        /// Content-Type header key
        public static let contentType = "Content-Type"
        /// Accept header key
        public static let accept = "Accept"
        /// Authorization
        public static let authorization = "Authorization"
    }

    public enum ApplicationType {
        /// JSON application type value
        public static let json = "application/json"
    }

}

/// MARK: - JSON Request headers

public extension Headers {

    static var jsonRequestHeaders: HTTPHeaders {
        return [
            Key.contentType: ApplicationType.json,
            Key.accept: ApplicationType.json
        ]
    }

}
