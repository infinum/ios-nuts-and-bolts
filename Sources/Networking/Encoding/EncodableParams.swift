//
//  EncodableParams.swift
//  Catalog
//
//  Created by Filip Gulan on 25/03/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

/// Request params with associated encoding. Used in conjuction with
/// networking router
public struct EncodableParams {

    /// MARK: - Private properties -

    private let _encoding: ParameterEncoding
    private let _parameters: Parameters?

    /// MARK: - Init -

    public init(
        encoding: ParameterEncoding = URLEncoding.default,
        parameters: Parameters?
    ) {
        _encoding = encoding
        _parameters = parameters
    }

    func encode(_ request: URLRequest) throws -> URLRequest {
        return try _encoding.encode(request, with: _parameters)
    }

}
