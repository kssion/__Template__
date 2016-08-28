//
//  UIAlertController+Extenstion.h
//  CTools
//
//  Created by Chance on 16/5/6.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Extenstion)
@property (nonatomic, strong, readonly) NSMutableArray<UIAlertAction *> *actionArray; /**< 所有UIAlertAction */



#pragma mark - ActionSheet样式

/**
 *  创建ActionSheet样式 (标题, 信息)
 *
 *  @param title   标题
 *  @param message 信息
 *
 *  @return 返回UIAlertController对象
 */
+ (UIAlertController *)actionSheetWithTitle:(NSString *)title message:(NSString *)message;

/**
 *  创建ActionSheet样式 (信息, 取消按钮标题)
 *
 *  @param message           信息
 *  @param cancelButtonTitle 取消按钮标题
 *
 *  @return 返回UIAlertController对象
 */
+ (UIAlertController *)actionSheetWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;

/**
 *  创建ActionSheet样式 (标题, 信息, 取消按钮标题)
 *
 *  @param title             标题
 *  @param message           信息
 *  @param cancelButtonTitle 取消按钮标题
 *
 *  @return 返回UIAlertController对象
 */
+ (UIAlertController *)actionSheetWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;

/**
 *  创建ActionSheet样式 (信息, 取消按钮标题, 其它默认标题组)
 *
 *  @param message           信息
 *  @param cancelButtonTitle 取消按钮标题
 *  @param otherButtonTitles 其它默认标题组
 *
 *  @return 返回UIAlertController对象
 */
+ (UIAlertController *)actionSheetWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;

/**
 *  创建ActionSheet样式 (标题, 信息, 取消按钮标题, 其它默认标题组)
 *
 *  @param title             标题
 *  @param message           信息
 *  @param cancelButtonTitle 取消按钮标题
 *  @param otherButtonTitles 其它默认标题组
 *
 *  @return 返回UIAlertController对象
 */
+ (UIAlertController *)actionSheetWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;



#pragma mark - Alert样式

/**
 *  创建Alert样式 (标题, 信息)
 *
 *  @param title   标题
 *  @param message 信息
 *
 *  @return 返回UIAlertController对象
 */
+ (UIAlertController *)alertWithTitle:(NSString *)title message:(NSString *)message;

/**
 *  创建Alert样式 (标题, 取消按钮标题)
 *
 *  @param title             标题
 *  @param cancelButtonTitle 取消按钮标题
 *
 *  @return 返回UIAlertController对象
 */
+ (UIAlertController *)alertWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;

/**
 *  创建Alert样式 (标题, 信息, 取消按钮标题)
 *
 *  @param title             标题
 *  @param message           信息
 *  @param cancelButtonTitle 取消按钮标题
 *
 *  @return 返回UIAlertController对象
 */
+ (UIAlertController *)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;

/**
 *  创建Alert样式 (标题, 取消按钮标题, 其它默认标题组)
 *
 *  @param title             标题
 *  @param cancelButtonTitle 取消按钮标题
 *  @param otherButtonTitles 其它默认标题组
 *
 *  @return 返回UIAlertController对象
 */
+ (UIAlertController *)alertWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;

/**
 *  创建Alert样式 (标题, 信息, 取消按钮标题, 其它默认标题组)
 *
 *  @param title             标题
 *  @param message           信息
 *  @param cancelButtonTitle 取消按钮标题
 *  @param otherButtonTitles 其它默认标题组
 *
 *  @return 返回UIAlertController对象
 */
+ (UIAlertController *)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;



#pragma mark -

/**
 *  添加 Default 按钮标题
 */
- (void)addDefaultTitle:(NSString *)title;

/**
 *  添加 Destructive 按钮标题
 */
- (void)addDestructiveTitle:(NSString *)title;

/**
 *  设置 Cancel 按钮标题
 */
- (void)addCancelTitle:(NSString *)title;

/**
 *  添加 Default 按钮标题
 *
 *  @param title   标题
 *  @param handler 单个按钮事件Block
 */
- (void)addDefaultTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler;

/**
 *  添加 Destructive 按钮标题
 *
 *  @param title   标题
 *  @param handler 单个按钮事件Block
 */
- (void)addDestructiveTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler;

/**
 *  设置 Cancel 按钮标题
 *
 *  @param title   标题
 *  @param handler 单个按钮事件Block
 */
- (void)addCancelTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler;



#pragma mark -

/**
 *  显示
 */
- (void)show;

/**
 *  显示
 *
 *  @param handler 按钮事件Block
 */
- (void)showWithHandler:(void(^)(UIAlertController *alertController, NSInteger index))handler;

@end
