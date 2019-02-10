//
//  CollectionViewReloader.swift
//
//  Created by Vlaho Poluta
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

/// Used in conjuction with CollectionDataSourceDelegate to provide a way
/// to control collection view reloading behavior
public protocol CollectionViewReloader {
    
    /// Called when new data arrives and reload is necessary
    ///
    /// - Parameters:
    ///   - collectionView: Current collection view
    ///   - oldSections: Previous sections/items
    ///   - newSections: New sections/items
    func reload(
        _ collectionView: UICollectionView,
        oldSections: [CollectionSectionItem]?,
        newSections: [CollectionSectionItem]?
    )
}

/// Reloads collection view data simply calling collection view's reloadData method
public struct DefaultCollectionViewReloader: CollectionViewReloader {
    
    public init() {}
    
    public func reload(_ collectionView: UICollectionView, oldSections: [CollectionSectionItem]?, newSections: [CollectionSectionItem]?) {
        collectionView.reloadData()
    }
    
}
