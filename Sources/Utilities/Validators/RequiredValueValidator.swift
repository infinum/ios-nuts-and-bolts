//
//  RequiredValueValidator.swift
//  Catalog
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Foundation

public struct RequiredValueValidator: StringValidator {

    // Example invalid input description
    public var invalidInputDescription: String {
        "Input field requires a value!"
    }

    public func validate(_ value: String) -> Bool {
        value.isNotBlank
    }
}
