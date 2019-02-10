//
//  BlankCollectionSection.swift
//
//  Created by Vlaho Poluta
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation

public class BlankCollectionSection: CollectionSectionItem {
    
    public var items: [CollectionCellItem]
    
    public init(items: [CollectionCellItem]) {
        self.items = items
    }
    
    public convenience init?(items: [CollectionCellItem]?) {
        guard let items = items else {
            return nil
        }
        self.init(items: items)
    }
    
}
