//
//  BundleExtensions.swift
//  Loggie
//
//  Created by Filip Gulan on 25/10/2019.
//

import Foundation

extension Bundle {

    private static var _bundlePath: String? {
       return Bundle.main.path(forResource: "LoggieResources", ofType: "bundle")
   }

    static var loggie: Bundle {
       // If use_frameworks! is not used then resources will be embedded
       // inside separate bundle, just for resources
       if let path = _bundlePath, let bundle = Bundle(path: path) {
           return bundle
       }
       return Bundle(for: LoggieManager.self)
   }

}
