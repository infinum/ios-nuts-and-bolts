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

- (NSArray *)composeWithArray:(NSArray *)array usingBlock:(id _Nonnull (^)(id firstItem, id secondItem))block
{
    if (!block) {
        return [NSArray new];
    }
    
    BOOL isFirstArraySmaller = self.count <= array.count;
    NSArray *enumeratingArray = isFirstArraySmaller ? self : array;
    NSArray *secondArray = isFirstArraySmaller ? array : self;
    NSMutableArray *result = [NSMutableArray new];
    
    [enumeratingArray enumerateObjectsUsingBlock:^(id _Nonnull item, NSUInteger index, BOOL *stop) {
        id blockResult = isFirstArraySmaller ? block(item, secondArray[index]) : block(secondArray[index], item);
        if (blockResult) { [result addObject:blockResult]; }
    }];
    
    return [NSArray arrayWithArray:result];
}

@end
