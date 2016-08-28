//
//  NSArray+Extension.h
//  CTools
//
//  Created by Chance on 16/3/10.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Extension)
@property (readonly) NSUInteger lastIndex; /**< 末尾索引 */

/**
 *  转换为JSON字符串
 */
- (NSString *)JSONString;

/**
 *  取出一个数字
 *
 *  @param index 索引
 */
- (NSInteger)integerAtIndex:(NSUInteger)index;

/**
 *  取出一个字符串对象
 *
 *  @param index 索引
 */
- (NSString *)stringAtIndex:(NSUInteger)index;

/**
 *  取出一个数组对象
 *
 *  @param index 索引
 */
- (NSArray *)arrayAtIndex:(NSUInteger)index;

/**
 *  取出一个字典对象
 *
 *  @param index 索引
 */
- (NSDictionary *)dictionaryAtIndex:(NSUInteger)index;

/**
 *  插入排序
 *
 *  @param handle 对象排序规则
 *
 *  @return 返回排序后的数组
 */
- (NSArray *)sortInsertionHanndle:(BOOL (^)(id obj0, id obj1))handle;

/**
 *  快速排序
 *
 *  @param handle 对象排序规则
 *
 *  @return 返回排序后的数组
 */
- (NSArray *)sortQuickHanndle:(BOOL (^)(id obj0, id obj1))handle;

/**
 *  堆排序
 *
 *  @param handle 对象排序规则
 *
 *  @return 返回排序后的数组
 */
- (NSArray *)sortHeapHanndle:(BOOL (^)(id obj0, id obj1))handle;


- (NSArray *)removeObjectFromIndex:(NSUInteger)index;
- (NSArray *)removeObjectToIndex:(NSUInteger)index;
- (NSArray *)removeObjectFromIndex:(NSUInteger)index length:(NSUInteger)length;
- (NSArray *)removeObjectFromIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex;


@end

@interface NSMutableArray (Extension)

- (void)removeObjectFromIndex:(NSUInteger)index;
- (void)removeObjectToIndex:(NSUInteger)index;
- (void)removeObjectFromIndex:(NSUInteger)index length:(NSUInteger)length;
- (void)removeObjectFromIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex;

@end
