//
//  CollectionSectionItem.swift
//
//  Created by Vlaho Poluta
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

public protocol CollectionSectionItem: SectionItem {
    
    // MARK: - Required methods and properties
    
    var items: [CollectionCellItem] { get }
    
}

public extension Array where Element: CollectionSectionItem {
    
    subscript(indexPath: IndexPath) -> CollectionCellItem {
        return self[indexPath.section].items[indexPath.row]
    }
    
}

public extension Array where Element == CollectionSectionItem {
    
    subscript(indexPath: IndexPath) -> CollectionCellItem {
        return self[indexPath.section].items[indexPath.row]
    }
    
}
