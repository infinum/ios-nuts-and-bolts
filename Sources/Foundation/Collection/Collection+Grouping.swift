//
//  Collection+Grouping.swift
//
//  Created by Goran Brlas on 11/04/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation

public extension Collection {
    
    /// Groups an array of elements by some value, while still keeping the original order of elements. Swift 4.0 has introduced dictionary functionality which allowed grouping, but it doesn't preserve the initial order.
    
    /// For example, if we have:
    ///    people = [
    ///         Person(name: "Mark", age: 25),
    ///         Person(name: "Ann", age: 24),
    ///         Person(name: "John", age: 25)
    ///    ]
    ///
    /// We want the resulting grouping by age to be:
    ///    [
    ///        [
    ///             Person(name: "Mark", age: 25),
    ///             Person(name: "John", age: 25)
    ///        ],
    ///        [
    ///             Person(name: "Ann", age: 24)]
    ///        ]
    ///    ]
    ///
    /// - Parameter key: Element which is used for grouping.
    /// - Returns: Array containing grouped elements.
    func groupBy<GroupingType: Hashable>(key: (Element) -> (GroupingType)) -> [[Element]] {
        var groups: [GroupingType: [Element]] = [:]
        var groupsOrder: [GroupingType] = []
        
        forEach { element in
            let key = key(element)
            
            if case nil = groups[key]?.append(element) {
                groups[key] = [element]
                groupsOrder.append(key)
            }
        }
        
        return groupsOrder.map { groups[$0] ?? [] }
    }
    
}
