//
//  UILineView.m
//  CTools
//
//  Created by Chance on 16/2/18.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "UILineView.h"

@interface UILineView () {
    CALayer *_lineLayer;
}

@end

IB_DESIGNABLE
@implementation UILineView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _lineLayer = [CALayer layer];
        [self.layer addSublayer:_lineLayer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _lineLayer = [CALayer layer];
        [self.layer addSublayer:_lineLayer];
    }
    return self;
}

- (void)setLineColor:(UIColor *)lineColor {
    if (_lineColor != lineColor) {
        _lineColor = lineColor;
        _lineLayer.backgroundColor = lineColor.CGColor;
    }
}

- (void)drawRect:(CGRect)rect {
    float w = self.lineWidth <= 0 ? rect.size.width : self.lineWidth  / [UIScreen mainScreen].scale;
    float h = self.lineHeight <= 0 ? rect.size.height : self.lineHeight / [UIScreen mainScreen].scale;
    
    _lineLayer.frame = CGRectMake(0, 0, w, h);
    _lineLayer.position = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
}


@end
