//
//  JLBaseWebViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseWebViewController.h"
#import <WebKit/WebKit.h>
#import "JLArtDetailViewController.h"
#import "JLBoxDetailViewController.h"

typedef NS_ENUM(NSUInteger, JLWebViewType) {
    JLWebViewTypeUrl,
    JLWebViewTypeTextHtml,
};

@interface JLBaseWebViewController ()<WKNavigationDelegate, WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NSString *originURLString;
@property (nonatomic, strong) NSString *originHTMLString;
@property (nonatomic, assign) JLWebViewType webViewType;
@end

@implementation JLBaseWebViewController
- (void)dealloc {
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (instancetype)initWithWebUrl:(NSString *)url naviTitle:(NSString *)title {
    self = [super init];
    if (self) {
        self.title = title;
        self.originURLString = url;
        self.webViewType = JLWebViewTypeUrl;
    }
    return self;
}

- (instancetype)initWithHtmlContent:(NSString *)htmlContent naviTitle:(NSString *)title {
    self = [super init];
    if (self) {
        self.title = title;
        self.originHTMLString = htmlContent;
        self.webViewType = JLWebViewTypeTextHtml;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    [self setupViews];
    [self requestData];
}

- (void)setupViews {
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addScriptMessageHandler:self name:WKScriptMessageHandlerNameNftDetail];
    [userContentController addScriptMessageHandler:self name:WKScriptMessageHandlerNameMysteryBoxDetail];
    configuration.userContentController = userContentController;
    
    CGRect webViewFrame = CGRectMake(25.0f, 25.0f, kScreenWidth - 25.0f * 2, kScreenHeight - KStatusBar_Navigation_Height - 25.0f);
    if (self.webViewType == JLWebViewTypeUrl) {
        webViewFrame = CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height);
    }
    self.wkWebView = [[WKWebView alloc] initWithFrame:webViewFrame configuration:configuration];
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

- (void)requestData {
    if (![NSString stringIsEmpty:self.originURLString]) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.originURLString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
        [self.wkWebView loadRequest:request];
    } else if(![NSString stringIsEmpty:self.originHTMLString]) {
        [self.wkWebView loadHTMLString:self.originHTMLString baseURL:nil];
    }
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"name: %@, body: %@", message.name, message.body);
    if ([message.name isEqualToString:WKScriptMessageHandlerNameNftDetail]) {
        JLArtDetailViewController *vc = [[JLArtDetailViewController alloc] init];
        vc.artDetailId = message.body;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([message.name isEqualToString:WKScriptMessageHandlerNameMysteryBoxDetail]) {
        JLBoxDetailViewController *vc = [[JLBoxDetailViewController alloc] init];
        vc.boxId = message.body;
        [self.navigationController pushViewController:vc animated:YES];
    }
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

@end
