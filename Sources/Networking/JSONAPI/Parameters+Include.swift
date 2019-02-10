//
//  Parameters+Include.swift
//
//  Created by Filip Gulan on 10/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

public extension JSONAPI {
    
    public enum Include {
        
        public static func adapt(parameters: Parameters, include: [String]) -> Parameters {
            var parameters = parameters
            if !include.isEmpty {
                let includeParams = include.joined(separator: ",")
                parameters["include"] = includeParams
            }
            return parameters
        }
        
        public static func adapt(url: String, include: [String]) -> String {
            var url = url
            if !include.isEmpty {
                let includeParams = include.joined(separator: ",")
                url = url + "?include=" + includeParams
            }
            return url
        }
        
    }
    
}

