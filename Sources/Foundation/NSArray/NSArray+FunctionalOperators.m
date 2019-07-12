//
//  NSArray+FunctionalOperators.m
//  Catalog
//
//  Created by Nikola Majcen on 13/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import "NSArray+FunctionalOperators.h"

@implementation NSArray (FunctionalOperators)

- (NSArray *)map:(id (^)(id))mapValue
{
    if (!mapValue) { return self; }
    NSMutableArray *result = [NSMutableArray new];
    [self enumerateObjectsUsingBlock:^(id item, NSUInteger index, BOOL *stop) {
        id mappedItem = mapValue(item);
        if (mappedItem) {
            [result addObject:mappedItem];
        }
    }];
    return [NSArray arrayWithArray:result];
}

- (NSArray *)flatMap:(id (^)(id))flatMapValue
{
    if (!flatMapValue) { return self; }
    NSMutableArray *result = [NSMutableArray new];
    [self enumerateObjectsUsingBlock:^(id item, NSUInteger index, BOOL *stop) {
        id flattenedItem = flatMapValue(item);
        if ([flattenedItem isKindOfClass:NSArray.class]) {
            NSArray *flattenedArray = [flattenedItem flatMap:flatMapValue];
            [result addObjectsFromArray:flattenedArray];
        } else if (flattenedItem) {
            [result addObject:flattenedItem];
        }
    }];
    return [NSArray arrayWithArray:result];
}

- (void)forEach:(void (^)(id))forEachValue
{
    if (!forEachValue) { return; }
    [self enumerateObjectsUsingBlock:^(id _Nonnull item, NSUInteger index, BOOL *stop) {
        forEachValue(item);
    }];
}

- (NSArray *)filter:(BOOL (^)(id))includeValue
{
    if (!includeValue) { return self; }
    NSMutableArray *result = [NSMutableArray new];
    [self enumerateObjectsUsingBlock:^(id item, NSUInteger index, BOOL *stop) {
        if (includeValue(item)) {
            [result addObject:item];
        }
    }];
    return [NSArray arrayWithArray:result];
}

- (id)reduce:(id)initial next:(id (^)(id accumulator, id value))nextValue
{
    if (!nextValue) { return initial; }
    __block id result = initial;
    [self enumerateObjectsUsingBlock:^(id item, NSUInteger index, BOOL *stop) {
        result = nextValue(result, item);
    }];
    return result;
}

- (NSArray *)composeWithArray:(NSArray *)array usingBlock:(id _Nullable (^)(id firstItem, id secondItem))block
{
    if (self.count != array.count) {
        [NSException raise:@"Invalid array length." format:@"Arrays must be of same length."];
    }
    
    NSMutableArray *result = [NSMutableArray new];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result addObject:block(obj, array[idx])];
    }];
    
    return [NSArray arrayWithArray:result];
}

@end
