//
//  UITextFieldEdge.h
//  CTools
//
//  Created by Chance on 15/7/2.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextFieldEdge : UITextField
@property (nonatomic, assign) UIEdgeInsets edge;

- (instancetype)initWithEdge:(UIEdgeInsets)edge;
- (instancetype)initWithFrame:(CGRect)frame edge:(UIEdgeInsets)edge;
@end
