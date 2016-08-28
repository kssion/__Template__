//
//  UINavigationController+Extention.h
//  CTools
//
//  Created by Chance on 15/9/9.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Extention)

@property (nonatomic, assign) CGFloat barAlpha; /**< 导航透明度*/
- (void)setBarAlpha:(CGFloat)barAlpha animated:(BOOL)animated;

@property (nonatomic, assign) CGFloat barHeight;   /**< 导航高度*/
- (void)setBarHeight:(CGFloat)barHeight animated:(BOOL)animated;



#pragma mark -

- (void)removeViewController:(UIViewController *)viewController;
- (void)removeViewControllerAtIndex:(NSUInteger)index;
- (void)removeViewControllersInRange:(NSRange)range;
- (void)removeViewControllerFromIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex;
- (void)removeViewControllerFromIndex:(NSUInteger)index length:(NSUInteger)length;



#pragma mark -

- (void)pushViewController:(UIViewController *)viewController;
- (UIViewController *)popViewController;

@end
