//
//  XPLoadViewController.m
//  Template
//
//  Created by Chance on 15/10/12.
//  Copyright © 2015年 Chance. All rights reserved.
//

#import "XPLoadViewController.h"
#import "MainViewController.h"

@interface XPLoadViewController ()

@end

@implementation XPLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 是否第一次启动
    if ([UserManager manager].isFirstOpen) {
        
//        UIViewController *nav = [BaseNavigationController navWithRootViewController:[IMLoginViewController new]];
//        
//        // 打开引导页
//        [[XPSingleTool sharedSingleTool] openGuideViewController:NSClassFromString(@"XPGuideViewController")];
//        // 关闭时设置根视图
//        [[XPSingleTool sharedSingleTool] setClosedViewController:nav completion:^{
//            
//            [NSUserDefaults setBool:YES forKey:@"DID_SHOW_GUIDEVIEW"];
//            [NSUserDefaults synchronize];
//            
//        }];
        
    } else {
        
//        UIViewController *vc = nil;
//        if ([LoginInfo isLogin]) {
//            vc = [MainViewController new]; //[NSClassFromString(@"ViewController") new];
//        } else {
//            vc = [IMNavigation navWithRootViewController:[IMLoginViewController new]];
//        }
        
//        vc = new_from(@"ViewController");
//        
//        [[[[UIApplication sharedApplication] delegate] window] setRootViewController:vc];
//        [[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];
    }
    
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:[MainViewController new]];
    [[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    self.view = nil;
    NSLog(@"XPLoadViewController dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
