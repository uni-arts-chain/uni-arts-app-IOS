//
//  JLExportKeystorePwdViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/28.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLExportKeystorePwdViewController.h"
#import "JLExportKeystoreViewController.h"

#import "JLInputView.h"

@interface JLExportKeystorePwdViewController ()
@property (nonatomic, strong) UILabel *pwdTitleLabel;
@property (nonatomic, strong) JLInputView *pwdInputView;
@property (nonatomic, strong) UILabel *confirmPwdTitleLabel;
@property (nonatomic, strong) JLInputView *confirmPwdInputView;
@property (nonatomic, strong) UIImageView *noticeImageView;
@property (nonatomic, strong) UILabel *noticeLabel;
@property (nonatomic, strong) UIButton *nextButton;
@end

@implementation JLExportKeystorePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置Keystore密码";
    [self addBackItem];
    [self setupSubViews];
}

- (void)setupSubViews {
    [self.view addSubview:self.pwdTitleLabel];
    [self.view addSubview:self.pwdInputView];
    [self.view addSubview:self.confirmPwdTitleLabel];
    [self.view addSubview:self.confirmPwdInputView];
    [self.view addSubview:self.noticeImageView];
    [self.view addSubview:self.noticeLabel];
    [self.view addSubview:self.nextButton];

    [self.pwdTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(20.0f);
    }];
    [self.pwdInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(self.pwdTitleLabel.mas_bottom);
        make.height.mas_equalTo(50.0f);
    }];
    [self.confirmPwdTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(self.pwdInputView.mas_bottom).offset(20.0f);
    }];
    [self.confirmPwdInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(self.confirmPwdTitleLabel.mas_bottom);
        make.height.mas_equalTo(50.0f);
    }];
    [self.noticeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.confirmPwdInputView.mas_bottom).offset(15.0f);
        make.size.mas_equalTo(14.0f);
    }];
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.noticeImageView.mas_top).offset(-3.0f);
        make.left.equalTo(self.noticeImageView.mas_right).offset(8.0f);
        make.right.mas_equalTo(-15.0f);
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.bottom.mas_equalTo(-KTouch_Responder_Height - 50.0f);
        make.height.mas_offset(46.0f);
    }];
    
}

- (UIImageView *)noticeImageView {
    if (!_noticeImageView) {
        _noticeImageView = [JLUIFactory imageViewInitImageName:@"icon_wallet_export_keystore_notice"];
    }
    return _noticeImageView;
}

- (UILabel *)noticeLabel {
    if (!_noticeLabel) {
        _noticeLabel = [JLUIFactory labelInitText:@"请设置导出Keystore密码，导入Keystore时需要校验！" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_666666 textAlignment:NSTextAlignmentLeft];
    }
    return _noticeLabel;
}

- (UILabel *)pwdTitleLabel {
    if (!_pwdTitleLabel) {
        _pwdTitleLabel = [JLUIFactory labelInitText:@"设置Keystore密码" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _pwdTitleLabel;
}

- (JLInputView *)pwdInputView {
    if (!_pwdInputView) {
        _pwdInputView = [[JLInputView alloc] initWithHeadImage:@"" placeholder:@"请输入6-18位数字与字母组合" trailType:JLInputTrailTypePwd];
    }
    return _pwdInputView;
}

- (UILabel *)confirmPwdTitleLabel {
    if (!_confirmPwdTitleLabel) {
        _confirmPwdTitleLabel = [JLUIFactory labelInitText:@"再次确认Keystore密码" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _confirmPwdTitleLabel;
}

- (JLInputView *)confirmPwdInputView {
    if (!_confirmPwdInputView) {
        _confirmPwdInputView = [[JLInputView alloc] initWithHeadImage:@"" placeholder:@"请输入6-18位数字与字母组合" trailType:JLInputTrailTypePwd];
    }
    return _confirmPwdInputView;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [JLUIFactory buttonInitTitle:@"下一步" titleColor:JL_color_white_ffffff backgroundColor:JL_color_blue_50C3FF font:kFontPingFangSCRegular(17.0f) addTarget:self action:@selector(nextButtonClick)];
        ViewBorderRadius(_nextButton, 23.0f, 0.0f, JL_color_clear);
    }
    return _nextButton;
}

- (void)nextButtonClick {
    [self.view endEditing:YES];
    if ([self.pwdInputView.inputContent isEqualToString:self.confirmPwdInputView.inputContent]) {
        JLExportKeystoreViewController *exportKeyStoreVC = [[JLExportKeystoreViewController alloc] init];
        exportKeyStoreVC.keystorePwd = self.pwdInputView.inputContent;
        [self.navigationController pushViewController:exportKeyStoreVC animated:YES];
    } else {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"密码输入不一致" hideTime:KToastDismissDelayTimeInterval];
    }
}
@end
