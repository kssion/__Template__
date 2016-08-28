//
//  UIButton+Extension.h
//  CTools
//
//  Created by Chance on 15/7/14.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)
@property (nonatomic, assign) CGFloat fontSize; /**< 字体大小 */

- (void)setBackground:(UIImage *)normalImage :(UIImage *)highlightImage;
- (void)setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType;

@end
