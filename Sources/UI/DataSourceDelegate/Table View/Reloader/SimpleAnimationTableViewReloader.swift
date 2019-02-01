//
//  SimpleAnimationTableViewReloader.swift
//
//  Created by Vlaho Poluta
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

/// Only use for table view's where you just add or remove some cells
/// (not sections) at the end of the section.
///
/// It can't handle both adding and removing, or reloading
public struct SimpleAnimationTableViewReloader: TableViewReloader {
    
    public var animation: UITableView.RowAnimation
    
    public init(animation: UITableView.RowAnimation = .fade) {
        self.animation = animation
    }
    
    public func reload(_ tableView: UITableView, oldSections: [TableSectionItem]?, newSections: [TableSectionItem]?) {
        guard let oldSections = oldSections, let newSections = newSections, oldSections.count == newSections.count else {
            tableView.reloadData()
            return
        }
        
        let indexPathsToDelete: [IndexPath] = zip(oldSections, newSections)
            .enumerated()
            .filter { $1.0.tableItems.count > $1.1.tableItems.count }
            .flatMap { e in (e.element.1.tableItems.count..<e.element.0.tableItems.count).map { IndexPath(item: $0, section: e.offset) } }
        
        let indexPathsToInsert: [IndexPath] = zip(oldSections, newSections)
            .enumerated()
            .filter { $1.0.tableItems.count < $1.1.tableItems.count }
            .flatMap { e in (e.element.0.tableItems.count..<e.element.1.tableItems.count).map { IndexPath(item: $0, section: e.offset) } }
        
        tableView.beginUpdates()
        tableView.deleteRows(at: indexPathsToDelete, with: animation)
        tableView.insertRows(at: indexPathsToInsert, with: animation)
        tableView.endUpdates()
    }
    
}
