//
//  NSMutableArray+FunctionalOperatorsTests.m
//  Tests
//
//  Created by Nikola Majcen on 19/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSMutableArray+FunctionalOperators.h"

@interface NSMutableArray_FunctionalOperatorsTests : XCTestCase

@end

@implementation NSMutableArray_FunctionalOperatorsTests

- (void)testArrayMapOperator
{
    NSMutableArray<NSString *> *values = [[NSMutableArray alloc] initWithArray:@[@"One", @"Two", @"Three"]];
    NSMutableArray<NSString *> *expected = [[NSMutableArray alloc] initWithArray:@[@"OneMap", @"TwoMap", @"ThreeMap"]];
    NSMutableArray<NSString *> *result = (NSMutableArray<NSString *> *)[values map:^id _Nonnull(NSString * _Nonnull obj) {
        return [obj stringByAppendingString:@"Map"];
    }];
    XCTAssertTrue([result isEqual:expected]);
}

- (void)testArrayFlatMapOperator
{
    NSMutableArray *values = [[NSMutableArray alloc] initWithArray:@[@"One", @[@"Two", @"Three"], @"Four"]];
    NSMutableArray *result = [values flatMap:^id _Nonnull(id  _Nonnull obj) {
        return obj;
    }];
    NSMutableArray<NSString *> *expected =  [[NSMutableArray alloc] initWithArray:@[@"One", @"Two", @"Three", @"Four"]];
    XCTAssertTrue([result isEqual:expected]);
}

- (void)testArrayForEachOperator
{
    NSMutableArray<NSString *> *values = [[NSMutableArray alloc] initWithArray:@[@"One", @"Two", @"Three"]];
    NSMutableArray<NSString *> *result = [[NSMutableArray alloc] init];
    [values forEach:^(NSString * _Nonnull obj) {
        [result addObject:obj];
    }];
    XCTAssertTrue([result isEqual:values]);
}

- (void)testArrayFilterOperator
{
    NSMutableArray<NSNumber *> *values = [[NSMutableArray alloc] initWithArray:@[@(10), @(20), @(30), @(40), @(50)]];
    NSMutableArray<NSNumber *> *expected = [[NSMutableArray alloc] initWithArray:@[@(20), @(40)]];
    NSMutableArray<NSNumber *> *result = [values filter:^BOOL(NSNumber * _Nonnull obj) {
        return obj.integerValue % 20 == 0 ;
    }];
    XCTAssertTrue([result isEqual:expected]);
}

- (void)testArrayReduceOperator
{
    NSMutableArray<NSNumber *> *values = [[NSMutableArray alloc] initWithArray:@[@(1), @(2), @(3), @(4), @(5)]];
    NSNumber *expected = @(25);
    NSNumber *result = [values reduce:@(10) next:^id _Nonnull(NSNumber * _Nonnull accumulator, NSNumber * _Nonnull value) {
        return @(accumulator.integerValue + value.integerValue);
    }];
    XCTAssertTrue([expected isEqual:result]);
}

@end
