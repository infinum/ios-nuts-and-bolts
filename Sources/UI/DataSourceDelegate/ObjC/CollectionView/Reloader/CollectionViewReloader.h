//
//  CollectionViewReloader.h
//
//  Created by Ivana Mršić on 20/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionSectionItem.h"

/// Used in conjuction with CollectionDataSourceDelegate to provide a way
/// to control collection view reloading behavior
@protocol CollectionViewReloader <NSObject>

/// Called when new data arrives and reload is necessary
///
/// - Parameters:
///   - collectionView: Current collection view
///   - oldSections: Previous sections/items
///   - newSections: New sections/items
- (void)reloadCollectionView:(UICollectionView *)collectionView
                 oldSections:(NSArray<id<CollectionSectionItem>> *)oldSections
                 newSections:(NSArray<id<CollectionSectionItem>> *)newSections;

@end

@interface DefaultCollectionViewReloader : NSObject <CollectionViewReloader>

@end
