//
//  NSObject+Invocation.h
//  CTools
//
//  Created by Chance on 16/4/25.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Invocation)

/**
 *  动态调用方法
 *
 *  @param selector 方法
 *  @param ...      参数列表(末尾需要加入nil)
 *
 *  @return 返回值
 */
- (nullable id)invokeSelector:(nonnull SEL)selector, ... NS_REQUIRES_NIL_TERMINATION;

@end
