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

            it("should return int for default non-optional") {
                expect(StoreTest.nonOptionalDefaultIntValue).to(equal(100))
            }

            it("should return int for stored in optional") {
                StoreTest.optionalIntValue = 2
                expect(StoreTest.optionalIntValue).to(equal(2))
            }

            it("should return int for stored in non-optional") {
                StoreTest.nonOptionalIntValue = 2
                expect(StoreTest.nonOptionalIntValue).to(equal(2))
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

            it("should return float for default non-optional") {
                expect(StoreTest.nonOptionalDefaultFloatValue).to(equal(10.0))
            }

            it("should return float for stored in optional") {
                StoreTest.optionalFloatValue = 15.0
                expect(StoreTest.optionalFloatValue).to(equal(15.0))
            }

            it("should return float for stored in non-optional") {
                StoreTest.nonOptionalFloatValue = 20.0
                expect(StoreTest.nonOptionalFloatValue).to(equal(20.0))
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

            it("should return double for default non-optional") {
                expect(StoreTest.nonOptionalDefaultDoubleValue).to(equal(10.0))
            }

            it("should return double for stored in optional") {
                StoreTest.optionalDoubleValue = 15.0
                expect(StoreTest.optionalDoubleValue).to(equal(15.0))
            }

            it("should return double for stored in non-optional") {
                StoreTest.nonOptionalDoubleValue = 20.0
                expect(StoreTest.nonOptionalDoubleValue).to(equal(20.0))
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

            it("should return string for default non-optional") {
                expect(StoreTest.nonOptionalDefaultStringValue).to(equal("Default value"))
            }

            it("should return string for stored in optional") {
                StoreTest.optionalStringValue = "123ABC"
                expect(StoreTest.optionalStringValue).to(equal("123ABC"))
            }

            it("should return string for stored in non-optional") {
                StoreTest.nonOptionalStringValue = "ABC123"
                expect(StoreTest.nonOptionalStringValue).to(equal("ABC123"))
            }

            it("should return nil for removed value") {
                StoreTest.optionalStringValue = "A1B2C3"
                StoreTest.optionalStringValue = nil
                expect(StoreTest.optionalStringValue).to(beNil())
            }
        }

        describe("testing codable value storing") {

            it("should return nil for default option") {
                expect(StoreTest.optionalCodableValue).to(beNil())
            }

            it("should return stored data for default non-optional") {
                expect(StoreTest.nonOptionalDefaultCodableValue.testValue).to(equal("default data"))
            }

            it("should return stored data for stored in optional") {
                StoreTest.optionalCodableValue = TestData(testValue: "Test data")
                expect(StoreTest.optionalCodableValue?.testValue).to(equal("Test data"))
            }

            it("should return stored data for stored in non-optional") {
                StoreTest.nonOptionalCodableValue = TestData(testValue: "Test data 2")
                expect(StoreTest.nonOptionalCodableValue.testValue).to(equal("Test data 2"))
            }

            it("should return nil for removed value") {
                StoreTest.optionalCodableValue = TestData(testValue: "")
                StoreTest.optionalCodableValue = nil
                expect(StoreTest.optionalCodableValue).to(beNil())
            }
        }

        describe("testing raw representable value storing") {

            it("should return stored data for default non-optional") {
                expect(StoreTest.nonOptionalEnumDefaultValue.rawValue).to(equal(-1))
            }

            it("should return stored data for stored in non-optional") {
                StoreTest.nonOptionalEnumValue = .one
                expect(StoreTest.nonOptionalEnumValue.rawValue).to(equal(1))
            }
        }

        describe("testing custom UserDefaults storing") {

            it("should return stored data for stored optional") {
                StoreTest.optionalCodableValueCustomUserDefaults = TestData(testValue: "Test data")
                let storedOptionalCodable = try! JSONDecoder().decode(
                    TestData.self,
                    from: StoreTest.customUserDefaults.object(forKey: "optionalCodableValueCustomUserDefaults") as! Data
                )
                expect(storedOptionalCodable.testValue).to(equal("Test data"))
                expect(StoreTest.optionalCodableValueCustomUserDefaults?.testValue).to(equal("Test data"))
            }

            it("should return stored data for default non-optional string") {
                StoreTest.nonOptionalStringValueCustomUserDefaults = "123ABC"
                let storedString = StoreTest.customUserDefaults.object(forKey: "nonOptionalStringValueCustomUserDefaults") as! String
                expect(storedString).to(equal("123ABC"))
                expect(StoreTest.nonOptionalStringValueCustomUserDefaults).to(equal("123ABC"))
            }

            it("should return stored data for default non-optional rawRepresentable") {
                StoreTest.nonOptionalEnumValueCustomUserDefaults = .two
                let storedEnum = StoreTest.customUserDefaults.object(forKey: "nonOptionalEnumValueCustomUserDefaults") as! Int
                expect(storedEnum).to(equal(2))
                expect(StoreTest.nonOptionalEnumValueCustomUserDefaults).to(equal(.two))
            }
        }
    }
}

