//
//  JSONAPI.swift
//
//  Created by Filip Gulan on 10/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

/// Helpers related to JSONAPI structure
public enum JSONAPI {
    
}

/// MARK: - JSONAPI Request headers

public extension Headers.ApplicationType {
    /// JSONAPI application type value
    static let jsonApi = "application/vnd.api+json"
}

public extension Headers {

    static var jsonApiRequestHeaders: [HTTPHeader] {
        return [
            .init(name: Key.contentType, value: ApplicationType.jsonApi),
            .init(name: Key.accept, value: ApplicationType.jsonApi)
        ]
    }
    
    static var combinedJsonApiRequestHeaders: [HTTPHeader] {
        return [
              .init(name: Key.contentType, value: ApplicationType.jsonApi),
              .init(name: Key.accept, value: "\(ApplicationType.jsonApi), \(ApplicationType.json)")
          ]
    }

}
