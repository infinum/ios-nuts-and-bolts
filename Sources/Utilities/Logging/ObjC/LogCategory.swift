//
//  LogCategory.swift
//  Logging
//
//  Created by Ivana Mršić on 24.05.2021..
//

import Foundation
import os

// MARK: - Objc Bridge -

@objc(LogCategory)
// swiftlint:disable type_name attributes
enum __ObjCLogCategory: Int {
    case none, ui, network

    var asOSLog: OSLog {
        switch self {
        case .none: return .default
        case .ui: return .ui
        case .network: return .network
        }
    }
}
