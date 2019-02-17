//
//  JapxResponse.swift
//
//  Created by Filip Gulan on 16/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Japx

public struct JapxResponse<T: Codable>: Codable {
    public let data: T
}

public struct EmptyObject: JapxCodable {
    public let id: String
    public let type: String
}
