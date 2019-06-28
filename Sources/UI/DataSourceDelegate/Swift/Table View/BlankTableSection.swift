//
//  BlankTableSection.swift
//
//  Created by Vlaho Poluta
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

/// Represents blank section - without header or footer
/// Used in conjuction with table view data source delegate
/// for easy mapping items to single section without footer
/// or header - just like you didn't use section at all.
public class BlankTableSection: TableSectionItem {
    
    public var items: [TableCellItem]
    
    public init(items: [TableCellItem]) {
        self.items = items
    }
    
    public convenience init?(items: [TableCellItem]?) {
        guard let items = items else {
            return nil
        }
        self.init(items: items)
    }
    
    public var headerHeight: CGFloat {
        if #available(iOS 11.0, *) {
            return .leastNonzeroMagnitude
        } else {
            return 0
        }
    }

    public var footerHeight: CGFloat {
        if #available(iOS 11.0, *) {
            return .leastNonzeroMagnitude
        } else {
            return 0
        }
    }
    
    public var estimatedHeaderHeight: CGFloat {
        return headerHeight
    }
    
    public var estimatedFooterHeight: CGFloat {
        return footerHeight
    }
    
}
