//
//  URLRequest+Alamofire.swift
//  Catalog
//
//  Created by Filip Gulan on 26/02/2020.
//  Copyright © 2020 Infinum. All rights reserved.
//

import Foundation
import Alamofire

public extension URLRequest {
    
    mutating func setHeader(_ header: HTTPHeader) {
        setValue(header.value, forHTTPHeaderField: header.name)
    }
}
