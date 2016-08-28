//
//  NSString+Log.m
//  CTools
//
//  Created by Chance on 15/10/11.
//  Copyright © 2015年 Chance. All rights reserved.
//

#import "NSString+Log.h"

@implementation NSArray (Log)

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    NSMutableString *desc = [NSMutableString string];
    
    NSMutableString *tabString = [[NSMutableString alloc] initWithCapacity:level];
    for (NSUInteger i = 0; i < level; ++i) {
        [tabString appendString:@"    "];
    }
    
    NSString *tab = @"";
    if (level > 0) {
        tab = tabString;
        [desc appendString:@"    "];
    }
    [desc appendString:@"(\n"];
    
    for (id obj in self) {
        if ([obj isKindOfClass:[NSString class]]) {
            [desc appendFormat:@"%@    \"%@\",\n", tab, obj];
        } else if ([obj isKindOfClass:[NSDictionary class]]
                   || [obj isKindOfClass:[NSArray class]]
                   || [obj isKindOfClass:[NSSet class]]) {
            NSString *str = [((NSDictionary *)obj) descriptionWithLocale:locale indent:level + 1];
            [desc appendFormat:@"%@    %@,\n", tab, str];
        } else {
            [desc appendFormat:@"%@    %@,\n", tab, obj];
        }
    }
    
    if ([desc hasSuffix:@",\n"]) {
        [desc deleteCharactersInRange:NSMakeRange(desc.length - 2, 1)];
    }
    
    [desc appendFormat:@"%@)", tab];
    return desc;
}

@end

@implementation NSDictionary (Log)

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    NSMutableString *desc = [NSMutableString string];
    
    NSMutableString *tabString = [[NSMutableString alloc] initWithCapacity:level];
    for (NSUInteger i = 0; i < level; ++i) {
        [tabString appendString:@"    "];
    }
    
    NSString *tab = @"";
    if (level > 0) {
        tab = tabString;
        [desc appendString:@"    "];
    }
    [desc appendString:@"{\n"];
    
    for (id key in self.allKeys) {
        id obj = [self objectForKey:key];
        
        if ([obj isKindOfClass:[NSString class]]) {
            [desc appendFormat:@"%@    %@ = \"%@\";\n", tab, key, obj];
        } else if ([obj isKindOfClass:[NSArray class]]
                   || [obj isKindOfClass:[NSDictionary class]]
                   || [obj isKindOfClass:[NSSet class]]) {
            [desc appendFormat:@"%@    %@ = %@;\n", tab, key, [obj descriptionWithLocale:locale indent:level + 1]];
        } else {
            [desc appendFormat:@"%@    %@ = %@;\n", tab, key, obj];
        }
    }
    
    if ([desc hasSuffix:@",\n"]) {
        [desc deleteCharactersInRange:NSMakeRange(desc.length - 2, 1)];
    }
    
    [desc appendFormat:@"%@}", tab];
    return desc;
}

@end

@implementation NSSet (Log)

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    NSMutableString *desc = [NSMutableString string];
    
    NSMutableString *tabString = [[NSMutableString alloc] initWithCapacity:level];
    for (NSUInteger i = 0; i < level; ++i) {
        [tabString appendString:@"    "];
    }
    
    NSString *tab = @"";
    if (level > 0) {
        tab = tabString;
        [desc appendString:@"    "];
    }
    [desc appendString:@"{(\n"];
    
    for (id obj in self) {
        if ([obj isKindOfClass:[NSDictionary class]]
            || [obj isKindOfClass:[NSArray class]]
            || [obj isKindOfClass:[NSSet class]]) {
            NSString *str = [((NSDictionary *)obj) descriptionWithLocale:locale indent:level + 1];
            [desc appendFormat:@"%@    %@;\n", tab, str];
        } else if ([obj isKindOfClass:[NSString class]]) {
            [desc appendFormat:@"%@    \"%@\";\n", tab, obj];
        } else {
            [desc appendFormat:@"%@    %@;\n", tab, obj];
        }
    }
    
    if ([desc hasSuffix:@",\n"]) {
        [desc deleteCharactersInRange:NSMakeRange(desc.length - 2, 1)];
    }
    
    [desc appendFormat:@"%@)}", tab];
    return desc;
}

@end