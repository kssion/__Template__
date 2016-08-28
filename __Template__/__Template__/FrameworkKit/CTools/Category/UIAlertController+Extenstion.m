//
//  UIAlertController+Extenstion.m
//  CTools
//
//  Created by Chance on 16/5/6.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "UIAlertController+Extenstion.h"
#import <objc/runtime.h>

@implementation UIAlertController (Extenstion)

- (void (^)(UIAlertController *, NSInteger))handlerBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHandlerBlock:(void (^)(UIAlertController *, NSInteger))handlerBlock {
    objc_setAssociatedObject(self, @selector(handlerBlock), handlerBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSMutableArray *)actionArray {
    NSMutableArray *array = objc_getAssociatedObject(self, _cmd);
    if (!array) {
        array = [NSMutableArray array];
        objc_setAssociatedObject(self, _cmd, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return array;
}



#pragma mark -

+ (instancetype)alertControllerWithStyle:(UIAlertControllerStyle)style title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles
 {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    // 添加取消按钮
    if (cancelButtonTitle) {
        [ac addCancelTitle:cancelButtonTitle];
    }
    
    // 添加默认按钮
    for (NSString *title in otherButtonTitles) {
        [ac addDefaultTitle:title];
    }
    
    return ac;
}

+ (UIAlertController *)actionSheetWithTitle:(NSString *)title message:(NSString *)message {
    return [self alertControllerWithStyle:UIAlertControllerStyleActionSheet title:title message:message cancelButtonTitle:nil otherButtonTitles:nil];
}

+ (UIAlertController *)actionSheetWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle {
    return [self alertControllerWithStyle:UIAlertControllerStyleActionSheet title:nil message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
}

+ (UIAlertController *)actionSheetWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle {
    return [self alertControllerWithStyle:UIAlertControllerStyleActionSheet title:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
}

+ (UIAlertController *)actionSheetWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles {
    return [self alertControllerWithStyle:UIAlertControllerStyleActionSheet title:nil message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
}

+ (UIAlertController *)actionSheetWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles {
    return [self alertControllerWithStyle:UIAlertControllerStyleActionSheet title:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
}



#pragma mark -

+ (UIAlertController *)alertWithTitle:(NSString *)title message:(NSString *)message {
    return [self alertControllerWithStyle:UIAlertControllerStyleAlert title:title message:message cancelButtonTitle:nil otherButtonTitles:nil];
}

+ (UIAlertController *)alertWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle {
    return [self alertControllerWithStyle:UIAlertControllerStyleAlert title:nil message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
}

+ (UIAlertController *)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle {
    return [self alertControllerWithStyle:UIAlertControllerStyleAlert title:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
}

+ (UIAlertController *)alertWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles {
    return [self alertControllerWithStyle:UIAlertControllerStyleAlert title:nil message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
}

+ (UIAlertController *)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles {
    return [self alertControllerWithStyle:UIAlertControllerStyleAlert title:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
}



#pragma mark -

- (void)addTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(UIAlertAction *action))handler {
    UIAlertAction *ac = [UIAlertAction actionWithTitle:title style:style handler:handler];
    if (style != UIAlertActionStyleCancel) {
        [self.actionArray addObject:ac];
    }
    [self addAction:ac];
}

- (void)addDefaultTitle:(NSString *)title {
    __weak __typeof(self) _self = self;
    [self addTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (_self.handlerBlock) {
            _self.handlerBlock(_self, [_self.actionArray indexOfObject:action]);
        }
    }];
}

- (void)addDestructiveTitle:(NSString *)title {
    __weak __typeof(self) _self = self;
    [self addTitle:title style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        if (_self.handlerBlock) {
            _self.handlerBlock(_self, [_self.actionArray indexOfObject:action]);
        }
    }];
}

- (void)addCancelTitle:(NSString *)title {
    __weak __typeof(self) _self = self;
    [self addTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        if (_self.handlerBlock) {
            _self.handlerBlock(_self, -1);
        }
    }];
}

- (void)addDefaultTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler {
    [self addTitle:title style:UIAlertActionStyleCancel handler:handler];
}

- (void)addDestructiveTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler {
    [self addTitle:title style:UIAlertActionStyleDestructive handler:handler];
}

- (void)addCancelTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler {
    [self addTitle:title style:UIAlertActionStyleCancel handler:handler];
}



#pragma mark -

- (void)show {
    UIViewController *rootvc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootvc presentViewController:self animated:YES completion:nil];
}

- (void)showWithHandler:(void(^)(UIAlertController *alertController, NSInteger index))handler {
    [self setHandlerBlock:handler];
    [self show];
}

@end
