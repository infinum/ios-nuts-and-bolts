//
//  CatalogItem.swift
//  Catalog
//
//  Created by Filip Gulan on 01/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

struct CatalogItem {
    let title: String
    let didSelect: (() -> ())?
}

extension CatalogItem: TableCellItem {
    
    func cell(from tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: CatalogItemTableViewCell.self, for: indexPath)
        cell.textLabel?.text = title
        return cell
    }
    
    func didSelect(at indexPath: IndexPath) {
        didSelect?()
    }
    
}
