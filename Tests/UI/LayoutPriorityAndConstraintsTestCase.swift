//
//  LayoutPriorityAndConstraintsTestCase.swift
//  Tests
//
//  Created by Infinum on 28.07.2023..
//  Copyright © 2023 Infinum. All rights reserved.
//

import Foundation
import XCTest
import Quick
import Nimble
@testable import Catalog

class LayoutPriorityExtensionsTestCase: QuickSpec {

    override func spec() {
        let view = UIView()

        it("Initializers Literals for Layout Priorities") {
            view.horizontalHuggingPriority = 750
            expect(view.contentHuggingPriority(for: .horizontal)).to(equal(UILayoutPriority.defaultHigh))

            view.horizontalCompressionResistance = 1000
            expect(view.contentCompressionResistancePriority(for: .horizontal)).to(equal(UILayoutPriority.required))
        }

        it("Setters for Layout Priorities") {
            view.horizontalCompressionResistance = 900
            expect(view.contentCompressionResistancePriority(for: .horizontal).rawValue).to(equal(900))

            view.verticalCompressionResistance = 800
            expect(view.contentCompressionResistancePriority(for: .vertical).rawValue).to(equal(800))

            view.horizontalHuggingPriority = 700
            expect(view.contentHuggingPriority(for: .horizontal).rawValue).to(equal(700))

            view.verticalHuggingPriority = 600
            expect(view.contentHuggingPriority(for: .vertical).rawValue).to(equal(600))
        }

        it("Changing priority of array of constraints") {
            let widthConstraint = view.widthAnchor.constraint(equalToConstant: 80)
            let heightConstraint = view.heightAnchor.constraint(equalToConstant: 80)

            let constraints = [widthConstraint, heightConstraint].with(priority: 600)

            expect(constraints.allSatisfy { $0.priority.rawValue == 600 }).to(beTrue())
        }

        it("Activate All Constraints") {
            let widthConstraint = view.widthAnchor.constraint(equalToConstant: 80)
            let heightConstraint = view.heightAnchor.constraint(equalToConstant: 80)

            let constraints = [widthConstraint, heightConstraint]
            expect(constraints.map(\.isActive)).to(equal([false, false]))
            constraints.activateAll()
            expect(constraints.map(\.isActive)).to(equal([true, true]))
        }
    }
}
