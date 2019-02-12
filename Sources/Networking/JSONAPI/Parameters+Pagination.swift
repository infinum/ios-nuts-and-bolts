//
//  Parameters+Pagination.swift
//
//  Created by Filip Gulan on 10/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

public extension JSONAPI {
 
    public enum Pagination {
        
        /// Adds pagination info to given parameters.
        ///
        /// - Parameters:
        ///   - parameters: Current parameters.
        ///   - page: Page to fetch
        ///   - pageSize: Page size
        /// - Returns: Parameters containing pagination info.
        public static func adapt(parameters: Parameters, page: Int, pageSize: Int) -> Parameters {
            var parameters = parameters
            parameters["page[number]"] = page
            parameters["page[size]"] = pageSize
            
            return parameters
        }
        
    }
    
}
