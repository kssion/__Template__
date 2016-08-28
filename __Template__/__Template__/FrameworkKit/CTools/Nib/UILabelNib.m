//
//  UILabelNib.m
//  CTools
//
//  Created by Chance on 15/11/30.
//  Copyright © 2015年 Chance. All rights reserved.
//

#import "UILabelNib.h"

@interface UILabelNib ()
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

@property (nonatomic, assign) IBInspectable CGFloat edgeTop, edgeRight, edgeBottom, edgeLeft;

@end

IB_DESIGNABLE
@implementation UILabelNib

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.borderWidth = 1;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.borderWidth = 1;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame edge:(UIEdgeInsets)edge {
    self = [self initWithFrame:frame];
    if (self)
    {
        self.borderWidth = 1;
        _edge = edge;
    }
    return self;
}

- (instancetype)initWithEdge:(UIEdgeInsets)edge {
    self = [super init];
    if (self)
    {
        _edge = edge;
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

#pragma mark -
- (void)setEdge:(UIEdgeInsets)edge {
    if (!UIEdgeInsetsEqualToEdgeInsets(_edge, edge)) {
        _edge = edge;
        [self setNeedsDisplay];
    }
}

- (void)setEdgeLeft:(CGFloat)edgeLeft {
    UIEdgeInsets edge = self.edge;
    edge.left = edgeLeft;
    self.edge = edge;
}

- (void)setEdgeTop:(CGFloat)edgeTop {
    UIEdgeInsets edge = self.edge;
    edge.top = edgeTop;
    self.edge = edge;
}

- (void)setEdgeRight:(CGFloat)edgeRight {
    UIEdgeInsets edge = self.edge;
    edge.right = edgeRight;
    self.edge = edge;
}

- (void)setEdgeBottom:(CGFloat)edgeBottom {
    UIEdgeInsets edge = self.edge;
    edge.bottom = edgeBottom;
    self.edge = edge;
}

- (void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edge)];
}

@end
