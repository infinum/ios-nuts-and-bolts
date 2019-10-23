//
//  BaseCollectionSection.h
//
//  Created by Ivana Mršić on 20/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionSectionItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseCollectionSection : NSObject <CollectionSectionItem>

@property (nonatomic, strong) NSArray<id<CollectionCellItem>> *items;

- (instancetype)initWithItems:(NSArray<id<CollectionCellItem>> *) items;

@end

NS_ASSUME_NONNULL_END
