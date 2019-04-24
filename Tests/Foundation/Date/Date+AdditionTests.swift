//
//  Date+AdditionTests.swift
//  Tests
//
//  Created by Goran Brlas on 11/04/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import Catalog

class Date_AdditionTests: QuickSpec {
    
    override func spec() {
        
        var date: Date!
        
        beforeEach {
            let isoDate = "2016-04-14T10:44:00+0000"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            date = dateFormatter.date(from: isoDate)!
        }
        
        describe("Testing date(byAddingMonths:)") {
            
            it("Should be properly calculated for positive months") {
                let calendar = Calendar(identifier: .gregorian)
                let currentDateComponents = calendar.dateComponents([.year, .month, .day], from: date)
                let twoMonthsLaterComponents = calendar.dateComponents([.year, .month, .day], from: date.date(byAddingMonths: 2)!)
                
                expect(twoMonthsLaterComponents.day!) == currentDateComponents.day!
                expect(twoMonthsLaterComponents.month!) == currentDateComponents.month! + 2
                expect(twoMonthsLaterComponents.year!) == currentDateComponents.year!
            }
            
        }
        
        describe("Testing date(byAddingMonths:)") {
            
            it("Should be properly calculated for negative months") {
                let calendar = Calendar(identifier: .gregorian)
                let currentDateComponents = calendar.dateComponents([.year, .month, .day], from: date)
                let twoMonthsLaterComponents = calendar.dateComponents([.year, .month, .day], from: date.date(byAddingMonths: -2)!)
                
                expect(twoMonthsLaterComponents.day!) == currentDateComponents.day!
                expect(twoMonthsLaterComponents.month!) == currentDateComponents.month! - 2
                expect(twoMonthsLaterComponents.year!) == currentDateComponents.year!
            }
            
        }

        describe("Testing date(byAddingDays:)") {
            
            it("Should be properly calculated for positive days") {
                let calendar = Calendar(identifier: .gregorian)
                let currentDateComponents = calendar.dateComponents([.year, .month, .day], from: date)
                let twoDaysLaterComponents = calendar.dateComponents([.year, .month, .day], from: date.date(byAddingDays: 2)!)
                
                expect(twoDaysLaterComponents.day!) == currentDateComponents.day! + 2
                expect(twoDaysLaterComponents.month!) == currentDateComponents.month
                expect(twoDaysLaterComponents.year!) == currentDateComponents.year!
            }
            
            it("Should be properly calculated for negative days") {
                let calendar = Calendar(identifier: .gregorian)
                let currentDateComponents = calendar.dateComponents([.year, .month, .day], from: date)
                let twoDaysLaterComponents = calendar.dateComponents([.year, .month, .day], from: date.date(byAddingDays: -2)!)
                
                expect(twoDaysLaterComponents.day!) == currentDateComponents.day! - 2
                expect(twoDaysLaterComponents.month!) == currentDateComponents.month!
                expect(twoDaysLaterComponents.year!) == currentDateComponents.year!
            }
            
        }
    }
    
}
