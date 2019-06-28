//
//  NSSet+FunctionalOperatorsTests.m
//  Tests
//
//  Created by Nikola Majcen on 19/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSSet+FunctionalOperators.h"

@interface NSSet_FunctionalOperatorsTests : XCTestCase

@end

@implementation NSSet_FunctionalOperatorsTests

- (void)testSetMapOperator
{
    NSSet<NSString *> *values = [NSSet setWithArray:@[@"One", @"Two", @"Three"]];
    NSSet<NSString *> *expected = [NSSet setWithArray:@[@"OneMap", @"TwoMap", @"ThreeMap"]];
    NSSet<NSString *> *result = [values map:^id _Nonnull(NSString * _Nonnull obj) {
        return [obj stringByAppendingString:@"Map"];
    }];

    XCTAssertTrue([result isEqual:expected]);
}

- (void)testSetFlatMapOperator
{
    NSSet<NSString *> *values = [NSSet setWithArray:@[@"One", @[@"Two", @"Three"], @"Four"]];
    NSSet<NSString *> *result = [values flatMap:^id _Nonnull(id  _Nonnull obj) {
        return obj;
    }];
    NSSet<NSString *> *expected = [NSSet setWithArray:@[@"One", @"Two", @"Three", @"Four"]];
    XCTAssertTrue([result isEqual:expected]);
}

- (void)testSetForEachOperator
{
    NSSet<NSString *> *values = [NSSet setWithArray:@[@"One", @"Two", @"Three"]];
    NSMutableSet<NSString *> *result = [[NSMutableSet alloc] init];
    [values forEach:^(NSString * _Nonnull obj) {
        [result addObject:obj];
    }];
    XCTAssertTrue([result isEqual:values]);
}

- (void)testSetFilterOperator
{
    NSSet<NSNumber *> *values = [NSSet setWithArray:@[@(10), @(20), @(30), @(40), @(50)]];
    NSSet<NSNumber *> *expected = [NSSet setWithArray:@[@(20), @(40)]];
    NSSet<NSNumber *> *result = [values filter:^BOOL(NSNumber * _Nonnull obj) {
        return obj.integerValue % 20 == 0 ;
    }];
    XCTAssertTrue([result isEqual:expected]);
}

- (void)testSetReduceOperator
{
    NSSet<NSNumber *> *values = [NSSet setWithArray:@[@(1), @(2), @(3), @(4), @(5)]];
    NSNumber *expected = @(25);
    NSNumber *result = [values reduce:@(10) next:^id (NSNumber *accumulator, NSNumber *value) {
        return @(accumulator.integerValue + value.integerValue);
    }];
    XCTAssertTrue([expected isEqual:result]);
}

@end
