//
//  Date+ComparisonTests.swift
//
//  Created by Filip Gulan on 06/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import Catalog

class DateComparisonTests: QuickSpec {

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
            
            it("should return false for current date same as start and end dates but hour after end with day granularity, and not inclusive") {
                let start = formatter.date(from: "14-01-2018 08:00:00")!
                let current = formatter.date(from: "14-01-2018 10:00:00")!
                let end = formatter.date(from: "14-01-2018 09:00:00")!
                
                let isBetween = current.isBetween(start, and: end,
                                                  withGranularity: .day, inclusive: false)
                expect(isBetween).to(beFalse())
            }
            
            it("should work for different days comparison with day granularity, and not inclusive") {
                let start = formatter.date(from: "12-01-2018 00:00:00")!
                let current = formatter.date(from: "14-01-2018 13:00:00")!
                let end = formatter.date(from: "16-01-2018 23:59:59")!
                
                let isBetween = current.isBetween(start, and: end, withGranularity: .day, inclusive: false)
                expect(isBetween).to(beTrue())
            }
            
            it("should work for different days comparison with day granularity, reversed end and start") {
                let start = formatter.date(from: "12-01-2018 00:00:00")!
                let current = formatter.date(from: "14-01-2018 13:00:00")!
                let end = formatter.date(from: "16-01-2018 23:59:59")!
                
                let isBetween = current.isBetween(end, and: start, withGranularity: .day, checkInterval: true)
                expect(isBetween).to(beTrue())
            }
            
            it("should return false for current date same as start and end dates but hour after end with day granularity, and not inclusive and reversed dates") {
                let start = formatter.date(from: "14-01-2018 08:00:00")!
                let current = formatter.date(from: "14-01-2018 10:00:00")!
                let end = formatter.date(from: "14-01-2018 09:00:00")!
                
                let isBetween = current.isBetween(
                    end, and: start,
                    withGranularity: .day,
                    inclusive: false,
                    checkInterval: true
                )
                expect(isBetween).to(beFalse())
            }
            
            it("should return false for current date same as start and end dates but hour after end with day granularity, and not inclusive and reversed dates") {
                let start = formatter.date(from: "14-01-2018 08:00:00")!
                let current = formatter.date(from: "14-01-2018 10:00:00")!
                let end = formatter.date(from: "14-01-2018 09:00:00")!
                
                let isBetween = current.isBetween(
                    end, and: start,
                    withGranularity: .day,
                    inclusive: false,
                    checkInterval: true
                )
                expect(isBetween).to(beFalse())
            }
            
        }
        
        describe("testing isToday") {
            
            it("Should return true if date is today") {
                let date = Date()

                expect(date.isToday).to(beTrue())
            }
            
            it("Should return false if date is not today") {
                var date: Date {
                    let isoDate = "1995-05-20T10:44:00+0000"
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                    return dateFormatter.date(from: isoDate)!
                }
                
                expect(date.isToday).to(beFalse())
            }
            
        }
        
        describe("testing isAfterToday") {
            
            it("Should return false if date is before today") {
                let date = Date()
                
                expect(date.isAfterToday).to(beFalse())
            }
            
            it("Should return false if date is exactly today") {
                let date = Date()
                
                expect(date.isAfterToday).to(beFalse())
            }
            
            it("Should return true if date is after today") {
                var date: Date {
                    let isoDate = "1995-05-20T10:44:00+0000"
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                    return dateFormatter.date(from: isoDate)!
                }
                
                expect(date.isToday).to(beFalse())
            }
            
        }
        
        describe("testing isInSameMonth(as:)") {
            
            it("Should return true if dates are both today") {
                let first = Date()
                let second = Date()
                
                expect(first.isInSameDay(as: second)).to(beTrue())
            }
            
            it("Should return true if dates are both in the same month") {
                var first: Date {
                    let isoDate = "2019-05-20T10:44:00+0000"
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                    return dateFormatter.date(from: isoDate)!
                }
                
                var second: Date {
                    let isoDate = "2019-05-20T10:44:00+0000"
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                    return dateFormatter.date(from: isoDate)!
                }
                
                expect(first.isInSameMonth(as: second)).to(beTrue())
            }
            
            it("Should return false if dates are not in the same month") {
                var first: Date {
                    let isoDate = "2019-05-20T10:44:00+0000"
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                    return dateFormatter.date(from: isoDate)!
                }
                
                var second: Date {
                    let isoDate = "2019-04-20T10:44:00+0000"
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                    return dateFormatter.date(from: isoDate)!
                }
                
                expect(first.isInSameMonth(as: second)).to(beFalse())
            }
            
        }
        
        describe("testing isInSameDay(as:)") {
            
            it("Should return true if dates are both today") {
                let first = Date()
                let second = Date()
                
                expect(first.isInSameDay(as: second)).to(beTrue())
            }
            
            it("Should return false if dates are not in the same day") {
                var first: Date {
                    let isoDate = "2019-05-20T10:44:00+0000"
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                    return dateFormatter.date(from: isoDate)!
                }
                
                var second: Date {
                    let isoDate = "2019-05-21T10:44:00+0000"
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                    return dateFormatter.date(from: isoDate)!
                }
                
                expect(first.isInSameDay(as: second)).to(beFalse())
            }
            
            it("Should return false if dates are on the same day, but different month") {
                var first: Date {
                    let isoDate = "2019-05-20T10:44:00+0000"
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                    return dateFormatter.date(from: isoDate)!
                }
                
                var second: Date {
                    let isoDate = "2019-04-20T10:44:00+0000"
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                    return dateFormatter.date(from: isoDate)!
                }
                
                expect(first.isInSameDay(as: second)).to(beFalse())
            }
            
        }

    }
}
