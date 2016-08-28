//
//  UILabel+Extension.h
//  CTools
//
//  Created by Chance on 15/7/11.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)
@property (nonatomic, assign) BOOL deleteLine; /**< 显示删除线 */
@property (nonatomic, assign) CGFloat fontSize; /**< 字体大小 */
@property (nonatomic, assign) CGFloat fontAutoSize; /**< 设置字体自动大小 4.0 +0, 4.7 +1, 5.5 +2 */

- (CGSize)sizeToFitWithSize:(CGSize)size; /**< 适应大小后返回size */

@end
