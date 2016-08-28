//
//  QRCode.h
//  CTools
//
//  Created by Chance on 16/7/21.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 *  二维码
 */
@interface QRCode : NSObject

+ (NSString *)decodeWithImage:(UIImage *)image;

+ (UIImage *)encodeWithString:(NSString *)string;
+ (UIImage *)encodeWithString:(NSString *)string width:(CGFloat)width;
+ (UIImage *)encodeWithString:(NSString *)string color:(UIColor *)color;
+ (UIImage *)encodeWithString:(NSString *)string width:(CGFloat)width color:(UIColor *)color;

@end


/**
 *  条形码
 */
@interface BarCode : NSObject

+ (UIImage *)encodeWithString:(NSString *)string;
+ (UIImage *)encodeWithString:(NSString *)string size:(CGSize)size;
+ (UIImage *)encodeWithString:(NSString *)string color:(UIColor *)color;
+ (UIImage *)encodeWithString:(NSString *)string size:(CGSize)size color:(UIColor *)color;

@end
