//
//  NSDate+Addition.h
//
//  Created by Mate Masnov on 31/10/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#ifndef NSDate_Addition_h
#define NSDate_Addition_h

#import <Foundation/Foundation.h>

@interface NSDate (NSDateAddition)

/**
 Creates a new date by adding or subtracting years, months and days to 'self'.

 @param years number of years to add or subtract to 'self'.
 @param months number of months to add or subtract to 'self'.
 @param days number of days to add or subtract to 'self'.
 @return resulting date by adding or subtracting years, months and days to 'self'.
 */
- (NSDate *)dateByAddingYears:(NSInteger)years months:(NSInteger)months days:(NSInteger)days;

/**
 Creates a new date by adding or subtracting years to 'self'.

 @param years number of years to add or subtract to 'self'.
 @return resulting date by adding or subtracting years to 'self'.
 */
- (NSDate *)dateByAddingYears:(NSInteger)years;

/**
 Creates a new date by adding or subtracting months to 'self'.

 @param months number of months to add or subtract to 'self'.
 @return resulting date by adding or subtracting months to 'self'.
 */
- (NSDate *)dateByAddingMonths:(NSInteger)months;

/**
 Creates a new date by adding or subtracting days to 'self'.

 @param days number of days to add or subtract to 'self'.
 @return resulting date by adding or subtracting days to 'self'.
 */
- (NSDate *)dateByAddingDays:(NSInteger)days;

@end

#endif /* NSDate_Addition_h */
