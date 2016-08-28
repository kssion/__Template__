//
//  UIScrollView+Extension.h
//  CTools
//
//  Created by Chance on 15/7/11.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Extension)

/** 内容区高度 */
@property (nonatomic, assign) CGFloat contentHeight;

/** 内容区宽度 */
@property (nonatomic, assign) CGFloat contentWidth;

/** 边缘顶部距离 */
@property (nonatomic, assign) CGFloat contentTop;

/** 边缘底部距离 */
@property (nonatomic, assign) CGFloat contentBottom;

/** 边缘左边距离 */
@property (nonatomic, assign) CGFloat contentLeft;

/** 边缘右边距离 */
@property (nonatomic, assign) CGFloat contentRight;

/** 横向偏移量 contentOffset.x */
@property (nonatomic, assign) CGFloat contentX;

/** 纵向偏移量 contentOffset.y */
@property (nonatomic, assign) CGFloat contentY;

/**
 *  移动到底部
 */
- (void)scrollToBottom;
- (void)scrollToBottomAnimation:(BOOL)animation;
@end
