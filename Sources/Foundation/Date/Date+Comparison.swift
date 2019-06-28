//
//  Date+Comparison.swift
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
    
    
    /// `true` if `self` is today, false otherwise
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    /// `true` if `self` after today, false otherwise
    var isAfterToday: Bool {
        return self > Date() && !isToday
    }

    /// Checks whether `self` is in the same month as the provided date.
    ///
    /// - Parameter date: Other date
    /// - Returns: `true` if `self` is in the same month as the provided date, false otherwise.
    func isInSameMonth(as date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .month)
    }
    
    /// Checks whether `self` is the same day as the provided date.
    ///
    /// - Parameter date: Other date
    /// - Returns: `true` if `self` is the same date as the provided date, false otherwise.
    func isInSameDay(as date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .day)
    }
    
}
