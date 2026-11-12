//
//  NSDate+AdditionTests.m
//  Tests
//
//  Created by Mate Masnov on 31/10/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDate+Addition.h"

@interface NSDateAdditionTests : XCTestCase

@end

@implementation NSDateAdditionTests

- (void)testDateAdditionByAddingDays
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *startingDateComponents = [NSDateComponents new];
    startingDateComponents.day = 15;
    startingDateComponents.month = 6;
    startingDateComponents.year = 2015;
    NSDate *startingDate = [calendar dateFromComponents:startingDateComponents];
    
    NSDate *testDate = [startingDate dateByAddingDays:10];
    
    NSDateComponents *expectedDateComponents = [NSDateComponents new];
    expectedDateComponents.day = 25;
    expectedDateComponents.month = 6;
    expectedDateComponents.year = 2015;
    NSDate *expectedDate = [calendar dateFromComponents:expectedDateComponents];
    
    XCTAssertTrue([testDate isEqualToDate:expectedDate]);
    XCTAssertTrue([[testDate dateByAddingDays:-10] isEqualToDate:startingDate]);
}

- (void)testDateAdditionByAddingMoreThan30Days
{
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateComponents *startingDateComponents = [NSDateComponents new];
    startingDateComponents.day = 15;
    startingDateComponents.month = 6;
    startingDateComponents.year = 2015;
    NSDate *startingDate = [calendar dateFromComponents:startingDateComponents];
    
    NSDate *testDate = [startingDate dateByAddingDays:40];
    
    NSDateComponents *expectedDateComponents = [NSDateComponents new];
    expectedDateComponents.day = 25;
    expectedDateComponents.month = 7;
    expectedDateComponents.year = 2015;
    NSDate *expectedDate = [calendar dateFromComponents:expectedDateComponents];
    
    XCTAssertTrue([testDate isEqualToDate:expectedDate]);
    XCTAssertTrue([[testDate dateByAddingDays:-40] isEqualToDate:startingDate]);
}

- (void)testDateAdditionByAddingMonths
{
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateComponents *startingDateComponents = [NSDateComponents new];
    startingDateComponents.day = 15;
    startingDateComponents.month = 6;
    startingDateComponents.year = 2015;
    NSDate *startingDate = [calendar dateFromComponents:startingDateComponents];
    
    NSDate *testDate = [startingDate dateByAddingMonths:-3];
    
    NSDateComponents *expectedDateComponents = [NSDateComponents new];
    expectedDateComponents.day = 15;
    expectedDateComponents.month = 3;
    expectedDateComponents.year = 2015;
    NSDate *expectedDate = [calendar dateFromComponents:expectedDateComponents];
    
    XCTAssertTrue([testDate isEqualToDate:expectedDate]);
    XCTAssertTrue([[testDate dateByAddingMonths:3] isEqualToDate:startingDate]);
}

- (void)testDateAdditionByAddingMoreThan12Months
{
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateComponents *startingDateComponents = [NSDateComponents new];
    startingDateComponents.day = 15;
    startingDateComponents.month = 6;
    startingDateComponents.year = 2015;
    NSDate *startingDate = [calendar dateFromComponents:startingDateComponents];
    
    NSDate *testDate = [startingDate dateByAddingMonths:-14];
    
    NSDateComponents *expectedDateComponents = [NSDateComponents new];
    expectedDateComponents.day = 15;
    expectedDateComponents.month = 4;
    expectedDateComponents.year = 2014;
    NSDate *expectedDate = [calendar dateFromComponents:expectedDateComponents];
    
    XCTAssertTrue([testDate isEqualToDate:expectedDate]);
    XCTAssertTrue([[testDate dateByAddingYears:1 months:2 days:0] isEqualToDate:startingDate]);
    XCTAssertTrue([[testDate dateByAddingMonths:14] isEqualToDate:startingDate]);
}

- (void)testDateAdditionByAddingYears
{
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateComponents *startingDateComponents = [NSDateComponents new];
    startingDateComponents.day = 15;
    startingDateComponents.month = 6;
    startingDateComponents.year = 2015;
    NSDate *startingDate = [calendar dateFromComponents:startingDateComponents];
    
    NSDate *testDate = [startingDate dateByAddingYears:-10];
    
    NSDateComponents *expectedDateComponents = [NSDateComponents new];
    expectedDateComponents.day = 15;
    expectedDateComponents.month = 6;
    expectedDateComponents.year = 2005;
    NSDate *expectedDate = [calendar dateFromComponents:expectedDateComponents];
    
    XCTAssertTrue([testDate isEqualToDate:expectedDate]);
    XCTAssertTrue([[testDate dateByAddingYears:10] isEqualToDate:startingDate]);
}

@end
