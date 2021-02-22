//
//  JLLoginView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/16.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLLoginView.h"
#import "JLInputView.h"

@interface JLLoginView ()
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIView *headerBottomView;
@property (nonatomic, strong) UILabel *loginLabel;
@property (nonatomic, strong) UIView *sepLineView;
@property (nonatomic, strong) UIButton *registerBtn;

@property (nonatomic, strong) JLInputView *phoneInputView;
@property (nonatomic, strong) JLInputView *pwdInputView;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *forgetButton;
@end

@implementation JLLoginView
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
    [self.headerBottomView addSubview:self.loginLabel];
    [self.headerBottomView addSubview:self.sepLineView];
    [self.headerBottomView addSubview:self.registerBtn];
    
    [self addSubview:self.phoneInputView];
    [self addSubview:self.pwdInputView];
    [self addSubview:self.loginButton];
    [self addSubview:self.forgetButton];
    
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
    [self.loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.headerBottomView);
    }];
    [self.sepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginLabel.mas_right);
        make.width.mas_equalTo(1.0f);
        make.height.mas_equalTo(20.0f);
        make.centerY.equalTo(self.headerBottomView);
    }];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sepLineView.mas_right);
        make.top.bottom.right.equalTo(self.headerBottomView);
        make.width.equalTo(self.loginLabel.mas_width);
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
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.pwdInputView.mas_bottom).offset(30.0f);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(46.0f);
    }];
    [self.forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-KTouch_Responder_Height);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(60.0f);
    }];
}

- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [JLUIFactory imageViewInitImageName:@"icon_login_back"];
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

- (UILabel *)loginLabel {
    if (!_loginLabel) {
        _loginLabel = [JLUIFactory labelInitText:@"登录" font:kFontPingFangSCMedium(17.0f) textColor:JL_color_white_ffffff textAlignment:NSTextAlignmentCenter];
    }
    return _loginLabel;
}

- (UIView *)sepLineView {
    if (!_sepLineView) {
        _sepLineView = [[UIView alloc] init];
        _sepLineView.backgroundColor = JL_color_white_ffffff;
    }
    return _sepLineView;
}

- (UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _registerBtn.titleLabel.font = kFontPingFangSCRegular(15.0f);
        [_registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}

- (void)registerBtnClick {
    if (self.registerBlock) {
        self.registerBlock();
    }
}

- (JLInputView *)phoneInputView {
    if (!_phoneInputView) {
        _phoneInputView = [[JLInputView alloc] initWithHeadImage:@"icon_phone" placeholder:@"手机号" trailType:JLInputTrailTypeNone];
    }
    return _phoneInputView;
}

- (JLInputView *)pwdInputView {
    if (!_pwdInputView) {
        _pwdInputView = [[JLInputView alloc] initWithHeadImage:@"icon_pwd" placeholder:@"密码" trailType:JLInputTrailTypePwd];
    }
    return _pwdInputView;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _loginButton.titleLabel.font = kFontPingFangSCRegular(17.0f);
        _loginButton.backgroundColor = JL_color_blue_50C3FF;
        ViewBorderRadius(_loginButton, 23.0f, 0.0f, JL_color_clear);
        [_loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (void)loginButtonClick {
    
}

- (UIButton *)forgetButton {
    if (!_forgetButton) {
        _forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_forgetButton setTitleColor:JL_color_blue_38B2F1 forState:UIControlStateNormal];
        _forgetButton.titleLabel.font = kFontPingFangSCRegular(15.0f);
        [_forgetButton addTarget:self action:@selector(forgetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetButton;
}

- (void)forgetButtonClick {
    if (self.forgetPwdBlock) {
        self.forgetPwdBlock();
    }
}
@end
