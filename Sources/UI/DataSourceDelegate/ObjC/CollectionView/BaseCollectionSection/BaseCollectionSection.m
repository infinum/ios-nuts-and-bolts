//
//  BaseCollectionSection.m
//
//  Created by Ivana Mršić on 20/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import "BaseCollectionSection.h"

@implementation BaseCollectionSection

- (instancetype)initWithItems:(NSArray<id> *)items
{
    self = [super init];
    if (self) {
        _items = items;
    }
    return self;
}

@end
