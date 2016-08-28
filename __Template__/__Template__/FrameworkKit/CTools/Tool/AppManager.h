//
//  AppManager.h
//  CTools
//
//  Created by Chance on 16/4/8.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppManager : NSObject
@property (nonatomic, weak) UIWindow *mainWindow;

+ (AppManager *)sharedAppManager;

/// 设置根视图
+ (void)setRootViewController:(UIViewController *)rootViewController;

/// 去登录
+ (void)goLogin;

/// 去主页
+ (void)goHome;
@end
