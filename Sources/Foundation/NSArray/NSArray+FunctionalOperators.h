//
//  NSArray+FunctionalOperators.h
//  Catalog
//
//  Created by Nikola Majcen on 13/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<__covariant T: id> (FunctionalOperators)

/**
 Returns an array containing the results of mapping the given
 closure over the sequence's elements. Nil values will be ignored.
 */
- (NSArray *)map:(id _Nullable (^)(T value))mapValue;

/**
 Returns an array containing the concatenated results of calling
 the given transformation with each element of this sequence.
 Nil values will be ignored.
 */
- (NSArray *)flatMap:(id _Nullable (^)(id _Nonnull))flatMapValue;

/**
 Calls the given closure on each element in the sequence
 in the same order as @p for-in loop.
 */
- (void)forEach:(void (^)(T value))forEachValue;

/**
 Returns an array containing in order, the elements of the
 sequence that satisfy the given predicate.
 */
- (NSArray<T> *)filter:(BOOL (^)(T value))includeValue;

/**
 Returns the result of combining the elements of the sequence
 using the given block.
 */
- (id _Nullable)reduce:(id _Nullable)initial next:(id _Nullable (^)(T _Nullable accumulator, T value))nextValue;

/**
 Returns an array composed with another array using the given block.
 Returns an empty array if block is not provided.
 */
- (NSArray *)composeWithArray:(NSArray *)array usingBlock:(id _Nullable (^)(T firstItem, id secondItem))block;

@end

NS_ASSUME_NONNULL_END
