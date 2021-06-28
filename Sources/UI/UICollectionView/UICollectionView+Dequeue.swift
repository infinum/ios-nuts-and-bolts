//
//  UICollectionView+Dequeue.swift
//  Catalog
//
//  Created by Martin Čolja on 02.03.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import UIKit

public extension UICollectionView {

    /// Returns a reusable collection-view cell object for the specified reuse identifier and type
    /// and adds it to the collection.
    ///
    /// If identifier is not provided, cell type will be used as idenitifer.
    ///
    /// - Parameters:
    ///   - type: The class of a cell that you want to use in the collection (must be a UICollectionViewCell subclass).
    ///   - identifier: Custom cell identifier
    ///   - indexPath: The index path specifying the location of the cell
    /// - Returns: A subclass of UICollectionViewCell object with the associated reuse identifier.
    func dequeueReusableCell<T: UICollectionViewCell>(
        ofType type: T.Type,
        withReuseIdentifier identifier: String? = nil,
        for indexPath: IndexPath
    ) -> T {
        let identifier = identifier ?? String(describing: type)
        // swiftlint:disable:next force_cast
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }
    
}
