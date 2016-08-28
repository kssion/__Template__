//
//  UIGestureRecognizer+Handle.m
//  CTools
//
//  Created by Chance on 16/5/13.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "UIGestureRecognizer+Handle.h"
#import <objc/runtime.h>

@class UIGestureRecognizerHandle;

@interface UIGestureRecognizer () <UIGestureRecognizerDelegate>
@property (nonatomic, copy) BOOL (^handle1)(UIGestureRecognizer *);
@property (nonatomic, copy) BOOL (^handle2)(UIGestureRecognizer *, UIGestureRecognizer *);
@property (nonatomic, copy) BOOL (^handle3)(UIGestureRecognizer *, UIGestureRecognizer *);
@property (nonatomic, copy) BOOL (^handle4)(UIGestureRecognizer *, UIGestureRecognizer *);
@property (nonatomic, copy) BOOL (^handle5)(UIGestureRecognizer *, UITouch *);
@property (nonatomic, copy) BOOL (^handle6)(UIGestureRecognizer *, UIPress *);

@end

@implementation UIGestureRecognizer (Handle)

#pragma mark - getter setter
- (BOOL (^)(UIGestureRecognizer *))handle1 {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setHandle1:(BOOL (^)(UIGestureRecognizer *))handle1 {
    objc_setAssociatedObject(self, @selector(handle1), handle1, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL (^)(UIGestureRecognizer *, UIGestureRecognizer *))handle2 {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setHandle2:(BOOL (^)(UIGestureRecognizer *, UIGestureRecognizer *))handle2 {
    objc_setAssociatedObject(self, @selector(handle2), handle2, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL (^)(UIGestureRecognizer *, UIGestureRecognizer *))handle3 {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setHandle3:(BOOL (^)(UIGestureRecognizer *, UIGestureRecognizer *))handle3 {
    objc_setAssociatedObject(self, @selector(handle3), handle3, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL (^)(UIGestureRecognizer *, UIGestureRecognizer *))handle4 {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setHandle4:(BOOL (^)(UIGestureRecognizer *, UIGestureRecognizer *))handle4 {
    objc_setAssociatedObject(self, @selector(handle4), handle4, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL (^)(UIGestureRecognizer *, UITouch *))handle5 {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setHandle5:(BOOL (^)(UIGestureRecognizer *, UITouch *))handle5 {
    objc_setAssociatedObject(self, @selector(handle5), handle5, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL (^)(UIGestureRecognizer *, UIPress *))handle6 {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setHandle6:(BOOL (^)(UIGestureRecognizer *, UIPress *))handle6 {
    objc_setAssociatedObject(self, @selector(handle6), handle6, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - Functions

- (void)gestureExchangeImplementations:(SEL)sel to:(SEL)toSel
{
    Class cla = [self class];
    Method m = class_getInstanceMethod([self class], toSel);
    IMP imp = method_getImplementation(m);
    const char *tp = method_getTypeEncoding(m);
    
    class_addMethod(cla, sel, imp, tp);
    
    self.delegate = self;
}

- (void)gestureShouldBeginHandle:(BOOL (^)(UIGestureRecognizer *gesture))handle {
    self.handle1 = handle;
    
    [self gestureExchangeImplementations:@selector(gestureRecognizerShouldBegin:)
                                      to:@selector(gestureRecognizerShouldBeginHandle:)];
}

- (void)gestureShouldRecognizeSimultaneouslyHandle:(BOOL (^)(UIGestureRecognizer *gesture, UIGestureRecognizer *otherGesture))handle {
    self.handle2 = handle;
    
    [self gestureExchangeImplementations:@selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)
                                      to:@selector(gestureRecognizerHandle:shouldRecognizeSimultaneouslyWithGestureRecognizer:)];
}

- (void)gestureShouldRequireFailureHandle:(BOOL (^)(UIGestureRecognizer *gesture, UIGestureRecognizer *otherGesture))handle {
    self.handle3 = handle;
    
    [self gestureExchangeImplementations:@selector(gestureRecognizer:shouldRequireFailureOfGestureRecognizer:)
                                      to:@selector(gestureRecognizerHandle:shouldRequireFailureOfGestureRecognizer:)];
}

- (void)gestureShouldBeRequiredToFailHandle:(BOOL (^)(UIGestureRecognizer *gesture, UIGestureRecognizer *otherGesture))handle {
    self.handle4 = handle;
    
    [self gestureExchangeImplementations:@selector(gestureRecognizer:shouldBeRequiredToFailByGestureRecognizer:)
                                      to:@selector(gestureRecognizerHandle:shouldBeRequiredToFailByGestureRecognizer:)];
}

- (void)gestureShouldReceiveTouchHandle:(BOOL (^)(UIGestureRecognizer *gesture, UITouch *touch))handle {
    self.handle5 = handle;
    
    [self gestureExchangeImplementations:@selector(gestureRecognizer:shouldReceiveTouch:)
                                      to:@selector(gestureRecognizerHandle:shouldReceiveTouch:)];
}

- (void)gestureShouldReceivePressHandle:(BOOL (^)(UIGestureRecognizer *gesture, UIPress *press))handle {
    self.handle6 = handle;
    
    [self gestureExchangeImplementations:@selector(gestureRecognizer:shouldReceivePress:)
                                      to:@selector(gestureRecognizerHandle:shouldReceivePress:)];
}



#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBeginHandle:(UIGestureRecognizer *)gestureRecognizer {
    if (self.handle1) {
        return self.handle1(gestureRecognizer);
    }
    return YES;
}

- (BOOL)gestureRecognizerHandle:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.handle2) {
        return self.handle2(gestureRecognizer, otherGestureRecognizer);
    }
    return YES;
}

- (BOOL)gestureRecognizerHandle:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.handle3) {
        return self.handle3(gestureRecognizer, otherGestureRecognizer);
    }
    return YES;
}

- (BOOL)gestureRecognizerHandle:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.handle4) {
        return self.handle4(gestureRecognizer, otherGestureRecognizer);
    }
    return YES;
}

- (BOOL)gestureRecognizerHandle:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.handle5) {
        return self.handle5(gestureRecognizer, touch);
    }
    return YES;
}

- (BOOL)gestureRecognizerHandle:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press {
    if (self.handle6) {
        return self.handle6(gestureRecognizer, press);
    }
    return YES;
}

@end
