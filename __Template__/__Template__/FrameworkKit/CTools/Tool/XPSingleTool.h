//
//  XPSingleTool.h
//  CTools
//
//  Created by Chance on 15/10/12.
//  Copyright © 2015年 Chance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  单例工具
 */
@interface XPSingleTool : NSObject

+ (instancetype)sharedSingleTool;

#pragma mark - 引导页管理
/**
 *  打开引导页
 *
 *  @param viewController 引导页视图控制器类
 */
- (void)openGuideViewController:(Class)viewControllerClass;

/**
 *  关闭引导页
 */
- (void)closeGuideView;

/**
 *  设置引导页关闭时显示的ViewController 设置Window的根视图
 */
- (void)setClosedViewController:(UIViewController *)vc;

/**
 *  设置引导页关闭时显示的ViewController 设置Window的根视图
 */
- (void)setClosedViewController:(UIViewController *)vc completion:(void (^)())completion;

@end

@interface XPSingleTool (CF)

#pragma mark - 引导页管理
/**
 *  打开引导页
 *
 *  @param viewController 引导页视图控制器类
 */
+ (void)openGuideViewController:(Class)viewControllerClass;

/**
 *  关闭引导页
 */
+ (void)closeGuideView;

/**
 *  设置引导页关闭时显示的ViewController 设置Window的根视图
 */
+ (void)setClosedViewController:(UIViewController *)vc;

/**
 *  设置引导页关闭时显示的ViewController 设置Window的根视图
 */
+ (void)setClosedViewController:(UIViewController *)vc completion:(void (^)())completion;

@end
