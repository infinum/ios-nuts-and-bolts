//
//  CollectionViewReloader.m
//  Catalog
//
//  Created by Ivana Mršić on 20/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewReloader.h"

@implementation DefaultCollectionViewReloader

- (void)reloadCollectionView:(UICollectionView *)collectionView oldSections:(NSArray<id> *)oldSections newSections:(NSArray<id> *)newSections
{
    [collectionView reloadData];
}

@end
