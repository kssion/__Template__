//
//  Function.h
//  CTools
//
//  Created by Chance on 15/7/1.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Function : NSObject

#pragma mark - 计时器
/**
 *  定时器 v2
 *
 *  @date   2016.2.24
 *
 *  @param timeout          超时时间
 *  @param increase         每个时间间隔的增加量
 *  @param interval         时间间隔
 *  @param stop             控制是否停止
 *  @param runingHandler    每个时间间隔执行(当前时间)
 *  @param stopHandler      停止时执行(停止时间)
 *
 *  @return                 返回一个 t 用来控制运行. 取消运行dispatch_source_cancel(t)
 */
dispatch_source_t timer_create_v2(double timeout, double increase, double interval, bool *stop, void(^runingHandler)(double currentTime), void(^stopHandler)(double stopTime));

/**
 *  倒计时 v2
 *
 *  @date   2016.2.24
 *
 *  @param duration         总时长
 *  @param decrease         每个时间间隔减少量
 *  @param interval         时间间隔
 *  @param *stop            控制是否停止
 *  @param runingHandler    每个时间间隔执行(当前时间)
 *  @param stopHandler      停止时执行(停止时间)
 *
 *  @return                 返回一个 t 用来控制运行. 取消运行dispatch_source_cancel(t)
 */
dispatch_source_t countdown_create_v2(double duration, double decrease, double interval, bool *stop, void(^runingHandler)(double currentTime), void(^stopHandler)(double stopTime));

/**
 *  定时器 v3
 *
 *  @date   2016.05.08
 *
 *  @param starttime        开始时间
 *  @param timeout          超时时间
 *  @param increase         每个时间间隔的增加量
 *  @param interval         时间间隔
 *  @param runingHandler    每个时间间隔执行(当前时间)
 *  @param stopHandler      停止时执行(停止时间)
 *
 *  @return                 返回一个 t 用来控制运行. 取消运行dispatch_source_cancel(t)
 */
dispatch_source_t timer_create_v3(double starttime, double timeout, double increase, double interval, void(^runingHandler)(double currentTime), void(^stopHandler)(double stopTime));

/**
 *  倒计时 v3
 *
 *  @date   2016.05.08
 *
 *  @param duration         总时长
 *  @param decrease         每个时间间隔减少量
 *  @param interval         时间间隔
 *  @param runingHandler    每个时间间隔执行(当前时间)
 *  @param stopHandler      停止时执行(停止时间)
 *
 *  @return                 返回一个 t 用来控制运行. 取消运行dispatch_source_cancel(t)
 */
dispatch_source_t countdown_create_v3(double duration, double decrease, double interval, void(^runingHandler)(double currentTime), void(^stopHandler)(double stopTime));



#pragma mark -

/**
 *  主线程同步执行
 */
void dispatch_sync_main_safe(dispatch_block_t);

/**
 *  主线程异步执行
 */
void dispatch_async_main_safe(dispatch_block_t);

/**
 *  全局队列同步执行
 */
void dispatch_sync_global(dispatch_block_t);

/**
 *  全局队列异步执行
 */
void dispatch_async_global(dispatch_block_t);


#pragma mark - 转换
/**
 *  字符串转换为NSURL
 *
 *  @param str URL字符串
 *
 *  @return NSURL
 */
NSURL *URLWithString(NSString *str);

#pragma mark - UIColor
/**
 *  获取UIColor对象 (0 - 255)
 *
 *  @param r 红 0 - 255
 *  @param g 绿 0 - 255
 *  @param b 蓝 0 - 255
 */
UIColor *color_rgb(UInt8 r, UInt8 g, UInt8 b);

/**
 *  获取UIColor对象 (0.0 - 1.0)
 *
 *  @param r 红 0.0 - 1.0
 *  @param g 绿 0.0 - 1.0
 *  @param b 蓝 0.0 - 1.0
 */
UIColor *color_rgb_f(CGFloat r, CGFloat g, CGFloat b);

/**
 *  获取UIColor对象 (0.0 - 1.0)
 *
 *  @param r 红 0 - 255
 *  @param g 绿 0 - 255
 *  @param b 蓝 0 - 255
 *  @param a 透明度  0.0 - 1.0
 */
UIColor *color_rgba(UInt8 r, UInt8 g, UInt8 b, CGFloat a);

/**
 *  获取UIColor对象 (0.0 - 1.0)
 *
 *  @param r 红 0.0 - 1.0
 *  @param g 绿 0.0 - 1.0
 *  @param b 蓝 0.0 - 1.0
 *  @param a 透明度 0.0 - 1.0
 */
UIColor *color_rgba_f(CGFloat r, CGFloat g, CGFloat b, CGFloat a);

/**
 *  获取图片模式颜色
 *
 *  @param image 图片对象
 */
UIColor *color_image(UIImage *image);

/**
 *  获取UIColor对象 (0x000000 - 0xffffff)
 *
 *  @param hex 十六进制颜色
 */
UIColor *color_hex(NSUInteger hex);

/**
 *  获取UIColor对象 (0x000000 - 0xffffff)
 *
 *  @param hex   十六进制颜色
 *  @param alpha 透明度
 */
UIColor *color_hexAlpha(NSUInteger hex, CGFloat alpha);

#pragma mark - UIImage
/* UIImage */
UIImage *image_name(NSString *name);
UIImage *image_color(UIColor *color);
UIImage *image_colorHex(NSUInteger hex);

#pragma mark - 校验
/** 检查摄像头 */
BOOL checkValidateCamera();

/** 拨打电话(电话号码 number, 拨打前提示 isPrompt) */
BOOL callTelNumber(NSString *number, BOOL isPrompt);

/** 返回一个非空参数. If params the former is nil, select params the latter in successively. If all params is nil, return nil; */
id not_nil_object(id opt1, id opt2);

/** 返回一个非空字符串 如果都为空 则返回空字符串 @"" */
NSString *not_null_string(NSString *str1, NSString *str2);

/** 文件(路径)是否存在 */
BOOL fileExistsAtPath(NSString *path);


#pragma mark - NSUserDefaults
id userDefaultsGet(NSString *key);
void userDefaultsSet(id obj, NSString *key);
void userDefaultsRemove(NSString *key);
void userDefaultsClear();

#pragma mark - 沙盒路径
/* 沙盒路径 */
/** Documents/ */
NSString *pathForDocuments();

/** Library/Caches/ */
NSString *pathForCaches();

/** Documents/<文件名> */
NSString *pathForDocumentsFileName(NSString *name);

/** Documents/<子路径>/<文件名> */
NSString *pathForDocumentsFilePathName(NSString *subPath, NSString *name);

/** Documents/<文件名> */
NSString *pathForCachesFileName(NSString *name);

/** Documents/<子路径>/<文件名> */
NSString *pathForCachesFilePathName(NSString *subPath, NSString *name);

#pragma mark -
/** 获取类的变量列表 */
NSArray *getVarListForClass(Class cla);

@end
