//
//  JLForgetPwdViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/16.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLForgetPwdViewController.h"
#import "JLForgetPwdNewViewController.h"

#import "JLInputView.h"

@interface JLForgetPwdViewController ()
@property (nonatomic, strong) JLInputView *phoneInputView;
@property (nonatomic, strong) JLInputView *verifyCodeInputView;
@property (nonatomic, strong) UIButton *nextButton;
@end

@implementation JLForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.forgetPwdType == JLForgetPwdTypeForget) {
        self.navigationItem.title = @"忘记密码";
    } else {
        self.navigationItem.title = @"修改密码";
    }
    [self addBackItem];
    [self createView];
}

- (void)createView {
    [self.view addSubview:self.phoneInputView];
    [self.view addSubview:self.verifyCodeInputView];
    [self.view addSubview:self.nextButton];
    
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
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.verifyCodeInputView.mas_bottom).offset(37.0f);
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

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _nextButton.titleLabel.font = kFontPingFangSCRegular(17.0f);
        _nextButton.backgroundColor = JL_color_blue_50C3FF;
        ViewBorderRadius(_nextButton, 23.0f, 0.0f, JL_color_clear);
        [_nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

- (void)nextButtonClick {
    JLForgetPwdNewViewController *forgetPwdNewVC = [[JLForgetPwdNewViewController alloc] init];
    forgetPwdNewVC.forgetPwdType = self.forgetPwdType;
    [self.navigationController pushViewController:forgetPwdNewVC animated:YES];
}
@end
