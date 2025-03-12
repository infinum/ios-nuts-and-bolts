//
//  Date+CurrentMonthExtension.swift
//
//  Created by Goran Brlas on 11/04/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import Catalog

class DateCurrentMonthTests: QuickSpec {
    
    override func spec() {
        
        var date: Date!
        
        beforeEach {
            let isoDate = "2016-04-14T10:44:00+0000"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            date = dateFormatter.date(from: isoDate)!
        }
        
        describe("Testing startOfCurrentMonth") {
            
            it("Should be properly calculated") {
                let calendar = Calendar(identifier: .gregorian)
                let components = calendar.dateComponents([.year, .month, .day], from: date.startOfCurrentMonth!)
                
                expect(components.day!) == 1
                expect(components.month!) == 4
                expect(components.year!) == 2016
            }
            
        }
        
        describe("Testing endOfCurrentMonth") {
            
            it("Should be properly calculated") {
                let calendar = Calendar(identifier: .gregorian)
                let components = calendar.dateComponents([.year, .month, .day], from: date.endOfCurrentMonth!)
                
                expect(components.day!) == 30
                expect(components.month!) == 4
                expect(components.year!) == 2016
            }
            
        }

    }
    
}
