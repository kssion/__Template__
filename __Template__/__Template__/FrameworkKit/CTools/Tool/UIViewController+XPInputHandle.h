//
//  UIViewController+XPInputHandle.h
//  CTools
//
//  Created by Chance on 15/10/10.
//  Copyright © 2015年 Chance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPInputHandle.h"

/*
 *  使用说明:（只要是继承自UIViewController的子类都支持）
 *
 *  Must be XPInputHandle 2.2+
 *
 *  [self addInputView:textField superView:self.view];  // 添加 输入控件 和 父控件(可以动的父视图)
 *
 *  可在所有继承自UIViewController的子类中使用
 *  输入控件支持  UITextField、UITextView
 *  父控件支持   UIView、UIScrollView
 *
 */

@interface UIViewController (XPInputHandle)

/**
 *  添加输入控件
 *
 *  @param inputView 输入控件
 *  @param superView 顶级父控件 UIView、UIScrollView
 */
- (void)addInputView:(UIView *)inputView superView:(UIView *)superView; /**< 添加输入控件*/

/**
 *  设置输入控件返回键为 UIReturnKeyNext, 最后一个为 UIReturnKeyDone
 */
- (void)setReturnKeyType;


@end
