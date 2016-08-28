//
//  NSDictionary+Extension.m
//  CTools
//
//  Created by Chance on 15/10/12.
//  Copyright © 2015年 Chance. All rights reserved.
//

#import "NSDictionary+Extension.h"

static inline NSString *stringForDictionary(NSDictionary *dict) {
    
    NSMutableString *ms = [NSMutableString stringWithString:@"{"];
    
    for (NSString *key in dict.allKeys) {
        id obj = dict[key];
        
        if ([obj isKindOfClass:[NSString class]]) {
            [ms appendString:@"\""];
            [ms appendString:key];
            [ms appendString:@"\":\""];
            [ms appendString:obj];
            [ms appendString:@"\","];
        } else if ([obj isKindOfClass:[NSArray class]]) {
            [ms appendString:@"\""];
            [ms appendString:key];
            [ms appendString:@"\":"];
            [ms appendString:[obj JSONString]];
            [ms appendString:@","];
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            [ms appendString:@"\""];
            [ms appendString:key];
            [ms appendString:@"\":"];
            [ms appendString:[obj JSONString]];
            [ms appendString:@","];
        } else if ([obj isKindOfClass:[NSNumber class]]) {
            [ms appendString:@"\""];
            [ms appendString:key];
            [ms appendFormat:@"\":%@,", obj];
        } else if ([obj isKindOfClass:[NSNull class]]) {
            [ms appendString:@"\""];
            [ms appendString:key];
            [ms appendString:@"\":\"<null>\""];
        } else {
            NSCAssert(0, @"Invalid (non-string/number) key in JSON dictionary");
        }
    }
    
    [ms deleteCharactersInRange:NSMakeRange(ms.length - 1, 1)];
    [ms appendString:@"}"];
    return [ms copy];
}

@implementation NSDictionary (Extension)

- (NSString *)JSONString {
    return stringForDictionary(self);
}

- (NSString *)toQueryString {
    __block NSMutableString *ms = [NSMutableString string];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]) {
            [ms appendFormat:@"%@=%@&", key, obj];
        } else {
            [ms appendFormat:@"%@=&", key];
        }
    }];
    if ([ms hasSuffix:@"&"]) {
        [ms deleteCharactersInRange:NSMakeRange(ms.length - 1, 1)];
    }
    return [ms copy];
}

- (id)objForKey:(id)key {
    id obj = [self objectForKey:key];
    return (!obj || [obj isEqual:[NSNull null]]) ? nil : obj;
}

- (NSInteger)integerForKey:(id)key {
    id obj = [self objectForKey:key];
    if (obj && ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]])) {
        return [obj integerValue];
    }
    return 0;
}

- (NSString *)stringForKey:(id)key {
    id obj = [self objectForKey:key];
    
    if (obj) {
        if ([obj isKindOfClass:[NSString class]]) {
            return obj;
        }
        if ([obj isKindOfClass:[NSNumber class]]) {
            return [NSString stringWithFormat:@"%@", obj];
        }
    }
    return @"";
}

- (NSArray *)arrayForKey:(id)key {
    id obj = [self objectForKey:key];
    if (obj && [obj isKindOfClass:[NSArray class]]) {
        return obj;
    }
    return @[];
}

- (NSDictionary *)dictionaryForKey:(id)key {
    id obj = [self objectForKey:key];
    if (obj && [obj isKindOfClass:[NSDictionary class]]) {
        return obj;
    }
    return @{};
}


@end
