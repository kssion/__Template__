//
//  Define.h
//  CTools
//
//  Created by Chance on 15/7/2.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#ifndef CTools_Define_h
#define CTools_Define_h

/**
 *  在此处定义宏
 */

// 设备屏幕显示尺寸
#define SCREEN_3_5    CGSizeEqualToSize([[UIScreen mainScreen] bounds].size, CGSizeMake(320, 480))
#define SCREEN_4_0    CGSizeEqualToSize([[UIScreen mainScreen] bounds].size, CGSizeMake(320, 568))
#define SCREEN_4_7    CGSizeEqualToSize([[UIScreen mainScreen] bounds].size, CGSizeMake(375, 667))
#define SCREEN_5_5    CGSizeEqualToSize([[UIScreen mainScreen] bounds].size, CGSizeMake(414, 736))

// 设备系统版本
#define __IOS_VERSION [[UIDevice currentDevice].systemVersion floatValue]
#define ISIOS_5_0   ([[UIDevice currentDevice].systemVersion floatValue] >= 5.0)
#define ISIOS_6_0   ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
#define ISIOS_7_0   ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
#define ISIOS_8_0   ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#define ISIOS_9_0   ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    #define __IOS_7_0   1
#else
    #define __IOS_7_0   0
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    #define __IOS_8_0   1
#else
    #define __IOS_8_0   0
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    #define __IOS_9_0   1
#else
    #define __IOS_9_0   0
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    #define __IOS_10_0   1
#else
    #define __IOS_10_0   0
#endif

/**
 *  判断是否是64位设备 (预编译宏)
 */
#define IS64Bit (defined(__LP64__) && __LP64__)

/**
 *  界面常用颜色
 */
#define kDefaultColor [UIColor colorWithRed:0.3373 green:0.6706 blue:0.3569 alpha:1]

/**
 *  主屏的宽
 */
#define kScreenWidth ([[UIScreen mainScreen] bounds].size.width)

/**
 *  主屏的高
 */
#define kScreenHeight ([[UIScreen mainScreen] bounds].size.height)

/**
 *  主屏的大小
 */
#define kScreenBounds  [[UIScreen mainScreen] bounds]

/**
 *  主屏的frame
 */
#define kScreenFrame  [UIScreen mainScreen].applicationFrame

/**
 *  主屏的size
 */
#define kScreenSize   [[UIScreen mainScreen] bounds].size

/**
 *  屏幕的中心点
 */
#define kScreenCenter   CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5)

/**
 *  1像素宽度
 */
#define kSingleLine   (1 / [UIScreen mainScreen].scale)

/**
 *  屏幕缩放比例
 */
#define kScreenScale    ([[UIScreen mainScreen] bounds].size.width / 320.0)



#pragma mark - 宏定义函数

/**
 *  宏定义AlertView
 */
#ifdef __IPHONE_8_0
#define SHOW_ALERT(msg) [[UIAlertController alertWithTitle:@"温馨提示" message:msg cancelButtonTitle:@"我知道啦！"] show];
#else
#define SHOW_ALERT(message) [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:@"我知道啦！" otherButtonTitles:nil] show];
#endif

#define __weakof(obj) __weak __typeof(obj) _##obj = obj;
#define __strongof(obj) __strong __typeof(obj) _##obj = obj;

/**
 *  字符串拼接
 */
#define STR(FORMAT, ...) [NSString stringWithFormat:FORMAT, ##__VA_ARGS__]

/**
 *  通用 Property 宏定义
 */
#define __propertyAssign(__v__)     @property (nonatomic, assign)   __v__;
#define __propertyCopy(__v__)       @property (nonatomic, copy)     __v__;
#define __propertyWeak(__v__)       @property (nonatomic, weak)     __v__;
#define __propertyStrong(__v__)     @property (nonatomic, strong)   __v__;

// test property
#define __assignProperty(__v__)     @property (nonatomic, assign)   __v__;
#define __copyProperty(__v__)       @property (nonatomic, copy)     __v__;
#define __weakProperty(__v__)       @property (nonatomic, weak)     __v__;
#define __strongProperty(__v__)     @property (nonatomic, strong)   __v__;

/**
 *  NSLog
 */
#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d　\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif








#endif
