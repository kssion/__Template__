//
//  UILabelInsets.m
//  CTools
//
//  Created by 任晨培 on 15/4/28.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import "UILabelEdge.h"

@implementation UILabelEdge

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _edge = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _edge = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame edge:(UIEdgeInsets)edge {
    self = [self initWithFrame:frame];
    if (self)
    {
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

- (void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edge)];
}

@end
