//
//  StackViewExtensions+TestCase.swift
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

class StackViewExtensions: QuickSpec {

    override func spec() {

        describe("stack view extensions test") {
            var label = UILabel()
            var slider = UISlider()
            var stackView = UIStackView(arrangedSubviews: [label, slider])

            beforeEach {
                label = UILabel()
                slider = UISlider()
                stackView = UIStackView(arrangedSubviews: [label, slider])
            }

            it("initialization") {
                stackView = .init(
                    axis: .horizontal,
                    distribution: .equalSpacing,
                    alignment: .firstBaseline,
                    spacing: 9,
                    margins: .leftAndRight(16),
                    arrangedSubviews: [label]
                )

                expect(stackView.axis).to(equal(.horizontal))
                expect(stackView.distribution).to(equal(.equalSpacing))
                expect(stackView.alignment).to(equal(.firstBaseline))
                expect(stackView.spacing).to(equal(9))
                expect(stackView.explicitMargins).to(equal(.leftAndRight(16)))
                expect(stackView.arrangedSubviews.count).to(equal(1))
            }

            it("should return valid isEmptyOrAllSubviewsHidden") {
                expect(stackView.isEmptyOrAllSubviewsHidden).to(equal(false))
                slider.isHidden = true
                expect(stackView.isEmptyOrAllSubviewsHidden).to(equal(false))
                label.isHidden = true
                expect(stackView.isEmptyOrAllSubviewsHidden).to(equal(true))
                label.isHidden = false
                slider.removeFromSuperview()
                expect(stackView.isEmptyOrAllSubviewsHidden).to(equal(false))
                label.removeFromSuperview()
                expect(stackView.isEmptyOrAllSubviewsHidden).to(equal(true))
            }

            it("addArrangedSubviews") {
                stackView.addArrangedSubviews(UISlider(), UISlider())
                expect(stackView.arrangedSubviews.count).to(equal(4))
            }

            it("addArrangedSubviewsArray") {
                stackView.addArrangedSubviews([UISlider(), UISlider()])
                expect(stackView.arrangedSubviews.count).to(equal(4))
            }

            it("removeAllArrangedSubviews") {
                stackView.removeAllArrangedSubviews()
                expect(stackView.arrangedSubviews.isEmpty).to(beTrue())
            }

            it("removeArrangedSubviews") {
                stackView.removeArrangedSubviews([label])
                expect(stackView.arrangedSubviews).to(contain(slider))
                expect(stackView.arrangedSubviews).toNot(contain(label))
            }

            it("replaceAllArrangedSubviews") {
                expect(stackView.arrangedSubviews.count).to(equal(2))
                stackView.replaceAllArrangedSubviews(with: UILabel())
                expect(stackView.arrangedSubviews.count).to(equal(1))
            }
         }

    }
}
