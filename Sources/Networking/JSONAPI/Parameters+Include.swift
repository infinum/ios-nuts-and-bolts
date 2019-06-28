//
//  Parameters+Include.swift
//
//  Created by Filip Gulan on 10/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

public extension JSONAPI {
    
    enum Include {
        
        /// Adds include list to given parameters
        ///
        /// - Parameters:
        ///   - parameters: Current parameters
        ///   - include: Objects to include in response
        /// - Returns: Parameters containing include info.
        public static func adapt(parameters: Parameters, include: [String]) -> Parameters {
            guard !include.isEmpty else { return parameters }

            var parameters = parameters
            var include = include

            /// If include list already exists - keep the old items
            if let currentItemsString = parameters["include"] as? String {
                include.append(contentsOf: currentItemsString.components(separatedBy: ","))
            }

            /// Filter out the duplicates if needed
            parameters["include"] = include.joined(separator: ",")

            return parameters
        }
        
    }
    
}

