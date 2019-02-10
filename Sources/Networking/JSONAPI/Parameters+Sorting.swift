//
//  Parameters+Sorting.swift
//
//  Created by Filip Gulan on 10/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

public extension JSONAPI {
    
    public enum Sorting {
        
        public static func adapt(parameters: Parameters, properties: [String]) -> Parameters {
            var parameters = parameters
            if !properties.isEmpty {
                let propertiesString = properties.joined(separator: ",")
                parameters["sort"] = propertiesString
            }
            return parameters
        }
        
    }
    
}
