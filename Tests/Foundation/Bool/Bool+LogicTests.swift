//
//  Bool+Logic.swift
//
//  Created by Goran Brlas on 11/04/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import Catalog

class Bool_LogicTests: QuickSpec {
    
    override func spec() {
        
        describe("Testing and(lhs:rhs:)") {
            
            it("AND should return true if both are true") {
                expect(.and(lhs: true, rhs: true)).to(beTrue())
            }
            
            it("AND should return false if both are not true") {
                expect(.and(lhs: false, rhs: false)).to(beFalse())
            }
            
            it("AND should return false if one is true and one isn't") {
                expect(.and(lhs: true, rhs: false)).to(beFalse())
                expect(.and(lhs: false, rhs: true)).to(beFalse())
            }
            
        }
        
        describe("Testing or(lhs:rhs:)") {
            
            it("OR should return true if both are true") {
                expect(.or(lhs: true, rhs: true)).to(beTrue())
            }
            
            it("OR should return true if one is true and one isn't") {
                expect(.or(lhs: true, rhs: false)).to(beTrue())
                expect(.or(lhs: false, rhs: true)).to(beTrue())
            }
            
            it("OR should return false if both are false") {
                expect(.or(lhs: false, rhs: false)).to(beFalse())
            }
            
        }
        
        describe("Testing xor(lhs:rhs:)") {
            
            it("XOR should return false if both are true") {
                expect(.xor(lhs: true, rhs: true)).to(beFalse())
            }
            
            it("XOR should return true if one is true and one isn't") {
                expect(.xor(lhs: true, rhs: false)).to(beTrue())
                expect(.xor(lhs: false, rhs: true)).to(beTrue())
            }
            
            it("XOR should return false if both are false") {
                expect(.xor(lhs: false, rhs: false)).to(beFalse())
            }
            
        }
        
    }
    
}
