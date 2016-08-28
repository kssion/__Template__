//
//  XPInputHandle.m
//  CTools
//
//  Created by Chance on 15/9/15.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import "XPInputHandle.h"
#import <objc/runtime.h>


#ifndef kWidth
    #define kHeight ([[UIScreen mainScreen] bounds].size.height)
#endif

#ifndef kHeight
    #define kWidth ([[UIScreen mainScreen] bounds].size.width)
#endif

#define kSpacing 20.0f

@interface UIView (KeyboardHandle)
@property CGPoint oldCenter;
@property CGRect oldFrame;
@property (readonly) UIWindow *viewWindow;
@property (readonly) UIViewController *viewController;

- (BOOL)isInView:(UIView *)view;
- (BOOL)containsView:(UIView *)view;
@end

@interface UIScrollView ()
@property CGPoint oldContentOffset;
@end

#pragma mark -
@interface XPInputHandle ()
@property (nonatomic, strong) NSMutableDictionary *allSuperviews;   /**< 所有父控件*/
@property (nonatomic, strong) NSMutableDictionary *allInputviews;   /**< 所有输入控件*/
@property (nonatomic, strong, readonly) NSMutableSet *inputKeys;    /**< 输入控件所有key*/

// Set keyboard return key type. 151017.10
@property (nonatomic, strong) NSMutableDictionary *inputGroups;         /**< 所有输入控件组*/

@property (nonatomic, assign, readonly) CGFloat keyboardHeight;         /**< 键盘高度*/
@property (nonatomic, assign) CGFloat insetBottom;
@property (nonatomic, assign) BOOL haveKeyboard;
@property (nonatomic, assign) BOOL haveResponse;

@property (nonatomic, copy) NSString *currentKey;               /**< 当前控件组的key*/
@property (nonatomic, weak) NSMutableArray *currentInputGroup;  /**< 当前输入控件组*/
@property (nonatomic, weak, readonly) UIView *inputView;        /**< 当前输入控件*/
@property (nonatomic, weak, readonly) UIView *superView;        /**< 当前父控件*/


@end

#pragma mark -
@implementation XPInputHandle

+ (XPInputHandle *)defaultInputHandle {
    static XPInputHandle *sharedInputHandle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInputHandle = [[self alloc] init];
    });
    return sharedInputHandle;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    for (NSString *key in self.inputKeys) [self removeForKey:key];
    self.inputGroups = nil;
    self.allInputviews = nil;
    self.allSuperviews = nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 添加键盘通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
        // 初始化
        _allInputviews = [NSMutableDictionary dictionary];
        _allSuperviews = [NSMutableDictionary dictionary];
        _inputKeys = [NSMutableSet set];
        _inputGroups = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSMutableArray *)currentInputGroup {
    NSMutableArray *inputGroup = nil;
    if ([self.inputGroups.allKeys containsObject:_currentKey]) {
        inputGroup = self.inputGroups[_currentKey];
    }
    return inputGroup;
}

#pragma mark - New
/*
    v: 2.0
    t: 2015.10.10
 */
- (void)registerForKey:(NSString *)key {
    if (key && ![self.inputKeys containsObject:key]) {
        [self.inputKeys addObject:key];
        [self.allInputviews setObject:[NSMutableSet set] forKey:key];
        [self.allSuperviews setObject:[NSMutableDictionary dictionary] forKey:key];
        [self.inputGroups setObject:[NSMutableArray array] forKey:key];
    }
}

- (void)removeForKey:(NSString *)key {
    if ([self.inputKeys containsObject:key]) {
        [self.inputKeys removeObject:key];            // remove key
        for (id obj in self.allInputviews[key]) {     // remove Observer
            [obj removeObserver:self forKeyPath:@"firstResponder"];
        }
        [self.allInputviews removeObjectForKey:key];  // remove input views
        [self.allSuperviews removeObjectForKey:key];  // remove super views
        [self.inputGroups removeObjectForKey:key];
    }
}

- (void)addInputView:(UIView *)inputView superView:(UIView *)superView forKey:(NSString *)key {
    NSAssert([inputView isKindOfClass:[UIView class]], @"inputView must be a view");
    NSAssert([superView isKindOfClass:[UIView class]], @"superView must be a view");
    
    if ([self.inputKeys containsObject:key]) {
        
        if (![self.allInputviews[key] containsObject:inputView]) { // inputView is exist
            // 添加输入控件
            [self.allInputviews[key] addObject:inputView];
            
            // 添加父视图
            NSString *inputKey = [NSString stringWithFormat:@"%p", inputView];
            [self.allSuperviews[key] setObject:superView forKey:inputKey];
            
            // 添加到控件组
            [self.inputGroups[key] addObject:inputView];
            
            // 设置返回键类型
            
            // 添加输入框属性监听
            [inputView addObserver:self forKeyPath:@"firstResponder" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:(__bridge void *)superView];
        }
    }
}

- (void)setReturnKeyTypeForKey:(NSString *)key {
    [self sortInputGroup:self.inputGroups[key]];
}

