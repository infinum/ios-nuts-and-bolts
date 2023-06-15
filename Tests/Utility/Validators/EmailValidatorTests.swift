//
//  EmailValidatorTests.swift
//  Tests
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//


import Quick
import Nimble
@testable import Catalog

class EmailValidatorTests: QuickSpec {

    override func spec() {

        let validEmailAddresses: [String] = [
            "email@example.com",
            "firstname.lastname@example.com",
            "email@subdomain.example.com",
            "firstname+lastname@example.com",
            "1234567890@example.com",
            "email@example-one.com",
            "email@example.name",
            "email@example.museum",
            "email@example.co.jp",
            "firstname-lastname@example.com",
            "test+mail+test123@example.com",
            "test++someone.123@example.com",
            "Abc..123@example.com",
            "email..email@example.com"
        ]

        let invalidEmailAddresses: [String] = [
            "plainaddress",
            "#@%^%#$@#$@#.com",
            "@example.com",
            "Joe Smith <email@example.com>",
            "email@example@example.com",
            "あいうえお@example.com",
            "email@example.com (Joe Smith)",
            "email@example",
            "email@-example.com",
            "email@example..com",
            "email.example.com",
            ".email@example.com"
        ]

        describe("Test email validator") {

            it("should return emails as valid") {
                let validator = EmailValidator()
                validEmailAddresses.forEach { expect(validator.validate($0)).to(beTrue()) }
            }

            it("should return emails as invalid") {
                let validator = EmailValidator()
                invalidEmailAddresses.forEach { expect(validator.validate($0)).to(beFalse()) }
            }
        }
    }
}
