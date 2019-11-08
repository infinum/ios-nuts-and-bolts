//
//  NSDate+Addition.m
//
//  Created by Mate Masnov on 31/10/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import "NSDate+Addition.h"

@implementation NSDate (NSDateAddition)

- (NSDate *)dateByAddingYears:(NSInteger)years months:(NSInteger)months days:(NSInteger)days
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.year = years;
    dateComponents.month = months;
    dateComponents.day = days;
    
    return [calendar dateByAddingComponents:dateComponents toDate:self options:0];
}

- (NSDate *)dateByAddingYears:(NSInteger)years
{
    return [self dateByAddingYears:years months:0 days:0];
}

- (NSDate *)dateByAddingMonths:(NSInteger)months
{
    return [self dateByAddingYears:0 months:months days:0];
}

- (NSDate *)dateByAddingDays:(NSInteger)days
{
    return [self dateByAddingYears:0 months:0 days:days];
}

@end
