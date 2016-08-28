//
//  NSFormatterTool.h
//  CTools
//
//  Created by Chance on 15/8/11.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - NSDateTool

/**
 *  格式化工具
 */
@interface NSFormatterTool : NSObject
@property (nonatomic, strong, readonly) NSDateFormatter *dateFormatter;
@property (nonatomic, strong, readonly) NSNumberFormatter *numberFormatter;

/*
 If you want to know the date format, Advice read http://www.cnblogs.com/Cristen/p/3599922.html
 */

- (instancetype)init;
+ (instancetype)sharedFormatterTool;

#pragma mark - NSDate
/*
 If the dateFormat is nil, default is "yyyy-MM-dd HH:mm:ss". // 1970-01-01 23:59:59
 */
- (void)setDateFormat:(NSString *)dateFormat;

- (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format;
- (NSDate *)dateWithString:(NSString *)string format:(NSString *)format;

#pragma mark - NSNumber
- (void)setNumberStyle:(NSNumberFormatterStyle)style;

@end

#pragma mark - NSDate 类别
@interface NSDate (DateFormater)
/**
 *  按format格式返回时间字符串. e.g. [[NSDate date] stringWithDateFormat:@"yyyy-MM-dd"]
 */
- (NSString *)stringWithDateFormat:(NSString *)format;

/**
 *  返回时间戳字符串
 */
- (NSTimeInterval)timestamp;

@end

#pragma mark - NSString 类别
@interface NSString (DateFormater)
/**
 *  按format格式读取时间字符串. e.g. [@"2015-08-11" dateWithDateFormat:@"yyyy-MM-dd"]
 */
- (NSDate *)dateWithDateFormat:(NSString *)format;

/**
 *  时间戳
 */
- (NSTimeInterval)timestamp;

/**
 *  时间字符串转换为时间戳
 *
 *  @param format 时间格式
 *
 *  @return 返回时间戳
 */
- (NSTimeInterval)timestampWithFormat:(NSString *)format;

/**
 *  时间戳转换为时间字符串 按默认时间格式
 *
 *  @param timestamp 要转换的时间戳
 *
 *  @return 返回时间字符串
 */
+ (NSString *)stringWithTimestamp:(NSTimeInterval)timestamp;

/**
 *  时间戳转换为时间字符串 按指定时间格式
 *
 *  @param timestamp 要转换的时间戳
 *  @param format    时间格式
 *
 *  @return 返回时间字符串
 */
+ (NSString *)stringWithTimestamp:(NSTimeInterval)timestamp format:(NSString *)format;

@end

#pragma mark - NSNumber 类别
@interface NSNumber (DateFormater)

/**
 *  数字转换为带指定样式的字符串
 *
 *  @param style 样式
 *
 *  @return 返回指定样式的字符串
 */
- (NSString *)stringWithNumberStyle:(NSNumberFormatterStyle)style;

@end
