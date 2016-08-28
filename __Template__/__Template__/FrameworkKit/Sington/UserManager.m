//
//  UserManager.m
//  Template
//
//  Created by Chance on 16/5/29.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "UserManager.h"
#import <objc/message.h>


static NSString *kUserPersistentSuiteName = @"User.Manager"; /**< 持久化存储容器名称 */

@interface UserManager () {
    NSUserDefaults *_userManager;
    NSArray *_resetSkipKeys;
}

@end

@implementation UserManager

+ (void)initialize {
    kUserPersistentSuiteName = [NSString stringWithFormat:@"UM.%@", NSStringFromClass([self class])];
}

+ (instancetype)manager {
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
        
        // 设置重置时不清空的属性名
        _resetSkipKeys = @[@"username"];
        
        [self initData];
        
        NSArray *names = [self getNameList];
        for (NSString *name in names) {
            [self addObserver:self forKeyPath:name options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    return self;
}

- (void)dealloc {
    NSArray *names = [self getNameList];
    for (NSString *name in names) {
        [self removeObserver:self forKeyPath:name context:nil];
    }
}

/**
 *  持久化存储容器
 */
- (NSUserDefaults *)userManager {
    if (!_userManager) {
        _userManager = [[NSUserDefaults alloc] initWithSuiteName:kUserPersistentSuiteName];
    }
    return _userManager;
}

/**
 *  获取属性名列表
 */
- (NSArray *)getNameList {
    NSMutableArray *names = [NSMutableArray array];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; ++i) {
        objc_property_t p = propertyList[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(p)];
        [names addObject:name];
    }
    free(propertyList);
    return names;
}

/**
 *  初始化数据
 */
- (void)initData {
    NSDictionary *config = [[self userManager] persistentDomainForName:kUserPersistentSuiteName];
    
    if (config) {
        NSArray *keys = [self getNameList];
        for (NSString *k in keys) {
            id v = config[k];
            if (v) {
                [self setValue:v forKey:k];
            }
        }
    }
}

/**
 *  重置数据
 */
- (void)resetData {
    NSDictionary *config = [[self userManager] persistentDomainForName:kUserPersistentSuiteName];
    if (config) {
        for (NSString *key in config.allKeys) {
            if ([_resetSkipKeys containsObject:key]) continue;
            [self.userManager removeObjectForKey:key];
        }
        [self initData];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    id newValue = change[@"new"];
    [self.userManager setObject:newValue forKey:keyPath];
}



#pragma mark -

+ (NSString *)deviceId {
    NSString *deviceId = [Keychain objectForKey:@"deviceId"];
    if (!deviceId || [@"" isEqualToString:deviceId]) {
        
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef str = CFUUIDCreateString(NULL, uuidRef);
        
        deviceId = [NSString stringWithFormat:@"%@", str];
        
        CFRelease(uuidRef);
        CFRelease(str);
        
        [Keychain setObject:deviceId forKey:@"deviceId"];
    }
    return deviceId;
}

@end
