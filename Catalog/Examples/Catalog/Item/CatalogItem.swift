//
//  CatalogItem.swift
//  Catalog
//
//  Created by Filip Gulan on 01/02/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import RxCocoa

struct CatalogItem {
    let model: Catalogizable.Type
    let didSelect: PublishRelay<CatalogItem>
}

extension CatalogItem: TableCellItem {
    
    func cell(from tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: CatalogItemTableViewCell.self, for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }
    
    func didSelect(at indexPath: IndexPath) {
        didSelect.accept(self)
    }
    
}

struct CatalogSection {
    let title: String
    let items: [TableCellItem]
}

extension CatalogSection: TableSectionItem {
    
    var estimatedHeaderHeight: CGFloat {
        return 44.0
    }
    
    func titleForHeader(from tableView: UITableView, at index: Int) -> String? {
        return title
    }
    
}
