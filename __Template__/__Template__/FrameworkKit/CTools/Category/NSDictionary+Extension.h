//
//  NSDictionary+Extension.h
//  CTools
//
//  Created by Chance on 15/10/12.
//  Copyright © 2015年 Chance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extension)

/**
 *  转换为JSON字符串
 */
- (NSString *)JSONString;

/**
 *  转换为URL参数格式字符串
 */
- (NSString *)toQueryString;

/**
 *  取出一个非NSNull的对象
 *
 *  如果对象为NSNull 则返回 nil
 */
- (id)objForKey:(id)key;

/**
 *  取出一个数字
 *
 *  如果对象不是number或字符串 则返回 0
 */
- (NSInteger)integerForKey:(id)key;

/**
 *  取出一个字符串对象
 *
 *  如果不是NSString类型 则返回空字符串 @""
 */
- (NSString *)stringForKey:(id)key;

/**
 *  取出一个数组对象
 *
 *  如果不是NSArray类型 则返回空字数组 @[]
 */
- (NSArray *)arrayForKey:(id)key;

/**
 *  取出一个数组对象
 *
 *  如果不是NSDictionary类型 则返回空字典 @{}
 */
- (NSDictionary *)dictionaryForKey:(id)key;

@end
