//
//  UIGestureRecognizer+Handle.h
//  CTools
//
//  Created by Chance on 16/5/13.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (Handle)

#pragma mark - Delegate to Block
- (void)gestureShouldBeginHandle:(BOOL (^)(UIGestureRecognizer *gesture))handle;
- (void)gestureShouldRecognizeSimultaneouslyHandle:(BOOL (^)(UIGestureRecognizer *gesture, UIGestureRecognizer *otherGesture))handle;
- (void)gestureShouldRequireFailureHandle:(BOOL (^)(UIGestureRecognizer *gesture, UIGestureRecognizer *otherGesture))handle;
- (void)gestureShouldBeRequiredToFailHandle:(BOOL (^)(UIGestureRecognizer *gesture, UIGestureRecognizer *otherGesture))handle;
- (void)gestureShouldReceiveTouchHandle:(BOOL (^)(UIGestureRecognizer *gesture, UITouch *touch))handle;
- (void)gestureShouldReceivePressHandle:(BOOL (^)(UIGestureRecognizer *gesture, UIPress *press))handle;

@end
