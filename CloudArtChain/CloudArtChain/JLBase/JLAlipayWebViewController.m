//
//  JLAlipayWebViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/5/17.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLAlipayWebViewController.h"
#import "UIAlertController+Alert.h"
#import "JLAuctionSubmitOrderViewController.h"
#import "JLNewAuctionArtDetailViewController.h"

@interface JLAlipayWebViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation JLAlipayWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"支付";
    [self addBackItem];
    [self setupViews];
    [self requestData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayResultNotification:) name:@"JLAliPayResultNotification" object:nil];
}

/// 将视图控制器移除栈
- (void)fihishViewControllers {
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if (_payGoodType == JLAlipayWebViewControllerPayGoodTypeAuctionArt) {
            if ([vc isMemberOfClass:JLNewAuctionArtDetailViewController.class] ||
                [vc isMemberOfClass:JLAuctionSubmitOrderViewController.class]) {
                [arr removeObject:vc];
            }
        }
    }
    self.navigationController.viewControllers = [arr copy];
}

- (void)alipayResultNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSDictionary *result = userInfo[@"result"];
    NSString *resultStatus = result[@"ResultStatus"];
    NSString *memoStr = result[@"memo"];
    if (resultStatus.intValue == 9000) {
        [[JLLoading sharedLoading] showMBSuccessTipMessage:@"支付成功" hideTime:KToastDismissDelayTimeInterval];
        [self fihishViewControllers];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [[JLLoading sharedLoading] showMBFailedTipMessage:memoStr hideTime:KToastDismissDelayTimeInterval];
    }
}

- (void)requestData {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.payUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
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
    WS(weakSelf)
    if ([navigationAction.request.URL.scheme isEqualToString:@"alipay"]) {
            //  1.以？号来切割字符串
            NSArray *urlBaseArr = [navigationAction.request.URL.absoluteString componentsSeparatedByString:@"?"];
            NSString *urlBaseStr = urlBaseArr.firstObject;
            NSString *urlNeedDecode = urlBaseArr.lastObject;
            //  2.将截取以后的Str，做一下URLDecode，方便我们处理数据
            NSMutableString *afterDecodeStr = [NSMutableString stringWithString:[NSString decoderUrlEncodeStr:urlNeedDecode]];
            //  3.替换里面的默认Scheme为自己的Scheme
            NSString *afterHandleStr = [afterDecodeStr stringByReplacingOccurrencesOfString:@"alipays" withString:@"alipayreturn.senmeo.tech"];
            //  4.然后把处理后的，和最开始切割的做下拼接，就得到了最终的字符串
            NSString *finalStr = [NSString stringWithFormat:@"%@?%@",urlBaseStr, [NSString urlEncodeStr:afterHandleStr]];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //  判断一下，是否安装了支付宝APP（也就是看看能不能打开这个URL）
                
                BOOL bSucc = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:finalStr]];
                if (!bSucc) {
                    UIAlertController *alert = [UIAlertController alertShowWithTitle:@"提示" message:@"未检测到支付宝客户端，请安装后重试。" cancel:@"取消" cancelHandler:^{
                        
                    } confirm:@"立即安装" confirmHandler:^{
                        NSString* urlStr = @"https://itunes.apple.com/cn/app/zhi-fu-bao-qian-bao-yu-e-bao/id333206289?mt=8";
                        NSURL *downloadUrl = [NSURL URLWithString:urlStr];
                        [[UIApplication sharedApplication] openURL:downloadUrl];
                    }];
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                }
            });
            
            decisionHandler(WKNavigationActionPolicyCancel);
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
