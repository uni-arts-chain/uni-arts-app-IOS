//
//  JLChainQueryViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/2.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLChainQueryViewController.h"
#import "JLBaseTextField.h"
#import "JLScanViewController.h"

#import "JLChainQueryArtInfoView.h"
#import "JLChainQueryArtCertView.h"
#import "JLSignTradeView.h"
#import "WMPhotoBrowser.h"

@interface JLChainQueryViewController ()
@property (nonatomic, strong) UIView *queryView;
@property (nonatomic, strong) UIView *outlineInputView;
@property (nonatomic, strong) UIButton *scanButton;
@property (nonatomic, strong) JLBaseTextField *addressTF;
@property (nonatomic, strong) UIButton *queryBtn;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) JLChainQueryArtInfoView *chainQueryArtInfoView;
@property (nonatomic, strong) JLChainQueryArtCertView *chainQueryArtCertView;
@property (nonatomic, strong) JLSignTradeView *signTradeView;
@end

@implementation JLChainQueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"链查询";
    [self addBackItem];
    [self createSubviews];
}

- (void)createSubviews {
    WS(weakSelf)
    [self.view addSubview:self.queryView];
    [self.queryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(19.0f);
        make.height.mas_equalTo(46.0f);
    }];
    [self.queryView addSubview:self.outlineInputView];
    [self.queryView addSubview:self.queryBtn];
    [self.queryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.queryView);
        make.width.mas_equalTo(74.0f);
    }];
    [self.outlineInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(self.queryView);
        make.right.equalTo(self.queryBtn.mas_left).offset(-13.0f);
    }];
    
    [self.outlineInputView addSubview:self.scanButton];
    [self.outlineInputView addSubview:self.addressTF];
    [self.scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(9.0f);
        make.size.mas_equalTo(23.0f);
        make.centerY.equalTo(self.outlineInputView.mas_centerY);
    }];
    [self.addressTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scanButton.mas_right).offset(13.0f);
        make.top.bottom.equalTo(self.outlineInputView);
        make.right.equalTo(self.outlineInputView).offset(-8.0f);
    }];
    
    [self.addressTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [weakSelf.addressTF markedTextRange];
            UITextPosition *position = [weakSelf.addressTF positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                NSString *result = [JLUtils trimSpace:x];
                weakSelf.addressTF.text = result;
            }
        } else {
            NSString *result = [JLUtils trimSpace:x];
            weakSelf.addressTF.text = result;
        }
    }];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.queryView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    [self.scrollView addSubview:self.chainQueryArtInfoView];
    [self.scrollView addSubview:self.chainQueryArtCertView];
    [self.scrollView addSubview:self.signTradeView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.signTradeView.frame = CGRectMake(0.0f, self.chainQueryArtCertView.frameBottom, kScreenWidth, 307.0f);
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.signTradeView.frameBottom);
}

- (UIView *)queryView {
    if (!_queryView) {
        _queryView = [[UIView alloc] init];
    }
    return _queryView;
}

- (UIView *)outlineInputView {
    if (!_outlineInputView) {
        _outlineInputView = [[UIView alloc] init];
        ViewBorderRadius(_outlineInputView, 5.0f, 1.0f, JL_color_gray_DDDDDD);
    }
    return _outlineInputView;
}

- (UIButton *)queryBtn {
    if (!_queryBtn) {
        _queryBtn = [JLUIFactory buttonInitTitle:@"查询" titleColor:JL_color_white_ffffff backgroundColor:JL_color_blue_50C3FF font:kFontPingFangSCRegular(17.0f) addTarget:self action:@selector(queryBtnClick)];
        _queryBtn.contentEdgeInsets = UIEdgeInsetsZero;
        ViewBorderRadius(_queryBtn, 5.0f, 0.0f, JL_color_clear);
    }
    return _queryBtn;
}

- (void)queryBtnClick {
    
}

- (UIButton *)scanButton {
    if (!_scanButton) {
        _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scanButton setImage:[UIImage imageNamed:@"icon_home_chainquery_scan"] forState:UIControlStateNormal];
        [_scanButton addTarget:self action:@selector(scanButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanButton;
}

- (void)scanButtonClick {
    JLScanViewController *scanVC = [JLScanViewController new];
    scanVC.scanType = JLScanTypeChainQuery;
    scanVC.qrCode = YES;
    scanVC.resultBlock = ^(NSString *scanResult) {
        NSLog(@"%@", scanResult);
    };
    scanVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:scanVC animated:YES completion:nil];
}

- (JLBaseTextField *)addressTF {
    if (!_addressTF) {
        _addressTF = [[JLBaseTextField alloc] init];
        _addressTF.font = kFontPingFangSCRegular(16.0f);
        _addressTF.textColor = JL_color_gray_101010;
        _addressTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _addressTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_BBBBBB, NSFontAttributeName: kFontPingFangSCRegular(16.0f)};
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"请输入证书地址" attributes:dic];
        _addressTF.attributedPlaceholder = attr;
    }
    return _addressTF;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = JL_color_white_ffffff;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (JLChainQueryArtInfoView *)chainQueryArtInfoView {
    if (!_chainQueryArtInfoView) {
        _chainQueryArtInfoView = [[JLChainQueryArtInfoView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, 221.0f)];
    }
    return _chainQueryArtInfoView;
}

- (JLChainQueryArtCertView *)chainQueryArtCertView {
    if (!_chainQueryArtCertView) {
        _chainQueryArtCertView = [[JLChainQueryArtCertView alloc] initWithFrame:CGRectMake(0.0f, self.chainQueryArtInfoView.frameBottom, kScreenWidth, 0.0f)];
        _chainQueryArtCertView.certImageBlock = ^{
            //图片查看
            WMPhotoBrowser *browser = [WMPhotoBrowser new];
            //数据源
            browser.dataSource = [@[[UIImage imageNamed:@"1"]] mutableCopy];
            browser.downLoadNeeded = YES;
            browser.currentPhotoIndex = 0;
            browser.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [[JLTool currentViewController] presentViewController:browser animated:YES completion:nil];
        };
    }
    return _chainQueryArtCertView;
}

- (JLSignTradeView *)signTradeView {
    if (!_signTradeView) {
        _signTradeView = [[JLSignTradeView alloc] initWithFrame:CGRectMake(0.0f, self.chainQueryArtCertView.frameBottom, kScreenWidth, 0.0f)];
    }
    return _signTradeView;
}
@end
