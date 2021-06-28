//
//  Logging.swift
//  Logging
//
//  Created by Ivana Mršić on 24.05.2021..
//  Idea taken from: https://github.com/SwiftyBeaver/SwiftyBeaver
//

import Foundation
import os

@objc(Logger)
class Log: NSObject {

    // MARK: - Private properties -

    private(set) static var configurator: LogConfigurator?

    // MARK: - Configuration -

    @objc
    class func configure(with configurator: LogConfigurator) {
        self.configurator = configurator
    }

    // MARK: - Levels -

    /// Log something generally unimportant (lowest priority).
    class func verbose(
        _ message: @autoclosure () -> Any,
        _ file: String = #file,
        _ function: String = #function,
        line: Int = #line,
        context: Any? = nil,
        category: OSLog? = nil
    ) {
        Log.formatAndLog(level: .verbose, message(), file, function, line: line, context: context, category: category)
    }

    /// Log something which help during debugging (low priority).
    class func debug(
        _ message: @autoclosure () -> Any,
        _ file: String = #file,
        _ function: String = #function,
        line: Int = #line,
        context: Any? = nil,
        category: OSLog? = nil
    ) {
        Log.formatAndLog(level: .debug, message(), file, function, line: line, context: context, category: category)
    }

    /// Log something which you are really interested but which is not an issue or error (normal priority).
    class func info(
        _ message: @autoclosure () -> Any,
        _ file: String = #file,
        _ function: String = #function,
        line: Int = #line,
        context: Any? = nil,
        category: OSLog? = nil
    ) {
        Log.formatAndLog(level: .info, message(), file, function, line: line, context: context, category: category)
    }

    /// Log something which may cause big trouble soon (high priority).
    class func warning(
        _ message: @autoclosure () -> Any,
        _ file: String = #file,
        _ function: String = #function,
        line: Int = #line,
        context: Any? = nil,
        category: OSLog? = nil
    ) {
        Log.formatAndLog(level: .warning, message(), file, function, line: line, context: context, category: category)
    }

    /// Log something which will keep you awake at night (highest priority).
    class func error(
        _ message: @autoclosure () -> Any,
        _ file: String = #file,
        _ function: String = #function,
        line: Int = #line,
        context: Any? = nil,
        category: OSLog? = nil
    ) {
        Log.formatAndLog(level: .error, message(), file, function, line: line, context: context, category: category)
    }
}

private extension Log {

    class func formatAndLog(
        level: LogConfigurator.Level,
        _ message: @autoclosure () -> Any,
        _ file: String = #file,
        _ function: String = #function,
        line: Int = #line,
        context: Any? = nil,
        category: OSLog? = nil
    ) {
        guard let configurator = configurator else { preconditionFailure("Logger should be configured before first use!") }
        if !configurator.logLevels.isEmpty && !configurator.logLevels.contains(level) { return }
        LoggingFormatter.prepareAndPrint(
            for: level,
            message: message(),
            file: file,
            function: function,
            line: line,
            context: context,
            category: category
        )
    }
}
