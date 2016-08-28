//
//  Keychain.m
//  CTools
//
//  Created by Chance on 16/4/18.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "Keychain.h"

@interface Keychain ()
@property (nonatomic, retain) NSMutableDictionary *keychainItemData;

@end

@implementation Keychain

+ (Keychain *)sharedKeychain {
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
        _keychainItemData = [self load:kKeychainIdentifier];
    }
    return self;
}

#pragma mark - Keychain
- (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
            service, (__bridge_transfer id)kSecAttrService,
            service, (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,
            nil];
}

- (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
    
}

- (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    return ret;
}

- (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}

- (void)setObject:(id)object forKey:(NSString *)key {
    if (object == nil) return;
    id currentObject = [_keychainItemData objectForKey:key];
    if (![currentObject isEqual:object])
    {
        if (!_keychainItemData) {
            _keychainItemData = [NSMutableDictionary dictionary];
        }
        [_keychainItemData setObject:object forKey:key];
        [self save:kKeychainIdentifier data:_keychainItemData];
    }
}

- (id)objectForKey:(NSString *)key {
    return [_keychainItemData objectForKey:key];
}

- (void)resetKeychain {
    if (!_keychainItemData) {
        _keychainItemData = [NSMutableDictionary dictionary];
    }
    [self delete:kKeychainIdentifier];
}

#pragma mark -
+ (void)setObject:(id)object forKey:(NSString *)key {
    [[self sharedKeychain] setObject:object forKey:key];
}

+ (id)objectForKey:(NSString *)key {
    return [[self sharedKeychain] objectForKey:key];
}

+ (void)resetKeychain {
    [[self sharedKeychain] resetKeychain];
}


@end
