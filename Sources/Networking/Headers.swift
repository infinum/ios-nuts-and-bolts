//
//  Headers.swift
//
//  Created by Filip Gulan on 10/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

public enum Headers {

    public enum ApplicationType {
        /// JSON application type value
        public static let json = "application/json"
    }

}

/// MARK: - JSON Request headers

public extension Headers {

    static var jsonRequestHeaders: [HTTPHeader] {
        return [
            .contentType(ApplicationType.json),
            .accept(ApplicationType.json)
        ]
    }

}
