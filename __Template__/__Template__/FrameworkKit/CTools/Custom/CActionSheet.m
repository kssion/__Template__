//
//  CActionSheet.m
//  CTools
//
//  Created by Chance on 15/4/29.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import "CActionSheet.h"

#define kWidth [[UIScreen mainScreen] bounds].size.width

@interface CActionSheet ()
/**
 *  灰色背景视图
 */
@property (nonatomic, strong) UIControl *baseView;
/**
 *  内容区视图
 */
@property (nonatomic, strong) UIView *contentView;
/**
 *  菜单列表区
 */
@property (nonatomic, strong) UIView *listView;
/**
 *  取消按钮
 */
@property (nonatomic, strong) UIButton *cancel;
@end

@implementation CActionSheet

//+ (instancetype)sharedActionSheet
//{
//    static CActionSheet *actionSheetInstance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        actionSheetInstance = [[self alloc] init];
//    });
//    return actionSheetInstance;
//}

- (instancetype)init {
    self = [super init];
    if (self)
    {
        _baseView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _baseView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        _baseView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [_baseView addTarget:self action:@selector(backgroundTouches) forControlEvents:UIControlEventTouchUpInside];
        
        _contentView = [[UIControl alloc] initWithFrame:CGRectMake(5, _baseView.frame.size.height + 50, kWidth - 10, 100)];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        [_baseView addSubview:_contentView];
        
        _listView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, 100)];
        _listView.layer.cornerRadius = 5;
        _listView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
        _listView.userInteractionEnabled = YES;
        _listView.clipsToBounds = YES;
        _listView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        [_contentView addSubview:_listView];
        
        _cancel = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancel.frame = CGRectMake(0, 0, _contentView.frame.size.width, 44);
        _cancel.layer.cornerRadius = 5;
        [_cancel setBackgroundColor:[UIColor whiteColor]];
        [_cancel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_cancel addTarget:self action:@selector(cancelEvent) forControlEvents:UIControlEventTouchUpInside];
        _cancel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        [_contentView addSubview:_cancel];
        
    }
    return self;
}

//设置标题 代理 按钮标题等
- (void)setTitle:(NSString *)title delegate:(id<CActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles otherButtonImages:(NSArray *)otherButtonImages {
    self.delegate = delegate;
    CGFloat height = (otherButtonTitles.count + 1) * 44 + 5;
    
    _contentView.bounds = CGRectMake(0, 0, _contentView.frame.size.width, height);
    _contentView.center = CGPointMake(_contentView.center.x, _baseView.frame.size.height + height / 2);
    
    _listView.bounds = CGRectMake(0, 0, _contentView.frame.size.width, otherButtonTitles.count * 44);
    _listView.center = CGPointMake(_listView.center.x, otherButtonTitles.count * 44 / 2);
    
    for (int i = 0; i < otherButtonTitles.count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(0, 44 * i + i/2.0, _contentView.frame.size.width, 44);
        btn.tag = 1000 + i;
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTintColor:[UIColor blackColor]];
        
        if (i < otherButtonImages.count) {
            [btn.imageView setContentMode:UIViewContentModeCenter];
            [btn setImage:otherButtonImages[i] forState:UIControlStateNormal];
        }
        
        [btn.titleLabel setContentMode:UIViewContentModeCenter];
        [btn.titleLabel setBackgroundColor:[UIColor clearColor]];
        [btn setTitle:otherButtonTitles[i] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
        btn.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        [_listView addSubview:btn];
    }
    
    _cancel.center = CGPointMake(_cancel.center.x, height - 22);
    [_cancel setTitle:cancelButtonTitle forState:UIControlStateNormal];
}


#pragma mark - Event
// 触摸灰色部分 隐藏
- (void)backgroundTouches {
    [self hidden];
}

// 点击取消
- (void)cancelEvent {
    if (_delegate && [_delegate respondsToSelector:@selector(actionSheetCancel:)])
    {
        [_delegate actionSheetCancel:self];
    }
    [self hidden];
}

//点击列表其中一项
- (void)selectItem:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)])
    {
        [_delegate actionSheet:self clickedButtonAtIndex:btn.tag - 1000];
    }
    [self hidden];
}

#pragma mark - Function
//显示
- (void)show {
    _baseView.frame = [UIScreen mainScreen].bounds;
    
    [[UIApplication sharedApplication].keyWindow addSubview:_baseView];
    
    [UIView animateWithDuration:0.2 animations:^{
        _baseView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _contentView.center = CGPointMake(_contentView.center.x, CGRectGetMaxY(_baseView.frame) - _contentView.frame.size.height / 2 - 5);
    }];
}

// 隐藏
- (void)hidden {
    [UIView animateWithDuration:0.2 animations:^{
        _baseView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        _contentView.center = CGPointMake(_contentView.center.x, CGRectGetMaxY(_baseView.frame) + _contentView.frame.size.height / 2);
    } completion:^(BOOL finished) {
        [_baseView removeFromSuperview];
    }];
}


@end