private extension UserDefaults_PropertyWrapperTests {

    // Codable test data

    struct TestData: Codable {
        let testValue: String

        static var `default`: TestData {
            return TestData(testValue: "default data")
        }
    }

    // RawRepresentable test data

    enum Number: Codable {
        case zero
        case one
        case two
        case unknown
    }

    // Storage

    enum StoreTest {

        @UserDefault(.nonOptionalBoolValue, defaultValue: true)
        static var nonOptionalBoolValue: Bool
        @UserDefault(.nonOptionalBoolDefaultValue, defaultValue: true)
        static var nonOptionalDefaultBoolValue: Bool
        @UserDefault(.optionalBoolValue)
        static var optionalBoolValue: Bool?

        @UserDefault(.nonOptionalIntValue, defaultValue: 100)
        static var nonOptionalIntValue: Int
        @UserDefault(.nonOptionalDefaultIntValue, defaultValue: 100)
        static var nonOptionalDefaultIntValue: Int
        @UserDefault(.optionalIntValue)
        static var optionalIntValue: Int?

        @UserDefault(.nonOptionalFloatValue, defaultValue: 10.0)
        static var nonOptionalFloatValue: Float
        @UserDefault(.nonOptionalDefaultFloatValue, defaultValue: 10.0)
        static var nonOptionalDefaultFloatValue: Float
        @UserDefault(.optionalFloatValue)
        static var optionalFloatValue: Float?

        @UserDefault(.nonOptionalDoubleValue, defaultValue: 10.0)
        static var nonOptionalDoubleValue: Double
        @UserDefault(.nonOptionalDefaultDoubleValue, defaultValue: 10.0)
        static var nonOptionalDefaultDoubleValue: Double
        @UserDefault(.optionalDoubleValue)
        static var optionalDoubleValue: Double?

        @UserDefault(.nonOptionalStringValue, defaultValue: "Default value")
        static var nonOptionalStringValue: String
        @UserDefault(.nonOptionalDefaultStringValue, defaultValue: "Default value")
        static var nonOptionalDefaultStringValue: String
        @UserDefault(.optionalStringValue)
        static var optionalStringValue: String?

        @UserDefault(.nonOptionalCodableValue, defaultValue: TestData.default)
        static var nonOptionalCodableValue: TestData
        @UserDefault(.nonOptionalDefaultCodableValue, defaultValue: TestData.default)
        static var nonOptionalDefaultCodableValue: TestData
        @UserDefault(.optionalCodableValue)
        static var optionalCodableValue: TestData?

        @UserDefault(.nonOptionalEnumValue, defaultValue: .unknown)
        static var nonOptionalEnumValue: Number
        @UserDefault(.nonOptionalEnumDefaultValue, defaultValue: .unknown)
        static var nonOptionalEnumDefaultValue: Number

        static let customUserDefaults = UserDefaults(suiteName: "customUserDefaults")!

        @UserDefault(.optionalCodableValueCustomUserDefaults, defaultValue: nil, userDefaults: customUserDefaults)
        static var optionalCodableValueCustomUserDefaults: TestData?

        @UserDefault(.nonOptionalStringValueCustomUserDefaults, defaultValue: "", userDefaults: customUserDefaults)
        static var nonOptionalStringValueCustomUserDefaults: String

        @UserDefault(.nonOptionalEnumValueCustomUserDefaults, defaultValue: .unknown, userDefaults: customUserDefaults)
        static var nonOptionalEnumValueCustomUserDefaults: Number
    }

    static func clearStorage() {
        StoreTest.optionalBoolValue = nil
        StoreTest.optionalIntValue = nil
        StoreTest.optionalFloatValue = nil
        StoreTest.optionalDoubleValue = nil
        StoreTest.optionalStringValue = nil
        StoreTest.optionalCodableValue = nil
    }
}

extension UserDefaults_PropertyWrapperTests.Number: RawRepresentable {

    init(rawValue: Int) {
        switch rawValue {
            case 0: self = .zero
            case 1: self = .one
            case 2: self = .two
            default: self = .unknown
        }
    }

    var rawValue: Int {
        switch self {
            case .zero: return 0
            case .one: return 1
            case .two: return 2
            case .unknown: return -1
        }
    }
}
