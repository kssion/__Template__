//
//  XPPromptTag.h
//  CTools
//
//  Created by Chance on 16/4/10.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XPPromptTag : NSObject

/**
 *  标签文字提示
 *
 *  @param text 字符串
 */
+ (void)showWithText:(NSString *)text;

/**
 *  标签文字提示
 *
 *  @param format 格式字符串
 */
+ (void)showWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

@end
