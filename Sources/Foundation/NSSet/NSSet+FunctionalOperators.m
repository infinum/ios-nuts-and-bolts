//
//  NSSet+FunctionalOperators.m
//  Catalog
//
//  Created by Nikola Majcen on 19/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import "NSSet+FunctionalOperators.h"
#import "NSArray+FunctionalOperators.h"

@implementation NSSet (FunctionalOperators)

- (NSSet *)map:(id (^)(id))mapValue
{
    if (!mapValue) { return self; }
    NSMutableSet *result = [[NSMutableSet alloc] init];
    [self enumerateObjectsUsingBlock:^(id _Nonnull item, BOOL *stop) {
        id mappedItem = mapValue(item);
        if (mappedItem) {
            [result addObject:mappedItem];
        }
    }];
    return [NSSet setWithSet:result];
}

- (NSSet *)flatMap:(id (^)(id))flatMapValue
{
    if (!flatMapValue) { return self; }
    NSMutableSet *result = [NSMutableSet new];
    [self enumerateObjectsUsingBlock:^(id item, BOOL *stop) {
        id flattenedItem = flatMapValue(item);
        if ([flattenedItem isKindOfClass:NSArray.class]) {
            NSArray *flattenedArray = [(NSArray *)flattenedItem flatMap:flatMapValue];
            [result addObjectsFromArray:flattenedArray];
        } else if ([flattenedItem isKindOfClass:NSSet.class]) {
            NSSet *flattenedSet = [(NSSet *)flattenedItem flatMap:flatMapValue];
            [result addObjectsFromArray:flattenedSet.allObjects];
        } else if (flattenedItem) {
            [result addObject:flattenedItem];
        }
    }];
    return [NSSet setWithSet:result];
}

- (void)forEach:(void (^)(id))forEachValue
{
    if (!forEachValue) { return; }
    [self enumerateObjectsUsingBlock:^(id _Nonnull item, BOOL *stop) {
        forEachValue(item);
    }];
}

- (NSSet *)filter:(BOOL (^)(id))includeValue
{
    if (!includeValue) { return self; }
    NSMutableSet *result = [[NSMutableSet alloc] init];
    [self enumerateObjectsUsingBlock:^(id _Nonnull item, BOOL *stop) {
        if (includeValue(item)) {
            [result addObject:item];
        }
    }];
    return [NSSet setWithSet:result];
}

- (id)reduce:(id)initial next:(id (^)(id accumulator, id value))nextValue
{
    if (!nextValue) { return initial; }
    __block id result = initial;
    [self enumerateObjectsUsingBlock:^(id item, BOOL *stop) {
        result = nextValue(result, item);
    }];
    return result;
}

@end
