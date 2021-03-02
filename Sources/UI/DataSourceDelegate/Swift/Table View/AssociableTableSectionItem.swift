//
//  AssociableTableSectionItem.swift
//  Catalog
//
//  Created by Martin Čolja on 02.03.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import UIKit


/// Extended interface for all table view cell items
/// - helps to remove bolierplate when creating cell items
/// - used in conjuction with `TableDataSourceDelegate`
public protocol AssociableTableCellItem: TableCellItem {
    associatedtype AssociatedCell: UITableViewCell, ItemConfigurable
}

extension AssociableTableCellItem where Self == Self.AssociatedCell.ConfigurationItem {

    /// Dequeues and configures reusable cell at given index path
    /// from given table view
    ///
    /// - Parameters:
    ///   - tableView: parent table view
    ///   - indexPath: index path of cell to configure
    /// - Returns: Dequeued, configured and reused cell
    func cell(from tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: AssociatedCell.self, for: indexPath)
        cell.configure(with: self)
        return cell
    }

}

