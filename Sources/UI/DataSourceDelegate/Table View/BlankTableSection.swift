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
    
    public var tableItems: [TableCellItem]
    
    public init(tableItems: [TableCellItem]) {
        self.tableItems = tableItems
    }
    
    public convenience init?(tableItems: [TableCellItem]?) {
        guard let items = tableItems else {
            return nil
        }
        self.init(tableItems: items)
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
