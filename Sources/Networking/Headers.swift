//
//  Headers.swift
//
//  Created by Filip Gulan on 10/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire

public enum Headers {
    
    public static var defaultJSONAPIRequestHeaders: HTTPHeaders {
        return [
            "Content-Type" : "application/vnd.api+json",
            "Accept" : "application/vnd.api+json"
        ]
    }
    
    public static var defaultJSONRequestHeaders: HTTPHeaders {
        return [
            "Content-Type" : "application/json",
            "Accept" : "application/json"
        ]
    }
    
    public static var combinedJSONAPIRequestHeaders: HTTPHeaders {
        return [
            "Content-Type" : "application/vnd.api+json",
            "Accept" : "application/vnd.api+json, application/json"
        ]
    }
    
}
