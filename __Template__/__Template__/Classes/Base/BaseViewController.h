//
//  BaseViewController.h
//  Template
//
//  Created by Chance on 16/4/8.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *  所有 ViewController 都继承 BaseViewController
 */
@interface BaseViewController : UIViewController

@property (nonatomic, assign) BOOL barHidden;    // default NO
@property (nonatomic, assign) CGFloat barHeight; // default 44.0
@property (nonatomic, assign) CGFloat barAlpha;  // default 1.0

@end

@interface UIViewController (XPBaseViewController)
@property (nonatomic, assign) BOOL interactivePopEnable; /**< 滑动返回手势是否启用 默认YES */
@end

@interface UINavigationController (XPBaseViewController)
@property (nonatomic, assign) BOOL barHidden;    // default NO
- (void)setBarHidden:(BOOL)barHidden animated:(BOOL)animated;

@property (nonatomic, assign) CGFloat barAlpha; /**< 导航透明度*/
- (void)setBarAlpha:(CGFloat)barAlpha animated:(BOOL)animated;

@property (nonatomic, assign) CGFloat barHeight;   /**< 导航高度*/
- (void)setBarHeight:(CGFloat)barHeight animated:(BOOL)animated;

@end
