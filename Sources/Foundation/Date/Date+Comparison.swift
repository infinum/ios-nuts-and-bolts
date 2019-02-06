//
//  Date+Comparison.swift
//  Catalog
//
//  Created by Filip Gulan on 06/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation

public extension Date {
    
    /// Checks if the current date is between two given dates with some
    /// granularity (minute, hour, day) in specified calendar.
    ///
    /// - Parameters:
    ///   - start: Start date
    ///   - end: End date
    ///   - granularity: Comparison granularity (minute, hour, day...)
    ///   - inclusive: If edge dates are included in comparison, default to `true`
    ///   - checkInterval: If should check for start/end valid interval and reverse
    ///                    them if they are in wrong order, defaults to `false`
    ///   - calendar: Calendar to use
    /// - Returns: `true` if current date falls in given range, `false` otherwise
    func isBetween(
        _ start: Date,
        and end: Date,
        withGranularity granularity: Calendar.Component,
        inclusive: Bool = true,
        checkInterval: Bool = false,
        in calendar: Calendar = .current
    ) -> Bool {
        var correctStart = start
        var correctEnd = end
        
        /// Case when start date is after end date and interval check should
        /// be done
        if checkInterval && start > end {
            correctStart = end
            correctEnd = start
        }
        
        let startResult = calendar.compare(self, to: correctStart, toGranularity: granularity)
        let endResult = calendar.compare(self, to: correctEnd, toGranularity: granularity)
        
        /// Take in consideration if interval is inclusive
        let afterStart = startResult == .orderedDescending ||
            (inclusive && startResult == .orderedSame)
        
        let beforeEnd = endResult == .orderedAscending ||
            (inclusive && endResult == .orderedSame)
        
        return afterStart && beforeEnd
    }
    
}
