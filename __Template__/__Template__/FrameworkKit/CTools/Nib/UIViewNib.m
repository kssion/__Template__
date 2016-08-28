//
//  UIViewNib.m
//  CTools
//
//  Created by Chance on 15/11/30.
//  Copyright © 2015年 Chance. All rights reserved.
//

#import "UIViewNib.h"

@interface UIViewNib ()
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, strong) IBInspectable NSString *backgroundHex;

@end

IB_DESIGNABLE
@implementation UIViewNib

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

#pragma mark -
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

- (void)setBackgroundHex:(NSString *)backgroundHex {
    
}

@end
