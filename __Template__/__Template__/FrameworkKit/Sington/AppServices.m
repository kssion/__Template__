//
//  AppServices.m
//  Template
//
//  Created by Chance on 16/4/8.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "AppServices.h"

@interface AppServices()

@end

@implementation AppServices

+ (instancetype)sharedAppServices {
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
    [[self sharedAppServices] setRootViewController:rootViewController];
}

+ (void)goLogin {
    
}

+ (void)goHome {
    
}

+ (void)recordLastTouch:(UITouch *)touch {
    [[self sharedAppServices] setLastTouch:touch];
}


@end
