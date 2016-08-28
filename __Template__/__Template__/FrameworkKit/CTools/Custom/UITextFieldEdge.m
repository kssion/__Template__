//
//  UITextFieldEdge.m
//  CTools
//
//  Created by Chance on 15/7/2.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import "UITextFieldEdge.h"

@interface UITextFieldEdge ()

@property (nonatomic, assign) IBInspectable CGFloat edgeTop, edgeRight, edgeBottom, edgeLeft;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;
@property (nonatomic, strong) IBInspectable UIColor *cursorColor;

@end

IB_DESIGNABLE
@implementation UITextFieldEdge

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self makeDefaultValues];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeDefaultValues];
    }
    return self;
}

- (instancetype)initWithEdge:(UIEdgeInsets)edge {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self makeDefaultValues];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame edge:(UIEdgeInsets)edge {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeDefaultValues];
    }
    return self;
}

- (void)makeDefaultValues {
    self.edgeLeft = 10;
    self.edgeTop = 10;
    self.edgeRight = 10;
    self.edgeBottom = 10;
    self.edge = UIEdgeInsetsMake(_edgeTop, _edgeRight, _edgeBottom, _edgeLeft);
//    self.borderWidth = 1;
//    self.borderColor = [UIColor grayColor];
}

#pragma mark -
- (void)setEdge:(UIEdgeInsets)edge {
    if (!UIEdgeInsetsEqualToEdgeInsets(_edge, edge)) {
        _edge = edge;
    }
}

- (void)setEdgeLeft:(CGFloat)edgeLeft {
    _edge.left = edgeLeft;
}

- (void)setEdgeTop:(CGFloat)edgeTop {
    _edge.top = edgeTop;
}

- (void)setEdgeRight:(CGFloat)edgeRight {
    _edge.right = edgeRight;
}

- (void)setEdgeBottom:(CGFloat)edgeBottom {
    _edge.bottom = edgeBottom;
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

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    [[self valueForKey:@"_placeholderView"] setTextColor:placeholderColor];
}

- (void)setCursorColor:(UIColor *)cursorColor {
    self.tintColor = cursorColor;
}

#pragma mark -
- (CGRect)textRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, _edge);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    if (self.clearButtonMode != UITextFieldViewModeNever) {
        UIEdgeInsets edge = _edge;
        edge.right += 15;
        return UIEdgeInsetsInsetRect(bounds, edge);
    }
    return UIEdgeInsetsInsetRect(bounds, _edge);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, _edge);
}


@end
