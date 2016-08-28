//
//  XPScrollView.m
//  CTools
//
//  Created by Chance on 16/2/18.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "XPScrollView.h"

@implementation XPScrollView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.superview) {
        [self.superview endEditing:YES];
    } else {
        [self endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
}

@end
