//
//  NSSet+FunctionalOperators.h
//  Catalog
//
//  Created by Nikola Majcen on 19/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSSet<__covariant T: id> (FunctionalOperators)

/**
 Returns a set containing the results of mapping the given
 closure over the sequence's elements. Nil values will be ignored.
 */
- (NSSet *)map:(id _Nullable (^)(T value))mapValue;

/**
 Returns a set containing the concatenated results of calling
 the given transformation with each element of this sequence.
 Nil values will be ignored.
 */
- (NSSet *)flatMap:(id _Nullable (^)(T value))flatMapValue;

/**
 Calls the given closure on each element in the sequence
 in the same order as @p for-in loop.
 */
- (void)forEach:(void (^)(T value))forEachValue;

/**
 Returns a set containing in order, the elements of the
 sequence that satisfy the given predicate.
 */
- (NSSet<T> *)filter:(BOOL (^)(T value))includeValue;

/**
 Returns the result of combining the elements of the sequence
 using the given closure.
 */
- (id _Nullable)reduce:(id _Nullable)initial next:(id _Nullable (^)(T _Nullable accumulator, T value))nextValue;

@end

NS_ASSUME_NONNULL_END
