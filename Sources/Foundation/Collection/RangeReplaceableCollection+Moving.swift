//
//  RangeReplaceableCollection+Moving.swift
//  Tests
//
//  Created by Goran Brlas on 11/04/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation

extension RangeReplaceableCollection {
    
    /// Moves the element at the `startIndex` to `endIndex`.
    ///
    /// - Parameters:
    ///   - startIndex: Starting index
    ///   - endIndex: Ending index
    /// - Returns: `Self`, with reordered elements.
    func moving(elementAt startIndex: Index, to endIndex: Index) -> Self {
        var result = self
        let element = result.remove(at: startIndex)
        result.insert(element, at: endIndex)
        return result
    }
    
}
