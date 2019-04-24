//
//  String+BlankTests.swift
//  Tests
//
//  Created by Filip Gulan on 01/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Catalog

class String_BlankTests: QuickSpec {
    
    override func spec() {
        
        describe("testing string extensions") {
            
            it("is not blank for string with characters") {
                let string = "Test"
                expect(string.isBlank).to(beFalse())
            }
            
            it("is not blank for string with characters, spaces and empty lines") {
                let string = "   Test    \n   "
                expect(string.isBlank).to(beFalse())
            }
            
            it("is blank for string with only spaces and empty lines") {
                let string = "       \n   \n"
                expect(string.isBlank).to(beTrue())
            }
            
            it("is blank for empty string") {
                let string = ""
                expect(string.isBlank).to(beTrue())
            }
            
            it("is not blank for optional string with characters") {
                let string: String? = "Test"
                expect(string.isBlank).to(beFalse())
            }
            
            it("is not blank for optional string with characters, spaces and empty lines") {
                let string: String? = "   Test    \n   "
                expect(string.isBlank).to(beFalse())
            }
            
            it("is blank for optional string with only spaces and empty lines") {
                let string: String? = "       \n   \n"
                expect(string.isBlank).to(beTrue())
            }
            
            it("is blank for optional empty string") {
                let string: String? = ""
                expect(string.isBlank).to(beTrue())
            }
            
            it("is blank for nil") {
                let string: String? = nil
                expect(string.isBlank).to(beTrue())
            }
            
        }
    }
}
