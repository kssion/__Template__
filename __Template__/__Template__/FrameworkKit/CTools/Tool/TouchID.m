//
//  TouchID.m
//  CTools
//
//  Created by 董駸 on 15/6/15.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import "TouchID.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation TouchID

+ (TouchID *)usedTouchID {
    static TouchID *usedTouchID = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        usedTouchID = [[self alloc] init];
    });
    return usedTouchID;
}

- (void)showTouchIdOnComplet:(void (^)(BOOL success, NSError *authenticationError))complet failed:(void (^)(NSError *authenticationError))failed {
    LAContext *context = [[LAContext alloc] init];
    NSError *error;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请使用 Touch ID 解锁。" reply:^(BOOL success, NSError *authenticationError)
        {
            //放到主线程运行防止出现延迟
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!success) {
                    //失败
                    if (failed) {
                        failed(authenticationError);
                    }
                }
                if (complet) {
                    //成功
                    complet(success, authenticationError);
                }
            });

        }];
    }
}

@end
