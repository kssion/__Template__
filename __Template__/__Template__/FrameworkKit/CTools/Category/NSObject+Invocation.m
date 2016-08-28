//
//  NSObject+Invocation.m
//  CTools
//
//  Created by Chance on 16/4/25.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "NSObject+Invocation.h"

@implementation NSObject (Invocation)

- (nullable id)invokeSelector:(nonnull SEL)selector, ... {
    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:selector];
    
    NSInvocation *invacation = [NSInvocation invocationWithMethodSignature:sig];
    [invacation setTarget:self];
    [invacation setSelector:selector];
    
    if (selector) {
        va_list args;
        va_start(args, selector);
        id arg;
        for (int i = 0; (arg = va_arg(args, id)); i++) {
            [invacation setArgument:&arg atIndex:2 + i];
        }
        va_end(args);
    }
    
    [invacation invoke];
    
    id result = nil;
    [invacation getReturnValue:&result];
    return result;
}


@end
