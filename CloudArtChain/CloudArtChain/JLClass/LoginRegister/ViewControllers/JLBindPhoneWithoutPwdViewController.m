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
        _bindButton.backgroundColor = JL_color_gray_101010;
        ViewBorderRadius(_bindButton, 23.0f, 0.0f, JL_color_clear);
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
