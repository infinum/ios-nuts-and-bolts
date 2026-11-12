//
//  RequiredValueValidatorTests.swift
//  Tests
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Quick
import Nimble
@testable import Catalog

class RequiredValueValidatorTests: QuickSpec {

    override func spec() {

        describe("Test required value validator") {

            it("should return valid input") {
                let input = "Here's some text"
                let validator = RequiredValueValidator()
                expect(validator.validate(input)).to(beTrue())
            }

            it("should return invalid input") {
                let input = ""
                let validator = RequiredValueValidator()
                expect(validator.validate(input)).to(beFalse())
            }
        }
    }
}
