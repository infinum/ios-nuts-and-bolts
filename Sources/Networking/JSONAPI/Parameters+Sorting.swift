//
//  Parameters+Sorting.swift
//
//  Created by Filip Gulan on 10/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

public extension JSONAPI {
    
    enum Sorting {
        
        /// Adds sort list to given parameters
        ///
        /// - Parameters:
        ///   - parameters: Current parameters
        ///   - properties: Properties to sort by
        /// - Returns: Parameters containing sort info.
        public static func adapt(parameters: Parameters, properties: [String]) -> Parameters {
            guard !properties.isEmpty else { return parameters }
            
            var parameters = parameters

            let propertiesString = properties.joined(separator: ",")
            parameters["sort"] = propertiesString

            return parameters
        }
        
    }
    
}
