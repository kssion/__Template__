//
//  APPSBaseManager.m
//  CTools
//
//  Created by Chance on 16/6/2.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "APPSBaseManager.h"
#import <objc/message.h>

static NSString *kUserPersistentSuiteName = @"Automatic.Property.Persistent.Storage"; /**< 持久化存储容器名称 */

@interface APPSBaseManager () {
    NSUserDefaults *_userManager;
}

@end

@implementation APPSBaseManager

+ (void)initialize {
    kUserPersistentSuiteName = [NSString stringWithFormat:@"APPS.%@", NSStringFromClass([self class])];
}

+ (instancetype)sharedManager {
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
    return names;
}

/**
 *  初始化数据
 */
- (void)initData {
    NSDictionary *config = [[self userManager] persistentDomainForName:kUserPersistentSuiteName];
    for (NSString *k in config.allKeys) {
        NSString *v = config[k];
        [self setValue:v forKey:k];
    }
}

/**
 *  重置数据
 */
- (void)resetData {
    [[NSUserDefaults standardUserDefaults] removeSuiteNamed:kUserPersistentSuiteName];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    id newValue = change[@"new"];
    [self.userManager setObject:newValue forKey:keyPath];
}

@end
