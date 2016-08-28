//
//  UITextViewNib.m
//  CTools
//
//  Created by Chance on 15/11/30.
//  Copyright © 2015年 Chance. All rights reserved.
//

#import "UITextViewNib.h"

@interface UITextViewNib ()
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

@end

IB_DESIGNABLE
@implementation UITextViewNib

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setBorderColor:(UIColor *)borderColor {
    if (_borderColor != borderColor) {
        _borderColor = borderColor;
        self.layer.borderColor = borderColor.CGColor;
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    if (_borderWidth != borderWidth && borderWidth >= 0) {
        _borderWidth = borderWidth;
        self.layer.borderWidth = borderWidth / [UIScreen mainScreen].scale;
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (_cornerRadius != cornerRadius && cornerRadius >= 0) {
        _cornerRadius = cornerRadius;
        self.layer.cornerRadius = cornerRadius;
        self.layer.masksToBounds = cornerRadius > 0;
    }
}

@end
