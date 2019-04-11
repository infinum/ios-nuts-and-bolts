//
//  Date+Addition.swift
//  Tests
//
//  Created by Goran Brlas on 11/04/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation

public extension Date {
    
    /// Adds `numOfMonths` to `self` and returns it as a new `Date`.
    ///
    /// - Parameter numOfMonths: Number of months to add
    /// - Returns: Resulting date by adding `numOfMonths` to `self`.
    func date(byAddingMonths numOfMonths: Int) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(byAdding: .month, value: numOfMonths, to: self)
    }
    
    /// Adds `numOfDays` to `self` and returns it as a new `Date`.
    ///
    /// - Parameter numOfDays: Number of months to add
    /// - Returns: Resulting date by adding `numOfDays` to `self`.
    func date(byAddingDays numOfDays: Int) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(byAdding: .day, value: numOfDays, to: self)
    }
    
}
