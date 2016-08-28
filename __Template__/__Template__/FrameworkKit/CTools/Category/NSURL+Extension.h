//
//  NSURL+Extension.h
//  CTools
//
//  Created by Chance on 16/3/21.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Extension)
@property (nonatomic, strong, readonly) NSDictionary *queryParams; /**< 获取URL的参数列表 */

@end
