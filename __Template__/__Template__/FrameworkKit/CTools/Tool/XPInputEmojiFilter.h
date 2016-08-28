//
//  XPTextInputManager.h
//  Caches
//
//  Created by Chance on 16/4/28.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XPPromptTag.h"

/**
 *  Emoji表情输入过滤
 */
@interface XPInputEmojiFilter : NSObject

+ (XPInputEmojiFilter *)sharedManager;

/**
 *  开启控制
 */
+ (void)open;

/**
 *  关闭控制
 */
+ (void)close;

@end
