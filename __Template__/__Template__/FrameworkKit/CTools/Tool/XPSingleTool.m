//
//  XPSingleTool.m
//  CTools
//
//  Created by Chance on 15/10/12.
//  Copyright © 2015年 Chance. All rights reserved.
//

#import "XPSingleTool.h"

@interface XPSingleTool ()
@property (nonatomic, weak) UIWindow *mainWindow;       /**< 入口 window */
@property (nonatomic, strong) UIWindow *guideWindow;    /**< 引导页 window */
@property (nonatomic, copy) void (^closeBlock)();       /**< 关闭引导页时调用的 block */

@end

@implementation XPSingleTool

+ (instancetype)sharedSingleTool {
    static XPSingleTool *sharedSingleTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingleTool = [[self alloc] init];
        [[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];
        sharedSingleTool.mainWindow = [[[UIApplication sharedApplication] delegate] window];
    });
    return sharedSingleTool;
}

#pragma mark -
- (void)openGuideViewController:(Class)viewControllerClass {
    NSAssert(viewControllerClass, [NSString stringWithFormat:@"Method:-openGuideViewController:, info:请使用你的引导页视图控制器类."]);
    
    UIViewController *rootvc = [viewControllerClass new];
    
    NSAssert([rootvc isKindOfClass:[UIViewController class]], @"viewControllerClass is not UIViewController class");
    
    self.guideWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.guideWindow setBackgroundColor:[UIColor orangeColor]];
    [self.guideWindow setWindowLevel:UIWindowLevelAlert];
    [self.guideWindow setRootViewController:rootvc];
    [self.guideWindow makeKeyAndVisible];
}

- (void)closeGuideView {
    if (self.closeBlock) {
        self.closeBlock();
        self.closeBlock = nil;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.guideWindow.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self.guideWindow resignKeyWindow];
        [self.guideWindow setRootViewController:nil];
        self.guideWindow = nil;
        [self.mainWindow makeKeyAndVisible];
    }];
}

- (void)setClosedViewController:(UIViewController *)vc {
    self.mainWindow.rootViewController = vc;
}

- (void)setClosedViewController:(UIViewController *)vc completion:(void (^)())completion {
    [self.mainWindow setRootViewController:vc];
    self.closeBlock = completion;
}

@end

#pragma mark -
@implementation XPSingleTool (CF)

+ (void)openGuideViewController:(Class)viewControllerClass {
    [[self sharedSingleTool] openGuideViewController:viewControllerClass];
}

+ (void)closeGuideView {
    [[self sharedSingleTool] closeGuideView];
}

+ (void)setClosedViewController:(UIViewController *)vc {
    [[self sharedSingleTool] setClosedViewController:vc];
}

+ (void)setClosedViewController:(UIViewController *)vc completion:(void (^)())completion {
    [[self sharedSingleTool] setClosedViewController:vc completion:completion];
}

@end
