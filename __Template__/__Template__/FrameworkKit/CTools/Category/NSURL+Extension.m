//
//  NSURL+Extension.m
//  CTools
//
//  Created by Chance on 16/3/21.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "NSURL+Extension.h"

@implementation NSURL (Extension)

- (NSDictionary *)queryParams {
    if (self.query && ![self.query isEqualToString:@""]) {
        
        NSMutableDictionary *queryParams = [NSMutableDictionary dictionary];
        
        NSString *query = [self.query stringByRemovingPercentEncoding];
        NSArray *params = [query componentsSeparatedByString:@"&"];
        
        for (NSString *str in params) {
            if ([str isEqualToString:@""] || [str isEqualToString:@"="]) {
                continue;
            }
            
            NSArray *compons = [str componentsSeparatedByString:@"="];
            if (compons.count > 1) {
                [queryParams setObject:compons[1] forKey:[compons firstObject]];
            } else {
                [queryParams setObject:@"" forKey:[compons firstObject]];
            }
        }
        return queryParams;
    }
    return nil;
}

@end
