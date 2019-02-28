//
//  Headers.swift
//
//  Created by Filip Gulan on 10/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

public enum Headers {

    public enum Key {
        /// Content-Type header key
        public static var contentType = "Content-Type"
        /// Accept header key
        public static var accept = "Accept"
        /// Authorization
        public static var authorization = "Authorization"
    }

    public enum ApplicationType {
        /// JSON application type value
        public static var json = "application/json"
        /// JSONAPI application type value
        public static var jsonApi = "application/vnd.api+json"
    }

    public static var jsonApiRequestHeaders: HTTPHeaders {
        return [
            Key.contentType: ApplicationType.jsonApi,
            Key.accept: ApplicationType.jsonApi
        ]
    }
    
    public static var jsonRequestHeaders: HTTPHeaders {
        return [
            Key.contentType: ApplicationType.json,
            Key.accept: ApplicationType.json
        ]
    }
    
    public static var combinedJsonApiRequestHeaders: HTTPHeaders {
        return [
            Key.contentType: ApplicationType.jsonApi,
            Key.accept: "\(ApplicationType.jsonApi), \(ApplicationType.json)"
        ]
    }
    
}
