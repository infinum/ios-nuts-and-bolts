//
//  LoggingOptions.swift
//  Logging
//
//  Created by Ivana Mršić on 24.05.2021..
//

import Foundation

/// Custom options for logging
@objc(LoggingOptions)
@objcMembers
// swiftlint:disable type_name
final class __ObjCLoggingOptions: NSObject {
    var category: __ObjCLogCategory?
    var functionName: String?
    var line: Int?
    var context: Any?

    static func defaultOptions(function: String, line: Int, category: __ObjCLogCategory) -> __ObjCLoggingOptions {
        let options = __ObjCLoggingOptions()
        options.functionName = function
        options.line = line
        options.category = category
        return options
    }
}
