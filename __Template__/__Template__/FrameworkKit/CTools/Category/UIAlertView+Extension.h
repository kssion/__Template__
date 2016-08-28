//
//  UIAlertView+Extension.h
//  CTools
//
//  Created by Chance on 15/7/15.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Extension) <UIAlertViewDelegate>

/**
 *  创建AlertView
 */
+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles block:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))block;

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles block:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))block cancelBlock:(void(^)())cancel;

/**
 *  显示 带block事件
 */
- (void)showWithBlock:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))ok;
- (void)showWithBlock:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))ok cancelBlock:(void(^)())cancel;

@end