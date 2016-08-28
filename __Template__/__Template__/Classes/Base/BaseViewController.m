//
//  BaseViewController.m
//  Template
//
//  Created by Chance on 16/4/8.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "BaseViewController.h"
#import <objc/runtime.h>

@interface BaseViewController ()

@end

@implementation BaseViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _barHidden = NO;
        _barAlpha = 1.0;
        _barHeight = 44.0;
    }
    return self;
}

// 状态栏白色样式 子类样式改变重写即可
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setBarAlpha:_barAlpha animated:animated];
    [self.navigationController setBarHeight:_barHeight animated:animated];
    [self.navigationController setBarHidden:_barHidden animated:animated];
        
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.view.backgroundColor) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    self.view.clipsToBounds = YES;
}

//- (BOOL)shouldAutorotate
//{
//    // 开启自动旋转，通过supportedInterfaceOrientations来指定旋转的方向
//    return YES;
//}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
- (NSUInteger)supportedInterfaceOrientations {
    // 指定旋转的方向
    return UIInterfaceOrientationMaskPortrait;
}
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    // 指定旋转的方向
    return UIInterfaceOrientationMaskPortrait;
}
#endif

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark -
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)dealloc {
    // 测试是否循环引用
    NSLog(@"%@ dealloc", self.class);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

@implementation UIViewController (XPBaseViewController)

- (BOOL)interactivePopEnable {
    id enable = objc_getAssociatedObject(self, _cmd);
    if (enable == nil) {
        return YES;
    }
    return [enable boolValue];
}
- (void)setInteractivePopEnable:(BOOL)interactivePopEnable {
    objc_setAssociatedObject(self, @selector(interactivePopEnable), @(interactivePopEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UINavigationController (XPBaseViewController)

- (UIView *)navigationBarBackgroundView {
    return [self.navigationBar valueForKey:@"_backgroundView"];
}

- (BOOL)barHidden {
    return self.navigationBarHidden;
}
- (void)setBarHidden:(BOOL)barHidden {
    [self setBarHidden:barHidden animated:NO];
}
- (void)setBarHidden:(BOOL)barHidden animated:(BOOL)animated {
    [self setNavigationBarHidden:barHidden animated:animated];
}

- (CGFloat)barAlpha {
    return self.navigationBarBackgroundView.alpha;
}
- (void)setBarAlpha:(CGFloat)barAlpha {
    [self setBarAlpha:barAlpha animated:NO];
}
- (void)setBarAlpha:(CGFloat)barAlpha animated:(BOOL)animated {
    [UIView animateWithDuration:animated?UINavigationControllerHideShowBarDuration:0 animations:^{
        self.navigationBarBackgroundView.alpha = barAlpha;
    }];
}

- (CGFloat)barHeight {
    return self.navigationBar.frame.size.height;
}
- (void)setBarHeight:(CGFloat)barHeight {
    CGRect frame = self.navigationBar.frame;
    frame.size.height = barHeight;
    self.navigationBar.frame = frame;
}
- (void)setBarHeight:(CGFloat)barHeight animated:(BOOL)animated {
    CGRect frame = self.navigationBar.frame;
    frame.size.height = barHeight;
    
    [UIView animateWithDuration:animated?UINavigationControllerHideShowBarDuration:0 animations:^{
        self.navigationBar.frame = frame;
    }];
}

@end
