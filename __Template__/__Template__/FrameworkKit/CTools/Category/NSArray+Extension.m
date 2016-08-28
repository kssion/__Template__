//
//  NSArray+Extension.m
//  CTools
//
//  Created by Chance on 16/3/10.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "NSArray+Extension.h"

static inline NSString *stringForArray(NSArray *array) {
    
    NSMutableString *ms = [NSMutableString stringWithString:@"["];
    
    for (id obj in array) {
        if ([obj isKindOfClass:[NSString class]]) {
            [ms appendString:@"\""];
            [ms appendString:obj];
            [ms appendString:@"\","];
        } else if ([obj isKindOfClass:[NSArray class]]) {
            [ms appendString:[obj JSONString]];
            [ms appendString:@","];
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            [ms appendString:[obj JSONString]];
            [ms appendString:@","];
        } else if ([obj isKindOfClass:[NSNumber class]]) {
            [ms appendFormat:@"%@,", obj];
        } else if ([obj isKindOfClass:[NSNull class]]) {
            [ms appendFormat:@"\"<null>\","];
        } else {
            NSCAssert(0, @"Invalid (non-string/number) key in JSON dictionary");
        }
    }
    
    [ms deleteCharactersInRange:NSMakeRange(ms.length - 1, 1)];
    [ms appendString:@"]"];
    return [ms copy];
}

@implementation NSArray (Extension)

- (NSUInteger)lastIndex {
    return [self count] - 1;
}

- (NSString *)JSONString {
    return stringForArray(self);
}

- (NSInteger)integerAtIndex:(NSUInteger)index {
    if (index > self.count - 1) {
        return 0;
    }
    
    id obj = [self objectAtIndex:index];
    if (obj && ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]])) {
        return [obj integerValue];
    }
    return 0;
}

- (NSString *)stringAtIndex:(NSUInteger)index {
    if (index > self.count - 1) {
        return @"";
    }
    
    NSString *str = [self objectAtIndex:index];
    
    if (str) {
        if ([str isKindOfClass:[NSString class]]) {
            return str;
        }
        if ([str isKindOfClass:[NSNumber class]]) {
            return [NSString stringWithFormat:@"%@", str];
        }
    }
    return @"";
}

- (NSArray *)arrayAtIndex:(NSUInteger)index {
    if (index > self.count - 1) {
        return @[];
    }
    
    id obj = [self objectAtIndex:index];
    if (obj && [obj isKindOfClass:[NSArray class]]) {
        return obj;
    }
    
    return @[];
}

- (NSDictionary *)dictionaryAtIndex:(NSUInteger)index {
    if (index > self.count - 1) {
        return @{};
    }
    
    id obj = [self objectAtIndex:index];
    if (obj && [obj isKindOfClass:[NSDictionary class]]) {
        return obj;
    }
    return @{};
}

- (NSArray *)sortInsertionHanndle:(BOOL (^)(id obj0, id obj1))handle {
    NSMutableArray *array = [self mutableCopy];
    
    for (int i = 0; i < array.count; i++) {
        for (int j = i+1; j < array.count; j++) {
            
            id o0 = [array objectAtIndex:i];
            id o1 = [array objectAtIndex:j];
            
            if (handle(o0, o1)) {
                [array replaceObjectAtIndex:i withObject:o1];
                [array replaceObjectAtIndex:j withObject:o0];
            }
        }
    }
    return [array copy];
}

- (NSArray *)sortQuickHanndle:(BOOL (^)(id obj0, id obj1))handle {
    NSMutableArray *unsorted = [self mutableCopy];
    
    for (int i = 1; i < unsorted.count; i++) {
        
        if (handle(unsorted[i - 1], unsorted[i])) {
            id tmp = unsorted[i];
            int j = i;
            while (j > 0 && handle(unsorted[j - 1], tmp)) {
                unsorted[j] = unsorted[j - 1];
                j--;
            }
            unsorted[j] = tmp;
        }
    }
    return [unsorted copy];
}

- (NSArray *)sortHeapHanndle:(BOOL (^)(id obj0, id obj1))handle {
    return HeapSort(self, handle);
}

NSArray *HeapSort(NSArray *array, BOOL (^handle)(id obj0, id obj1)) {
    NSMutableArray *mutableArray = [array mutableCopy];
    NSInteger i;
    
    for(i = array.count * 0.5 - 1; i >= 0; --i)
        HeapAdjust(mutableArray, i, mutableArray.count, handle);
    
    for(i = array.count - 1; i > 0; --i)
    {
        id tmp = mutableArray[0];
        mutableArray[0] = mutableArray[i];
        mutableArray[i] = tmp;
        
        HeapAdjust(mutableArray, 0, i, handle);
    }
    return [mutableArray copy];
}
static inline void HeapAdjust(NSMutableArray *array, NSInteger i, NSInteger nLength, BOOL (^handle)(id obj0, id obj1)) {
    NSInteger nChild;
    id nTemp;
    for(; 2 * i + 1 < nLength; i = nChild)
    {
        nChild = 2 * i + 1;
        
        if(nChild < nLength - 1 && handle(array[nChild + 1], array[nChild]))
            ++nChild;
        
        if(handle(array[nChild], array[i]))
        {
            nTemp = array[i];
            array[i] = array[nChild];
            array[nChild] = nTemp;
        } else break;
    }
}

- (NSArray *)removeObjectFromIndex:(NSUInteger)index {
    NSMutableArray *array = [self mutableCopy];
    [array removeObjectsInRange:NSMakeRange(index, self.count - index)];
    return [array copy];
}

- (NSArray *)removeObjectToIndex:(NSUInteger)index {
    NSMutableArray *array = [self mutableCopy];
    [array removeObjectsInRange:NSMakeRange(0, index)];
    return [array copy];
}

- (NSArray *)removeObjectFromIndex:(NSUInteger)index length:(NSUInteger)length {
    NSMutableArray *array = [self mutableCopy];
    [array removeObjectsInRange:NSMakeRange(index, length)];
    return [array copy];
}

- (NSArray *)removeObjectFromIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex {
    NSMutableArray *array = [self mutableCopy];
    [array removeObjectsInRange:NSMakeRange(index, toIndex - index)];
    return [array copy];
}


@end

@implementation NSMutableArray (Extension)

- (void)removeObjectFromIndex:(NSUInteger)index {
    [self removeObjectsInRange:NSMakeRange(index, self.count - index)];
}

- (void)removeObjectToIndex:(NSUInteger)index {
    [self removeObjectsInRange:NSMakeRange(0, index)];
}

- (void)removeObjectFromIndex:(NSUInteger)index length:(NSUInteger)length {
    [self removeObjectsInRange:NSMakeRange(index, length)];
}

- (void)removeObjectFromIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex {
    [self removeObjectsInRange:NSMakeRange(index, toIndex - index)];
}

@end
