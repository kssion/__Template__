//
//  XPWebView.m
//  CTools
//
//  Created by Chance on 16/3/23.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "XPWebView.h"

@interface XPWebView () <UIWebViewDelegate>
@property (nonatomic, weak) id<UIWebViewDelegate> loadDelegate;
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, copy) NSString *host;

@end

@implementation XPWebView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:47/255.0 green:48/255.0 blue:50/255.0 alpha:1];
        
        _isHint = YES;
        
        _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 20)];
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
        _hintLabel.font = [UIFont systemFontOfSize:10];
        _hintLabel.hidden = YES;
        [self insertSubview:_hintLabel atIndex:0];
        
        self.delegate = self;
    }
    return self;
}

- (void)setDelegate:(id<UIWebViewDelegate>)delegate {
    if (delegate && [delegate isEqual:self]) {
        [super setDelegate:delegate];
    } else {
        _loadDelegate = delegate;
    }
}

- (void)setIsHint:(BOOL)hint {
    _isHint = hint;
    _hintLabel.hidden = !hint;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (request.URL.host) {
        self.host = request.URL.host;
    }
    
    if (_loadDelegate && [_loadDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [_loadDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (_loadDelegate && [_loadDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [_loadDelegate webViewDidStartLoad:webView];
    }
    
    _hintLabel.text = [NSString stringWithFormat:@"网页由 %@ 提供", self.host];
    _hintLabel.hidden = !_isHint;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (_loadDelegate && [_loadDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [_loadDelegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (_loadDelegate && [_loadDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [_loadDelegate webView:webView didFailLoadWithError:error];
    }
}

@end
