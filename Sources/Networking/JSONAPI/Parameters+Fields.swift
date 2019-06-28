//
//  Parameters+Fields.swift
//
//  Created by Filip Gulan on 10/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

public extension JSONAPI {
    
    enum Fields {

        /// Nested properties to include for given items
        ///
        /// - Parameters:
        ///   - parameters: Current parameters
        ///   - fields: Nested properties to include in response
        /// - Returns: Parameters containing fields include info.
        public static func adapt(parameters: Parameters, fields: [String: [String]]) -> Parameters {
            var parameters = parameters
            for (field, properties) in fields where !properties.isEmpty {
                parameters["fields[\(field)]"] = properties.joined(separator: ",")
            }
            return parameters
        }
        
    }

}
