//
//  NSData+Encryption.h
//  CTools
//
//  Created by Chance on 16/4/6.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Encryption)

/**
 *  AES加密
 *
 *  @param key 密码
 *
 *  @return 返回加密后的数据Data
 */
- (NSData *)AES256EncryptWithKey:(NSString *)key;

/**
 *  AES解密
 *
 *  @param key 密码
 *
 *  @return 返回解密后的数据Data
 */
- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end

#pragma mark - NSString + Encryption
@interface NSString (Encryption)

/**
 *  AES加密
 *
 *  @param key 密码
 *
 *  @return 返回加密后的数据String
 */
- (NSString *)AES256EncryptWithKey:(NSString *)key;

/**
 *  AES解密
 *
 *  @param key 密码
 *
 *  @return 返回解密后的数据String
 */
- (NSString *)AES256DecryptWithKey:(NSString *)key;

@end