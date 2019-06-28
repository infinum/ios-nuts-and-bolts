//
//  Array+SafeGet.swift
//
//  Created by Mario Galijot on 27/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation

public extension Array {
    
    /// Returns object at provided index, if an index is in bounds of array indices,
    /// otherwise, returns nil.
    ///
    /// - Parameter index: Index of the object that you want to get.
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
