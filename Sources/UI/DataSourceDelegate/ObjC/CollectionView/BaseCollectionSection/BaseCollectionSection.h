//
//  BaseCollectionSection.h
//  Catalog
//
//  Created by Ivana Mršić on 20/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionSectionItem.h"

@interface BaseCollectionSection : NSObject <CollectionSectionItem>

@property (nonatomic, strong) NSArray<id<CollectionCellItem>> *items;

- (instancetype)initWithItems:(NSArray<id<CollectionCellItem>> *) items;

@end
