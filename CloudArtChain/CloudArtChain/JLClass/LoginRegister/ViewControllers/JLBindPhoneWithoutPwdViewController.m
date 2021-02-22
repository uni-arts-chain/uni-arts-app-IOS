//
//  JLBindPhoneWithoutPwdViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/19.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBindPhoneWithoutPwdViewController.h"
#import "JLInputView.h"

@interface JLBindPhoneWithoutPwdViewController ()
@property (nonatomic, strong) JLInputView *phoneInputView;
@property (nonatomic, strong) JLInputView *verifyCodeInputView;
@property (nonatomic, strong) UIButton *bindButton;
@end

@implementation JLBindPhoneWithoutPwdViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"绑定手机号";
    [self addBackItem];
    [self createView];
}

- (void)createView {
    [self.view addSubview:self.phoneInputView];
    [self.view addSubview:self.verifyCodeInputView];
    [self.view addSubview:self.bindButton];
    
    [self.phoneInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.view);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(67.0f);
    }];
    [self.verifyCodeInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.phoneInputView.mas_bottom);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(67.0f);
    }];
    [self.bindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.verifyCodeInputView.mas_bottom).offset(30.0f);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(46.0f);
    }];
}

- (JLInputView *)phoneInputView {
    if (!_phoneInputView) {
        _phoneInputView = [[JLInputView alloc] initWithHeadImage:@"icon_phone" placeholder:@"手机号" trailType:JLInputTrailTypeNone];
    }
    return _phoneInputView;
}

- (JLInputView *)verifyCodeInputView {
    if (!_verifyCodeInputView) {
        _verifyCodeInputView = [[JLInputView alloc] initWithHeadImage:@"icon_verifycode" placeholder:@"请输入验证码" trailType:JLInputTrailTypeVerifyCode];
    }
    return _verifyCodeInputView;
}

- (UIButton *)bindButton {
    if (!_bindButton) {
        _bindButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bindButton setTitle:@"确认绑定" forState:UIControlStateNormal];
        [_bindButton setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _bindButton.titleLabel.font = kFontPingFangSCRegular(17.0f);
        _bindButton.backgroundColor = JL_color_blue_50C3FF;
        ViewBorderRadius(_bindButton, 23.0f, 0.0f, JL_color_clear);
        [_bindButton addTarget:self action:@selector(bindButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bindButton;
}

- (void)bindButtonClick {
    
}
@end
