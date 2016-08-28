//
//  UIImage+Extension.h
//  CTools
//
//  Created by Chance on 15/8/28.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *  图片缩放到指定大小
 *
 *  @param  size    指定大小
 */
- (UIImage *)imageScaleToSize:(CGSize)size;

/**
 *  图片缩放到指定比例
 *
 *  @param  ratio   0.0~1.0
 */
- (UIImage *)imageScaleWithRatio:(CGFloat)ratio;

/**
 *  图片高斯模糊效果
 */
- (UIImage*)blurImageWithRadius:(CGFloat)radius;

/**
 *  生成圆形图片
 */
- (UIImage *)roundImage;

/**
 *  生成圆形图片
 *
 *  @param  radius  半径 跟UIImageView大小一致即可 大小不一致会出现锯齿
 */
- (UIImage *)roundImageWithRadius:(CGFloat)radius;

/**
 *  生成圆形图片(带边框)
 *  
 *  @param  radius          半径 跟UIImageView大小一致即可 大小不一致会出现锯齿
 *  @param  borderWidth     边框宽度
 *  @param  borderColor     边框颜色
 */
- (UIImage *)roundImageWithRadius:(CGFloat)radius borderWith:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 *  图片高斯模糊效果+颜色填充
 */
- (UIImage*)blurImageWithRadius:(CGFloat)radius color:(UIColor *)color;

/**
 *  返回屏幕截图
 */
+ (UIImage *)imageWithScreenshot;

/**
 *  返回屏幕截图(不包含状态栏)
 */
+ (UIImage *)imageWithScreenshotNoStatusBar;

///**
// *  返回字符串的二维码图片
// */
//+ (UIImage *)imageQRCodeWithString:(NSString *)string;
//
///**
// *  返回字符串的二维码图片
// *
// *  @param  width   指定宽度
// */
//+ (UIImage *)imageQRCodeWithString:(NSString *)string width:(CGFloat)width;
//
///**
// *  返回字符串的二维码图片
// *
// *  @param  color   指定颜色
// */
//+ (UIImage *)imageQRCodeWithString:(NSString *)string color:(UIColor *)color;
//
///**
// *  返回字符串的二维码图片
// *
// *  @param  width   指定宽度
// *  @param  color   指定颜色
// */
//+ (UIImage *)imageQRCodeWithString:(NSString *)string width:(CGFloat)width color:(UIColor *)color;
//
///**
// *  返回字符串的条形码图片
// */
//+ (UIImage *)imageBarCodeWithString:(NSString *)string;
//
///**
// *  返回字符串的条形码图片
// *
// *  @param  size   指定大小
// */
//+ (UIImage *)imageBarCodeWithString:(NSString *)string size:(CGSize)size;
//
///**
// *  返回字符串的条形码图片
// *
// *  @param  color   指定颜色
// */
//+ (UIImage *)imageBarCodeWithString:(NSString *)string color:(UIColor *)color;
//
///**
// *  返回字符串的条形码图片
// *
// *  @param  width   指定大小
// *  @param  color   指定颜色
// */
//+ (UIImage *)imageBarCodeWithString:(NSString *)string size:(CGSize)size color:(UIColor *)color;

@end
