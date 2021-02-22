//
//  JLInputLogisticsViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/19.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLInputLogisticsViewController.h"

#import "JLBaseTextField.h"

@interface JLInputLogisticsViewController ()
@property (nonatomic, strong) UIView *orderNoView;
@property (nonatomic, strong) UIView *outlineInputView;
@property (nonatomic, strong) UIButton *scanButton;
@property (nonatomic, strong) JLBaseTextField *orderNoTF;
@property (nonatomic, strong) UIButton *submitBtn;
@end

@implementation JLInputLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"填写物流信息";
    [self addBackItem];
    [self createSubViews];
}

- (void)createSubViews {
    WS(weakSelf)
    [self.view addSubview:self.orderNoView];
    [self.orderNoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(19.0f);
        make.height.mas_equalTo(46.0f);
    }];
    [self.orderNoView addSubview:self.outlineInputView];
    [self.orderNoView addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.orderNoView);
        make.width.mas_equalTo(74.0f);
    }];
    [self.outlineInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(self.orderNoView);
        make.right.equalTo(self.submitBtn.mas_left).offset(-13.0f);
    }];
    
    [self.outlineInputView addSubview:self.scanButton];
    [self.outlineInputView addSubview:self.orderNoTF];
    [self.scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(9.0f);
        make.size.mas_equalTo(23.0f);
        make.centerY.equalTo(self.outlineInputView.mas_centerY);
    }];
    [self.orderNoTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scanButton.mas_right).offset(13.0f);
        make.top.bottom.equalTo(self.outlineInputView);
        make.right.equalTo(self.outlineInputView).offset(-8.0f);
    }];
    
    [self.orderNoTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [weakSelf.orderNoTF markedTextRange];
            UITextPosition *position = [weakSelf.orderNoTF positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                NSString *result = [JLUtils trimSpace:x];
                weakSelf.orderNoTF.text = result;
            }
        } else {
            NSString *result = [JLUtils trimSpace:x];
            weakSelf.orderNoTF.text = result;
        }
    }];
}

- (UIView *)orderNoView {
    if (!_orderNoView) {
        _orderNoView = [[UIView alloc] init];
    }
    return _orderNoView;
}

- (UIView *)outlineInputView {
    if (!_outlineInputView) {
        _outlineInputView = [[UIView alloc] init];
        ViewBorderRadius(_outlineInputView, 5.0f, 1.0f, JL_color_gray_DDDDDD);
    }
    return _outlineInputView;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [JLUIFactory buttonInitTitle:@"提交" titleColor:JL_color_white_ffffff backgroundColor:JL_color_blue_50C3FF font:kFontPingFangSCRegular(17.0f) addTarget:self action:@selector(submitBtnClick)];
        _submitBtn.contentEdgeInsets = UIEdgeInsetsZero;
        ViewBorderRadius(_submitBtn, 5.0f, 0.0f, JL_color_clear);
    }
    return _submitBtn;
}

- (void)submitBtnClick {
    
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

- (JLBaseTextField *)orderNoTF {
    if (!_orderNoTF) {
        _orderNoTF = [[JLBaseTextField alloc] init];
        _orderNoTF.font = kFontPingFangSCRegular(16.0f);
        _orderNoTF.textColor = JL_color_gray_101010;
        _orderNoTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _orderNoTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_BBBBBB, NSFontAttributeName: kFontPingFangSCRegular(16.0f)};
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"请输快递单号" attributes:dic];
        _orderNoTF.attributedPlaceholder = attr;
    }
    return _orderNoTF;
}

@end
