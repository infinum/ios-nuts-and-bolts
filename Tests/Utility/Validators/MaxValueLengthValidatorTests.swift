//
//  MaxValueLengthValidatorTests.swift
//  Tests
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Quick
import Nimble
@testable import Catalog

class MaxValueLengthValidatorTests: QuickSpec {

    override func spec() {

        describe("Test max value length validator") {

            it("should return valid input length") {
                let input = "Proper text"
                let validator = MaxValueLengthValidator(maxLength: 20)
                expect(validator.validate(input)).to(beTrue())
            }

            it("should return invalid input length") {
                let input = "Not a proper text since it's too long"
                let validator = MaxValueLengthValidator(maxLength: 20)
                expect(validator.validate(input)).to(beFalse())
            }

            it("should return valid input length with empty input") {
                let input = ""
                let validator = MaxValueLengthValidator(maxLength: 20)
                expect(validator.validate(input)).to(beTrue())
            }
        }
    }
}
