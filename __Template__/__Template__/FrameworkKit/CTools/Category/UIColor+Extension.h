//
//  UIColor+Extension.h
//  CTools
//
//  Created by Chance on 16/8/8.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

/**
 *  0x333333 (51, 51, 51)
 */
+ (UIColor *)gray333;

/**
 *  0x666666 (102, 102, 102)
 */
+ (UIColor *)gray666;

/**
 *  0x999999 (153, 153, 153)
 */
+ (UIColor *)gray999;

/**
 *  0xCCCCCC (204, 204, 204)
 */
+ (UIColor *)grayCCC;


/**
 *  0x00 ~ 0xFF
 */
+ (UIColor *)grayHex:(NSUInteger)colorHex;

@end
