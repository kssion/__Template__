//
//  NSNumber+Extension.m
//  CTools
//
//  Created by Chance on 16/1/21.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "NSNumber+Extension.h"

@implementation NSNumber (Extension)

- (NSString *)stringValueWithFormatterStyle:(NSNumberFormatterStyle)style {
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    return [currencyFormatter stringFromNumber:self];
}

@end
