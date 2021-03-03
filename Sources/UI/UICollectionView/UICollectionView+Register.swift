//
//  UICollectionView+Register.swift
//  Catalog
//
//  Created by Martin Čolja on 02.03.2021..
//  Copyright © 2021 Infinum. All rights reserved.
//

import UIKit

public extension UICollectionView {

    // MARK: - Register cell

    /// Registers a nib object containing a cell, from specified bundle,
    /// with the collection view under a specified identifier. Cell nib object and
    /// cell class name have to be the same.
    ///
    /// If identifier is not provided, cell type will be used as idenitifer.
    ///
    /// If bundle is not provided, main bundle will be used.
    ///
    /// - Parameters:
    ///   - cellType: The class of a cell that you want to use in the collection (must be a UICollectionViewCell subclass).
    ///   - identifier: Cell reuse identifier
    ///   - bundle: Nib object source bundle
    func registerNib<T: UICollectionViewCell>(
        cellOfType cellType: T.Type,
        withReuseIdentifier identifier: String? = nil,
        in bundle: Bundle? = nil
    ) {
        let cellName = String(describing: cellType)
        let identifier = identifier ?? cellName
        let source = bundle ?? Bundle(for: cellType)
        let nib = UINib(nibName: cellName, bundle: source)
        register(nib, forCellWithReuseIdentifier: identifier)
    }

    /// Registers a class for use in creating new collection cells.
    ///
    /// If identifier is not provided, cell type will be used as idenitifer.
    ///
    /// - Parameters:
    ///   - cellType: The class of a cell that you want to use in the collection (must be a UICollectionViewCell subclass).
    ///   - identifier: Cell reuse identifier
    func registerClass<T: UICollectionViewCell>(
        cellOfType cellType: T.Type,
        withReuseIdentifier identifier: String? = nil
    ) {
        let cellName = String(describing: cellType)
        let identifier = identifier ?? cellName
        register(cellType, forCellWithReuseIdentifier: identifier)
    }

}
