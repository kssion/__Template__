//
//  MainViewController.m
//  Template
//
//  Created by Chance on 16/4/8.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBar setTintColor:color_hex(0x1eafd8)];
    
    HomeViewController *vc = [HomeViewController new];
    vc.title = @"首页";
    UINavigationController *msgNav = [BaseNavigationController navWithRootViewController:vc];
    msgNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:image_name(@"home") tag:0];
    
//    
//    IMChatViewController *friendsController = [IMChatViewController new];
//    friendsController.title = @"聊天";
//    UINavigationController *friendsNav = [IMNavigation navWithRootViewController:friendsController];
//    friendsNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"聊天" image:[UIImage imageNamed:@"tabbar_friends"] tag:0];
    
//    SettingsViewController *settingsController = [SettingsViewController new];
//    settingsController.title = @"设置";
//    UINavigationController *settingsNav = [IMNavigation navWithRootViewController:settingsController];
//    settingsNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置" image:[UIImage imageNamed:@"tabbar_settings"] tag:0];
    
    
//    MeViewController *meController = [MeViewController new];
//    meController.title = @"我";
//    UINavigationController *meNav = [IMNavigation navWithRootViewController:meController];
//    meController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:[UIImage imageNamed:@"tabbar_me"] tag:0];
    
    self.viewControllers = @[msgNav];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
