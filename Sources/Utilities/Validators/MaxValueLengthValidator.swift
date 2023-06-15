//
//  MaxValueLengthValidator.swift
//  Catalog
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Foundation

public struct MaxValueLengthValidator {

    // MARK: - Private propeties

    private let maxLength: Int

    // MARK: - Init -

    public init(maxLength: Int) {
        self.maxLength = maxLength
    }
}

// MARK: StringValidator conformance

extension MaxValueLengthValidator: StringValidator {

    // Example invalid input description
    public var invalidInputDescription: String {
        "The input is too long, it has to have maximum of \(maxLength) characters"
    }

    public func validate(_ value: String) -> Bool {
        value.count <= maxLength
    }
}
