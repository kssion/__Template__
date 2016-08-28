//
//  UIAlertView+Extension.m
//  CTools
//
//  Created by Chance on 15/7/15.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import "UIAlertView+Extension.h"
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

@implementation UIAlertView (Extension)

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    for (NSString *title in otherButtonTitles) {
        [alert addButtonWithTitle:title];
    }
    return alert;
}

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles block:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))block {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    for (NSString *title in otherButtonTitles) {
        [alert addButtonWithTitle:title];
    }
    alert.clickedButtonBlock = block;
    return alert;
}

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles block:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))block cancelBlock:(void(^)())cancel {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    for (NSString *title in otherButtonTitles) {
        [alert addButtonWithTitle:title];
    }
    alert.clickedButtonBlock = block;
    alert.cancelButtonBlock = cancel;
    return alert;
}

- (void)showView {
    self.delegate = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self show];
    });
}

- (void)showWithBlock:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))ok {
    self.clickedButtonBlock = ok;
    [self showView];
}

- (void)showWithBlock:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))ok cancelBlock:(void(^)())cancel {
    self.clickedButtonBlock = ok;
    self.cancelButtonBlock = cancel;
    [self showView];
}

#pragma mark - GET / SET
#pragma mark clickedButtonBlock
- (void (^)(UIAlertView *, NSInteger))clickedButtonBlock {
    return objc_getAssociatedObject(self, @"chance_clickedButtonBlock");
}

- (void)setClickedButtonBlock:(void (^)(UIAlertView *, NSInteger))clickedButtonBlock {
    [self willChangeValueForKey:@"chance_clickedButtonBlock"];
    objc_setAssociatedObject(self, @"chance_clickedButtonBlock", clickedButtonBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"chance_clickedButtonBlock"];
}

#pragma mark cancelButtonBlock
- (void (^)())cancelButtonBlock {
    return objc_getAssociatedObject(self, @"chance_cancelButtonBlock");
}

- (void)setCancelButtonBlock:(void (^)())cancelButtonBlock {
    [self willChangeValueForKey:@"chance_cancelButtonBlock"];
    objc_setAssociatedObject(self, @"chance_cancelButtonBlock", cancelButtonBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"chance_cancelButtonBlock"];
}

#pragma mark - UIAlertViewDelegate
#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex)
        self.cancelButtonBlock ? self.cancelButtonBlock(self) : nil;
    else
        self.clickedButtonBlock ? self.clickedButtonBlock(self, buttonIndex) : nil;
}

@end
#pragma clang diagnostic pop