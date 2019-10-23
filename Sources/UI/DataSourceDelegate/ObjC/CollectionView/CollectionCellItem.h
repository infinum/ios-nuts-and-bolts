//
//  CollectionCellItem.h
//
//  Created by Ivana Mršić on 20/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellItem.h"

NS_ASSUME_NONNULL_BEGIN

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
/// @param collectionView Parent collection view
/// @param indexPath Index path of cell to configure
- (__kindof UICollectionViewCell *)cellFromCollectionView:(UICollectionView *)collectionView at:(NSIndexPath *)indexPath;

#pragma mark - Optional methods and properties

/// Size for item's cell
///
/// @param collectionViewSize Size of a parent collection view
/// @param layout Used flow layout
/// @param indexPath Cell index path
/// @param numberOfItemsInSection Number of items in current section
- (CGSize)itemSizeForCollectionViewSize:(CGSize)collectionViewSize layout:(UICollectionViewLayout *)layout at:(NSIndexPath *)indexPath numberOfItemsInSection:(NSInteger)numberOfItemsInSection;

/// Notification before cell will be displayed - use this method
/// for configuring complex cell layout
///
/// @param cell Item's collection view cell
/// @param indexPath Item's index path
- (void)willDisplayCell:(UICollectionViewCell *)cell at:(NSIndexPath *)indexPath;

/// Notifies cell item when user selects collection view cell.
/// @param indexPath Index path of a selected cell
- (void)didSelectAt:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
