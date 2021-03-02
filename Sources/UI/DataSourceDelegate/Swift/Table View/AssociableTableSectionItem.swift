//
//  AssociableTableSectionItem.swift
//  Catalog
//
//  Created by Martin Čolja on 02.03.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import UIKit

protocol AssociableTableCellItem: TableCellItem {
    associatedtype AssociatedCell: UITableViewCell, ItemConfigurable
}

extension AssociableTableCellItem where Self == AssociatedCell.ConfigurationItem {

    func cell(from tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: AssociatedCell.self, for: indexPath)
        cell.configure(with: self)
        return cell
    }

}

