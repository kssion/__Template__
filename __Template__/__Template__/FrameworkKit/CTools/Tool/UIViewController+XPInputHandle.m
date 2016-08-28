//
//  UIViewController+XPInputHandle.m
//  CTools
//
//  Created by Chance on 15/10/10.
//  Copyright © 2015年 Chance. All rights reserved.
//

#import "UIViewController+XPInputHandle.h"
#import <objc/message.h>

#define pointerKey [NSString stringWithFormat:@"%p", self]

#pragma mark -
@implementation UIViewController (XPInputHandle)

+ (void)load {
    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
    Method method2 = class_getInstanceMethod([self class], @selector(xp_dealloc));
    method_exchangeImplementations(method1, method2);
}

- (void)xp_dealloc {
    [XPInputHandle removeForKey:pointerKey];
    [self xp_dealloc];
}

- (void)addInputView:(UIView *)inputView superView:(UIView *)superView {
    [XPInputHandle registerForKey:pointerKey];
    [XPInputHandle addInputView:inputView superView:superView forKey:pointerKey];
}

- (void)setReturnKeyType {
    [XPInputHandle setReturnKeyTypeForKey:pointerKey];
}

@end
