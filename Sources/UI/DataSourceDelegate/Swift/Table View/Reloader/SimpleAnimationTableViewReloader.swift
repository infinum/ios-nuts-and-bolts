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
            .filter { $1.0.items.count > $1.1.items.count }
            .flatMap { element in
                (element.element.1.items.count ..< element.element.0.items.count)
                    .map { IndexPath(item: $0, section: element.offset) }
            }
        
        let indexPathsToInsert: [IndexPath] = zip(oldSections, newSections)
            .enumerated()
            .filter { $1.0.items.count < $1.1.items.count }
            .flatMap { element in
                (element.element.0.items.count ..< element.element.1.items.count)
                    .map { IndexPath(item: $0, section: element.offset) }
            }
        
        tableView.beginUpdates()
        tableView.deleteRows(at: indexPathsToDelete, with: animation)
        tableView.insertRows(at: indexPathsToInsert, with: animation)
        tableView.endUpdates()
    }
    
}
