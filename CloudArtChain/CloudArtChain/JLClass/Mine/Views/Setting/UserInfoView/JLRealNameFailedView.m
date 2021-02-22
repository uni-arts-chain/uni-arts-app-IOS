//
//  JLRealNameFailedView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLRealNameFailedView.h"

@interface JLRealNameFailedView()
@property (nonatomic, strong) UIImageView *failedImage;
@property (nonatomic, strong) UILabel *failedLabel;
@property (nonatomic, strong) UILabel *reasonLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *retryButton;
@end

@implementation JLRealNameFailedView

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createView];
    }
    return self;
}

- (void)createView {
    [self addSubview:self.failedImage];
    [self addSubview:self.failedLabel];
    [self addSubview:self.reasonLabel];
    [self addSubview:self.backButton];
    [self addSubview:self.retryButton];
    [self.failedImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50.0f);
        make.centerX.mas_equalTo(self);
    }];
    [self.failedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.failedImage.mas_bottom).offset(30.0f);
        make.left.mas_equalTo(30.0f);
        make.right.mas_equalTo(-30.0f);
    }];
    [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.failedLabel.mas_bottom).offset(20.0f);
        make.left.mas_equalTo(30.0f);
        make.right.mas_equalTo(-30.0f);
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.reasonLabel.mas_bottom).offset(65.0f);
        make.left.mas_equalTo(30.0f);
        make.right.mas_equalTo(self.mas_centerX).offset(-15.0f);
        make.height.mas_equalTo(40.0f);
    }];
    
    [self.retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.reasonLabel.mas_bottom).offset(65.0f);
        make.left.mas_equalTo(self.mas_centerX).offset(15.0f);
        make.right.mas_equalTo(-30.0f);
        make.height.mas_equalTo(40.0f);
    }];
}

- (UIImageView *)failedImage {
    if (!_failedImage) {
        _failedImage = [[UIImageView alloc] init];
        _failedImage.image = [UIImage imageNamed:@"icon_mine_realname_failed"];
    }
    return _failedImage;
}

- (UILabel *)failedLabel{
    if (!_failedLabel) {
        _failedLabel = [[UILabel alloc] init];
        _failedLabel.textColor = JL_color_black;
        _failedLabel.font = kFontPingFangSCMedium(14.0f);
        _failedLabel.numberOfLines = 0;
        _failedLabel.textAlignment = NSTextAlignmentCenter;
        _failedLabel.text = @"实人认证信息审核未通过";
    }
    return _failedLabel;
}

- (UILabel *)reasonLabel{
    if (!_reasonLabel) {
        _reasonLabel = [[UILabel alloc] init];
        _reasonLabel.textColor = JL_color_black;
        _reasonLabel.font = kFontPingFangSCRegular(12.0f);
        _reasonLabel.numberOfLines = 0;
        _reasonLabel.textAlignment = NSTextAlignmentCenter;
//        UserDataBody *user = [AppSingleton sharedAppSingleton].userBody;
        NSString *reason = [NSString stringWithFormat:@"驳回原因："];
        _reasonLabel.text = reason;
    }
    return _reasonLabel;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_backButton setTitleColor:JL_color_blue forState:UIControlStateNormal];
        _backButton.titleLabel.font = kFontPingFangSCRegular(14.0f);
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
        _backButton.layer.cornerRadius = 3.0f;
        _backButton.layer.borderWidth = 1.0f;
        _backButton.layer.borderColor = JL_color_blue.CGColor;
        _backButton.layer.masksToBounds = YES;
        [_backButton addTarget:self action:@selector(successButonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)retryButton {
    if (!_retryButton) {
        _retryButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_retryButton setTitleColor:JL_color_blue_50C3FF forState:UIControlStateNormal];
        _retryButton.titleLabel.font = kFontPingFangSCRegular(14.0f);
        [_retryButton setTitle:@"重新提交" forState:UIControlStateNormal];
        _retryButton.layer.cornerRadius = 3.0f;
        _retryButton.layer.borderWidth = 1.0f;
        _retryButton.layer.borderColor = JL_color_blue_50C3FF.CGColor;
        _retryButton.layer.masksToBounds = YES;
        [_retryButton addTarget:self action:@selector(retryButonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _retryButton;
}

- (void)successButonAction:(UIButton*)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(failedViewBackAction)]) {
        [self.delegate failedViewBackAction];
    }
}

- (void)retryButonAction:(UIButton *)button {
    [self removeFromSuperview];
}
@end
