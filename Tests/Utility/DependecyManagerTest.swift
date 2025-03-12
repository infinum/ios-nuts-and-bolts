//
//  DependecyManagerTest.swift
//  Tests
//
//  Created by Zvonimir Medak on 29.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Catalog

class DependecyManagerTest: QuickSpec {

    override func spec() {

        describe("Dependency and demo manager") {

            beforeEach {
                DemoManager.instance.start()
            }

            afterEach {
                DemoManager.instance.stop()
            }

            it("ComplexSingletonClass should have mocked value") {
                let complexClass = DependencyManager.instance.complexSingletonClass

                expect(complexClass.exampleClass.exampleString).to(equal("mock string"))
            }

            it("ComplexSingletonClass returns the same instance") {
                var complexClass = DependencyManager.instance.complexSingletonClass
                complexClass.exampleClass.exampleString = "new string"

                var newComplexClass = DependencyManager.instance.complexSingletonClass
                newComplexClass.exampleClass.exampleString = "some newer string"

                expect(complexClass.exampleClass.exampleString).to(equal("some newer string"))
            }

            it("Example class returns a different instance") {
                var exampleClass = DependencyManager.instance.exampleClass
                exampleClass.exampleString = "new string"

                let newExampleClass = DependencyManager.instance.exampleClass

                expect(newExampleClass.exampleString).to(beNil())
            }

            it("ComplexSingletonClass is not mocked") {
                DemoManager.instance.stop()
                let complexSingletonClass = DependencyManager.instance.complexSingletonClass

                expect(complexSingletonClass.exampleClass.exampleString).to(beNil())
            }
        }
    }
}
