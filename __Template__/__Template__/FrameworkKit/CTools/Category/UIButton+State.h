//
//  UIButton+State.h
//  CTools
//
//  Created by Chance on 16/3/19.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, UIButtonStatus) {
    UIButtonStatusCommon       = 0,
    UIButtonStatusUnusual
};

@interface UIButton (State)
@property (nonatomic, assign, getter=isUnusual) BOOL unusual; // default NO.

- (void)setImage:(UIImage *)image forStatus:(UIButtonStatus)status;
@end
