//
//  Parameters+Filter.swift
//
//  Created by Filip Gulan on 10/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

public extension JSONAPI {
    
    public enum Filter {
        
        public static func adapt(parameters: Parameters, properties: [String: Any]) -> Parameters {
            var parameters = parameters
            for (key, value) in properties {
                parameters["filter[\(key)]"] = value
            }
            return parameters
        }
        
    }

}
