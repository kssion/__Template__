//
//  NSSington.m
//  Sundiro
//
//  Created by Chance on 16/7/27.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "NSTool.h"


const NSCalendar *calendar;









@implementation NSTool

+ (void)load
{
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
}

@end
