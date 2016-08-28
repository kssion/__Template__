//
//  UIButton+Extension.m
//  CTools
//
//  Created by Chance on 15/7/14.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

- (CGFloat)fontSize {
    return self.titleLabel.font.pointSize;
}

- (void)setFontSize:(CGFloat)fontSize {
    self.titleLabel.font = [self.titleLabel.font fontWithSize:fontSize];
}

- (void)setBackground:(UIImage *)normalImage :(UIImage *)highlightImage {
    [self setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
}

- (void)setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType {
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0.0, -5, 0.0, 0.0)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10, 0.0, 0.0)];
    [self setTitle:title forState:stateType];
}

@end
