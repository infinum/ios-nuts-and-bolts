//
//  NSDate+Addition.m
//
//  Created by Mate Masnov on 31/10/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import "NSDate+Addition.h"

@implementation NSDate (NSDateAddition)

- (NSDate *)dateByAddingYears:(NSInteger)years andMonths:(NSInteger)months andDays:(NSInteger)days
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *currentDateComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:[currentDateComponents year] + years];
    [dateComponents setMonth:[currentDateComponents month] + months];
    [dateComponents setDay:[currentDateComponents day] + days];
    
    return [calendar dateFromComponents:dateComponents];
}

- (NSDate *)dateByAddingYears:(NSInteger)years
{
    return [self dateByAddingYears:years andMonths:0 andDays:0];
}

- (NSDate *)dateByAddingMonths:(NSInteger)months
{
    return [self dateByAddingYears:0 andMonths:months andDays:0];
}

- (NSDate *)dateByAddingDays:(NSInteger)days
{
    return [self dateByAddingYears:0 andMonths:0 andDays:days];
}

@end
