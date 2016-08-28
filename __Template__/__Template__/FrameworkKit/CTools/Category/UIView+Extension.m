//
//  UIView+Extension.m
//  CTools
//
//  Created by Chance. on 15/4/30.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import "UIView+Extension.h"
#import <objc/runtime.h>

@implementation UIView (Extension)

- (CGFloat)x {
    return self.center.x;
}
- (void)setX:(CGFloat)x {
    CGPoint center = self.center;
    center.x = x;
    self.center = center;
}

- (CGFloat)y {
    return self.center.y;
}
- (void)setY:(CGFloat)y {
    CGPoint center = self.center;
    center.y = y;
    self.center = center;
}

- (CGFloat)top {
    return self.frame.origin.y;
}
- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.frame.size.height;
    self.frame = frame;
}

- (CGFloat)bottomEdge {
    return self.superview.frame.size.height - self.frame.origin.y - self.frame.size.height;
}

- (CGFloat)left {
    return self.frame.origin.x;
}
- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - self.frame.size.width;
    self.frame = frame;
}

- (CGFloat)rightEdge {
    return self.superview.frame.size.width - self.frame.origin.x - self.frame.size.width;
}

- (CGFloat)width {
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

// 此GET方法与 iOS 9.1 有冲突 获取视图大小请使用 getSize 或 frame.size //15.10.28
//- (CGSize)size
//{
//    return self.bounds.size;
//}
- (CGSize)getSize {
    return self.bounds.size;
}
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

#pragma mark -
- (void)setBorderWidth:(CGFloat)width color:(UIColor *)color {
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}

- (void)setBorderRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
}

- (void)colorDebug {
#if DEBUG
    self.backgroundColor = [UIColor colorWithRed:arc4random() % 100 / 100.0 green:arc4random() % 100 / 100.0 blue:arc4random() % 100 / 100.0 alpha:0.5];
#endif
}

- (void)removeAllSubviews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (BOOL)isInView:(UIView *)view {
    UIView *sv = nil;
    while ((sv = [sv superview])) {
        if ([sv isEqual:view])
            return YES;
    }
    return NO;
}

- (BOOL)containsSubview:(UIView *)view {
    NSArray *subviews = self.subviews;
    
    for (UIView *v in subviews) {
        if ([v isEqual:view]) {
            return YES;
        } else if ([v containsSubview:view]) { 
            return YES;
        }
    }
    return NO;
}

- (UIViewController *)viewController {
    UIResponder *responder = self;
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    }
    return nil;
}

- (UIWindow *)viewWindow {
    UIView *sv = self;
    while ((sv = [sv superview])) {
        if ([sv isKindOfClass: [UIWindow class]])
            return (UIWindow *)sv;
    }
    return nil;
}

- (UIImage *)viewScreenshot {
    CGSize imageSize = [self bounds].size;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[self layer] renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark -
- (void)presentView:(UIView *)view {
    [view.superview bringSubviewToFront:view];
    [UIView animateWithDuration:.25 delay:0 options:7<<16 animations:^{
        view.y = [[UIScreen mainScreen] bounds].size.height * 0.5;
        
    } completion:nil];
}

- (void)dismissView {
    __weak __typeof(self) _self = self;
    [UIView animateWithDuration:.25 delay:0 options:7<<16 animations:^{
        _self.y = [[UIScreen mainScreen] bounds].size.height * 1.5;
        
    } completion:nil];
}

#pragma mark -
- (void)present {
    [self presentAnimations:nil completion:nil];
}

- (void)presentAnimations:(void (^)(void))animations {
    [self presentAnimations:animations completion:nil];
}

- (void)presentAnimations:(void (^)(void))animations completion:(void (^ __nullable)(BOOL finished))completion {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    __block UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__dismiss:)]];
    [window addSubview:view];
    
    self.center = CGPointMake(self.center.x, window.frame.size.height + self.frame.size.height * 0.5);
    [view addSubview:self];
    
    __weak __typeof(self) _self = self;
    [UIView animateWithDuration:.25 delay:0 options:7<<16 animations:^{
        
        _self.center = CGPointMake(_self.center.x, [[UIScreen mainScreen] bounds].size.height - _self.frame.size.height * 0.5);
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        if (animations) {
            animations();
        }
        
    } completion:^(BOOL finished) {
        
        if (completion) {
            completion(finished);
        }
    }];
}

- (void)__dismiss:(UITapGestureRecognizer *)tap {
    if ([tap locationInView:self].y < 0) {
        [self dismiss];
    }
}

- (void)dismiss {
    [self dismissAnimations:nil completion:nil];
}

- (void)dismissAnimations:(void (^)(void))animations {
    [self dismissAnimations:animations completion:nil];
}

- (void)dismissAnimations:(void (^)(void))animations completion:(void (^ __nullable)(BOOL finished))completion {
    __weak __typeof(self) _self = self;
    [UIView animateWithDuration:.25 delay:0 options:7<<16 animations:^{
        
        _self.center = CGPointMake(_self.center.x, [[UIScreen mainScreen] bounds].size.height + _self.frame.size.height * 0.5);
        _self.superview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        
        if (animations) {
            animations();
        }
        
    } completion:^(BOOL finished) {
        [_self.superview removeFromSuperview];
        [_self removeFromSuperview];
        
        if (completion) {
            completion(finished);
        }
    }];
}

