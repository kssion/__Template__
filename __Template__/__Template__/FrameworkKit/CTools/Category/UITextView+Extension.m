//
//  UITextView+Extension.m
//  CTools
//
//  Created by Chance on 16/4/28.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "UITextView+Extension.h"
#import <objc/runtime.h>

@interface UITextView ()
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, assign) BOOL isAddObserver;

@end

@implementation UITextView (Extension)


#pragma mark - Font

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


#pragma mark - Placeholder

+ (void)load {
    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
    Method method2 = class_getInstanceMethod([self class], @selector(xp_dealloc));
    method_exchangeImplementations(method1, method2);
}

#pragma mark -
- (UILabel *)placeholderLabel {
    
    UILabel *label = objc_getAssociatedObject(self, _cmd);
    if (!label) {
        label = [[UILabel alloc] initWithFrame:self.bounds];
        label.numberOfLines = 0;
        label.textColor = self.placeholderColor;
        label.font = self.font;
        label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
        label.hidden = YES;
        [self addSubview:label];
        
        NSArray *keys = @[@"text", @"font"];
        
        for (NSString *key in keys) {
            [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedText:) name:UITextViewTextDidChangeNotification object:nil];
        
        objc_setAssociatedObject(self, _cmd, label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        self.isAddObserver = YES;
    }
    return label;
}

- (NSString *)placeholder {
    return objc_getAssociatedObject(self, @"placeholder");
}
- (void)setPlaceholder:(NSString *)placeholder {
    self.placeholderLabel.text = placeholder;
    [self updatePlaceholderLabel];
    objc_setAssociatedObject(self, @"placeholder", placeholder, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIColor *)placeholderColor {
    
    UIColor *color = objc_getAssociatedObject(self, _cmd);
    if (!color) {
        color = [UIColor lightGrayColor];
    }
    return color;
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    objc_setAssociatedObject(self, @selector(placeholderColor), placeholderColor, OBJC_ASSOCIATION_RETAIN);
    self.placeholderLabel.textColor = placeholderColor;
}

- (BOOL)isAddObserver {
    id obj = objc_getAssociatedObject(self, _cmd);
    if (!obj) obj = @NO;
    return [obj boolValue];
}
- (void)setIsAddObserver:(BOOL)isAddObserver {
    objc_setAssociatedObject(self, @selector(isAddObserver), @(isAddObserver), OBJC_ASSOCIATION_RETAIN);
}

#pragma mark -
- (void)changedText:(NSNotification *)notify {
    [self updatePlaceholderLabel];
}

- (void)updatePlaceholderLabel {
    if (self.text.length > 0) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
        self.placeholderLabel.font = self.font;
        
        [self updatePlaceholderLabelFrame];
    }
}

- (void)updatePlaceholderLabelFrame {
    CGPoint point = CGPointMake(self.textContainerInset.left + 5, self.textContainerInset.top);
    CGSize size = CGSizeMake(self.frame.size.width - self.textContainerInset.left - self.textContainerInset.right - 10,
                             self.frame.size.height - self.textContainerInset.top - self.textContainerInset.bottom);
    CGSize end_size = [self.placeholderLabel sizeThatFits:size];
    
    if (end_size.height > size.height) {
        float h = (int)(size.height / self.placeholderLabel.font.lineHeight) * self.placeholderLabel.font.lineHeight + .1;
        end_size.height = h;
    }
    
    self.placeholderLabel.frame = (CGRect){point, end_size};
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *, id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"placeholder"]) {
        
        [self updatePlaceholderLabelFrame];
        
    } else if ([keyPath isEqualToString:@"font"]) {
        
        self.placeholderLabel.font = self.font;
        [self updatePlaceholderLabelFrame];
        
    } else if ([keyPath isEqualToString:@"text"]) {
        
        [self updatePlaceholderLabel];
    }
}

- (void)xp_dealloc {
    if (self.isAddObserver) {
        NSArray *keys = @[@"text", @"font"];
        for (NSString *key in keys) {
            [self removeObserver:self forKeyPath:key context:nil];
        }
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    [self xp_dealloc];
}

@end
