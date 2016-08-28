//
//  SingletonTemplate.h
//  CTools
//
//  Created by Chance on 15/7/2.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

/**
 *  使用方法
 *
 *  1，导入 SingletonTemplate.h
 *  2，在.h里调用 singleton_for_header(类名)
 *  3，在.m里调用 singleton_for_class(类名)
 */

#ifndef CTools_SingletonTemplate_h
#define CTools_SingletonTemplate_h


// .h 调用
#define singleton_for_header(className) \
\
+ (className *)shared##className;


// .m 调用
#define singleton_for_class(className) \
\
+ (className *)shared##className { \
    static className *shared##className = nil; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        shared##className = [[self alloc] init]; \
    }); \
    return shared##className; \
}

#endif
