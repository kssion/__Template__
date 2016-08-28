//
//  UIView+Extension.h
//  CTools
//
//  Created by Chance. on 15/4/30.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

/**
 *  视图的中心点横坐标
 */
@property (nonatomic) CGFloat x;

/**
 *  视图的中心点纵坐标
 */
@property (nonatomic) CGFloat y;

/**
 *  视图的顶边位置
 */
@property (nonatomic) CGFloat top;

/**
 *  视图的底边位置
 */
@property (nonatomic) CGFloat bottom;

/**
 *  视图的底边相对于父视图的底边距离
 */
@property (nonatomic, readonly) CGFloat bottomEdge;

/**
 *  视图的左边位置
 */
@property (nonatomic) CGFloat left;

/**
 *  视图的右边位置
 */
@property (nonatomic) CGFloat right;

/**
 *  视图的右边相对于父视图的右边距离
 */
@property (nonatomic, readonly) CGFloat rightEdge;

/**
 *  视图的宽度
 */
@property (nonatomic) CGFloat width;

/**
 *  视图的高度
 */
@property (nonatomic) CGFloat height;

/**
 *  视图的大小
 */
@property (nonatomic, getter=getSize) CGSize size;

/**
 *  设置视图的边框宽度和颜色
 */
- (void)setBorderWidth:(CGFloat)width color:(UIColor *)color;

/**
 *  设置视图的圆角
 */
- (void)setBorderRadius:(CGFloat)radius;

#pragma mark - other event -

/**
 *  设置背景颜色为随机颜色
 */
- (void)colorDebug;

/**
 *  移除所有子视图
 */
- (void)removeAllSubviews;

/**
 *  当前视图是否是另一个视图的子视图
 */
- (BOOL)isInView:(UIView *)view;

/**
 *  当前视图上是否存在一个子视图
 */
- (BOOL)containsSubview:(UIView *)view;

/**
 *  当前视图所在的视图控制器
 */
- (UIViewController *)viewController;

/**
 *  当前视图所在的window (废弃16.5.8)
 */
- (UIWindow *)viewWindow;

/**
 *  返回当前View的截图
 */
- (UIImage *)viewScreenshot;

#pragma mark - 弹出 -
/**
 *  模仿模态弹出view(全屏)
 */
- (void)presentView:(UIView *)view;

/**
 *  模仿模态消失view(全屏)
 */
- (void)dismissView;

#pragma mark -
/**
 *  从屏幕底部弹出
 */
- (void)present;

/**
 *  从屏幕底部弹出 (动画块)
 *
 *  @param animations 动画块
 */
- (void)presentAnimations:(void (^)(void))animations;

/**
 *  从屏幕底部弹出 (动画块, 完成Block)
 *
 *  @param animations 动画块
 *  @param completion 完成Block
 */
- (void)presentAnimations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

/**
 *  从屏幕底部消失
 */
- (void)dismiss;

/**
 *  从屏幕底部弹出 (动画块)
 *
 *  @param animations 动画块
 */
- (void)dismissAnimations:(void (^)(void))animations;

/**
 *  从屏幕底部弹出 (动画块, 完成Block)
 *
 *  @param animations 动画块
 *  @param completion 完成Block
 */
- (void)dismissAnimations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

#pragma mark -
- (void)ejectFromTopPoint:(CGPoint)p;
- (void)ejectFromLeftPoint:(CGPoint)p;
- (void)ejectFromBottomPoint:(CGPoint)p;
- (void)ejectFromRightPoint:(CGPoint)p;

- (void)ejectFromTopPoint:(CGPoint)p animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;
- (void)ejectFromLeftPoint:(CGPoint)p animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;
- (void)ejectFromBottomPoint:(CGPoint)p animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;
- (void)ejectFromRightPoint:(CGPoint)p animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

- (void)ejectDismiss;

@end
