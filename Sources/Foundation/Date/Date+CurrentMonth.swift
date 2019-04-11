//
//  Date+CurrentMonth.swift
//  Tests
//
//  Created by Goran Brlas on 11/04/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation

public extension Date {
    
    /// Returns the start fo current month.
    var startOfCurrentMonth: Date? {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)
    }
    
    
    /// Returns the end of current month.
    var endOfCurrentMonth: Date? {
        let calendar = Calendar(identifier: .gregorian)
        guard
            let startOfCurrentMoth = self.startOfCurrentMonth,
            let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: startOfCurrentMoth)
            else { return nil }
        
        return calendar.date(byAdding: .second, value: -1, to: startOfNextMonth)
    }
    
}
