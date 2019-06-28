//
//  CollectionCellItem.swift
//
//  Created by Vlaho Poluta
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

/// Base interface for all collection view cell items - used in conjuction with
/// `CollectionDataSourceDelegate`
public protocol CollectionCellItem: CellItem {
    
    // MARK: - Required methods and properties
    
    /// Dequeue and configure reusable cell at given index path
    /// from given collection view
    ///
    /// Dequeued cell should be configured with current item before
    /// returning it.
    ///
    /// - Parameters:
    ///   - collectionView: parent collection view
    ///   - indexPath: index path of cell to configure
    /// - Returns: Dequeued, configured and reused cell
    func cell(from collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
    
    // MARK: - Optional methods and properties
    
    /// Size for item's cell
    ///
    /// - Parameters:
    ///   - collectionViewSize: Size of a parent collection view
    ///   - layout: Used flow layout
    ///   - indexPath: cell index path
    ///   - numberOfItemsInSection: number of items in current section
    /// - Returns: Size for item's cell
    func itemSize(
        for collectionViewSize: CGSize,
        layout: UICollectionViewFlowLayout?,
        at indexPath: IndexPath,
        numberOfItemsInSection: Int
    ) -> CGSize
    
    /// Notification before cell will be displayed - use this method
    /// for configuring complex cell layout
    ///
    /// - Parameters:
    ///   - cell: Item's collection view cell
    ///   - indexPath: Item's index path
    func willDisplay(cell: UICollectionViewCell, at indexPath: IndexPath)
    
    /// Notifies cell item when user selects collection view cell.
    ///
    /// - Parameter indexPath: index path of a selected cell
    func didSelect(at indexPath: IndexPath)
    
}

public extension CollectionCellItem {
    
    func itemSize(
        for collectionViewSize: CGSize,
        layout: UICollectionViewFlowLayout?,
        at indexPath: IndexPath,
        numberOfItemsInSection: Int
    ) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func willDisplay(cell: UICollectionViewCell, at indexPath: IndexPath) {
        // Empty implementation
    }
    
    func didSelect(at indexPath: IndexPath) {
        // Empty implementation
    }
    
}
