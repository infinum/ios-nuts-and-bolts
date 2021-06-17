//
//  EncodableParams.swift
//
//  Created by Filip Gulan on 25/03/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

/// Request params with associated encoding. Used in conjuction with
/// networking router
public struct EncodableParams {

    // MARK: - Private properties -

    private let encoding: ParameterEncoding
    private let parameters: Parameters?

    // MARK: - Init -

    public init(
        encoding: ParameterEncoding = URLEncoding.default,
        parameters: Parameters?
    ) {
        self.encoding = encoding
        self.parameters = parameters
    }

    func encode(_ request: URLRequest) throws -> URLRequest {
        return try encoding.encode(request, with: parameters)
    }

}
