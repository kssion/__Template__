//
//  UserManager.h
//  Template
//
//  Created by Chance on 16/5/29.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import <Foundation/Foundation.h>



/**
 *  UserManager是一个用户自动持久化存储property(以下简称`属性`)的单例类 所有属性都是自动存储到本地 当类被实例化的时候 所有属性会被加载
 *  支持的属性包含 NSString, NSData, NSNumber, NSDate, NSArray, and NSDictionary.
 */
@interface UserManager : NSObject
@property (nonatomic, copy) NSString *unid;         /**< 用户id */
@property (nonatomic, copy) NSString *deviceId;     /**< 设备id */



#pragma mark -

@property (nonatomic, assign) BOOL isFirstOpen;     /**< 是否第一次打开app */



#pragma mark - 账户密码记录

@property (nonatomic, assign) BOOL isLogin;     /**< 是否已经登录 */
@property (nonatomic, copy) NSString *username; /**< 保存的用户名 */



#pragma mark -

/**
 *  属性管理
 */
+ (UserManager *)manager;

/**
 *  设备唯一id (设备重置后会改变)
 */
+ (NSString *)deviceId;

/**
 *  重置数据
 */
- (void)resetData;

@end
