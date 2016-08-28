//
//  XPPromptTag.m
//  CTools
//
//  Created by Chance on 16/4/10.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "XPPromptTag.h"

#ifndef kWidth
    #define kWidth ([[UIScreen mainScreen] bounds].size.width)
#endif

#ifndef kHeight
    #define kHeight ([[UIScreen mainScreen] bounds].size.height)
#endif


@interface XPPromptTag ()
#if __IPHONE_OS_VERSION_MAX_ALLOWED == __IPHONE_10_0
<CAAnimationDelegate>
#endif
@property (nonatomic, strong) UIView *promptView;
@property (nonatomic, strong) UILabel *promptLabel;

@end

@implementation XPPromptTag

+ (instancetype)sharedPromptTag
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 30, 20)];
        _promptLabel.textColor = [UIColor whiteColor];
        _promptLabel.numberOfLines = 0;
        _promptLabel.font = [UIFont systemFontOfSize:14];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        _promptView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        _promptView.layer.cornerRadius = 5;
        _promptView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [_promptView addSubview:_promptLabel];
    }
    return self;
}

- (void)showWithText:(NSString *)text
{
    _promptLabel.text = text;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenView) object:nil];
    
    [_promptView.layer removeAllAnimations];
    _promptView.layer.opacity = 1;
    UIView *view = [self findTopView:nil];
    
    if (_promptView.superview != view) {
        [_promptView removeFromSuperview];
        [view addSubview:_promptView];
    }
    
    CGSize size = [_promptLabel sizeThatFits:CGSizeMake(kWidth - 80, 300)];
    _promptView.frame = CGRectMake(0, kHeight * 0.75 - size.height + 10, size.width + 20, size.height + 10);
    _promptView.center = CGPointMake(kWidth * .5, kHeight * 0.75);
    
    __weak __typeof(self) _self = self;
    [UIView animateWithDuration:.25 delay:0 options:7<<16 animations:^{
        
        _self.promptView.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        [_self performSelector:@selector(hiddenView) withObject:nil afterDelay:2];
    }];
}

- (void)hiddenView
{
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"opacity"];
    ani.toValue = @0;
    ani.duration = 0.25;
    ani.removedOnCompletion = NO;
    ani.fillMode = kCAFillModeForwards;
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    ani.delegate = self;
    [_promptView.layer addAnimation:ani forKey:@"opacity"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        [_promptView removeFromSuperview];
    }
}

- (UIView *)findTopView:(UIView *)view
{
    if (!view) {
        NSArray *ws = [[UIApplication sharedApplication] windows];
        
        UIWindow *window = nil;
        for (UIWindow *w in ws) {
            if (!window) {
                window = w;
            } else {
                if (w.windowLevel > window.windowLevel) {
                    window = w;
                } else if (w.windowLevel == window.windowLevel) {
                    if (w.isKeyWindow) {
                        window = w;
                    }
                }
            }
        }
        view = window;
    }
    NSArray *vs = [view subviews];
    for (int i = 0; i < vs.count; ++i) {
        UIView *v = vs[vs.count-i-1];
        if (CGRectEqualToRect(v.bounds, [[UIScreen mainScreen] bounds])) {
            return [self findTopView:v];
        }
    }
    return view;
}

#pragma mark -
+ (void)showWithText:(NSString *)text
{
    [[self sharedPromptTag] showWithText:text];
}

+ (void)showWithFormat:(NSString *)format, ...
{
    va_list list;
    if(format) {
        va_start(list, format);
        [self showWithText:[[NSString alloc] initWithFormat:format arguments:list]];
        va_end(list);
    }
}

@end
