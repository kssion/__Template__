//
//  UITextField+Extension.h
//  CTools
//
//  Created by Chance on 15/7/2.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Extension)
@property (nonatomic, assign) CGFloat fontSize; /**< 字体大小 */
@property (nonatomic, strong) UIColor *placeholderColor; /**< 占位符文字颜色 */
@property (nonatomic, assign) CGFloat fontAutoSize; /**< 设置字体自动大小 4.0 +0, 4.7 +1, 5.5 +2 */

@end
