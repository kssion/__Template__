//
//  UIButton+State.m
//  CTools
//
//  Created by Chance on 16/3/19.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "UIButton+State.h"
#import <objc/runtime.h>

@implementation UIButton (State)

- (void)setCommonImage:(UIImage *)commonImage {
    objc_setAssociatedObject(self, "chance_UIButton_commonImage", commonImage, OBJC_ASSOCIATION_RETAIN);
    if (!self.isUnusual) {
        [self setImage:[self commonImage] forState:UIControlStateNormal];
    }
}
- (UIImage *)commonImage {
    return objc_getAssociatedObject(self, "chance_UIButton_commonImage");
}

- (void)setUnusualImage:(UIImage *)unusualImage {
    objc_setAssociatedObject(self, "chance_UIButton_unusualImage", unusualImage, OBJC_ASSOCIATION_RETAIN);
    if (self.isUnusual) {
        [self setImage:[self unusualImage] forState:UIControlStateNormal];
    }
}
- (UIImage *)unusualImage {
    return objc_getAssociatedObject(self, "chance_UIButton_unusualImage");
}

- (void)setUnusual:(BOOL)unusual {
    if (self.isUnusual != unusual) {
        objc_setAssociatedObject(self, "chance_UIButton_status", @(unusual), OBJC_ASSOCIATION_RETAIN);
        
        if (unusual && [self unusualImage]) {
            [self setImage:[self unusualImage] forState:UIControlStateNormal];
        } else if ([self commonImage]) {
            [self setImage:[self commonImage] forState:UIControlStateNormal];
        }
    }
}

- (BOOL)isUnusual {
    id c = objc_getAssociatedObject(self, "chance_UIButton_status");
    return c ? [c boolValue] : NO;
}

- (void)setImage:(UIImage *)image forStatus:(UIButtonStatus)status {
    switch (status) {
        case UIButtonStatusUnusual:
            [self setUnusualImage:image];
            break;
        default:
            [self setCommonImage:image];
            break;
    }
}

@end
