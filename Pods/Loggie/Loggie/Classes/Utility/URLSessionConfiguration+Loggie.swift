//
//  Loggie.swift
//  Pods
//
//  Created by Filip Bec on 14/03/2017.
//
//

import UIKit

public extension URLSessionConfiguration {

    @objc(loggieSessionConfiguration)
    static var loggie: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses?.insert(LoggieURLProtocol.self, at: 0)
        return configuration
    }
}
