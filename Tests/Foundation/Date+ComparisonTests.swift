//
//  Date+ComparisonTests.swift
//  Catalog
//
//  Created by Filip Gulan on 06/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import Catalog

class Date_ComparisonTests: QuickSpec {

    override func spec() {

        describe("testing date range extension") {
            
            let formatter = DateFormatter()
            
            beforeEach {
                formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            }
            
            it("should work for same day comparison with minute granularity") {
                let start = formatter.date(from: "14-01-2018 00:00:00")!
                let current = formatter.date(from: "14-01-2018 13:00:00")!
                let end = formatter.date(from: "14-01-2018 23:59:59")!
                
                let isBetween = current.isBetween(start, and: end, withGranularity: .minute)
                expect(isBetween).to(beTrue())
            }
            
            it("should work for same day comparison with hour granularity") {
                let start = formatter.date(from: "14-01-2018 00:00:00")!
                let current = formatter.date(from: "14-01-2018 13:00:00")!
                let end = formatter.date(from: "14-01-2018 23:59:59")!
                
                let isBetween = current.isBetween(start, and: end, withGranularity: .hour)
                expect(isBetween).to(beTrue())
            }
            
            it("should work for same day comparison with day granularity") {
                let start = formatter.date(from: "14-01-2018 00:00:00")!
                let current = formatter.date(from: "14-01-2018 13:00:00")!
                let end = formatter.date(from: "14-01-2018 23:59:59")!
                
                let isBetween = current.isBetween(start, and: end, withGranularity: .day)
                expect(isBetween).to(beTrue())
            }
            
            it("should work for different days comparison with day granularity") {
                let start = formatter.date(from: "12-01-2018 00:00:00")!
                let current = formatter.date(from: "14-01-2018 13:00:00")!
                let end = formatter.date(from: "16-01-2018 23:59:59")!
                
                let isBetween = current.isBetween(start, and: end, withGranularity: .day)
                expect(isBetween).to(beTrue())
            }
            
            it("should work for current date same as start and end dates but hour after start with day granularity") {
                let start = formatter.date(from: "14-01-2018 09:00:00")!
                let current = formatter.date(from: "14-01-2018 08:00:00")!
                let end = formatter.date(from: "14-01-2018 23:59:59")!
                
                let isBetween = current.isBetween(start, and: end, withGranularity: .day)
                expect(isBetween).to(beTrue())
            }
            
            it("should work for current date same as start and end dates but hour after end with day granularity") {
                let start = formatter.date(from: "14-01-2018 08:00:00")!
                let current = formatter.date(from: "14-01-2018 10:00:00")!
                let end = formatter.date(from: "14-01-2018 09:00:00")!
                
                let isBetween = current.isBetween(start, and: end, withGranularity: .day)
                expect(isBetween).to(beTrue())
            }
            
            it("should return false for current date same as start and end dates but hour after start with hour granularity") {
                let start = formatter.date(from: "14-01-2018 09:00:00")!
                let current = formatter.date(from: "14-01-2018 08:00:00")!
                let end = formatter.date(from: "14-01-2018 23:59:59")!
                
                let isBetween = current.isBetween(start, and: end, withGranularity: .hour)
                expect(isBetween).notTo(beTrue())
            }
            
            it("should return false for current date same as start and end dates but hour after end with hour granularity") {
                let start = formatter.date(from: "14-01-2018 08:00:00")!
                let current = formatter.date(from: "14-01-2018 10:00:00")!
                let end = formatter.date(from: "14-01-2018 09:00:00")!
                
                let isBetween = current.isBetween(start, and: end, withGranularity: .hour)
                expect(isBetween).notTo(beTrue())
            }
            
        }

    }
}
