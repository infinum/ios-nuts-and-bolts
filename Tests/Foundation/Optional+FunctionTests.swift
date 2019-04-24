//
//  Optional+FunctionTests.swift
//  Tests
//
//  Created by Goran Brlas on 11/04/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Catalog

class Optional_FunctionTests: QuickSpec {
    
    override func spec() {
        
        describe("Testing forValue(do:)") {
            
            it("should be executed if optional is .some") {
                var value = 5
                let optional: Int? = 5
                
                optional.forValue { value = value + $0 }
                
                expect(value) == 10
            }
            
            it("should not be executed if optional is .none") {
                var value = 5
                let optional: Int? = nil
                
                optional.forValue { value = value + $0 }
                
                expect(value) == 5
            }
            
        }
    }
}
