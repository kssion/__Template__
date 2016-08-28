//
//  UIViewController+Extension.h
//  CTools
//
//  Created by Chance on 16/1/9.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extension)

- (void)presentView:(UIView *)view;
- (void)presentView:(UIView *)view completion:(void (^)(BOOL finished))completion;

- (void)dismissView;
- (void)dismissViewCompletion:(void (^)(BOOL finished))completion;
@end

@interface UIView (PresentExtension)
@property (nonatomic, assign) BOOL isPresented;

@end