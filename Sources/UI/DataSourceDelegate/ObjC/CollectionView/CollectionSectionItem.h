//
//  CollectionSectionItem.h
//
//  Created by Ivana Mršić on 20/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionItem.h"
#import "CollectionCellItem.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CollectionSectionItem <NSObject, SectionItem>

#pragma mark - Required methods and properties

@property (nonatomic, strong) NSArray<id<CollectionCellItem>> *items;

@end

NS_ASSUME_NONNULL_END
