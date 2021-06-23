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
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) JLInputView *phoneInputView;
@property (nonatomic, strong) JLInputView *verifyCodeInputView;
@property (nonatomic, strong) UIButton *bindButton;
@end

@implementation JLBindPhoneWithoutPwdViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"";
    self.view.backgroundColor = JL_color_navBgColor;
    [self addBackItem];
    [self createView];
}

- (void)createView {
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.phoneInputView];
    [self.bgView addSubview:self.verifyCodeInputView];
    [self.bgView addSubview:self.bindButton];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(26.0f);
        make.left.equalTo(self.view).offset(15.0f);
        make.right.equalTo(self.view).offset(-15.0f);
        make.height.mas_equalTo(@438.0f);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(21.0f);
        make.top.equalTo(self.bgView).offset(35.0f);
    }];
    [self.phoneInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15.0f);
        make.right.equalTo(self.bgView).offset(-12.0f);
        make.top.equalTo(self.bgView).offset(122.0f);
        make.height.mas_equalTo(60.0f);
    }];
    [self.verifyCodeInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneInputView.mas_bottom).offset(15.0f);
        make.right.left.equalTo(self.phoneInputView);
        make.height.mas_equalTo(60.0f);
    }];
    [self.bindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(34.0f);
        make.top.equalTo(self.verifyCodeInputView.mas_bottom).offset(50.0f);
        make.right.equalTo(self.bgView).offset(-34.0f);
        make.height.mas_equalTo(44.0f);
    }];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = JL_color_white_ffffff;
        _bgView.layer.cornerRadius = 10;
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"绑定手机号";
        _titleLabel.textColor = JL_color_black_101220;
        _titleLabel.font = kFontPingFangSCMedium(24);
    }
    return _titleLabel;
}

- (JLInputView *)phoneInputView {
    if (!_phoneInputView) {
        _phoneInputView = [[JLInputView alloc] initWithHeadImage:@"icon_phone" placeholder:@"手机号" trailType:JLInputTrailTypePhone];
    }
    return _phoneInputView;
}

- (JLInputView *)verifyCodeInputView {
    if (!_verifyCodeInputView) {
        WS(weakSelf)
        _verifyCodeInputView = [[JLInputView alloc] initWithHeadImage:@"icon_verifycode" placeholder:@"请输入验证码" trailType:JLInputTrailTypeVerifyCode];
        _verifyCodeInputView.sendSmsBlock = ^(JLTimeButton * _Nonnull sender) {
            [weakSelf.view endEditing:YES];
            if ([NSString stringIsEmpty:weakSelf.phoneInputView.inputContent]) {
                [[JLLoading sharedLoading] showMBFailedTipMessage:@"请输入手机号码" hideTime:KToastDismissDelayTimeInterval];
                return;
            }
            if (![JLUtils checkTelNumber:weakSelf.phoneInputView.inputContent]) {
                [[JLLoading sharedLoading] showMBFailedTipMessage:@"请输入正确的手机号码" hideTime:KToastDismissDelayTimeInterval];
                return;
            }
            // 发送验证码
            Model_members_send_sms_Req *request = [[Model_members_send_sms_Req alloc] init];
            request.phone_number = [NSString stringWithFormat:@"86%@", weakSelf.phoneInputView.inputContent];
            request.send_type = @"change_phone";
            Model_members_send_sms_Rsp *response = [[Model_members_send_sms_Rsp alloc] init];
            
            [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
            [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
                [[JLLoading sharedLoading] hideLoading];
                if (netIsWork) {
                    [sender startCountDown];
                } else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
                }
            }];
        };
    }
    return _verifyCodeInputView;
}

- (UIButton *)bindButton {
    if (!_bindButton) {
        _bindButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bindButton setTitle:@"确认绑定" forState:UIControlStateNormal];
        [_bindButton setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _bindButton.titleLabel.font = kFontPingFangSCRegular(17.0f);
        _bindButton.backgroundColor = JL_color_mainColor;
        ViewBorderRadius(_bindButton, 22.0f, 0.0f, JL_color_clear);
        [_bindButton addTarget:self action:@selector(bindButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bindButton;
}

- (void)bindButtonClick {
    WS(weakSelf)
    Model_members_bind_phone_Req *request = [[Model_members_bind_phone_Req alloc] init];
    request.phone_number = [NSString stringWithFormat:@"86%@", self.phoneInputView.inputContent];
    request.phone_token = self.verifyCodeInputView.inputContent;
    Model_members_bind_phone_Rsp *response = [[Model_members_bind_phone_Rsp alloc] init];
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            if (weakSelf.bindPhoneSuccessBlock) {
                weakSelf.bindPhoneSuccessBlock([NSString stringWithFormat:@"86%@", weakSelf.phoneInputView.inputContent]);
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
        }
    }];
}
@end
