//
//  String+SubstringTests.swift
//  Tests
//
//  Created by Goran Brlas on 11/04/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Catalog

class String_SubstringTests: QuickSpec {
    
    override func spec() {
        
        describe("testing substring(to:)") {
            
            it("should return proper substring if to is lower than string count") {
                let string = "Test"
                expect(string.substring(to: 0)) == ""
            }
            
            it("should return proper substring if to is lower than string count") {
                let string = "Test"
                expect(string.substring(to: 2)) == "Te"
            }
            
            it("should return nil if to is negative") {
                let string = "Test"
                expect(string.substring(to: -2)).to(beNil())
            }
            
            it("should return nil if to is higher than string count") {
                let string = "Test"
                expect(string.substring(to: 10)).to(beNil())
            }
            
        }
        
        describe("testing substring(from:)") {
            
            it("should return proper substring if from is lower than string count") {
                let string = "Test"
                expect(string.substring(from: 0)) == "Test"
            }
            
            it("should return proper substring if from is lower than string count") {
                let string = "Test"
                expect(string.substring(from: 2)) == "st"
            }
            
            it("should return nil if from is negative") {
                let string = "Test"
                expect(string.substring(from: -2)).to(beNil())
            }
            
            it("should return nil if from is higher than string count") {
                let string = "Test"
                expect(string.substring(from: 10)).to(beNil())
            }
            
        }
        
    }
}
