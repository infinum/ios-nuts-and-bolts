//
//  LoggingObjC.swift
//  Logging
//
//  Created by Ivana Mršić on 24.05.2021..
//

import Foundation

// MARK: - Objective-C extension -

// For using macro versions of this, please include LoggingObjC.h header file in project
// In objc, class name is set with `__PRETTY_FUNCTION__` so we don't need to pass it to print

extension Log {

    // MARK: - Verbose

    /// log something generally unimportant (lowest priority)
    @objc
    class func objc_verbose(_ message: Any) {
        verbose(message, "", #function, line: #line)
    }

    /// log something generally unimportant (lowest priority)
    ///
    /// Enables custom options for logging
    @objc
    class func objc_verbose(_ message: Any, options: __ObjCLoggingOptions?) {
        let category = options?.category == __ObjCLogCategory.none ? nil : options?.category
        verbose(message, "", options?.functionName ?? #function, line: options?.line ?? #line, context: options?.context, category: category?.asOSLog)
    }

    // MARK: - Debug

    /// log something which help during debugging (low priority)
    @objc
    class func objc_debug(_ message: Any) {
        debug(message, "", #function, line: #line)
    }

    /// log something which help during debugging (low priority)
    ///
    /// Enables custom options for logging
    @objc
    class func objc_debug(_ message: Any, options: __ObjCLoggingOptions?) {
        let category = options?.category == __ObjCLogCategory.none ? nil : options?.category
        debug(message, "", options?.functionName ?? #function, line: options?.line ?? #line, context: options?.context, category: category?.asOSLog)
    }

    // MARK: - Info

    /// log something which you are really interested but which is not an issue or error (normal priority)
    @objc
    class func objc_info(_ message: Any) {
        info(message, "", #function, line: #line)
    }

    /// log something which you are really interested but which is not an issue or error (normal priority)
    ///
    /// Enables custom options for logging
    @objc
    class func objc_info(_ message: Any, options: __ObjCLoggingOptions?) {
        let category = options?.category == __ObjCLogCategory.none ? nil : options?.category
        info(message, "", options?.functionName ?? #function, line: options?.line ?? #line, context: options?.context, category: category?.asOSLog)
    }

    // MARK: - Warning

    /// log something which may cause big trouble soon (high priority)
    @objc
    class func objc_warning(_ message: Any) {
        warning(message, "", #function, line: #line)
    }

    /// log something which may cause big trouble soon (high priority)
    ///
    /// Enables custom options for logging
    @objc
    class func objc_warning(_ message: Any, options: __ObjCLoggingOptions?) {
        let category = options?.category == __ObjCLogCategory.none ? nil : options?.category
        warning(message, "", options?.functionName ?? #function, line: options?.line ?? #line, context: options?.context, category: category?.asOSLog)
    }

    // MARK: - Error

    /// log something which will keep you awake at night (highest priority)
    @objc
    class func objc_error(_ message: Any) {
        error(message, "", #function, line: #line)
    }

    /// log something which will keep you awake at night (highest priority)
    ///
    /// Enables custom options for logging
    @objc
    class func objc_error(_ message: Any, options: __ObjCLoggingOptions?) {
        let category = options?.category == __ObjCLogCategory.none ? nil : options?.category
        error(message, "", options?.functionName ?? #function, line: options?.line ?? #line, context: options?.context, category: category?.asOSLog)
    }
}
