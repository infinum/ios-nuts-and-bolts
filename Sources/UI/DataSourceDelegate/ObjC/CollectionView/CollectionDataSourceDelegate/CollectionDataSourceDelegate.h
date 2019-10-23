//
//  CollectionDataSourceDelegate.h
//
//  Created by Ivana Mršić on 20/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionSectionItem.h"
#import "CollectionCellItem.h"
#import "CollectionViewReloader.h"

NS_ASSUME_NONNULL_BEGIN

/// Object serving as a data source and delegate for a collection view.
/// Main purpose is to reduce a boilerplate when dealing with simple
/// collection view data displaying.
///
/// It can handle both - sections and items
@interface CollectionDataSourceDelegate : NSObject <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/// Setting a sections will invoke internal reloader causing table view to refresh.
@property (nonatomic, strong) NSArray<id<CollectionSectionItem>> *sections;

/// Setting an items will invoke internal reloader causing table view to refresh.
///
/// If there are multiple sections - then data is flattened to single array
@property (nonatomic, strong) NSArray<id<CollectionCellItem>> *items;

/// Creates a new data source delegate object responsible for handling
/// collection view's data source and delegate logic.
///
/// **If using the data source delegate object do not change the table view
/// dataSource property since this object depends on it**
///
/// Freely use `delegate` property since internally data source delegate will
/// use pass through delegate.
///
/// Object will have DefaultTableViewReloader as reloader.
///
/// - Parameters:
///   - collectionView: Collection view to control
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;

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
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
                              reloader:(id<CollectionViewReloader>)reloader;

@end

NS_ASSUME_NONNULL_END
