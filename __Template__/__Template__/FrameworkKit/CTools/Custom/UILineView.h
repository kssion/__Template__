//
//  UILineView.h
//  CTools
//
//  Created by Chance on 16/2/18.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILineView : UIView
@property (nonatomic, assign) IBInspectable CGFloat lineWidth;
@property (nonatomic, assign) IBInspectable CGFloat lineHeight;
@property (nonatomic, strong) IBInspectable UIColor *lineColor;

@end
