//
//  UITableViewCell+Extension.m
//  CTools
//
//  Created by Chance on 16/2/17.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "UITableViewCell+Extension.h"
#import <objc/runtime.h>

@implementation UITableViewCell (Extension)

- (NSIndexPath *)indexPath {
    return objc_getAssociatedObject(self, "chance_UITableViewCell_indexPath");
}
- (void)setIndexPath:(NSIndexPath *)indexPath {
    objc_setAssociatedObject(self, "chance_UITableViewCell_indexPath", indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
