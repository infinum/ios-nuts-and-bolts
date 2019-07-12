//
//  NSMutableArray+FunctionalOperators.h
//  Catalog
//
//  Created by Nikola Majcen on 19/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSArray+FunctionalOperators.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray<T: id> (FunctionalOperators)

/**
 Returns a mutable array containing the results of mapping the given
 closure over the sequence's elements. Nil values will be ignored.
 */
- (NSMutableArray *)map:(id _Nullable (^)(T value))mapValue;

/**
 Returns a mutable array containing the concatenated results of calling
 the given transformation with each element of this sequence.
 Nil values will be ignored.
 */
- (NSMutableArray *)flatMap:(id _Nullable (^)(id value))flatMapValue;

/**
 Returns a mutable array containing in order, the elements of the
 sequence that satisfy the given predicate.
 */
- (NSMutableArray<T> *)filter:(BOOL (^)(T value))includeValue;

/**
 Returns a mutable array composed with another mutable array using the given block.
 */
- (NSMutableArray<T> *)composeWithArray:(NSMutableArray *)array usingBlock:(T _Nullable (^)(T firstItem, id secondItem))block;

@end

NS_ASSUME_NONNULL_END
