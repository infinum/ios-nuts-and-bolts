//
//  URL+Append.swift
//
//  Created by Filip Gulan on 10/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

extension URL {
    
    public func append(_ newQueryItems: [URLQueryItem]) throws -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else {
            return self
        }
        
        var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
        queryItems.append(contentsOf: newQueryItems)
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw AFError.invalidURL(url: self)
        }
        
        return url
    }
    
}
