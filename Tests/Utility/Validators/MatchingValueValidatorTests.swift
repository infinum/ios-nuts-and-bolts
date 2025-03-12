//
//  MatchingValueValidatorTests.swift
//  Tests
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Quick
import Nimble
@testable import Catalog

class MatchingValueValidatorTests: QuickSpec {

    override func spec() {

        describe("Test matching value validator") {

            it("should return valid input") {
                let input = "Here's some text"
                let valueToMatch = "Here's some text"
                let validator = MatchingValueValidator(valueToMatch: valueToMatch)
                expect(validator.validate(input)).to(beTrue())
            }

            it("should return invalid input empty input") {
                let input = ""
                let valueToMatch = "Here's some text"
                let validator = MatchingValueValidator(valueToMatch: valueToMatch)
                expect(validator.validate(input)).to(beFalse())
            }

            it("should return invalid input") {
                let input = "Here's some tex"
                let valueToMatch = "Here's some text"
                let validator = MatchingValueValidator(valueToMatch: valueToMatch)
                expect(validator.validate(input)).to(beFalse())
            }
        }
    }
}
