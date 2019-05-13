//
//  NSArray+FunctionalOperators.m
//  Catalog
//
//  Created by Nikola Majcen on 13/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import "NSArray+FunctionalOperators.h"

@implementation NSArray (FunctionalOperators)

- (NSArray *)map:(id  _Nonnull (^)(id _Nonnull))block
{
    if (!block) { return [self copy]; }
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [mutableArray addObject:block(obj)];
    }];
    return [mutableArray copy];
}

- (NSArray *)flatMap:(id  _Nonnull (^)(id _Nonnull))block
{
    if (!block) { return [self copy]; }
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id object = block(obj);
        if ([object isKindOfClass:[NSArray class]]) {
            NSArray *array = [object flatMap:block];
            [mutableArray addObjectsFromArray:array];
            return;
        }
        [mutableArray addObject:object];
    }];
    return [mutableArray copy];
}

- (void)forEach:(void (^)(id _Nonnull))block
{
    if (!block) { return; }
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block(obj);
    }];
}

- (NSArray *)filter:(BOOL (^)(id _Nonnull obj))block
{
    if (!block) { return [self copy]; }
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (block(obj)) {
            [mutableArray addObject:obj];
        }
    }];
    return [mutableArray copy];
}

- (id)reduce:(id)initial block:(id  _Nonnull (^)(id _Nonnull, id _Nonnull))block
{
    if (!block) { return initial; }
    __block id object = initial;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        object = block(object, obj);
    }];
    return object;
}

@end
