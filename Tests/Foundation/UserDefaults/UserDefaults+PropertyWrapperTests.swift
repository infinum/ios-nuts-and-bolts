//
//  UserDefaults+PropertyWrapperTests.swift
//  Tests
//
//  Created by Jasmin Abou Aldan on 01/09/2020.
//  Copyright © 2020 Infinum. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import Catalog

class UserDefaults_PropertyWrapperTests: QuickSpec {

    override func spec() {

        beforeEach {
            UserDefaults_PropertyWrapperTests.clearStorage()
        }

        afterEach {
            UserDefaults_PropertyWrapperTests.clearStorage()
        }

        describe("testing bool value storing") {

            it("should return nil for default option") {
                expect(StoreTest.optionalBoolValue).to(beNil())
            }

            it("should return bool for default non optional") {
                expect(StoreTest.nonOptionalDefaultBoolValue).to(beTrue())
            }

            it("should return bool for stored in optional") {
                StoreTest.optionalBoolValue = true
                expect(StoreTest.optionalBoolValue).to(beTrue())
            }

            it("should return bool for stored in non-optional") {
                StoreTest.nonOptionalBoolValue = true
                expect(StoreTest.nonOptionalBoolValue).to(beTrue())
            }

            it("should return nil for removed value") {
                StoreTest.optionalBoolValue = true
                StoreTest.optionalBoolValue = nil
                expect(StoreTest.optionalBoolValue).to(beNil())
            }
        }

        describe("testing int value storing") {

            it("should return nil for default option") {
                expect(StoreTest.optionalIntValue).to(beNil())
            }

            it("should return int for default non optional") {
                expect(StoreTest.nonOptionalDefaultIntValue).to(equal(100))
            }

            it("should return int for stored in optional") {
                StoreTest.nonOptionalIntValue = 2
                expect(StoreTest.nonOptionalIntValue).to(equal(2))
            }

            it("should return int for stored in non-optional") {
                StoreTest.optionalIntValue = 2
                expect(StoreTest.optionalIntValue).to(equal(2))
            }

            it("should return nil for removed value") {
                StoreTest.optionalIntValue = 5
                StoreTest.optionalIntValue = nil
                expect(StoreTest.optionalBoolValue).to(beNil())
            }
        }

        describe("testing float value storing") {

            it("should return nil for default option") {
                expect(StoreTest.optionalFloatValue).to(beNil())
            }

            it("should return float for default non optional") {
                expect(StoreTest.nonOptionalDefaultFloatValue).to(equal(10.0))
            }

            it("should return float for stored in optional") {
                StoreTest.nonOptionalFloatValue = 15.0
                expect(StoreTest.nonOptionalFloatValue).to(equal(15.0))
            }

            it("should return float for stored in non-optional") {
                StoreTest.optionalFloatValue = 20.0
                expect(StoreTest.optionalFloatValue).to(equal(20.0))
            }

            it("should return nil for removed value") {
                StoreTest.optionalFloatValue = 25.0
                StoreTest.optionalFloatValue = nil
                expect(StoreTest.optionalFloatValue).to(beNil())
            }
        }

        describe("testing double value storing") {

            it("should return nil for default option") {
                expect(StoreTest.optionalDoubleValue).to(beNil())
            }

            it("should return double for default non optional") {
                expect(StoreTest.nonOptionalDefaultDoubleValue).to(equal(10.0))
            }

            it("should return double for stored in optional") {
                StoreTest.nonOptionalDoubleValue = 15.0
                expect(StoreTest.nonOptionalDoubleValue).to(equal(15.0))
            }

            it("should return double for stored in non-optional") {
                StoreTest.optionalDoubleValue = 20.0
                expect(StoreTest.optionalDoubleValue).to(equal(20.0))
            }

            it("should return nil for removed value") {
                StoreTest.optionalDoubleValue = 25.0
                StoreTest.optionalDoubleValue = nil
                expect(StoreTest.optionalDoubleValue).to(beNil())
            }
        }

        describe("testing string value storing") {

            it("should return nil for default option") {
                expect(StoreTest.optionalStringValue).to(beNil())
            }

            it("should return string for default non optional") {
                expect(StoreTest.nonOptionalDefaultStringValue).to(equal("Default value"))
            }

            it("should return string for stored in optional") {
                StoreTest.nonOptionalStringValue = "123ABC"
                expect(StoreTest.nonOptionalStringValue).to(equal("123ABC"))
            }

            it("should return string for stored in non-optional") {
                StoreTest.optionalStringValue = "ABC123"
                expect(StoreTest.optionalStringValue).to(equal("ABC123"))
            }

            it("should return nil for removed value") {
                StoreTest.optionalStringValue = "A1B2C3"
                StoreTest.optionalStringValue = nil
                expect(StoreTest.optionalStringValue).to(beNil())
            }
        }

    }
}

private extension UserDefaults_PropertyWrapperTests {

    enum StoreTest {

        @Storage("nonOptionalBoolValue", defaultValue: true)
        static var nonOptionalBoolValue: Bool
        @Storage("nonOptionalBoolDefaultValue", defaultValue: true)
        static var nonOptionalDefaultBoolValue: Bool
        @Storage("optionalBoolValue")
        static var optionalBoolValue: Bool?

        @Storage("nonOptionalIntValue", defaultValue: 100)
        static var nonOptionalIntValue: Int
        @Storage("nonOptionalDefaultIntValue", defaultValue: 100)
        static var nonOptionalDefaultIntValue: Int
        @Storage("optionalIntValue")
        static var optionalIntValue: Int?

        @Storage("nonOptionalFloatValue", defaultValue: 10.0)
        static var nonOptionalFloatValue: Float
        @Storage("nonOptionalDefaultFloatValue", defaultValue: 10.0)
        static var nonOptionalDefaultFloatValue: Float
        @Storage("optionalFloatValue")
        static var optionalFloatValue: Float?

        @Storage("nonOptionalDoubleValue", defaultValue: 10.0)
        static var nonOptionalDoubleValue: Double
        @Storage("nonOptionalDefaultDoubleValue", defaultValue: 10.0)
        static var nonOptionalDefaultDoubleValue: Double
        @Storage("optionalDoubleValue")
        static var optionalDoubleValue: Double?

        @Storage("nonOptionalStringValue", defaultValue: "Default value")
        static var nonOptionalStringValue: String
        @Storage("nonOptionalDefaultStringValue", defaultValue: "Default value")
        static var nonOptionalDefaultStringValue: String
        @Storage("optionalStringValue")
        static var optionalStringValue: String?
    }

    static func clearStorage() {
        StoreTest.optionalBoolValue = nil
        StoreTest.optionalIntValue = nil
        StoreTest.optionalFloatValue = nil
        StoreTest.optionalDoubleValue = nil
        StoreTest.optionalStringValue = nil
    }
}
