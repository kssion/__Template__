//
//  NSObject+Extension.m
//  CTools
//
//  Created by Chance on 15/7/29.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import "NSObject+Extension.h"
#import <objc/runtime.h>

@implementation NSObject (Extension)
#pragma mark - Property
- (NSString *)identifier {
    return objc_getAssociatedObject(self, @"chance_NSObject_identifier");
}
- (void)setIdentifier:(NSString *)identifier {
    [self willChangeValueForKey:@"chance_NSObject_identifier"];
    objc_setAssociatedObject(self, @"chance_NSObject_identifier", identifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"chance_NSObject_identifier"];
}

- (id)object {
    return objc_getAssociatedObject(self, @"chance_NSObject_object");
}
- (void)setObject:(id)object {
    [self willChangeValueForKey:@"chance_NSObject_object"];
    objc_setAssociatedObject(self, @"chance_NSObject_object", object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"chance_NSObject_object"];
}

- (void(^)(id))callbackBlock {
    return objc_getAssociatedObject(self, @"chance_NSObject_callbackBlock");
}
- (void)setCallbackBlock:(void (^)(id))callbackBlock {
    [self willChangeValueForKey:@"chance_NSObject_callbackBlock"];
    objc_setAssociatedObject(self, @"chance_NSObject_callbackBlock", callbackBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"chance_NSObject_callbackBlock"];
}

#pragma mark - Function
- (NSString *)toString {
    if ([self isKindOfClass:[NSNull class]]) {
        NSLog(@"string is null");
        return @"";
    }
    if ([self isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@", self];
    }
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString *)self;
    }
    NSLog(@"class is %@", NSStringFromClass([self class]));
    return @"";
}

- (NSArray *)getVarList {
    NSMutableArray *array = [NSMutableArray array];
    unsigned int count = 0;
    Ivar *members = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; ++i) {
        Ivar var = members[i];
        const char *name = ivar_getName(var);
        const char *type = ivar_getTypeEncoding(var);
        
        NSDictionary *dict = @{@"name":[NSString stringWithUTF8String:name], @"type":[NSString stringWithUTF8String:type]};
        [array addObject:dict];
    }
    return array;
}

- (id)duplicate {
    if ([self respondsToSelector:@selector(encodeWithCoder:)]) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

#pragma mark -
+ (void)addInstanceMethod:(SEL)method fromObject:(id)obj method:(SEL)aMethod
{
    Method m = class_getInstanceMethod([obj class], aMethod);
    IMP imp = method_getImplementation(m);
    const char *tp = method_getTypeEncoding(m);
    
    class_addMethod(self, method, imp, tp);
}

+ (void)addClassMethod:(SEL)method fromObject:(id)obj method:(SEL)aMethod
{
    Method m = class_getClassMethod([obj class], aMethod);
    IMP imp = method_getImplementation(m);
    const char *tp = method_getTypeEncoding(m);
    
    class_addMethod(self, method, imp, tp);
}


@end
