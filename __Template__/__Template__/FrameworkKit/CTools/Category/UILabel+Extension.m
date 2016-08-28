//
//  UILabel+Extension.m
//  CTools
//
//  Created by Chance on 15/7/11.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import "UILabel+Extension.h"
#import <objc/runtime.h>

@implementation UILabel (Extension)

- (CGFloat)fontSize {
    return self.font.pointSize;
}

- (void)setFontSize:(CGFloat)fontSize {
    self.font = [self.font fontWithSize:fontSize];
}

- (CGFloat)fontAutoSize {
    return self.fontSize;
}
- (void)setFontAutoSize:(CGFloat)fontAutoSize
{
    switch ((int)([[UIScreen mainScreen] bounds].size.width)) {
        case 375:
            self.fontSize = fontAutoSize + 1;
            break;
        case 414:
            self.fontSize = fontAutoSize + 2;
            break;
        default:
            self.fontSize = fontAutoSize;
            break;
    }
}

- (BOOL)deleteLine {
    CALayer *layer = objc_getAssociatedObject(self, @"chance_line_layer");
    return layer ? !layer.hidden : NO;
}
- (void)setDeleteLine:(BOOL)deleteLine {
    CALayer *layer = objc_getAssociatedObject(self, @"chance_line_layer");
    if (!layer) {
        layer = [CALayer layer];
        layer.frame = CGRectMake(-1, self.frame.size.height / 2, self.frame.size.width + 2, 0.5);
        layer.contents = (id)__image_color__UILabel_Additions(self.textColor).CGImage;
        layer.hidden = YES;
        layer.opaque = YES;
        [self.layer insertSublayer:layer atIndex:(unsigned)self.layer.sublayers.count - 1];
        objc_setAssociatedObject(self, @"chance_line_layer", layer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:@"frame"];
        [self addObserver:self forKeyPath:@"textColor" options:NSKeyValueObservingOptionNew context:@"textColor"];
    }
    
    layer.hidden = !deleteLine;
    
}

- (CGSize)sizeToFitWithSize:(CGSize)size {
    CGSize fitSize = [self sizeThatFits:size];
    if (self.numberOfLines == 1) {
        CGRect frame = self.frame;
        frame.size.width = fitSize.width;
        self.frame = frame;
        return self.frame.size;
    }
    
    if (fitSize.height > size.height) {
        float h = size.height - ((int)(size.height * 100) % (int)(self.font.pointSize * 100)) * 0.01;
        CGRect frame = self.frame;
        frame.size = CGSizeMake(size.width, h);
        self.frame = frame;
    } else {
        CGRect frame = self.frame;
        frame.size = fitSize;
        self.frame = frame;
    }
    
    return self.frame.size;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CALayer *layer = objc_getAssociatedObject(self, @"chance_line_layer");
    if (context == @"frame") {
        CGSize size = [change[@"new"] CGRectValue].size;
        layer.frame = CGRectMake(-2, size.height / 2, size.width + 4, 1);
    }
    if (context == @"textColor") {
        layer.contents = (id)__image_color__UILabel_Additions(self.textColor).CGImage;
    }
}

- (void)dealloc {
    if (objc_getAssociatedObject(self, @"chance_line_layer")) {
        [self removeObserver:self forKeyPath:@"frame"];
        [self removeObserver:self forKeyPath:@"textColor"];
    }
}

UIImage *__image_color__UILabel_Additions(UIColor *color) {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