#pragma mark -
- (NSInteger)direction {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (void)setDirection:(NSInteger)direction {
    if (self.direction != direction) {
        objc_setAssociatedObject(self, @selector(direction), @(direction), OBJC_ASSOCIATION_RETAIN);
    }
}

- (void)ejectFromTopPoint:(CGPoint)p {
    [self ejectFromTopPoint:p animations:nil completion:nil];
}

- (void)ejectFromLeftPoint:(CGPoint)p {
    [self ejectFromLeftPoint:p animations:nil completion:nil];
}

- (void)ejectFromBottomPoint:(CGPoint)p {
    [self ejectFromBottomPoint:p animations:nil completion:nil];
}

- (void)ejectFromRightPoint:(CGPoint)p {
    [self ejectFromRightPoint:p animations:nil completion:nil];
}

- (void)ejectFromTopPoint:(CGPoint)p animations:(void (^)(void))animations completion:(void (^ __nullable)(BOOL finished))completion {
    [self ejectFromPoint:p direction:1 animations:animations completion:completion];
}

- (void)ejectFromLeftPoint:(CGPoint)p animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
    [self ejectFromPoint:p direction:2 animations:animations completion:completion];
}

- (void)ejectFromBottomPoint:(CGPoint)p animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
    [self ejectFromPoint:p direction:3 animations:animations completion:completion];
}

- (void)ejectFromRightPoint:(CGPoint)p animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
    [self ejectFromPoint:p direction:4 animations:animations completion:completion];
}

- (void)ejectFromPoint:(CGPoint)point direction:(NSInteger)direction animations:(void (^)(void))animations completion:(void (^ __nullable)(BOOL finished))completion {
    self.direction = direction;
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    float kw = window.bounds.size.width;
    float kh = window.bounds.size.height;
    CGSize size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    
    UIView *containerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [window addSubview:containerView];
    
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__ejectDismiss:)]];
    [containerView addSubview:view];
    
    float w = 0;
    float h = 0;
    UIViewAutoresizing autoresizingMask = 0;
    CGPoint center = CGPointMake(size.width * 0.5, size.height * 0.5);
    CGPoint origin = point;
    
    switch (direction) {
        case 1:{
            w = size.width;
            autoresizingMask = 1 << 3;//UIViewAutoresizingFlexibleTopMargin
            center.y = -self.frame.size.height * 0.5;
        } break;
        case 2:{
            h = size.height;
            autoresizingMask = 1 << 0;//UIViewAutoresizingFlexibleLeftMargin
            center.x = -self.frame.size.width * 0.5;
        } break;
        case 3:{
            w = size.width;
            autoresizingMask = 1 << 5;//UIViewAutoresizingFlexibleBottomMargin
            center.y = self.frame.size.height * 0.5;
            origin.y = kh - point.y;
        } break;
        case 4:{
            h = size.height;
            autoresizingMask = 1 << 2;//UIViewAutoresizingFlexibleRightMargin
            center.x = self.frame.size.width * 0.5;
            origin.x = kw - point.x;
        } break;
    }
    
    UIView *elasticView = [[UIView alloc] initWithFrame:(CGRect){origin, {w, h}}];
    elasticView.clipsToBounds = YES;
    [containerView addSubview:elasticView];
    
    self.center = center;
    self.autoresizingMask = autoresizingMask;
    [elasticView addSubview:self];
    
    [UIView animateWithDuration:1 delay:0 options:7<<16 animations:^{
        
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        if (direction == 4) {
            elasticView.frame = (CGRect){{kw - point.x - size.width, point.y}, size};
        } else if (direction == 3) {
            elasticView.frame = (CGRect){{point.x, kh - point.y - size.height}, size};
        } else {
            elasticView.frame = (CGRect){point, size};
        }
        
        if (animations) {
            animations();
        }
        
    } completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
    }];
}

- (void)__ejectDismiss:(UITapGestureRecognizer *)tap {
    [self ejectDismiss];
}

- (void)ejectDismiss {
    __weak __typeof(self) _self = self;
    [UIView animateWithDuration:.25 delay:0 options:7<<16 animations:^{
        
        UIView *tapView = [self.superview.superview.subviews firstObject];
        tapView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        
        UIView *supView = _self.superview;
        switch (_self.direction) {
            case 1:
            {
                CGRect frame = supView.frame;
                frame.size.height = 0;
                supView.frame = frame;
            }
                break;
            case 2:
            {
                CGRect frame = supView.frame;
                frame.size.width = 0;
                supView.frame = frame;
            }
                break;
            case 3:
            {
                CGRect frame = supView.frame;
                frame.origin.y = frame.size.height + frame.origin.y;
                frame.size.height = 0;
                supView.frame = frame;
            }
                break;
            case 4:
            {
                CGRect frame = supView.frame;
                frame.origin.x = frame.size.width + frame.origin.x;
                frame.size.width = 0;
                supView.frame = frame;
            }
                break;
        }
        
    } completion:^(BOOL finished) {
        [_self.superview.superview removeFromSuperview];
        [_self.superview removeFromSuperview];
        [_self removeFromSuperview];
    }];
}


@end
