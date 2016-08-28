//
//  XPInputHandle.h
//  CTools
//
//  version: 2.2
//  Created by Chance on 15/9/15.
//  Copyright (c) 2015年 Chance. All rights reserved.
//
//  151010
//  151010
//  Last update time 160501
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 *  使用说明:
 *  添加 输入控件 和 父控件(可以动的父视图)
 *  
 *  可以在继承自UIResponder的类下使用
 *  输入控件支持 UITextField、UITextView
 *  父控件支持 UIView、UIScrollView
 *
 */

/**
 *  输入控件键盘遮挡处理工具
 */
@interface XPInputHandle : NSObject <UITextFieldDelegate>

+ (XPInputHandle *)defaultInputHandle; /**< XPInputHandle 默认实例*/


#pragma mark -
/**
 *  Date: 2015.10.10
 *  Version: 2.1
 */
- (void)registerForKey:(NSString *)key;      /**< 注册一个标识*/
- (void)removeForKey:(NSString *)key;      /**< 移除一个标识*/
- (void)addInputView:(UIView *)inputView superView:(UIView *)superView forKey:(NSString *)key; /**< 添加输入控件 标识*/

/**
 *  设置输入控件返回键为 UIReturnKeyNext, 最后一个为 UIReturnKeyDone
 *
 *  @param key  registerForKey:key 为同一key
 */
- (void)setReturnKeyTypeForKey:(NSString *)key;

#pragma mark -
+ (void)registerForKey:(NSString *)key;      /**< 注册一个标识*/
+ (void)removeForKey:(NSString *)key;      /**< 移除一个标识*/
+ (void)addInputView:(UIView *)inputView superView:(UIView *)superView forKey:(NSString *)key; /**< 添加输入控件 标识*/

/**
 *  设置输入控件返回键为 UIReturnKeyNext, 最后一个为 UIReturnKeyDone
 *
 *  @param key  registerForKey:key 为同一key
 */
+ (void)setReturnKeyTypeForKey:(NSString *)key;

@end