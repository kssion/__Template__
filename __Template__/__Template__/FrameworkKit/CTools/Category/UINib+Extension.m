//
//  UINib+Extension.m
//  CTools
//
//  Created by Chance on 16/1/21.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "UINib+Extension.h"

@implementation UINib (Extension)

+ (UINib *)nibWithNibName:(NSString *)name {
    return [self nibWithNibName:name bundle:[NSBundle mainBundle]];
}

+ (UINib *)nibWithData:(NSData *)data {
    return [self nibWithData:data bundle:[NSBundle mainBundle]];
}

@end
