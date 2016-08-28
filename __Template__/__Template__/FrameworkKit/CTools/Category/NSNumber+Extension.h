//
//  NSNumber+Extension.h
//  CTools
//
//  Created by Chance on 16/1/21.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Extension)

/**
 *  数字转换为带指定格式的字符串
 */
- (NSString *)stringValueWithFormatterStyle:(NSNumberFormatterStyle)style;

@end
