//
//  AppManager.m
//  CTools
//
//  Created by Chance on 16/4/8.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "AppManager.h"

@interface AppManager()

@end

@implementation AppManager

+ (instancetype)sharedAppManager {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mainWindow = [[[UIApplication sharedApplication] delegate] window];
    }
    return self;
}

#pragma mark -
- (void)setRootViewController:(UIViewController *)rootViewController {
    [self.mainWindow setRootViewController:rootViewController];
}


#pragma mark -
+ (void)setRootViewController:(UIViewController *)rootViewController {
    [[self sharedAppManager] setRootViewController:rootViewController];
}

+ (void)goLogin {
    // 自己实现
}

+ (void)goHome {
    // 自己实现
}



@end
