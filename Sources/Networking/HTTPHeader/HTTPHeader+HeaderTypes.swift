//
//  HTTPHeader+HeaderTypes.swift
//  Catalog
//
//  Created by Zvonimir Medak on 10.10.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Alamofire

// MARK: - Common headers

public extension HTTPHeader {

    /// Returns a `Request-Id` header.
    ///
    /// - Parameter value: The request `id` value.
    ///
    /// - Returns: The header.
    static func requestId(_ id: String) -> HTTPHeader {
        HTTPHeader(name: "Request-Id", value: id)
    }
}
