//
//  NSObject+Extension.h
//  CTools
//
//  Created by Chance on 15/7/29.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension)

/**
 *  标识符
 */
@property (nonatomic, strong) NSString *identifier;

/**
 *  用来存放数据
 */
@property (nonatomic, weak) id object;

/**
 *  回调Block
 */
@property (nonatomic, weak) void(^callbackBlock)(id obj);
- (void)setCallbackBlock:(void (^)(id obj))callbackBlock;

/**
 *  到字符串. NSNull, NSNumber, other class.
 */
- (NSString *)toString;

/** 
 *  获取变量列表
 */
- (NSArray *)getVarList;

/**
 *  返回一个重复对象
 */
- (id)duplicate;


+ (void)addInstanceMethod:(SEL)method fromObject:(id)obj method:(SEL)aMethod;
+ (void)addClassMethod:(SEL)method fromObject:(id)obj method:(SEL)aMethod;
@end
