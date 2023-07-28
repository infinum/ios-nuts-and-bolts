//
//  LayoutableTestCase.swift
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

class LayoutableTestCase: QuickSpec {

    override func spec() {
        var view: UIView

        view = UILabel(frame: .zero)
        expect(view.translatesAutoresizingMaskIntoConstraints).to(equal(true))

        view = UILabel(frame: .zero).autoLayoutable()
        expect(view.translatesAutoresizingMaskIntoConstraints).to(equal(false))
        expect(view.preservesSuperviewLayoutMargins).to(equal(false))

        view = UILabel(frame: .zero).autoLayoutable(preservesMargins: true)
        expect(view.preservesSuperviewLayoutMargins).to(equal(true))
    }
}
