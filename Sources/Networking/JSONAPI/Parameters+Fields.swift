//
//  Parameters+Fields.swift
//
//  Created by Filip Gulan on 10/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

public extension JSONAPI {
    
    public enum Fields {
        
        public static func adapt(parameters: Parameters, fields: [String: [String]]) -> Parameters {
            var parameters = parameters
            for (field, properties) in fields {
                if !properties.isEmpty {
                    parameters["fields[\(field)]"] = properties.joined(separator: ",")
                }
            }
            return parameters
        }
        
    }

}
