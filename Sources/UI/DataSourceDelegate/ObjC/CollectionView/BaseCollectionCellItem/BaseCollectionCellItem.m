//
//  BaseCollectionCellItem.m
//  Catalog
//
//  Created by Ivana Mršić on 20/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import "BaseCollectionCellItem.h"

@implementation BaseCollectionCellItem

- (CGSize)itemSizeForCollectionViewSize:(CGSize)collectionViewSize layout:(UICollectionViewLayout *)layout at:(NSIndexPath *)indexPath numberOfItemsInSection:(NSInteger)numberOfItemsInSection
{
    return CGSizeMake(100, 100);
}

- (__kindof UICollectionViewCell *)cellFromCollectionView:(UICollectionView *)collectionView at:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)didSelectAt:(NSIndexPath *)indexPath
{
    // empty implementation
}

- (void)willDisplayCell:(UICollectionViewCell *)cell at:(NSIndexPath *)indexPath
{
    // empty implementation
}

@end

