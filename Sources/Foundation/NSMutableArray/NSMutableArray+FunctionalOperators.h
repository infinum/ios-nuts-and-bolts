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
 Returns an mutable array containing the results of mapping the given
 closure over the sequence's elements. Nil values will be ignored.
 */
- (NSMutableArray *)map:(id (^)(T _Nonnull obj))mapValue;

/**
 Returns an mutable array containing the concatenated results of calling
 the given transformation with each element of this sequence.
 Nil values will be ignored.
 */
- (NSMutableArray *)flatMap:(id (^)(id _Nonnull))flatMapValue;

/**
 Returns an mutable array containing in order, the elements of the
 sequence that satisfy the given predicate.
 */
- (NSMutableArray<T> *)filter:(BOOL (^)(T _Nonnull obj))includeValue;

@end

NS_ASSUME_NONNULL_END
