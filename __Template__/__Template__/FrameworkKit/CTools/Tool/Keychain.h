//
//  Keychain.h
//  CTools
//
//  Created by Chance on 16/4/18.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kKeychainIdentifier @"kKeychainIdentifier"

@interface Keychain : NSObject

+ (Keychain *)sharedKeychain;

/**
 *  存储
 *
 *  @param object object
 *  @param key    key
 */
+ (void)setObject:(id)object forKey:(NSString *)key;

/**
 *  获取存储对象
 *
 *  @param key key
 *
 *  @return value
 */
+ (id)objectForKey:(NSString *)key;

/**
 *  重置keychain
 */
+ (void)resetKeychain;

@end
