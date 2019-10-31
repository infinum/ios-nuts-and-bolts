//
//  NSDate+AdditionTests.m
//  Tests
//
//  Created by Mate Masnov on 31/10/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDate+Addition.h"

@interface NSDate_AdditionTests : XCTestCase

@end

@implementation NSDate_AdditionTests

- (void)testDateAdditionByAddingDays
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *startingDateComponents = [NSDateComponents new];
    [startingDateComponents setDay:15];
    [startingDateComponents setMonth:6];
    [startingDateComponents setYear:2015];
    NSDate *startingDate = [calendar dateFromComponents:startingDateComponents];
    
    NSDate *testDate = [startingDate dateByAddingDays:10];
    
    NSDateComponents *expectedDateComponents = [NSDateComponents new];
    [expectedDateComponents setDay:25];
    [expectedDateComponents setMonth:6];
    [expectedDateComponents setYear:2015];
    NSDate *expectedDate = [calendar dateFromComponents:expectedDateComponents];
    
    XCTAssertTrue([testDate isEqualToDate:expectedDate]);
    XCTAssertTrue([[testDate dateByAddingDays:-10] isEqualToDate:startingDate]);
}

- (void)testDateAdditionByAddingMoreThan30Days
{
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateComponents *startingDateComponents = [NSDateComponents new];
    [startingDateComponents setDay:15];
    [startingDateComponents setMonth:6];
    [startingDateComponents setYear:2015];
    NSDate *startingDate = [calendar dateFromComponents:startingDateComponents];
    
    NSDate *testDate = [startingDate dateByAddingDays:40];
    
    NSDateComponents *expectedDateComponents = [NSDateComponents new];
    [expectedDateComponents setDay:25];
    [expectedDateComponents setMonth:7];
    [expectedDateComponents setYear:2015];
    NSDate *expectedDate = [calendar dateFromComponents:expectedDateComponents];
    
    XCTAssertTrue([testDate isEqualToDate:expectedDate]);
    XCTAssertTrue([[testDate dateByAddingDays:-40] isEqualToDate:startingDate]);
}

- (void)testDateAdditionByAddingMonths
{
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateComponents *startingDateComponents = [NSDateComponents new];
    [startingDateComponents setDay:15];
    [startingDateComponents setMonth:6];
    [startingDateComponents setYear:2015];
    NSDate *startingDate = [calendar dateFromComponents:startingDateComponents];
    
    NSDate *testDate = [startingDate dateByAddingMonths:-3];
    
    NSDateComponents *expectedDateComponents = [NSDateComponents new];
    [expectedDateComponents setDay:15];
    [expectedDateComponents setMonth:3];
    [expectedDateComponents setYear:2015];
    NSDate *expectedDate = [calendar dateFromComponents:expectedDateComponents];
    
    XCTAssertTrue([testDate isEqualToDate:expectedDate]);
    XCTAssertTrue([[testDate dateByAddingMonths:3] isEqualToDate:startingDate]);
}

- (void)testDateAdditionByAddingMoreThan12Months
{
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateComponents *startingDateComponents = [NSDateComponents new];
    [startingDateComponents setDay:15];
    [startingDateComponents setMonth:6];
    [startingDateComponents setYear:2015];
    NSDate *startingDate = [calendar dateFromComponents:startingDateComponents];
    
    NSDate *testDate = [startingDate dateByAddingMonths:-14];
    
    NSDateComponents *expectedDateComponents = [NSDateComponents new];
    [expectedDateComponents setDay:15];
    [expectedDateComponents setMonth:4];
    [expectedDateComponents setYear:2014];
    NSDate *expectedDate = [calendar dateFromComponents:expectedDateComponents];
    
    XCTAssertTrue([testDate isEqualToDate:expectedDate]);
    XCTAssertTrue([[testDate dateByAddingYears:1 months:2 days:0] isEqualToDate:startingDate]);
    XCTAssertTrue([[testDate dateByAddingMonths:14] isEqualToDate:startingDate]);
}

- (void)testDateAdditionByAddingYears
{
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateComponents *startingDateComponents = [NSDateComponents new];
    [startingDateComponents setDay:15];
    [startingDateComponents setMonth:6];
    [startingDateComponents setYear:2015];
    NSDate *startingDate = [calendar dateFromComponents:startingDateComponents];
    
    NSDate *testDate = [startingDate dateByAddingYears:-10];
    
    NSDateComponents *expectedDateComponents = [NSDateComponents new];
    [expectedDateComponents setDay:15];
    [expectedDateComponents setMonth:6];
    [expectedDateComponents setYear:2005];
    NSDate *expectedDate = [calendar dateFromComponents:expectedDateComponents];
    
    XCTAssertTrue([testDate isEqualToDate:expectedDate]);
    XCTAssertTrue([[testDate dateByAddingYears:10] isEqualToDate:startingDate]);
}

@end
