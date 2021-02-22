//
//  JLRegisterView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/16.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLRegisterView.h"
#import "JLInputView.h"

@interface JLRegisterView ()
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIView *headerBottomView;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIView *sepLineView;
@property (nonatomic, strong) UILabel *registerLabel;

@property (nonatomic, strong) JLInputView *phoneInputView;
@property (nonatomic, strong) JLInputView *pwdInputView;
@property (nonatomic, strong) JLInputView *verifyCodeInputView;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *agreeProtocolBtn;
@property (nonatomic, strong) UIButton *protocolBtn;
@end

@implementation JLRegisterView
- (instancetype)init {
    if (self = [super init]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.headerImageView];
    [self.headerImageView addSubview:self.backButton];
    [self.headerImageView addSubview:self.headerBottomView];
    [self.headerBottomView addSubview:self.loginBtn];
    [self.headerBottomView addSubview:self.sepLineView];
    [self.headerBottomView addSubview:self.registerLabel];
    
    [self addSubview:self.phoneInputView];
    [self addSubview:self.pwdInputView];
    [self addSubview:self.verifyCodeInputView];
    [self addSubview:self.registerButton];
    
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.agreeProtocolBtn];
    [self.bottomView addSubview:self.protocolBtn];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(KwidthScale(222.0f));
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17.0f);
        make.top.mas_equalTo(KStatus_Bar_Height + 8.0f);
        make.width.mas_equalTo(8.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.headerBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.headerImageView);
        make.height.mas_equalTo(50.0f);
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.headerBottomView);
    }];
    [self.sepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginBtn.mas_right);
        make.width.mas_equalTo(1.0f);
        make.height.mas_equalTo(20.0f);
        make.centerY.equalTo(self.headerBottomView);
    }];
    [self.registerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sepLineView.mas_right);
        make.top.bottom.right.equalTo(self.headerBottomView);
        make.width.equalTo(self.loginBtn.mas_width);
    }];
    
    [self.phoneInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.headerImageView.mas_bottom).offset(6.0f);
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
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.verifyCodeInputView.mas_bottom).offset(30.0f);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(46.0f);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-KTouch_Responder_Height);
        make.height.mas_equalTo(60.0f);
        make.centerX.equalTo(self);
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

- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [JLUIFactory imageViewInitImageName:@"icon_register_back"];
        _headerImageView.userInteractionEnabled = YES;
    }
    return _headerImageView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (void)backButtonClick {
    if (self.backBlock) {
        self.backBlock();
    }
}

- (UIView *)headerBottomView {
    if (!_headerBottomView) {
        _headerBottomView = [[UIView alloc] init];
    }
    return _headerBottomView;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = kFontPingFangSCRegular(15.0f);
        [_loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (void)loginBtnClick {
    if (self.loginBlock) {
        self.loginBlock();
    }
}

- (UIView *)sepLineView {
    if (!_sepLineView) {
        _sepLineView = [[UIView alloc] init];
        _sepLineView.backgroundColor = JL_color_white_ffffff;
    }
    return _sepLineView;
}

- (UILabel *)registerLabel {
    if (!_registerLabel) {
        _registerLabel = [JLUIFactory labelInitText:@"注册" font:kFontPingFangSCMedium(17.0f) textColor:JL_color_white_ffffff textAlignment:NSTextAlignmentCenter];
    }
    return _registerLabel;
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

- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _registerButton.titleLabel.font = kFontPingFangSCRegular(17.0f);
        _registerButton.backgroundColor = JL_color_blue_50C3FF;
        ViewBorderRadius(_registerButton, 23.0f, 0.0f, JL_color_clear);
        [_registerButton addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

- (void)registerButtonClick {
    
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
