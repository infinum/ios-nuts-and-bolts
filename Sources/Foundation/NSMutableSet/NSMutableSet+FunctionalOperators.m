//
//  NSMutableSet+FunctionalOperators.m
//  Catalog
//
//  Created by Nikola Majcen on 19/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import "NSMutableSet+FunctionalOperators.h"
#import "NSArray+FunctionalOperators.h"

@implementation NSMutableSet (FunctionalOperators)

- (NSMutableSet *)map:(id (^)(id))mapValue
{
    if (!mapValue) { return [self copy]; }
    
    NSMutableSet *result = [[NSMutableSet alloc] init];
    [self enumerateObjectsUsingBlock:^(id _Nonnull item, BOOL *stop) {
        id mappedItem = mapValue(item);
        if (mappedItem) {
            [result addObject:mappedItem];
        }
    }];
    
    return result;
}

- (NSMutableSet *)flatMap:(id (^)(id))flatMapValue
{
    if (!flatMapValue) { return [self copy]; }
    
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
    
    return result;
}

- (NSSet *)filter:(BOOL (^)(id))includeValue
{
    if (!includeValue) { return [self copy]; }
    
    NSMutableSet *result = [[NSMutableSet alloc] init];
    [self enumerateObjectsUsingBlock:^(id _Nonnull item, BOOL *stop) {
        if (includeValue(item)) {
            [result addObject:item];
        }
    }];
    
    return result;
}

@end
