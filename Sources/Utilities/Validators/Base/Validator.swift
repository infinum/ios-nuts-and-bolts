//
//  Validator.swift
//  Catalog
//
//  Created by Zvonimir Medak on 16.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import Foundation

public protocol Validator {
    /// Description to show if the input is invalid
    var invalidInputDescription: String { get }
    /// Validates the specified input
    func validate(_ value: Any) -> Bool
}
