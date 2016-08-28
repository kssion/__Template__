//
//  UIViewController+Extension.m
//  CTools
//
//  Created by Chance on 16/1/9.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "UIViewController+Extension.h"
#import <objc/runtime.h>

@implementation UIView (PresentExtension)
- (BOOL)isPresented {
    return [objc_getAssociatedObject(self, "chance_UIView_isPresented") boolValue];
}
- (void)setIsPresented:(BOOL)isPresented {
    objc_setAssociatedObject(self, "chance_UIView_isPresented", @(isPresented), OBJC_ASSOCIATION_ASSIGN);
}

- (UIViewController *)controller {
    UIResponder *responder = self;
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    }
    return nil;
}

@end

@implementation UIViewController (Extension)

- (UIView *)presentedView {
    return objc_getAssociatedObject(self, "chance_UIViewController_presentedView");
}
- (void)setPresentedView:(UIView *)presentedView {
    objc_setAssociatedObject(self, "chance_UIViewController_presentedView", presentedView, OBJC_ASSOCIATION_RETAIN);
}

- (void)presentView:(UIView *)view {
    [self presentView:view completion:nil];
}
- (void)presentView:(UIView *)view completion:(void (^)(BOOL finished))completion {
    if (!self.presentedView || (self.presentedView && !self.presentedView.isPresented)) {
        self.presentedView = view;
        view.isPresented = YES;
        [self.view endEditing:YES];
        
        CGPoint p = view.center;
        p.y = [[UIScreen mainScreen] bounds].size.height * 1.5;
        view.center = p;
        [self.view addSubview:view];
        
        [UIView animateWithDuration:1 delay:0 options:7<<16 animations:^{
            CGPoint p = view.center;
            p.y = [[UIScreen mainScreen] bounds].size.height * 0.5;
            view.center = p;
            
        } completion:^(BOOL finished) {
            if (completion) {
                completion(YES);
            }
        }];
    }
}

- (void)dismissView {
    [self dismissViewCompletion:nil];
}
- (void)dismissViewCompletion:(void (^)(BOOL finished))completion {
    __block UIView *view = nil;
    
    if (self.presentedView) {
        view = self.presentedView;
    } else if (self.view.isPresented) {
        view = self.view;
    }
    
    view.isPresented = NO;
    [view endEditing:YES];
    
    [UIView animateWithDuration:1 delay:0 options:7<<16 animations:^{
        
        CGPoint p = view.center;
        p.y = [[UIScreen mainScreen] bounds].size.height * 1.5;
        view.center = p;
        
    } completion:^(BOOL finished) {
        
        view.superview.controller.presentedView = nil;
        
        if (self.view != view) {
            view = nil;
        }
        
        if (completion) {
            completion(YES);
        }
    }];
}

@end