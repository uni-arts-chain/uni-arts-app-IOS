//
//  JLExportKeystoreFileView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/4.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLExportKeystoreFileView.h"

@interface JLExportKeystoreFileView ()
@property (nonatomic, strong) UILabel *firstTitleLabel;
@property (nonatomic, strong) UILabel *firstNoticeLabel;
@property (nonatomic, strong) UILabel *secondTitleLabel;
@property (nonatomic, strong) UILabel *secondNoticeLabel;
@property (nonatomic, strong) UILabel *thirdTitleLabel;
@property (nonatomic, strong) UILabel *thirdNoticeLabel;
@property (nonatomic, strong) UIView *keystoreView;
@property (nonatomic, strong) UILabel *keystoreLabel;
@property (nonatomic, strong) UIButton *keystoreCopyBtn;
@end

@implementation JLExportKeystoreFileView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.frame;
    frame.size.height = self.keystoreCopyBtn.frameBottom;
    self.frame = frame;
}

- (void)createSubViews {
    [self addSubview:self.firstTitleLabel];
    [self addSubview:self.firstNoticeLabel];
    [self addSubview:self.secondTitleLabel];
    [self addSubview:self.secondNoticeLabel];
    [self addSubview:self.thirdTitleLabel];
    [self addSubview:self.thirdNoticeLabel];
    [self addSubview:self.keystoreView];
    [self.keystoreView addSubview:self.keystoreLabel];
    [self addSubview:self.keystoreCopyBtn];
    
    [self.firstTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(20.0f);
        make.height.mas_equalTo(16.0f);
    }];
    [self.firstNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstTitleLabel);
        make.right.equalTo(self.firstTitleLabel);
        make.top.equalTo(self.firstTitleLabel.mas_bottom).offset(20.0f);
    }];
    
    [self.secondTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(self.firstNoticeLabel.mas_bottom).offset(28.0f);
        make.height.mas_equalTo(16.0f);
    }];
    [self.secondNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.secondTitleLabel);
        make.right.equalTo(self.secondTitleLabel);
        make.top.equalTo(self.secondTitleLabel.mas_bottom).offset(20.0f);
    }];
    
    [self.thirdTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(self.secondNoticeLabel.mas_bottom).offset(28.0f);
        make.height.mas_equalTo(16.0f);
    }];
    [self.thirdNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.thirdTitleLabel);
        make.right.equalTo(self.thirdTitleLabel);
        make.top.equalTo(self.thirdTitleLabel.mas_bottom).offset(20.0f);
    }];
    
    [self.keystoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.thirdNoticeLabel);
        make.right.equalTo(self.thirdNoticeLabel);
        make.top.equalTo(self.thirdNoticeLabel.mas_bottom).offset(28.0f);
    }];
    [self.keystoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.keystoreView).insets(UIEdgeInsetsMake(20.0f, 12.0f, 20.0f, 12.0f));
    }];
    [self.keystoreCopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.keystoreView);
        make.right.equalTo(self.keystoreView);
        make.top.equalTo(self.keystoreView.mas_bottom).offset(20.0f);
        make.height.mas_equalTo(46.0f);
    }];
}

- (UILabel *)firstTitleLabel {
    if (!_firstTitleLabel) {
        _firstTitleLabel = [JLUIFactory labelInitText:@"离线保存" font:kFontPingFangSCMedium(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _firstTitleLabel;
}

- (UILabel *)firstNoticeLabel {
    if (!_firstNoticeLabel) {
        _firstNoticeLabel = [JLUIFactory labelInitText:@"请复制粘贴Keystore文件到安全、离线的地方保存。切勿保存至邮箱、记事本、网盘、聊天工具等，非常危险。" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 7.0f;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_firstNoticeLabel.text];
        [attr addAttributes:@{NSParagraphStyleAttributeName: paragraph} range:NSMakeRange(0, _firstNoticeLabel.text.length)];
        _firstNoticeLabel.attributedText = attr;
    }
    return _firstNoticeLabel;
}

- (UILabel *)secondTitleLabel {
    if (!_secondTitleLabel) {
        _secondTitleLabel = [JLUIFactory labelInitText:@"请勿使用网络传输" font:kFontPingFangSCMedium(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _secondTitleLabel;
}

- (UILabel *)secondNoticeLabel {
    if (!_secondNoticeLabel) {
        _secondNoticeLabel = [JLUIFactory labelInitText:@"请勿通过网络工具传输Keystore文件，一旦被黑客获取将造成不可挽回的资产损失。建议离线设备通过扫二维码方式传输。" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 7.0f;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_secondNoticeLabel.text];
        [attr addAttributes:@{NSParagraphStyleAttributeName: paragraph} range:NSMakeRange(0, _secondNoticeLabel.text.length)];
        _secondNoticeLabel.attributedText = attr;
    }
    return _secondNoticeLabel;
}

- (UILabel *)thirdTitleLabel {
    if (!_thirdTitleLabel) {
        _thirdTitleLabel = [JLUIFactory labelInitText:@"密码保险箱保存" font:kFontPingFangSCMedium(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _thirdTitleLabel;
}

- (UILabel *)thirdNoticeLabel {
    if (!_thirdNoticeLabel) {
        _thirdNoticeLabel = [JLUIFactory labelInitText:@"如需在线保存，则建议使用安全等级更高的1Password等密码保管软件保存Keystore。" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 7.0f;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_thirdNoticeLabel.text];
        [attr addAttributes:@{NSParagraphStyleAttributeName: paragraph} range:NSMakeRange(0, _thirdNoticeLabel.text.length)];
        _thirdNoticeLabel.attributedText = attr;
    }
    return _thirdNoticeLabel;
}

- (UIView *)keystoreView {
    if (!_keystoreView) {
        _keystoreView = [[UIView alloc] init];
        _keystoreView.backgroundColor = JL_color_gray_F3F3F3;
    }
    return _keystoreView;
}

- (UILabel *)keystoreLabel {
    if (!_keystoreLabel) {
        _keystoreLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(12.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 10.0f;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_keystoreLabel.text];
        [attr addAttributes:@{NSParagraphStyleAttributeName: paragraph} range:NSMakeRange(0, _keystoreLabel.text.length)];
        _keystoreLabel.attributedText = attr;
    }
    return _keystoreLabel;
}

- (UIButton *)keystoreCopyBtn {
    if (!_keystoreCopyBtn) {
        _keystoreCopyBtn = [JLUIFactory buttonInitTitle:@"复制Keystore" titleColor:JL_color_white_ffffff backgroundColor:JL_color_mainColor font:kFontPingFangSCRegular(17.0f) addTarget:self action:@selector(keystoreCopyBtnClick)];
        ViewBorderRadius(_keystoreCopyBtn, 23.0f, 0.0f, JL_color_clear);
    }
    return _keystoreCopyBtn;
}

- (void)keystoreCopyBtnClick {
    [UIPasteboard generalPasteboard].string = self.keystoreLabel.text;
    [[JLLoading sharedLoading] showMBSuccessTipMessage:@"复制成功" hideTime:KToastDismissDelayTimeInterval];
}

- (void)setRestoreData:(NSString *)restoreData {
    self.keystoreLabel.text = restoreData;
}

@end