// 控件组重新排序
- (void)sortInputGroup:(NSMutableArray *)group {
    // inputViews
    __weak UIView *inputViewA = nil;
    __weak UIView *inputViewB = nil;
    
    for (int i = 0; i < group.count; ++i)
    {
        inputViewA = group[i];
        CGFloat topA = [inputViewA.superview convertPoint:inputViewA.center toView:nil].y;
        
        for (int j = i+1; j < group.count; ++j)
        {
            inputViewB = group[j];
            CGFloat topB = [inputViewB.superview convertPoint:inputViewB.center toView:nil].y;
            
            if (topA > topB)
            {
                NSString *tmp = group[i];
                group[i] = group[j];
                group[j] = tmp;
                
                inputViewA = group[i];
                topA = [inputViewA.superview convertPoint:inputViewA.center toView:nil].y;
            }
        }
        
        UITextField *tf = (UITextField *)group[i];
        if (!tf.delegate) {
            tf.delegate = self;
        }
        
        if (!tf.returnKeyType) {
            tf.returnKeyType = UIReturnKeyNext;
        }
        
        if (i == group.count - 1) {
            tf.returnKeyType = UIReturnKeyDone;
        }
    }
}

+ (void)registerForKey:(NSString *)key {
    [[self defaultInputHandle] registerForKey:key];
}

+ (void)removeForKey:(NSString *)key {
    [[self defaultInputHandle] removeForKey:key];
}

+ (void)addInputView:(UIView *)inputView superView:(UIView *)superView forKey:(NSString *)key {
    [[self defaultInputHandle] addInputView:inputView superView:superView forKey:key];
}

+ (void)setReturnKeyTypeForKey:(NSString *)key {
    [[self defaultInputHandle] setReturnKeyTypeForKey:key];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger index = [self.currentInputGroup indexOfObject:textField];
    if (index >= self.currentInputGroup.count - 1) { // 完成
        if ([textField isFirstResponder]) {
            return [textField resignFirstResponder];
        }
    } else if (index < self.currentInputGroup.count - 1) { // 下一个
        UITextField *nextTF = self.currentInputGroup[index + 1];
        if ([nextTF canBecomeFirstResponder]) {
            return [nextTF becomeFirstResponder];
        }
    }
    return YES;
}

#pragma mark -
- (void)KeyboardWillShowNotification:(NSNotification *)notification {
    if (_haveResponse) {
        CGRect rect = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
        _keyboardHeight = rect.size.height;
        
        if ([self.superView isKindOfClass:[UIScrollView class]]) {
            UIScrollView *sup = (UIScrollView *)self.superView;
            if (!_haveKeyboard) {
                _insetBottom = sup.contentInset.bottom;
            }
            
            UIEdgeInsets edge = sup.contentInset;
            edge.bottom = _insetBottom + _keyboardHeight;
            sup.contentInset = edge;
        } else if ([self.superView isKindOfClass:[UIView class]]) {
            if (!_haveKeyboard) {
                self.superView.oldCenter = self.superView.center;
            }
        }
        
        [self takeFirstResponder];
        
        _haveKeyboard = YES;
    }
}

- (void)KeyboardWillHideNotification:(NSNotification *)notification {
    if (_haveKeyboard) {
        if ([self.superView isKindOfClass:[UIScrollView class]]) {
            UIScrollView *sup = (UIScrollView *)self.superView;
            
            UIEdgeInsets edge = sup.contentInset;
            edge.bottom -= _keyboardHeight;
            sup.contentInset = edge;
        }
        
        [self loseFirstResponder];
        
        _keyboardHeight = 0;
        _haveKeyboard = NO;
    }
}

// 获得输入焦点
- (void)takeFirstResponder {
    CGFloat keyboardSpacing = 0;
    
    if ([self.inputView isKindOfClass:[UITextView class]]) {  // 需要最大显示
        
//        CGRect frame = self.inputView.frame;
//        _inputView.oldFrame = frame;
//        frame.size.height = kHeight - 64 - kSpacing - _keyboardHeight;
//        _inputView.frame = frame;
        
        keyboardSpacing = kSpacing + self.inputView.frame.size.height;
        
        if (keyboardSpacing > kHeight-64-_keyboardHeight) {
            keyboardSpacing = kHeight-64-_keyboardHeight;
        }
        
        keyboardSpacing = keyboardSpacing > (kHeight-64-_keyboardHeight) ? kHeight-64-_keyboardHeight : keyboardSpacing;
        
    } else {
        
        keyboardSpacing = kSpacing + self.inputView.frame.size.height;
    }
    
    if ([self.superView isKindOfClass:[UIScrollView class]]) {
        
        UIScrollView *sup = (UIScrollView *)self.superView;
        
        sup.oldContentOffset = sup.contentOffset;
        
        CGRect rect = [self.inputView.superview convertRect:self.inputView.frame toView:nil];
        CGFloat cha = 0;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:7];
        [UIView setAnimationDuration:0.25];
        
        if (rect.origin.y - 74 < 0) { // 如果TextView在导航部分 则向下偏移
            cha = -(rect.origin.y - 74);
            
            sup.contentOffset = CGPointMake(sup.contentOffset.x, sup.contentOffset.y-cha);
            
        } else {
            
            CGFloat height = kHeight - (rect.origin.y + keyboardSpacing);
            cha = height - _keyboardHeight;
            
            if (cha < 0) { // 如果TextView被键盘遮挡 则向上偏移
                sup.contentOffset = CGPointMake(sup.contentOffset.x, sup.contentOffset.y-cha);
            }
        }
        
        [UIView commitAnimations];
        
    } else if ([self.superView isKindOfClass:[UIView class]]) {
        
        CGRect rect = [self.inputView.superview convertRect:self.inputView.frame toView:nil];
        CGFloat height = kHeight - (rect.origin.y + keyboardSpacing);
        CGFloat cha = height - _keyboardHeight;
        
        if (cha < 0) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationCurve:7];
            [UIView setAnimationDuration:0.25];
            
            self.superView.center = CGPointMake(self.superView.center.x, self.superView.center.y+cha);
            
            [UIView commitAnimations];
        }
    }
}

