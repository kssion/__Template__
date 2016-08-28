//
//  UINib+Extension.h
//  CTools
//
//  Created by Chance on 16/1/21.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINib (Extension)

/**
 *  加载MainBundle内的Nib文件
 */
+ (UINib *)nibWithNibName:(NSString *)name;

/**
 *  加载MainBundle的Data文件
 */
+ (UINib *)nibWithData:(NSData *)data;

@end
