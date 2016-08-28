//
//  XPTextInputManager.m
//  Caches
//
//  Created by Chance on 16/4/28.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "XPInputEmojiFilter.h"


NSString *const kEmojiString = @"35,42,48,49,50,51,52,53,54,55,56,57,169,174,8252,8265,8482,8505,8596,8597,8598,8599,8600,8601,8617,8618,8986,8987,9000,9193,9194,9195,9196,9197,9198,9199,9201,9202,9203,9208,9209,9210,9654,9664,9728,9729,9730,9731,9732,9745,9748,9749,9752,9757,9760,9762,9763,9766,9770,9774,9775,9784,9785,9786,9800,9801,9802,9803,9804,9805,9806,9807,9808,9809,9810,9811,9824,9827,9829,9830,9832,9851,9855,9874,9876,9878,9879,9881,9883,9884,9888,9889,9904,9905,9917,9918,9924,9928,9934,9935,9937,9939,9961,9962,9968,9969,9970,9971,9972,9973,9975,9976,9977,9978,9981,9986,9989,9992,9994,9995,9996,9997,10002,10004,10013,10017,10024,10035,10036,10052,10060,10067,10068,10069,10071,10083,10084,10133,10134,10135,10145,10160,10175,11013,11014,11015,11088,11093,12336,12349,12951,12953,21834,26342,55356,55357,55358";

typedef void (^CharacterBlock)(BOOL isEmoji, NSString *character, NSInteger len, BOOL *stop);


@interface XPInputEmojiFilter ()

@property (nonatomic, strong) NSArray *emojiCodes;

#pragma mark -
@property (nonatomic, assign) BOOL beginEditing;        /**< 是否在编辑中 */
@property (nonatomic, assign) BOOL isAdd;               /**< 是否添加 */
@property (nonatomic, assign) BOOL isDelete;            /**< 是否删除 */

#pragma mark -
@property (nonatomic, strong) NSMutableString *oldText; /**< 原文字内容 */

#pragma mark -
@property (nonatomic, weak) UIView <UITextInput> *inputView;  /**< 当前的输入控件 */

@end

#pragma mark -
@implementation XPInputEmojiFilter

+ (instancetype)sharedManager
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
        _oldText = [NSMutableString string];
        
        _emojiCodes = [kEmojiString componentsSeparatedByString:@","];
        
        [self open];
    }
    return self;
}

#pragma mark - UITextView Editing Notification
- (void)textViewTextDidBeginEditingNotification:(NSNotification *)notification
{
    UITextView <UITextInput> *inputView = notification.object;
    self.inputView = inputView;
    _beginEditing = YES;
    if (inputView.text.length) {
        [_oldText setString:inputView.text];;
    }
}

- (void)textViewTextDidEndEditingNotification:(NSNotification *)notification
{
    [_oldText setString:@""];
    _beginEditing = NO;
}

- (void)textViewTextDidChangeNotification:(NSNotification *)notification
{
    if (_isAdd) {
        _isAdd = NO;
    } else if (_isDelete) {
        _isDelete = NO;
    } else {
        if (_beginEditing) {
            [self textTextDidChangeOfInputView:notification.object];
        }
    }
}

#pragma mark - UITextField Editing Notification
- (void)textFieldTextDidBeginEditingNotification:(NSNotification *)notification
{
    UITextField <UITextInput> *inputView = notification.object;
    self.inputView = inputView;

    _beginEditing = YES;
    if (inputView.text.length) {
        [_oldText setString:inputView.text];
    }
}

- (void)textFieldTextDidEndEditingNotification:(NSNotification *)notification
{
    [_oldText setString:@""];
    _beginEditing = NO;
}

- (void)textFieldTextDidChangeNotification:(NSNotification *)notification
{
    if (_isAdd) {
        _isAdd = NO;
    } else if (_isDelete) {
        _isDelete = NO;
    } else {
        if (_beginEditing) {
            [self textTextDidChangeOfInputView:notification.object];
        }
    }
}