// 失去输入焦点
- (void)loseFirstResponder {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:7];
    [UIView setAnimationDuration:0.25];
    
    if ([self.superView isKindOfClass:[UIScrollView class]]) {
        UIScrollView *sup = (UIScrollView *)self.superView;
        
        CGFloat maxOffsetY = sup.contentSize.height - sup.frame.size.height + sup.contentInset.bottom;
        
        if (sup.contentSize.height < sup.frame.size.height || sup.contentOffset.y < -sup.contentInset.top) {
            // 顶边偏移
            sup.contentOffset = CGPointMake(sup.contentOffset.x, -sup.contentInset.top);
        } else if (sup.contentOffset.y > maxOffsetY) {
            // 底边偏移
            sup.contentOffset = CGPointMake(sup.contentOffset.x, maxOffsetY);
        }
        
    } else {
        self.superView.center = self.superView.oldCenter;
    }
    
    [UIView commitAnimations];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([change[@"new"] isEqual:object]) {
        for (NSString *objKey in self.allSuperviews.allKeys) {
            NSString *inputKey = [NSString stringWithFormat:@"%p", object];
            if ([[self.allSuperviews[objKey] allKeys] containsObject:inputKey]) {
                
                UIView *inputView = object;
                UIView *superView = self.allSuperviews[objKey][inputKey];
                _haveResponse = YES;
                _currentKey = objKey;
                
                if (_haveKeyboard && ![_superView isKindOfClass:[superView class]]) {
                    [self loseFirstResponder];
                }
                
                _inputView = inputView;
                _superView = superView;
                
                if (_haveKeyboard) { // 切换输入焦点 键盘已经显示
                    [self takeFirstResponder];
                }
                break;
            }
        }
        
        
        
    } else if ([change[@"old"] isEqual:object]) {
        
//        _inputView = nil;
//        _superView = nil;
        
        

        _haveResponse = NO;
        _currentKey = nil;
    }
}

@end

#pragma mark -
@implementation UIView (KeyboardHandle)

- (CGPoint)oldCenter {
    NSValue *value = objc_getAssociatedObject(self, @"chance_UIView_KeyboardHandle_oldCenter");
    return [value CGPointValue];
}

- (void)setOldCenter:(CGPoint)oldCenter {
    NSValue *value = [NSValue valueWithCGPoint:oldCenter];
    objc_setAssociatedObject(self, @"chance_UIView_KeyboardHandle_oldCenter", value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)oldFrame {
    NSValue *value = objc_getAssociatedObject(self, @"chance_UIView_KeyboardHandle_oldFrame");
    return [value CGRectValue];
}

- (void)setOldFrame:(CGRect)oldFrame {
    NSValue *value = [NSValue valueWithCGRect:oldFrame];
    objc_setAssociatedObject(self, @"chance_UIView_KeyboardHandle_oldFrame", value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)viewController {
    UIResponder *responder = self;
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    }
    return nil;
}

- (UIWindow *)viewWindow {
    UIView *sv = self;
    while ((sv = [sv superview])) {
        if ([sv isKindOfClass: [UIWindow class]])
            return (UIWindow *)sv;
    }
    return nil;
}

- (BOOL)isInView:(UIView *)view {
    UIView *sv = self;
    while ((sv = [sv superview])) {
        if ([sv isEqual:view])
            return YES;
    }
    return NO;
}

- (BOOL)containsView:(UIView *)view {
    NSArray *subviews = self.subviews;
    for (UIView *v in subviews) {
        if ([v isEqual:view]) {
            return YES;
        } else if ([v containsView:view]) {
            return YES;
        }
    }
    return NO;
}

@end

#pragma mark -
@implementation UIScrollView (KeyboardHandle)
- (CGPoint)oldContentOffset {
    NSValue *value = objc_getAssociatedObject(self, @"chance_UIView_KeyboardHandle_oldContentOffset");
    return [value CGPointValue];
}

- (void)setOldContentOffset:(CGPoint)oldContentOffset {
    NSValue *value = [NSValue valueWithCGPoint:oldContentOffset];
    objc_setAssociatedObject(self, @"chance_UIView_KeyboardHandle_oldContentOffset", value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
