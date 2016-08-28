//
//  NSDate+Extension.m
//  CTools
//
//  Created by Chance on 15/11/16.
//  Copyright © 2015年 Chance. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

- (NSDateComponents *)components:(NSCalendarUnit)unitFlags {
    return [[NSCalendar currentCalendar] components:unitFlags fromDate:self];
}

- (int)era {
    return (int)[[self components:2] era];
}

- (int)year {
    return (int)[[self components:4] year];
}

- (int)month {
    return (int)[[self components:8] month];
}

- (int)day {
    return (int)[[self components:16] day];
}

- (int)hour {
    return (int)[[self components:32] hour];
}

- (int)minute {
    return (int)[[self components:64] minute];
}

- (int)second {
    return (int)[[self components:128] second];
}

- (int)weekday {
    return (int)[[self components:512] weekday];
}

- (int)weekdayOrdinal {
    return (int)[[self components:1024] weekdayOrdinal];
}

- (int)quarter {
    return (int)[[self components:2048] quarter];
}

- (int)weekOfMonth {
    return (int)[[self components:4096] weekOfMonth];
}

- (int)weekOfYear {
    return (int)[[self components:8192] weekOfYear];
}

- (int)yearForWeekOfYear {
    return (int)[[self components:16384] yearForWeekOfYear];
}


#pragma mark -

- (NSDate *)lastDay {
    return [self addDay:-1];
}

- (NSDate *)lastMonth {
    return [self addMonth:-1];
}

- (NSDate *)lastYear {
    return [self addYear:-1];
}

- (NSDate *)nextDay {
    return [self addDay:1];
}

- (NSDate *)nextMonth {
    return [self addMonth:1];
}

- (NSDate *)nextYeay {
    return [self addYear:1];
}


#pragma mark -

- (NSDate *)addYear:(NSInteger)year {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:year];
    return [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents toDate:self options:0];
}

- (NSDate *)addMonth:(NSInteger)month {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:month];
    return [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents toDate:self options:0];
}

- (NSDate *)addDay:(NSInteger)day {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:day];
    return [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents toDate:self options:0];
}

- (NSDate *)addHour:(NSInteger)hour {
    return [self dateByAddingTimeInterval:hour * 3600];
}

- (NSDate *)addMinute:(NSInteger)minute {
    return [self dateByAddingTimeInterval:minute * 60];
}

- (NSDate *)addSeconds:(NSInteger)seconds {
    return [self dateByAddingTimeInterval:seconds];
}

@end
