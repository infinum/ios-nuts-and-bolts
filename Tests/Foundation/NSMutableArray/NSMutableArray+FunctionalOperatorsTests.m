//
//  NSMutableArray+FunctionalOperatorsTests.m
//  Tests
//
//  Created by Nikola Majcen on 19/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSMutableArray+FunctionalOperators.h"
#import "NSArrayTestModel.h"

@interface NSMutableArrayFunctionalOperatorsTests : XCTestCase

@end

@implementation NSMutableArrayFunctionalOperatorsTests

- (void)testMutableArrayMapOperator
{
    NSMutableArray<NSString *> *values = [[NSMutableArray alloc] initWithArray:@[@"One", @"Two", @"Three"]];
    NSMutableArray<NSString *> *expected = [[NSMutableArray alloc] initWithArray:@[@"OneMap", @"TwoMap", @"ThreeMap"]];
    NSMutableArray<NSString *> *result = (NSMutableArray<NSString *> *)[values map:^id _Nonnull(NSString * _Nonnull obj) {
        return [obj stringByAppendingString:@"Map"];
    }];
    XCTAssertTrue([result isEqual:expected]);
}

- (void)testMutableArrayFlatMapOperator
{
    NSMutableArray *values = [[NSMutableArray alloc] initWithArray:@[@"One", @[@"Two", @"Three"], @"Four"]];
    NSMutableArray *result = [values flatMap:^id _Nonnull(id  _Nonnull obj) {
        return obj;
    }];
    NSMutableArray<NSString *> *expected =  [[NSMutableArray alloc] initWithArray:@[@"One", @"Two", @"Three", @"Four"]];
    XCTAssertTrue([result isEqual:expected]);
}

- (void)testMutableArrayForEachOperator
{
    NSMutableArray<NSString *> *values = [[NSMutableArray alloc] initWithArray:@[@"One", @"Two", @"Three"]];
    NSMutableArray<NSString *> *result = [[NSMutableArray alloc] init];
    [values forEach:^(NSString * _Nonnull obj) {
        [result addObject:obj];
    }];
    XCTAssertTrue([result isEqual:values]);
}

- (void)testMutableArrayFilterOperator
{
    NSMutableArray<NSNumber *> *values = [[NSMutableArray alloc] initWithArray:@[@(10), @(20), @(30), @(40), @(50)]];
    NSMutableArray<NSNumber *> *expected = [[NSMutableArray alloc] initWithArray:@[@(20), @(40)]];
    NSMutableArray<NSNumber *> *result = [values filter:^BOOL(NSNumber * _Nonnull obj) {
        return obj.integerValue % 20 == 0 ;
    }];
    XCTAssertTrue([result isEqual:expected]);
}

- (void)testMutableArrayReduceOperator
{
    NSMutableArray<NSNumber *> *values = [[NSMutableArray alloc] initWithArray:@[@(1), @(2), @(3), @(4), @(5)]];
    NSNumber *expected = @(25);
    NSNumber *result = [values reduce:@(10) next:^id _Nonnull(NSNumber * _Nonnull accumulator, NSNumber * _Nonnull value) {
        return @(accumulator.integerValue + value.integerValue);
    }];
    XCTAssertTrue([expected isEqual:result]);
}

- (void)testMutableArrayComposeOperator
{
    NSMutableArray<NSString *> *values = [[NSMutableArray alloc] initWithArray:@[@"One", @"Two", @"Three"]];
    NSMutableArray<NSString *> *otherValues = [[NSMutableArray alloc] initWithArray:@[@"1", @"2", @"3"]];
    NSMutableArray<NSString *> *result = [values composeWithArray:otherValues usingBlock:^NSString *(NSString *firstItem, NSString *secondItem) {
        return [NSString stringWithFormat:@"%@%@", firstItem, secondItem];
    }];
    NSMutableArray<NSString *> *expected = [[NSMutableArray alloc] initWithArray:@[@"One1", @"Two2", @"Three3"]];
    
    XCTAssertTrue([expected isEqual:result]);
}

- (void)testMutableArrayComposeOperatorWithModel
{
    NSArrayTestModel *modelOne = [NSArrayTestModel new];
    modelOne.firstTestString = @"This";
    NSArrayTestModel *modelTwo = [NSArrayTestModel new];
    modelTwo.firstTestString = @"That";
    
    NSMutableArray<NSArrayTestModel *> *values = [[NSMutableArray alloc] initWithArray:@[modelOne, modelTwo]];
    NSMutableArray<UIColor *> *otherValues = [[NSMutableArray alloc] initWithArray:@[[UIColor whiteColor], [UIColor blackColor]]];
    NSMutableArray<NSArrayTestModel *> *result = [values composeWithArray:otherValues usingBlock:^NSArrayTestModel *(NSArrayTestModel *firstItem, UIColor *secondItem) {
        firstItem.color = secondItem;
        return firstItem;
    }];
    
    UIColor *firstModelColor = [UIColor whiteColor];
    UIColor *secondModelColor = [UIColor blackColor];
    NSMutableArray<UIColor *> *expected = [[NSMutableArray alloc] initWithArray:@[firstModelColor, secondModelColor]];
    
    XCTAssertTrue([expected[0] isEqual:result[0].color]);
}

- (void)testMutableArrayComposeOperatorWithSmallerArray
{
    NSArrayTestModel *modelOne = [NSArrayTestModel new];
    modelOne.firstTestString = @"This";
    NSArrayTestModel *modelTwo = [NSArrayTestModel new];
    modelTwo.firstTestString = @"That";
    
    NSMutableArray<NSArrayTestModel *> *values = [[NSMutableArray alloc] initWithArray:@[modelOne, modelTwo]];
    NSMutableArray<UIColor *> *otherValues = [[NSMutableArray alloc] initWithArray:@[[UIColor whiteColor]]];
    NSMutableArray<NSArrayTestModel *> *result = [values composeWithArray:otherValues usingBlock:^NSArrayTestModel *(NSArrayTestModel *firstItem, UIColor *secondItem) {
        firstItem.color = secondItem;
        return firstItem;
    }];
    
    UIColor *firstModelColor = [UIColor whiteColor];
    NSMutableArray<UIColor *> *expected = [[NSMutableArray alloc] initWithArray:@[firstModelColor]];

    XCTAssertTrue([expected[0] isEqual:result[0].color]);
    XCTAssertTrue([result count] == 1);
}

- (void)testMutableArrayComposeOperatorWithEmptyArray
{
    NSArrayTestModel *modelOne = [NSArrayTestModel new];
    modelOne.firstTestString = @"This";
    NSArrayTestModel *modelTwo = [NSArrayTestModel new];
    modelTwo.firstTestString = @"That";
    
    NSMutableArray<NSArrayTestModel *> *values = [[NSMutableArray alloc] initWithArray:@[modelOne, modelTwo]];
    NSMutableArray<UIColor *> *otherValues = [NSMutableArray new];
    NSMutableArray<NSArrayTestModel *> *result = [values composeWithArray:otherValues usingBlock:^NSArrayTestModel *(NSArrayTestModel *firstItem, UIColor *secondItem) {
        firstItem.color = secondItem;
        return firstItem;
    }];
    
    XCTAssertTrue([result count] == 0);
}

@end
