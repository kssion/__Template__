//
//  AppServices.h
//  Template
//
//  Created by Chance on 16/4/8.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIWindow.h>

@interface AppServices : NSObject
@property (nonatomic, weak) UIWindow *mainWindow;
@property (nonatomic, strong) NSString *deviceId; /**< 设备id 正常情况下不会变 */

@property (nonatomic, strong) UITouch *lastTouch;

+ (AppServices *)sharedAppServices;

/// 设置跟视图
+ (void)setRootViewController:(UIViewController *)rootViewController;

/// 去登录
+ (void)goLogin;

/// 去主页
+ (void)goHome;


+ (void)recordLastTouch:(UITouch *)touch;

@end
