//
//  NSArray+FunctionalOperatorsTests.m
//  Tests
//
//  Created by Nikola Majcen on 13/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import "NSArray+FunctionalOperatorsTests.h"
#import "NSArray+FunctionalOperators.h"

@implementation NSArray_FunctionalOperatorsTests

- (void)testArrayMapOperator
{
    NSArray<NSString *> *values = @[@"One", @"Two", @"Three"];
    NSArray<NSString *> *expected = @[@"OneMap", @"TwoMap", @"ThreeMap"];
    NSArray<NSString *> *result = [values map:^id _Nonnull(NSString * _Nonnull obj) {
        return [obj stringByAppendingString:@"Map"];
    }];
    XCTAssertTrue([result isEqual:expected]);
}

- (void)testArrayFlatMapOperator
{
    NSArray *values = @[@"One", @[@"Two", @"Three"], @"Four"];
    NSArray *result = [values flatMap:^id _Nonnull(id  _Nonnull obj) {
        return obj;
    }];
    NSArray<NSString *> *expected =  @[@"One", @"Two", @"Three", @"Four"];
    XCTAssertTrue([result isEqual:expected]);
}

- (void)testArrayForEachOperator
{
    NSArray<NSString *> *values = @[@"One", @"Two", @"Three"];
    NSMutableArray<NSString *> *result = [[NSMutableArray alloc] init];
    [values forEach:^(NSString * _Nonnull obj) {
        [result addObject:obj];
    }];
    XCTAssertTrue([result isEqual:values]);
}

- (void)testArrayFilterOperator
{
    NSArray<NSNumber *> *values = @[@(10), @(20), @(30), @(40), @(50)];
    NSArray<NSNumber *> *expected = @[@(20), @(40)];
    NSArray<NSNumber *> *result = [values filter:^BOOL(NSNumber * _Nonnull obj) {
        return obj.integerValue % 20 == 0 ;
    }];
    XCTAssertTrue([result isEqual:expected]);
}

- (void)testArrayReduceOperator
{
    NSArray<NSNumber *> *values = @[@(1), @(2), @(3), @(4), @(5)];
    NSNumber *expected = @(25);
    NSNumber *result = [values reduce:@(10) block:^id _Nonnull(NSNumber * _Nonnull acc, NSNumber * _Nonnull obj) {
        return @(acc.integerValue + obj.integerValue);
    }];
    XCTAssertTrue([expected isEqual:result]);
}

@end
