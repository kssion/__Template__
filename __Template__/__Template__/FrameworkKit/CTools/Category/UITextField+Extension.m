//
//  UITextField+Extension.m
//  CTools
//
//  Created by Chance on 15/7/2.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import "UITextField+Extension.h"

@implementation UITextField (Extension)

- (CGFloat)fontSize {
    return self.font.pointSize;
}

- (void)setFontSize:(CGFloat)fontSize {
    self.font = [self.font fontWithSize:fontSize];
}

- (UIColor *)placeholderColor {
    UILabel *lab = [self valueForKey:@"placeholderLabel"];
    return lab.textColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    UILabel *lab = [self valueForKey:@"placeholderLabel"];
    [lab setTextColor:placeholderColor];
}

- (CGFloat)fontAutoSize {
    return self.fontSize;
}
- (void)setFontAutoSize:(CGFloat)fontAutoSize
{
    switch ((int)([[UIScreen mainScreen] bounds].size.width)) {
        case 375:
            self.fontSize = fontAutoSize + 1;
            break;
        case 414:
            self.fontSize = fontAutoSize + 2;
            break;
        default:
            self.fontSize = fontAutoSize;
            break;
    }
}


@end
