//
//  JLArtDetailView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/1.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLArtDetailView.h"

@interface JLArtDetailView ()
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIView *chainView;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *signTimesLabel;
@property (nonatomic, strong) UIButton *certificateBtn;
@end

@implementation JLArtDetailView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.infoView];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = JL_color_gray_DDDDDD;
    [self addSubview:lineView];
    [self addSubview:self.chainView];
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(78.0f);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.infoView.mas_bottom);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(1.0f);
    }];
    [self.chainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.bottom.right.equalTo(self);
    }];
    
    [self.infoView addSubview:self.nameLabel];
    [self.infoView addSubview:self.priceLabel];
    [self.infoView addSubview:self.infoLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(12.0f);
        make.height.mas_equalTo(25.0f);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-19.0f);
        make.height.mas_equalTo(25.0f);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.bottom.right.equalTo(self.infoView);
    }];
    
    UILabel *chainInfoTitleLabel = [JLUIFactory labelInitText:@"区块链信息" font:kFontPingFangSCSCSemibold(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    [self.chainView addSubview:chainInfoTitleLabel];
    [self.chainView addSubview:self.addressLabel];
    
    UIButton *copyAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [copyAddressBtn setTitle:@"复制" forState:UIControlStateNormal];
    [copyAddressBtn setTitleColor:JL_color_blue_38B2F1 forState:UIControlStateNormal];
    copyAddressBtn.titleLabel.font = kFontPingFangSCRegular(12.0f);
    [copyAddressBtn addTarget:self action:@selector(copyAddressBtnClick) forControlEvents:UIControlEventTouchUpInside];
    ViewBorderRadius(copyAddressBtn, 5.0f, 1.0f, JL_color_blue_38B2F1);
    [self.chainView addSubview:copyAddressBtn];
    
    self.certificateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.certificateBtn setImage:[UIImage imageNamed:@"cer-bg"] forState:UIControlStateNormal];
    [self.certificateBtn addTarget:self action:@selector(certificateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.chainView addSubview:self.certificateBtn];
    
    [self.chainView addSubview:self.signTimesLabel];
    
    [chainInfoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(19.0f);
        make.height.mas_equalTo(16.0f);
    }];
    [self.certificateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-25.0f);
        make.width.mas_equalTo(27.0f);
        make.height.mas_equalTo(20.0f);
        make.centerY.equalTo(self.chainView.mas_centerY);
    }];
    [copyAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.certificateBtn.mas_left).offset(-20.0f);
        make.width.mas_equalTo(33.0f);
        make.height.mas_equalTo(18.0f);
        make.centerY.equalTo(self.certificateBtn.mas_centerY);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.equalTo(copyAddressBtn.mas_left).offset(-15.0f);
        make.height.mas_equalTo(14.0f);
        make.centerY.equalTo(self.certificateBtn.mas_centerY);
    }];
    [self.signTimesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(13.0f);
        make.height.mas_equalTo(14.0f);
    }];
}

- (void)copyAddressBtnClick {
    [UIPasteboard generalPasteboard].string = self.artDetailData.item_hash;
    [[JLLoading sharedLoading] showMBSuccessTipMessage:@"复制成功" hideTime:KToastDismissDelayTimeInterval];
}

- (void)certificateBtnClick {
    if (self.chainCertificateBlock) {
        self.chainCertificateBlock(self.certificateImage);
    }
}

- (UIView *)infoView {
    if (!_infoView) {
        _infoView = [[UIView alloc] init];
    }
    return _infoView;
}

- (UIView *)chainView {
    if (!_chainView) {
        _chainView = [[UIView alloc] init];
    }
    return _chainView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCSCSemibold(19.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(17.0f) textColor:JL_color_red_D70000 textAlignment:NSTextAlignmentRight];
    }
    return _priceLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _infoLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [JLUIFactory labelInitText:@"证书地址：" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _addressLabel;
}

- (UILabel *)signTimesLabel {
    if (!_signTimesLabel) {
        _signTimesLabel = [JLUIFactory labelInitText:@"作品签名次数：0次" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _signTimesLabel;
}

- (void)setArtDetailData:(Model_art_Detail_Data *)artDetailData {
    _artDetailData = artDetailData;
    self.nameLabel.text = artDetailData.name;
    self.priceLabel.text = [NSString stringWithFormat:@"%@UART", artDetailData.price];
    self.infoLabel.text = [NSString stringWithFormat:@"%@，%@x%@cm", [[AppSingleton sharedAppSingleton] getMaterialByID:@(artDetailData.material_id).stringValue], artDetailData.size_width, artDetailData.size_length];
    self.addressLabel.text = [NSString stringWithFormat:@"证书地址：%@", artDetailData.item_hash];
    self.signTimesLabel.text = [NSString stringWithFormat:@"作品签名次数：%ld次", artDetailData.signature_count];
}

- (void)setCertificateImage:(UIImage *)certificateImage {
    _certificateImage = certificateImage;
//    [self.certificateBtn setImage:certificateImage forState:UIControlStateNormal];
}

@end
