//
//  BaseNavigationController.h
//  Template
//
//  Created by Chance on 16/6/22.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UIViewControllerMethod <NSObject>

@optional
- (void)initUI;

@end

@protocol UIViewControllerPopProtocol <NSObject>
@optional

/**
 *  默认返回协议 如需自定义返回事件可实现此方法
 */
- (void)backAction:(id)sender;

@end

@interface UIViewController () <UIViewControllerPopProtocol, UIViewControllerMethod>
@end


@interface BaseNavigationController : UINavigationController
@property (nonatomic, assign) UIInterfaceOrientationMask interfaceOrientations;

+ (instancetype)navWithRootViewController:(UIViewController *)rootViewController;

@end


@interface UIBarButtonItem (BackBarButtonItem)

+ (UIBarButtonItem *)backBarButtonItemWithTarget:(nullable id)target action:(nullable SEL)action;
+ (UIBarButtonItem *)backBarButtonItemWithTitle:(nullable NSString *)title Target:(nullable id)target action:(nullable SEL)action;

@end

NS_ASSUME_NONNULL_END