#pragma mark - Functions
- (void)textTextDidChangeOfInputView:(id)inputView
{
    NSString *lang = [[inputView textInputMode] primaryLanguage];
    
    if([lang isEqualToString:@"zh-Hans"]){ // 简体中文输入（简体拼音 健体五笔 简体手写）
        
        UITextRange *selectedRange = [inputView markedTextRange];
        
        UITextPosition *position = [inputView positionFromPosition:selectedRange.start offset:0];
        
        if (position) return; // 高亮
    } else { // 其他输入法
        
    }
    
    NSString *newText = @"";
    
    if ([inputView text].length < _oldText.length) { // 删除或者替换了
        
        NSString *substr = [_oldText substringToIndex:[inputView text].length];
        
        if ([substr isEqualToString:[inputView text]]) { // 删除了
            [_oldText setString:[inputView text]];
            _isDelete = YES;
            return;
            
        } else {    // 替换了
            
            [_oldText setString:@""];
            newText = [inputView text];
        }
        
    } else if ([inputView text].length > _oldText.length) { // 添加或替换了
        
        NSString *substr = [[inputView text] substringToIndex:_oldText.length];
        
        if ([substr isEqualToString:_oldText]) { // 添加了
            newText = [[inputView text] substringFromIndex:_oldText.length];
            _isAdd = YES;
        } else {    // 替换了
            [_oldText setString:@""];
            newText = [inputView text];
        }
        
    } else { // 替换了
        
        if ([_oldText isEqualToString:[inputView text]]) {
            return;
        } else {
            [_oldText setString:@""];
            newText = [inputView text];
        }
    }
    
    [self getValidText:newText];
    
    [inputView setText:[_oldText copy]];
}

- (NSString *)getValidText:(NSString *)text
{
    NSString *newText;
    
    [self calculationLengthWithText:text outValidText:&newText];
    
    [_oldText appendString:newText ? newText:@""];
    
    return newText;
}

- (NSInteger)calculationLengthWithText:(NSString *)text
{
    return [self calculationLengthWithText:text outValidText:nil];
}

- (NSInteger)calculationLengthWithText:(NSString *)text outValidText:(NSString **)validText
{
    NSMutableString *validStr = validText ? [NSMutableString string] : nil;
    
    __block NSUInteger length = 0;
    
    [self enumerateSubstrings:text handle:^(BOOL isEmoji, NSString *character, NSInteger len, BOOL *stop) {
        
        BOOL state = NO;
        
        if (isEmoji) {
            state = NO;
            [XPPromptTag showWithText:@"不支持Emoji表情输入！"];
        } else {
            state = YES;
        }
        
        if (state) {
            [validStr appendString:character];
        }
        
    }];
    
    if (validText) {
        *validText = [validStr copy];
    }
    
    return length;
}

- (void)enumerateSubstrings:(NSString *)text handle:(CharacterBlock)handle
{
    [text enumerateSubstringsInRange:NSMakeRange(0, [text length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        const unichar hs = [substring characterAtIndex:0];
        
        {
            if (substring.length > 1) {
                if ([_emojiCodes containsObject:[NSString stringWithFormat:@"%@", @(hs)]]) {
                    handle(YES, substring, 2, stop); return;
                }
            } else {
                const unichar hs = [substring characterAtIndex:0];
                
                BOOL emoji = NO;
                
                if (0x2100 <= hs && hs <= 0x27ff) {
                    emoji = YES;
                } else if (0x2B05 <= hs && hs <= 0x2b07) {
                    emoji = YES;
                } else if (0x2934 <= hs && hs <= 0x2935) {
                    emoji = YES;
                } else if (0x3297 <= hs && hs <= 0x3299) {
                    emoji = YES;
                } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                    emoji = YES;
                }
                
                if (emoji) {
                    handle(YES, substring, 2, stop); return;
                }
            }
        }
        
        // 其它unicode
        {
            handle(NO, substring, substring.length, stop); return;
        }
    }];
}

#pragma mark - Instance Method

- (void)open {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidBeginEditingNotification:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidEndEditingNotification:) name:UITextViewTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChangeNotification:) name:UITextViewTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidBeginEditingNotification:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidEndEditingNotification:) name:UITextFieldTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)close {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (void)open {
    [[self sharedManager] open];
}

+ (void)close {
    [[self sharedManager] close];
}

- (void)dealloc
{
    [self close];
}



@end
