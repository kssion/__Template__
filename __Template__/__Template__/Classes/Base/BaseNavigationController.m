//
//  BaseNavigationController.m
//  Template
//
//  Created by Chance on 16/6/22.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController () <UINavigationControllerDelegate, UINavigationBarDelegate>

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationBar *navBar = self.navigationBar;
    
    // 样式 系统只有白色和黑色两种
    [navBar setBarStyle:UIBarStyleBlack];
    // 内容颜色
    [navBar setTintColor:[UIColor whiteColor]];
    
    // 返回按钮图片
    [navBar setBackIndicatorImage:nav_back];
    [navBar setBackIndicatorTransitionMaskImage:nav_back];
    
    self.delegate = self;
    
//    // 半透明
//    [navBar setTranslucent:YES];
//    // 背景颜色
//    [navBar setBarTintColor:[UIColor whiteColor]];
//    // 自定义标题样式
//    [navBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],
//                                     NSForegroundColorAttributeName:color_hex(0x333333)}];
//    // 背景图片
//    [navBar setBackgroundImage:image_color([UINavigationBar appearance].barTintColor) forBarMetrics:UIBarMetricsDefault];
    
    _interfaceOrientations = UIInterfaceOrientationMaskPortrait;
}

static UIImage *nav_back;
+ (void)initialize {
    if (nav_back == nil) {
        nav_back = [UIImage imageNamed:@"BackIndicatorImage"];
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return _interfaceOrientations;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
+ (instancetype)navWithRootViewController:(UIViewController *)rootViewController {
    return [[self alloc] initWithRootViewController:rootViewController];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 滑动返回设置
    navigationController.interactivePopGestureRecognizer.enabled = viewController.interactivePopEnable;
    
    // 若自定义返回 则添加leftBarButtonItem
    if([viewController respondsToSelector:@selector(backAction:)]) {
        if (self.viewControllers.count > 1) {
            viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backBarButtonItemWithTitle:nil Target:viewController action:@selector(backAction:)];
        }
    }
}

#pragma mark - UINavigationBarDelegate

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item {
    [item setValue:@"" forKey:@"_backButtonTitle"];
    return YES;
}

@end

#pragma mark -
@implementation UIBarButtonItem (BackBarButtonItem)

+ (UIBarButtonItem *)backBarButtonItemWithTarget:(nullable id)target action:(nullable SEL)action {
    return [self backBarButtonItemWithTitle:nil Target:target action:action];
}

+ (UIBarButtonItem *)backBarButtonItemWithTitle:(nullable NSString *)title Target:(nullable id)target action:(nullable SEL)action {
    UIBarButtonItem *backItem;
    if (title && ![title isEqualToString:@""]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setFrame:CGRectMake(0, 0, 80, 40)];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        [btn setImage:nav_back forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
        
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -4, 0, 0)];
        
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    } else {
        backItem = [[UIBarButtonItem alloc] initWithImage:nav_back style:UIBarButtonItemStylePlain target:target action:action];
        [backItem setImageInsets:UIEdgeInsetsMake(2, -8, 0, 0)];
    }
    return backItem;
}

@end
