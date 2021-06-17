//
//  CollectionDataSourceDelegate.swift
//
//  Created by Vlaho Poluta
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// Object serving as a data source and delegate for a collection view.
/// Main purpose is to reduce a boilerplate when dealing with simple
/// collection view data displaying.
///
/// It can handle both - sections and items
public class CollectionDataSourceDelegate: NSObject {
    
    // MARK: - Public properties

    /// Setting a sections will invoke internal reloader causing table view to refresh.
    public var sections: [CollectionSectionItem]? {
        didSet(oldValue) {
            reloader.reload(collectionView, oldSections: oldValue, newSections: sections)
        }
    }
    
    /// Setting an items will invoke internal reloader causing table view to refresh.
    ///
    /// If there are multiple sections - then data is flattened to single array
    public var items: [CollectionCellItem]? {
        get {
            return sections?
                .map(\.items)
                .reduce(into: [CollectionCellItem]()) { $0 = $0 + $1 }
        }
        set {
            let section: CollectionSectionItem? = BlankCollectionSection(items: newValue)
            sections = [section].compactMap { $0 }
        }
    }
    
    // MARK: - Private properties

    private let collectionView: UICollectionView
    private let reloader: CollectionViewReloader
    private let disposeBag = DisposeBag()
    
    /// Creates a new data source delegate object responsible for handling
    /// collection view's data source and delegate logic.
    ///
    /// **If using the data source delegate object do not change the table view
    /// dataSource property since this object depends on it**
    ///
    /// Freely use `delegate` property since internally data source delegate will
    /// use pass through delegate.
    ///
    /// - Parameters:
    ///   - collectionView: Collection view to control
    ///   - reloader: Data reloader
    public init(collectionView: UICollectionView, reloader: CollectionViewReloader = DefaultCollectionViewReloader()) {
        self.collectionView = collectionView
        self.reloader = reloader
        super.init()
        
        collectionView.dataSource = self
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
}

extension CollectionDataSourceDelegate: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections?[section].items.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return sections![indexPath].cell(from: collectionView, at: indexPath)
    }
    
}

extension CollectionDataSourceDelegate: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        sections?[indexPath].didSelect(at: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        sections?[indexPath].willDisplay(cell: cell, at: indexPath)
    }
    
}

extension CollectionDataSourceDelegate: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let sectionsCount = sections![indexPath.section].items.count
        
        return sections![indexPath]
            .itemSize(
                for: collectionView.bounds.size,
                layout: collectionViewLayout as? UICollectionViewFlowLayout,
                at: indexPath,
                numberOfItemsInSection: sectionsCount
            )
    }
    
}
