//
//  URL+Append.swift
//
//  Created by Filip Gulan on 10/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation

extension URL {
    
    /// Appends given query items to the URL. If appending fails or
    /// query items are invalid, current url is returned.
    ///
    /// - Parameter newQueryItems: Items to add
    /// - Returns: URL with given query items
    public func append(_ newQueryItems: [URLQueryItem]) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else {
            return self
        }
        
        var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
        queryItems.append(contentsOf: newQueryItems)
        urlComponents.queryItems = queryItems

        /// If appending fails, use current URL
        return urlComponents.url ?? self
    }
    
}
