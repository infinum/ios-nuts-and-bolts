//
//  LoggingBridge.swift
//  Catalog
//
//  Created by Ivana Mršić on 13.07.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import Foundation

extension LogConfigurator {

    @available(swift, obsoleted: 1.0)
    convenience init(settings: __ObjCLogSettings) {
        self.init()
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
