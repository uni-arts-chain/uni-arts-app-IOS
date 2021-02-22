//
//  JLBindPhoneViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/17.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBindPhoneViewController.h"
#import "JLInputView.h"

@interface JLBindPhoneViewController ()
@property (nonatomic, strong) JLInputView *phoneInputView;
@property (nonatomic, strong) JLInputView *pwdInputView;
@property (nonatomic, strong) JLInputView *verifyCodeInputView;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *agreeProtocolBtn;
@property (nonatomic, strong) UIButton *protocolBtn;
@end

@implementation JLBindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"绑定手机号";
    [self addBackItem];
    [self createView];
}

- (void)createView {
    [self.view addSubview:self.phoneInputView];
    [self.view addSubview:self.pwdInputView];
    [self.view addSubview:self.verifyCodeInputView];
    [self.view addSubview:self.nextButton];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.agreeProtocolBtn];
    [self.bottomView addSubview:self.protocolBtn];
    
    [self.phoneInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.view);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(67.0f);
    }];
    [self.pwdInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.phoneInputView.mas_bottom);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(67.0f);
    }];
    [self.verifyCodeInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.pwdInputView.mas_bottom);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(67.0f);
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.verifyCodeInputView.mas_bottom).offset(30.0f);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(46.0f);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-KTouch_Responder_Height);
        make.height.mas_equalTo(60.0f);
        make.centerX.equalTo(self.view);
    }];
    [self.agreeProtocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView);
        make.size.mas_equalTo(14.0f);
        make.centerY.equalTo(self.bottomView);
    }];
    [self.protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.agreeProtocolBtn.mas_right).offset(8.0f);
        make.top.bottom.right.equalTo(self.bottomView);
    }];
}

- (JLInputView *)phoneInputView {
    if (!_phoneInputView) {
        _phoneInputView = [[JLInputView alloc] initWithHeadImage:@"icon_phone" placeholder:@"手机号" trailType:JLInputTrailTypeNone];
    }
    return _phoneInputView;
}

- (JLInputView *)pwdInputView {
    if (!_pwdInputView) {
        _pwdInputView = [[JLInputView alloc] initWithHeadImage:@"icon_pwd" placeholder:@"请输入6-18位数字与字母组合" trailType:JLInputTrailTypePwd];
    }
    return _pwdInputView;
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
    
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}

- (UIButton *)agreeProtocolBtn {
    if (!_agreeProtocolBtn) {
        _agreeProtocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreeProtocolBtn setImage:[UIImage imageNamed:@"icon_agree_register_normal"] forState:UIControlStateNormal];
        [_agreeProtocolBtn setImage:[UIImage imageNamed:@"icon_agree_register_selected"] forState:UIControlStateSelected];
        _agreeProtocolBtn.selected = YES;
        [_agreeProtocolBtn addTarget:self action:@selector(agreeProtocolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeProtocolBtn;
}

- (void)agreeProtocolBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (UIButton *)protocolBtn {
    if (!_protocolBtn) {
        _protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_protocolBtn setTitle:@"同意《用户协议》" forState:UIControlStateNormal];
        [_protocolBtn setTitleColor:JL_color_gray_909090 forState:UIControlStateNormal];
        _protocolBtn.titleLabel.font = kFontPingFangSCRegular(15.0f);
        [_protocolBtn addTarget:self action:@selector(protocolBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _protocolBtn;
}

- (void)protocolBtnClick {
    
}
@end
