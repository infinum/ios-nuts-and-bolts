//
//  String+Inserting.swift
//  Tests
//
//  Created by Goran Brlas on 11/04/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation

public extension String {
    
    /// Inserts `charToAdd` to `self` at `position` and returns the resulting string.
    ///
    /// - Parameters:
    ///   - charToAdd: Character to add
    ///   - position: Position at which the character should be added
    /// - Returns: String with character inserted at provided position.
    func insertingCharacter(_ charToAdd: Character, at position: Int) -> String {
        if position > self.count || position < 0 {
            return self
        }
        
        var str = self
        str.insert(charToAdd, at: self.index(self.startIndex, offsetBy: position))
        return str
    }
    
    /// Inserts `charToAdd` to `self` at `position` and returns the resulting string.
    ///
    /// - Parameters:
    ///   - charToAdd: Character to add
    ///   - positions: Positions at which the character should be added
    /// - Returns: String with character inserted at provided positions.
    func insertingCharacter(_ charToAdd: Character, at positions: [Int]) -> String {
        return positions.reduce(self) {
            $0.insertingCharacter(charToAdd, at: $1)
        }
    }
    
}
