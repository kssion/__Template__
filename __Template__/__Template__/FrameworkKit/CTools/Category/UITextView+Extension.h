//
//  UITextView+Extension.h
//  CTools
//
//  Created by Chance on 16/4/28.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Extension)
@property (nonatomic, assign) CGFloat fontSize; /**< 字体大小 */
@property (nonatomic, assign) CGFloat fontAutoSize; /**< 设置字体自动大小 4.0 +0, 4.7 +1, 5.5 +2 */
@property (nonatomic, copy) NSString *placeholder; /**< 占位符 */
@property (nonatomic, strong) UIColor *placeholderColor; /**< 占位符文字颜色 */

@end
