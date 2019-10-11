//
//  NSArray+FunctionalOperatorsTests.m
//  Tests
//
//  Created by Nikola Majcen on 13/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSArray+FunctionalOperators.h"
#import "NSArrayTestModel.h"

@interface NSArray_FunctionalOperatorsTests : XCTestCase

@end

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
    NSNumber *result = [values reduce:@(10) next:^id _Nonnull(NSNumber * _Nonnull accumulator, NSNumber * _Nonnull value) {
        return @(accumulator.integerValue + value.integerValue);
    }];
    XCTAssertTrue([expected isEqual:result]);
}

- (void)testArrayComposeOperator
{
    NSArray<NSString *> *values = @[@"One", @"Two", @"Three"];
    NSArray<NSString *> *otherValues = @[@"1", @"2", @"3"];
    NSArray<NSString *> *result = [values composeWithArray:otherValues usingBlock:^NSString *(NSString *firstItem, NSString *secondItem) {
        return [NSString stringWithFormat:@"%@%@", firstItem, secondItem];
    }];
    NSArray<NSString *> *expected = @[@"One1", @"Two2", @"Three3"];
    
    XCTAssertTrue([expected isEqual:result]);
}

- (void)testArrayComposeOperatorWithModel
{
    NSArrayTestModel *modelOne = [NSArrayTestModel new];
    modelOne.firstTestString = @"This";
    NSArrayTestModel *modelTwo = [NSArrayTestModel new];
    modelTwo.firstTestString = @"That";

    NSArray<NSArrayTestModel *> *values = @[modelOne, modelTwo];
    NSArray<UIColor *> *otherValues = @[[UIColor whiteColor], [UIColor blackColor]];
    NSArray<NSArrayTestModel *> *result = [values composeWithArray:otherValues usingBlock:^NSArrayTestModel *(NSArrayTestModel *firstItem, UIColor *secondItem) {
        firstItem.color = secondItem;
        return firstItem;
    }];
    
    UIColor *firstModelColor = [UIColor whiteColor];
    UIColor *secondModelColor = [UIColor blackColor];
    NSArray<UIColor *> *expected = @[firstModelColor, secondModelColor];
    
    XCTAssertTrue([expected[0] isEqual:result[0].color]);
    XCTAssertTrue([expected[1] isEqual:result[1].color]);
}

- (void)testArrayComposeOperatorWithSmallerArray
{
    NSArrayTestModel *modelOne = [NSArrayTestModel new];
    modelOne.firstTestString = @"This";
    NSArrayTestModel *modelTwo = [NSArrayTestModel new];
    modelTwo.firstTestString = @"That";
    
    NSArray<NSArrayTestModel *> *values = @[modelOne, modelTwo];
    NSArray<UIColor *> *otherValues = @[[UIColor whiteColor]];
    NSArray<NSArrayTestModel *> *result = [values composeWithArray:otherValues usingBlock:^NSArrayTestModel *(NSArrayTestModel *firstItem, UIColor *secondItem) {
        firstItem.color = secondItem;
        return firstItem;
    }];
    
    UIColor *firstModelColor = [UIColor whiteColor];
    NSArray<UIColor *> *expected = @[firstModelColor];
    
    XCTAssertTrue([expected[0] isEqual:result[0].color]);
    XCTAssertTrue([result count] == 1);
}

- (void)testArrayComposeOperatorWithEmptyArray
{
    NSArrayTestModel *modelOne = [NSArrayTestModel new];
    modelOne.firstTestString = @"This";
    NSArrayTestModel *modelTwo = [NSArrayTestModel new];
    modelTwo.firstTestString = @"That";
    
    NSArray<NSArrayTestModel *> *values = @[modelOne, modelTwo];
    NSArray<UIColor *> *otherValues = @[];
    NSArray<NSArrayTestModel *> *result = [values composeWithArray:otherValues usingBlock:^NSArrayTestModel *(NSArrayTestModel *firstItem, UIColor *secondItem) {
        firstItem.color = secondItem;
        return firstItem;
    }];
    
    XCTAssertTrue([result count] == 0);
}

@end
