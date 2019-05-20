//
//  BaseCollectionCellItem.m
//  Catalog
//
//  Created by Ivana Mršić on 20/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import "BaseCollectionCellItem.h"

@implementation BaseCollectionCellItem

- (CGSize)itemSizeForCollectionViewSize:(CGSize)collectionViewSize layout:(UICollectionViewFlowLayout *)layout at:(NSIndexPath *)indexPath numberOfItemsInSection:(NSInteger)numberOfItemsInSection
{
    return CGSizeMake(100, 100);
}

- (nonnull UICollectionViewCell *)cellFromCollectionView:(nonnull UICollectionView *)collectionView at:(nonnull NSIndexPath *)indexPath
{
    return nil;
}

- (void)didSelectAt:(nonnull NSIndexPath *)indexPath
{
    // empty implementation
}

- (void)willDisplayCell:(nonnull UICollectionViewCell *)cell at:(nonnull NSIndexPath *)indexPath
{
    // empty implementation
}

@end

