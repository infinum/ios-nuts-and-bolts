//
//  Array+Rotate.swift
//  Catalog
//
//  Created by Filip Gulan on 01/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation

public extension Array {
    
    /// Rotates current array in left or right direction for given steps
    ///
    /// Step > 0 will rotate array to the right, e.g.:
    /// [1, 2, 3, 4, 5].rotated(for: 1) == [5, 1, 2, 3, 4]
    ///
    /// Step < 0 will rotate array to the left, e.g.:
    /// [1, 2, 3, 4, 5].rotated(for: -1) == [2, 3, 4, 5, 1]
    ///
    /// There are no constraints on number of steps - array length
    /// will be checked and number of steps will be reduced to
    /// rotations % array.length, e.g.:
    ///
    /// [1, 2, 3, 4, 5].rotated(for: 6) == [5, 1, 2, 3, 4]
    ///
    /// - Parameter rotations: Number of steps
    /// - Returns: Array rotated for given number of steps
    func rotated(for rotations: Int) -> [Element] {
        let length = count // Store it
        
        guard rotations != 0 && length > 1 else {
            return self
        }
        
        // If shift is larger than length then effectively array
        // is rotated only for modulo length
        var effectiveRotations = rotations % length
        
        // If shift is negative, then just reverse the order of rotation
        // and take care of the overflow
        effectiveRotations += length
        effectiveRotations %= length
        
        
        let wholeReversed: Array = reversed()
        let leftPart: Array = wholeReversed[0..<effectiveRotations].reversed()
        let rightPart: Array = wholeReversed[effectiveRotations..<length].reversed()
        
        return leftPart + rightPart
    }
    
}
