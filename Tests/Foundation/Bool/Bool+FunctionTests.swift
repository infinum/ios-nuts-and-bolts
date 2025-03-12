//
//  Bool+FunctionTests.swift
//
//  Created by Goran Brlas on 11/04/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import Catalog

class BoolFunctionTests: QuickSpec {
    
    override func spec() {
        
        describe("Testing forTrue(do:)") {
            
            it("Function should be executed if bool is true") {
                var value = 5
                true.forTrue { value = 10 }
                
                expect(value) == 10
            }
            
            it("Function should not be executed if bool is true") {
                var value = 5
                false.forTrue { value = 10 }
                
                expect(value) == 5
            }
            
        }
        
        describe("Testing forFalse(do:)") {
            
            it("Function should be executed if bool is false") {
                var value = 5
                false.forFalse { value = 10 }
                
                expect(value) == 10
            }
            
            it("Function should not be executed if bool is true") {
                var value = 5
                true.forFalse { value = 10 }
                
                expect(value) == 5
            }
            
        }
        
    }
    
}
