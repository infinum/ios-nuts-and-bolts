//
//  LogOptions.swift
//  Logging
//
//  Created by Ivana Mršić on 24.05.2021..
//

import Foundation

/// Custom options for logging
@objc(LogSettings)
@objcMembers
// swiftlint:disable type_name
final class __ObjCLogSettings: NSObject {

    var shouldLogInfo = true
    var shouldLogError = true
    var shouldLogVerbose = true
    var shouldLogWarning = true
    var shouldLogDebug = true

    var format: String?
    var isLoggingEnabled: Bool?
    var formatter: DateFormatter?
}
