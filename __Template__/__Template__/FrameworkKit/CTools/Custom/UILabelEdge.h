//
//  UILabelInsets.h
//  CTools
//
//  Created by 任晨培 on 15/4/28.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabelEdge : UILabel
@property(nonatomic) UIEdgeInsets edge;

- (instancetype)initWithFrame:(CGRect)frame edge:(UIEdgeInsets)edge;
- (instancetype)initWithEdge:(UIEdgeInsets)edge;

@end
