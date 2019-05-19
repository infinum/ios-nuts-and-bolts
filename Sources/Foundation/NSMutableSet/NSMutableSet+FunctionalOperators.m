//
//  NSMutableSet+FunctionalOperators.m
//  Catalog
//
//  Created by Nikola Majcen on 19/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import "NSMutableSet+FunctionalOperators.h"

@implementation NSMutableSet (FunctionalOperators)

- (NSMutableSet *)map:(id  _Nonnull (^)(id _Nonnull))block
{
    if (!block) { return [self copy]; }
    NSMutableSet *mutableSet = [[NSMutableSet alloc] init];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        [mutableSet addObject:block(obj)];
    }];
    return [mutableSet copy];
}

- (NSMutableSet *)flatMap:(id  _Nonnull (^)(id _Nonnull))block
{
    if (!block) { return [self copy]; }
    NSMutableSet *mutableSet = [[NSMutableSet alloc] init];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        id object = block(obj);
        if ([object isKindOfClass:[NSArray class]]) {
            NSArray *array = [[object flatMap:block] allObjects];
            [mutableSet addObjectsFromArray:array];
            return;
        }
        [mutableSet addObject:object];
    }];
    return [mutableSet copy];
}

- (void)forEach:(void (^)(id _Nonnull))block
{
    if (!block) { return; }
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        block(obj);
    }];
}

- (NSMutableSet *)filter:(BOOL (^)(id _Nonnull obj))block
{
    if (!block) { return [self copy]; }
    NSMutableSet *mutableSet = [[NSMutableSet alloc] init];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (block(obj)) {
            [mutableSet addObject:obj];
        }
    }];
    return [mutableSet copy];
}

- (id)reduce:(id)initial block:(id  _Nonnull (^)(id _Nonnull, id _Nonnull))block
{
    if (!block) { return initial; }
    __block id object = initial;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        object = block(object, obj);
    }];
    return object;
}

@end
