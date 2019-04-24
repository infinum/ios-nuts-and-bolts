//
//  Bool+MappingTests.swift
//  Tests
//
//  Created by Goran Brlas on 11/04/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import Catalog

class Bool_MappingTests: QuickSpec {
    
    override func spec() {
        
        describe("Testing mapTrue(to:)") {
            
            it("Map true should return object if bool is true") {
                expect(true.mapTrue(to: 7)) == 7
            }
            
            it("Map true should return nil if bool is false") {
                expect(false.mapTrue(to: 7)).to(beNil())
            }
            
        }
        
        describe("Testing mapFalse(to:)") {
            
            it("Map false should return object if bool is false") {
                expect(false.mapFalse(to: 7)) == 7
            }
            
            it("Map false should return nil if bool is true") {
                expect(true.mapFalse(to: 7)).to(beNil())
            }
            
        }
        
        describe("Testing mapTrue(for:)") {
            
            it("Map true should return optional object if bool is true") {
                let str: String? = "test"
                expect(true.mapTrue(for: str)) == str
            }
            
            it("Map true should return nil if bool is false") {
                let str: String? = "test"
                expect(false.mapTrue(for: str)).to(beNil())
            }
            
        }
        
        describe("Testing mapFalse(for:)") {
            
            it("Map false should return optional object if bool is false") {
                let str: String? = "test"
                expect(false.mapFalse(to: str)) == str
            }
            
            it("Map false should return nil if bool is true") {
                let str: String? = "test"
                expect(true.mapFalse(to: str)).to(beNil())
            }
            
        }
        
        describe("Testing mapTrue(for:_:)") {
            
            it("Map true for object with mapping should return mapped object if bool is true") {
                let object = true.mapTrue(for: 5) {
                    return $0 * $0
                }
                
                expect(object) == 25
            }
            
            it("Map true for object with mapping should return nil if bool is false") {
                let object = false.mapTrue(for: 5) {
                    return $0 * $0
                }
                
                expect(object).to(beNil())
            }
            
        }
        
        describe("Testing mapFalse(for:_:)") {
            
            it("Map false for object with mapping should return mapped object if bool is false") {
                let object = false.mapFalse(for: 5) {
                    return $0 * $0
                }
                
                expect(object) == 25
            }
            
            it("Map false for object with mapping should return nil if bool is true") {
                let object = true.mapFalse(for: 5) {
                    return $0 * $0
                }
                
                expect(object).to(beNil())
            }
            
        }
        
    }
    
}
