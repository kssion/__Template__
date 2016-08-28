//
//  UILabelNib.h
//  CTools
//
//  Created by Chance on 15/11/30.
//  Copyright © 2015年 Chance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabelNib : UILabel
@property (nonatomic) UIEdgeInsets edge;

- (instancetype)initWithFrame:(CGRect)frame edge:(UIEdgeInsets)edge;
- (instancetype)initWithEdge:(UIEdgeInsets)edge;

@end
