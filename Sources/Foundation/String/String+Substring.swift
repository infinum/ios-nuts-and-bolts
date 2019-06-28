//
//  String+Substring.swift
//
//  Created by Goran Brlas on 11/04/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation

public extension String {
    
    /// Returns the substring of `self` from the start of the string to the `to` index.
    ///
    /// - Parameter to: Ending index of the substring
    /// - Returns: Substring from `self`'s start up to the `to` index.
    func substring(to: Int) -> String? {
        guard 0..<count ~= to else { return nil }
        let index = self.index(startIndex, offsetBy: to)
        return String(self[..<index])
    }
    
    /// Returns the substring of `self` starting from the `from` index up to the end of the string.
    ///
    /// - Parameter from: Starting index of the substring
    /// - Returns: Substring from `self` starting from the `from` index.
    func substring(from: Int) -> String? {
        guard 0..<count ~= from else { return nil }
        let index = self.index(startIndex, offsetBy: from)
        return String(self[index...])
    }
    
}
