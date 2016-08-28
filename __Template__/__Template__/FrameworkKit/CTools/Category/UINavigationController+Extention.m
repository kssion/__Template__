//
//  UINavigationController+Extention.m
//  CTools
//
//  Created by Chance on 15/9/9.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import "UINavigationController+Extention.h"

@implementation UINavigationController (Extention)

- (UIView *)navigationBarBackgroundView
{
    return [self.navigationBar valueForKey:@"_backgroundView"];
}

- (CGFloat)barAlpha
{
    return self.navigationBarBackgroundView.alpha;
}
- (void)setBarAlpha:(CGFloat)barAlpha
{
    [self setBarAlpha:barAlpha animated:NO];
}
- (void)setBarAlpha:(CGFloat)barAlpha animated:(BOOL)animated
{
    [UIView animateWithDuration:animated?UINavigationControllerHideShowBarDuration:0 animations:^{
        if (self.navigationBarBackgroundView.alpha != barAlpha) {
            self.navigationBarBackgroundView.alpha = barAlpha;
        }
    }];
}

- (CGFloat)barHeight
{
    return self.navigationBar.frame.size.height;
}
- (void)setBarHeight:(CGFloat)barHeight
{
    [self setBarHeight:barHeight animated:NO];
}
- (void)setBarHeight:(CGFloat)barHeight animated:(BOOL)animated
{
    CGRect frame = self.navigationBar.frame;
    
    if (frame.size.height != barHeight) {
        frame.size.height = barHeight;
    }
    
    [UIView animateWithDuration:animated?UINavigationControllerHideShowBarDuration:0 animations:^{
        self.navigationBar.frame = frame;
    }];
}


#pragma mark -
- (void)removeViewController:(UIViewController *)viewController
{
    NSMutableArray *vcs = [self.viewControllers mutableCopy];
    [vcs removeObject:viewController];
    [self setViewControllers:vcs];
}
- (void)removeViewControllerAtIndex:(NSUInteger)index
{
    NSMutableArray *vcs = [self.viewControllers mutableCopy];
    [vcs removeObjectAtIndex:index];
    [self setViewControllers:vcs];
}
- (void)removeViewControllersInRange:(NSRange)range
{
    NSMutableArray *vcs = [self.viewControllers mutableCopy];
    [vcs removeObjectsInRange:range];
    [self setViewControllers:vcs];
}
- (void)removeViewControllerFromIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex
{
    NSMutableArray *vcs = [self.viewControllers mutableCopy];
    [vcs removeObjectsInRange:NSMakeRange(index, toIndex - index)];
    [self setViewControllers:vcs];
}
- (void)removeViewControllerFromIndex:(NSUInteger)index length:(NSUInteger)length
{
    NSMutableArray *vcs = [self.viewControllers mutableCopy];
    [vcs removeObjectsInRange:NSMakeRange(index, length)];
    [self setViewControllers:vcs];
}


#pragma mark -
- (void)pushViewController:(UIViewController *)viewController
{
    [self pushViewController:viewController animated:YES];
}

- (UIViewController *)popViewController
{
    return [self popViewControllerAnimated:YES];
}

@end
