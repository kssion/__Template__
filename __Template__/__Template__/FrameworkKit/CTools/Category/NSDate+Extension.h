//
//  NSDate+Extension.h
//  CTools
//
//  Created by Chance on 15/11/16.
//  Copyright © 2015年 Chance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
@property (nonatomic, readonly) int era; /**< 时代 */
@property (nonatomic, readonly) int year; /**< 年 */
@property (nonatomic, readonly) int month; /**< 月 */
@property (nonatomic, readonly) int day; /**< 日 */
@property (nonatomic, readonly) int hour; /**< 时 */
@property (nonatomic, readonly) int minute; /**< 分 */
@property (nonatomic, readonly) int second; /**< 秒 */
@property (nonatomic, readonly) int weekday; /**< 星期 */
@property (nonatomic, readonly) int weekdayOrdinal;
@property (nonatomic, readonly) int quarter; /**< 季度 */
@property (nonatomic, readonly) int weekOfMonth; /**< 一月的第几周 */
@property (nonatomic, readonly) int weekOfYear; /**< 一年的第几周 */
@property (nonatomic, readonly) int yearForWeekOfYear;


/**
 *  前一天
 */
- (NSDate *)lastDay;

/**
 *  前一个月
 */
- (NSDate *)lastMonth;

/**
 *  前一年
 */
- (NSDate *)lastYear;

/**
 *  下一天
 */
- (NSDate *)nextDay;

/**
 *  下一月
 */
- (NSDate *)nextMonth;

/**
 *  下一年
 */
- (NSDate *)nextYeay;


/**
 *  返回增加若干年后的时间
 */
- (NSDate *)addYear:(NSInteger)year;

/**
 *  返回增加若干月后的时间
 */
- (NSDate *)addMonth:(NSInteger)month;

/**
 *  返回增加若干天后的时间
 */
- (NSDate *)addDay:(NSInteger)day;

/**
 *  返回增加若干小时后的时间
 */
- (NSDate *)addHour:(NSInteger)hour;

/**
 *  返回增加若干分钟后的时间
 */
- (NSDate *)addMinute:(NSInteger)minute;

/**
 *  返回增加若干秒后的时间
 */
- (NSDate *)addSeconds:(NSInteger)seconds;

@end
