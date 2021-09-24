//
//  JLExportKeystoreQRCodeView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/4.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLExportKeystoreQRCodeView.h"
#import <SGQRCode/SGQRCode.h>

@interface JLExportKeystoreQRCodeView ()
@property (nonatomic, strong) UILabel *firstTitleLabel;
@property (nonatomic, strong) UILabel *firstNoticeLabel;
@property (nonatomic, strong) UILabel *secondTitleLabel;
@property (nonatomic, strong) UILabel *secondNoticeLabel;
@property (nonatomic, strong) UIView *qrCodeView;
@property (nonatomic, strong) UIImageView *qrCodeImageView;
@property (nonatomic, strong) UIView *qrCodeCoverView;
@end

@implementation JLExportKeystoreQRCodeView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.frame;
    frame.size.height = self.qrCodeView.frameBottom;
    self.frame = frame;
}

- (void)createSubViews {
    [self addSubview:self.firstTitleLabel];
    [self addSubview:self.firstNoticeLabel];
    [self addSubview:self.secondTitleLabel];
    [self addSubview:self.secondNoticeLabel];
    [self addSubview:self.qrCodeView];
    [self.qrCodeView addSubview:self.qrCodeCoverView];
    
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
    [self.qrCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondNoticeLabel.mas_bottom).offset(50.0f);
        make.width.mas_equalTo(260.0f);
        make.height.mas_equalTo(260.0f);
        make.centerX.equalTo(self.mas_centerX);
    }];
    [self.qrCodeCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.qrCodeView);
    }];
}

- (UILabel *)firstTitleLabel {
    if (!_firstTitleLabel) {
        _firstTitleLabel = [JLUIFactory labelInitText:@"仅供直接扫描" font:kFontPingFangSCMedium(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _firstTitleLabel;
}

- (UILabel *)firstNoticeLabel {
    if (!_firstNoticeLabel) {
        _firstNoticeLabel = [JLUIFactory labelInitText:@"二维码禁止保存、截图、以及拍照。仅供用户在安全环境下直接扫描来方便的导入钱包。" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
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
        _secondTitleLabel = [JLUIFactory labelInitText:@"在安全环境下使用" font:kFontPingFangSCMedium(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _secondTitleLabel;
}

- (UILabel *)secondNoticeLabel {
    if (!_secondNoticeLabel) {
        _secondNoticeLabel = [JLUIFactory labelInitText:@"请在确保四周无人及无摄像头的情况下使用。二维码一旦被他人获取将造成不可挽回的资产损失" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 7.0f;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_secondNoticeLabel.text];
        [attr addAttributes:@{NSParagraphStyleAttributeName: paragraph} range:NSMakeRange(0, _secondNoticeLabel.text.length)];
        _secondNoticeLabel.attributedText = attr;
    }
    return _secondNoticeLabel;
}

- (UIView *)qrCodeView {
    if (!_qrCodeView) {
        _qrCodeView = [[UIView alloc] init];
        _qrCodeView.backgroundColor = JL_color_gray_EEEEEE;
        [_qrCodeView addSubview:self.qrCodeImageView];
        [self.qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(250);
            make.center.equalTo(_qrCodeView);
        }];
    }
    return _qrCodeView;
}

- (UIImageView *)qrCodeImageView {
    if (!_qrCodeImageView) {
        _qrCodeImageView = [[UIImageView alloc] init];
    }
    return _qrCodeImageView;
}

- (UIView *)qrCodeCoverView {
    if (!_qrCodeCoverView) {
        _qrCodeCoverView = [[UIView alloc] init];
        _qrCodeCoverView.backgroundColor = JL_color_other_4C5B86;
        
        UIImageView *maskImageView = [JLUIFactory imageViewInitImageName:@"icon_wallet_keystore_safe"];
        [_qrCodeCoverView addSubview:maskImageView];
        
        UILabel *noticeLabel = [JLUIFactory labelInitText:@"已确认周围无人及摄像头" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_white_ffffff textAlignment:NSTextAlignmentCenter];
        [_qrCodeCoverView addSubview:noticeLabel];
        
        UIButton *showQRCodeBtn = [JLUIFactory buttonInitTitle:@"显示二维码" titleColor:JL_color_white_ffffff backgroundColor:JL_color_blue_50C3FF font:kFontPingFangSCRegular(15.0f) addTarget:self action:@selector(showQRCodeBtnClick)];
        ViewBorderRadius(showQRCodeBtn, 17.0f, 0.0f, JL_color_clear);
        [_qrCodeCoverView addSubview:showQRCodeBtn];
        
        [maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(24.0f);
            make.width.mas_equalTo(99.0f);
            make.height.mas_equalTo(102.0f);
            make.centerX.equalTo(_qrCodeCoverView.mas_centerX);
        }];
        [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_qrCodeCoverView);
            make.top.equalTo(maskImageView.mas_bottom);
            make.height.mas_equalTo(46.0f);
        }];
        [showQRCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(noticeLabel.mas_bottom).offset(4.0f);
            make.width.mas_equalTo(120.0f);
            make.height.mas_equalTo(34.0f);
            make.centerX.equalTo(_qrCodeCoverView.mas_centerX);
        }];
    }
    return _qrCodeCoverView;
}

- (void)showQRCodeBtnClick {
    [self.qrCodeCoverView removeFromSuperview];
}

- (void)setRestoreData:(NSString *)restoreData {
    UIImage * img = [SGQRCodeObtain generateQRCodeWithData:restoreData size:250];
    self.qrCodeImageView.image = img;
}

@end
