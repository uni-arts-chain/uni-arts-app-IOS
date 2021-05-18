//
//  JLPayWebViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/5/7.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLWechatPayWebViewController.h"
#import <WebKit/WebKit.h>

static const NSString *CompanyFirstDomainByWeChatRegister = @"mall.senmeo.tech";

@interface JLWechatPayWebViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation JLWechatPayWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"支付";
    [self addBackItem];
    [self setupViews];
    [self requestData];
}

- (void)requestData {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.payUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
    [request setValue:[NSString stringWithFormat:@"%@://", CompanyFirstDomainByWeChatRegister] forHTTPHeaderField: @"Referer"];
    [self.wkWebView loadRequest:request];
}

#pragma mark --WKNavigationDelegate
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.wkWebView.estimatedProgress;
        if (self.progressView.progress == 1) {
            WS(weakSelf);
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
            }];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    self.progressView.hidden = YES;
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    self.progressView.hidden = YES;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURLRequest *request        = navigationAction.request;
    NSString     *scheme         = [request.URL scheme];
    // decode for all URL to avoid url contains some special character so that it wasn't load.
    NSString     *absoluteString = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    NSLog(@"Current URL is %@",absoluteString);
    
    static NSString *endPayRedirectURL = nil;
    
    // Wechat Pay, Note : modify redirect_url to resolve we couldn't return our app from wechat client.
    if ([absoluteString hasPrefix:@"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb"] && ![absoluteString hasSuffix:[NSString stringWithFormat:@"redirect_url=%@://",CompanyFirstDomainByWeChatRegister]]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        
#warning Note : The string "xiaodongxie.cn://" must be configured by wechat background. It must be your company first domin. You also should configure "URL types" in the Info.plist file.
        
        // 1. If the url contain "redirect_url" : We need to remember it to use our scheme replace it.
        // 2. If the url not contain "redirect_url" , We should add it so that we will could jump to our app.
        //  Note : 2. if the redirect_url is not last string, you should use correct strategy, because the redirect_url's value may contain some "&" special character so that my cut method may be incorrect.
        NSString *redirectUrl = nil;
        if ([absoluteString containsString:@"redirect_url="]) {
            NSRange redirectRange = [absoluteString rangeOfString:@"redirect_url"];
            endPayRedirectURL =  [absoluteString substringFromIndex:redirectRange.location+redirectRange.length + 1];
            redirectUrl = [[absoluteString substringToIndex:redirectRange.location] stringByAppendingString:[NSString stringWithFormat:@"redirect_url=%@://",CompanyFirstDomainByWeChatRegister]];
        } else {
            redirectUrl = [absoluteString stringByAppendingString:[NSString stringWithFormat:@"&redirect_url=%@://",CompanyFirstDomainByWeChatRegister]];
        }
        
        NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:redirectUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
        newRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
        [newRequest setValue:[NSString stringWithFormat:@"%@://", CompanyFirstDomainByWeChatRegister] forHTTPHeaderField: @"Referer"];
        newRequest.URL = [NSURL URLWithString:redirectUrl];
        [webView loadRequest:newRequest];
        return;
    }
    
    // Judge is whether to jump to other app.
    if (![scheme isEqualToString:@"https"] && ![scheme isEqualToString:@"http"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        if ([scheme isEqualToString:@"weixin"]) {
            // The var endPayRedirectURL was our saved origin url's redirect address. We need to load it when we return from wechat client.
            if (endPayRedirectURL) {
                [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:endPayRedirectURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f]];
            }
        } else if ([scheme isEqualToString:CompanyFirstDomainByWeChatRegister]) {
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",CompanyFirstDomainByWeChatRegister]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f]];
        }
        
        BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:request.URL];
        if (canOpen) {
            [[UIApplication sharedApplication] openURL:request.URL];
        }
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)setupViews {
    CGRect webViewFrame = CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height);
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.javaScriptEnabled=YES;
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:webViewFrame configuration:config];
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:self.wkWebView];
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] bounds].size.width, 2.0f)];
    self.progressView.progressTintColor = JL_color_gray_101010;
    self.progressView.trackTintColor = JL_color_clear;
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
}

@end
