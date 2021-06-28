//
//  LoggingConfigurator.swift
//  Logging
//
//  Created by Ivana Mršić on 24.05.2021..
//  Idea taken from: https://github.com/SwiftyBeaver/SwiftyBeaver
//

import Foundation
import os

@objcMembers
class LogConfigurator: NSObject {

    struct Level: OptionSet {

        let rawValue: Int

        static let verbose = Level(rawValue: 1 << 0)
        static let debug = Level(rawValue: 1 << 1)
        static let info = Level(rawValue: 1 << 2)
        static let warning = Level(rawValue: 1 << 3)
        static let error = Level(rawValue: 1 << 4)

        var osLogType: OSLogType {
            switch self {
            case .verbose, .info: return .info
            case .warning: return .default
            case .debug: return .debug
            case .error: return .error
            default: return .info
            }
        }

        var stringRepresentation: String {
            switch self {
            case .verbose: return "💜 VERBOSE"
            case .debug: return "💚 DEBUG"
            case .info: return "💙 INFO"
            case .warning: return "💛 WARNING"
            case .error: return "❤️ ERROR"
            default: return ""
            }
        }
    }

    // MARK: - Public properties -

    /** Output format pattern

     The character $ marks the start of "variable" followed by a case-sensitive letter:

     *$L* - Level, for example "VERBOSE"

     *$M* - Message, for example the foo in log.debug("foo")

     *$J* - JSON-encoded logging object (can not be combined with other format variables!)

     *$N* - Name of file without suffix

     *$n* - Name of file with suffix

     *$F* - Function

     *$l* - Line (lower-case l)

     *$D* - Datetime, followed by standard Swift datetime syntax

     *$d* - Datetime format end

     *$T* - Thread

     *$X* - Optional context value of any type (see below)

     **Default format:**

     "$L $N.$F:$l - $M"
     */
    var format = "$L $N.$F:$l - $M"

    /// Set if value should be printed
    var isLoggingEnabled = true
    /// Set log level
    ///
    /// By default, if value is not set, everything will be logged
    var logLevels: Level = []
    var formatter = DateFormatter()

    override init() { }

    @available(swift, obsoleted: 1.0)
    init(settings: __ObjCLogSettings) {
        if let format = settings.format { self.format = format }
        if let isLoggingEnabled = settings.isLoggingEnabled {
            self.isLoggingEnabled = isLoggingEnabled
        }
        if let formatter = settings.formatter { self.formatter = formatter }
        if settings.shouldLogInfo { logLevels.insert(.info) }
        if settings.shouldLogWarning { logLevels.insert(.warning) }
        if settings.shouldLogError { logLevels.insert(.error) }
        if settings.shouldLogVerbose { logLevels.insert(.verbose) }
        if settings.shouldLogDebug { logLevels.insert(.debug) }
    }
}

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let ui = OSLog(subsystem: subsystem, category: "UI")
    static let network = OSLog(subsystem: subsystem, category: "Network")
}
