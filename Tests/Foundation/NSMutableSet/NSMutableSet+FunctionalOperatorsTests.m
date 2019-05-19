//
//  NSMutableSet+FunctionalOperatorsTests.m
//  Tests
//
//  Created by Nikola Majcen on 19/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSMutableSet+FunctionalOperators.h"

@interface NSMutableSet_FunctionalOperatorsTests : XCTestCase

@end

@implementation NSMutableSet_FunctionalOperatorsTests

- (void)testArrayMapOperator
{
    NSMutableSet<NSString *> *values = [NSMutableSet setWithArray:@[@"One", @"Two", @"Three"]];
    NSMutableSet<NSString *> *expected = [NSMutableSet setWithArray:@[@"OneMap", @"TwoMap", @"ThreeMap"]];
    NSMutableSet<NSString *> *result = (NSMutableSet<NSString *> *)[values map:^id _Nonnull(NSString * _Nonnull obj) {
        return [obj stringByAppendingString:@"Map"];
    }];

    XCTAssertTrue([result isEqual:expected]);
}

- (void)testArrayFlatMapOperator
{
    NSMutableSet<NSString *> *values = [NSMutableSet setWithArray:@[@"One", @[@"Two", @"Three"], @"Four"]];
    NSMutableSet<NSString *> *result = (NSMutableSet<NSString *> *)[values flatMap:^id _Nonnull(id  _Nonnull obj) {
        return obj;
    }];
    NSMutableSet<NSString *> *expected = [NSMutableSet setWithArray:@[@"One", @"Two", @"Three", @"Four"]];
    XCTAssertTrue([result isEqual:expected]);
}

- (void)testArrayForEachOperator
{
    NSMutableSet<NSString *> *values = [NSMutableSet setWithArray:@[@"One", @"Two", @"Three"]];
    NSMutableSet<NSString *> *result = [[NSMutableSet alloc] init];
    [values forEach:^(NSString * _Nonnull obj) {
        [result addObject:obj];
    }];
    XCTAssertTrue([result isEqual:values]);
}

- (void)testArrayFilterOperator
{
    NSMutableSet<NSNumber *> *values = [NSMutableSet setWithArray:@[@(10), @(20), @(30), @(40), @(50)]];
    NSMutableSet<NSNumber *> *expected = [NSMutableSet setWithArray:@[@(20), @(40)]];
    NSMutableSet<NSNumber *> *result =  (NSMutableSet<NSNumber *> *)[values filter:^BOOL(NSNumber * _Nonnull obj) {
        return obj.integerValue % 20 == 0 ;
    }];
    XCTAssertTrue([result isEqual:expected]);
}

- (void)testArrayReduceOperator
{
    NSMutableSet<NSNumber *> *values = [NSMutableSet setWithArray:@[@(1), @(2), @(3), @(4), @(5)]];
    NSNumber *expected = @(25);
    NSNumber *result = [values reduce:@(10) block:^id _Nonnull(NSNumber * _Nonnull acc, NSNumber * _Nonnull obj) {
        return @(acc.integerValue + obj.integerValue);
    }];
    XCTAssertTrue([expected isEqual:result]);
}

@end
