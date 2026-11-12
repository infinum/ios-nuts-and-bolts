//
//  NSLayoutConstraint+Extension.swift
//  Catalog
//
//  Created by Infinum on 30.01.2023..
//  Copyright © 2023 Infinum. All rights reserved.
//

import UIKit

public extension Array where Element: NSLayoutConstraint {

    /// Activates all the constraints in the list at once via NSLayoutConstraint.activate(...)
    func activateAll() {
        NSLayoutConstraint.activate(self)
    }

    /// Returns self with priority changed
    func with(priority: UILayoutPriority) -> [NSLayoutConstraint] {
        return map { $0.with(priority: priority) }
    }
}

public extension Array where Element == NSLayoutConstraint? {

    /// Activates all non-nil constraints
    func activateAll() {
        compactMap { $0 }.activateAll()
    }
}

extension NSLayoutConstraint {

    /// Returns array of constraints with their priorities changed.
    func with(priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
