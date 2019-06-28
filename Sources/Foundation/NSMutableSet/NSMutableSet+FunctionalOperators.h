//
//  NSMutableSet+FunctionalOperators.h
//  Catalog
//
//  Created by Nikola Majcen on 19/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSSet+FunctionalOperators.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableSet<T: id> (FunctionalOperators)

/**
 Returns a mutable set containing the results of mapping the given
 closure over the sequence's elements.
 Nil values will be ignored.
 */
- (NSMutableSet *)map:(id _Nullable (^)(T value))block;

/**
 Returns a mutable set containing the concatenated results of calling
 the given transformation with each element of this sequence.
 Nil values will be ignored.
 */
- (NSMutableSet *)flatMap:(id _Nullable (^)(T value))block;

/**
 Returns a mutable set containing in order, the elements of the
 sequence that satisfy the given predicate.
 */
- (NSMutableSet<T> *)filter:(BOOL (^)(T value))block;

@end

NS_ASSUME_NONNULL_END
