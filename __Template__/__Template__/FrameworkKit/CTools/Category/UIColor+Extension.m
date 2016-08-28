//
//  UIColor+Extension.m
//  CTools
//
//  Created by Chance on 16/8/8.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+ (UIColor *)gray333 {
    return [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
}

+ (UIColor *)gray666 {
    return [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
}

+ (UIColor *)gray999 {
    return [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
}

+ (UIColor *)grayCCC {
    return [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
}

+ (UIColor *)grayHex:(NSUInteger)colorHex {
    CGFloat blue = (colorHex & 0xFF) / 255.0f;
    return [UIColor colorWithRed:blue green:blue blue:blue alpha:1];
}

@end
