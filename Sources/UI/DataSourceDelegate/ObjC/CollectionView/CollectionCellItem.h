//
//  CollectionCellItem.h
//
//  Created by Ivana Mršić on 20/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellItem.h"

/// Base interface for all collection view cell items - used in conjuction with
/// `CollectionDataSourceDelegate`
@protocol CollectionCellItem <NSObject, CellItem>

#pragma mark - Required methods and properties

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
- (__kindof UICollectionViewCell *)cellFromCollectionView:(UICollectionView *)collectionView at:(NSIndexPath *)indexPath;

#pragma mark - Optional methods and properties

/// Size for item's cell
///
/// - Parameters:
///   - collectionViewSize: Size of a parent collection view
///   - layout: Used flow layout
///   - indexPath: cell index path
///   - numberOfItemsInSection: number of items in current section
/// - Returns: Size for item's cell
- (CGSize)itemSizeForCollectionViewSize:(CGSize)collectionViewSize layout:(UICollectionViewLayout *)layout at:(NSIndexPath *)indexPath numberOfItemsInSection:(NSInteger)numberOfItemsInSection;

/// Notification before cell will be displayed - use this method
/// for configuring complex cell layout
///
/// - Parameters:
///   - cell: Item's collection view cell
///   - indexPath: Item's index path
- (void)willDisplayCell:(UICollectionViewCell *)cell at:(NSIndexPath *)indexPath;

/// Notifies cell item when user selects collection view cell.
///
/// - Parameter indexPath: index path of a selected cell
- (void)didSelectAt:(NSIndexPath *)indexPath;

@end
