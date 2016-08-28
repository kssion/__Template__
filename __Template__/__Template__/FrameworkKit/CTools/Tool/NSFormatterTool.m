//
//  NSFormatterTool.m
//  CTools
//
//  Created by Chance on 15/8/11.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import "NSFormatterTool.h"

#pragma mark - NSFormatterTool
@interface NSFormatterTool ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;

@end

@implementation NSFormatterTool

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        self.numberFormatter = [[NSNumberFormatter alloc] init];
    }
    return self;
}

+ (instancetype)sharedFormatterTool {
    static NSFormatterTool *sharedFormatterTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFormatterTool = [[self alloc] init];
        
    });
    return sharedFormatterTool;
}

#pragma mark - NSDate
- (void)setDateFormat:(NSString *)dateFormat {
    if (![self.dateFormatter.dateFormat isEqualToString:dateFormat]) {
        [self.dateFormatter setDateFormat:dateFormat];
    }
}

- (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format {
    if (format && ![self.dateFormatter.dateFormat isEqualToString:format]) {
        [self.dateFormatter setDateFormat:format];
    }
    return [self.dateFormatter stringFromDate:date];
}

- (NSDate *)dateWithString:(NSString *)string format:(NSString *)format {
    if (format && ![self.dateFormatter.dateFormat isEqualToString:format]) {
        [self.dateFormatter setDateFormat:format];
    }
    return [self.dateFormatter dateFromString:string];
}

#pragma mark - NSNumber
- (void)setNumberStyle:(NSNumberFormatterStyle)style {
    [self.numberFormatter setNumberStyle:style];
}

- (NSString *)stringWithNumber:(NSNumber *)number {
    return [self.numberFormatter stringFromNumber:number];
}

- (NSString *)stringWithNumber:(NSNumber *)number style:(NSNumberFormatterStyle)style {
    [self.numberFormatter setNumberStyle:style];
    return [self.numberFormatter stringFromNumber:number];
}

@end

#pragma mark - NSDate 类别
@implementation NSDate (DateFormater)
- (NSString *)stringWithDateFormat:(NSString *)format {
    return [[NSFormatterTool sharedFormatterTool] stringWithDate:self format:format];
}

- (NSTimeInterval)timestamp {
    return [self timeIntervalSince1970];
}

@end

#pragma mark - NSString 类别
@implementation NSString (DateFormater)
- (NSDate *)dateWithDateFormat:(NSString *)format {
    return [[NSFormatterTool sharedFormatterTool] dateWithString:self format:format];
}

- (NSTimeInterval)timestamp {
    return [[[NSFormatterTool sharedFormatterTool] dateWithString:self format:nil] timeIntervalSince1970];
}

- (NSTimeInterval)timestampWithFormat:(NSString *)format {
    return [[[NSFormatterTool sharedFormatterTool] dateWithString:self format:format] timeIntervalSince1970];
}

+ (NSString *)stringWithTimestamp:(NSTimeInterval)timestamp {
    return [[NSFormatterTool sharedFormatterTool] stringWithDate:[NSDate dateWithTimeIntervalSince1970:timestamp] format:nil];
}

+ (NSString *)stringWithTimestamp:(NSTimeInterval)timestamp format:(NSString *)format {
    return [[NSFormatterTool sharedFormatterTool] stringWithDate:[NSDate dateWithTimeIntervalSince1970:timestamp] format:format];
}

@end

#pragma mark - NSNumber 类别
@implementation NSNumber (DateFormater)
- (NSString *)stringWithNumberStyle:(NSNumberFormatterStyle)style {
    return [[NSFormatterTool sharedFormatterTool] stringWithNumber:self style:style];
}

@end
