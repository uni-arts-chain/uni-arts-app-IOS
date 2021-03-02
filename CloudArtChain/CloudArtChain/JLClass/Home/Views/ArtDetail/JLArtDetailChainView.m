//
//  JLArtDetailChainView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/18.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLArtDetailChainView.h"

@interface JLArtDetailChainView ()
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *signTimesLabel;
@end

@implementation JLArtDetailChainView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    UILabel *chainInfoTitleLabel = [JLUIFactory labelInitText:@"区块链信息" font:kFontPingFangSCSCSemibold(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    [self addSubview:chainInfoTitleLabel];
    [self addSubview:self.addressLabel];
    
    UIButton *copyAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [copyAddressBtn setTitle:@"复制" forState:UIControlStateNormal];
    [copyAddressBtn setTitleColor:JL_color_blue_38B2F1 forState:UIControlStateNormal];
    copyAddressBtn.titleLabel.font = kFontPingFangSCRegular(12.0f);
    [copyAddressBtn addTarget:self action:@selector(copyAddressBtnClick) forControlEvents:UIControlEventTouchUpInside];
    ViewBorderRadius(copyAddressBtn, 5.0f, 1.0f, JL_color_blue_38B2F1);
    [self addSubview:copyAddressBtn];
    
    UIButton *chainQRCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chainQRCodeBtn setImage:[UIImage imageNamed:@"icon_home_artdetail_qrcode"] forState:UIControlStateNormal];
    [chainQRCodeBtn addTarget:self action:@selector(chainQRCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:chainQRCodeBtn];
    
    [self addSubview:self.signTimesLabel];
    
    [chainInfoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(25.0f);
        make.height.mas_equalTo(16.0f);
    }];
    [chainQRCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-25.0f);
        make.size.mas_equalTo(14.0f);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [copyAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(chainQRCodeBtn.mas_left).offset(-20.0f);
        make.width.mas_equalTo(33.0f);
        make.height.mas_equalTo(18.0f);
        make.centerY.equalTo(chainQRCodeBtn.mas_centerY);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.equalTo(copyAddressBtn.mas_left).offset(-15.0f);
        make.height.mas_equalTo(14.0f);
        make.centerY.equalTo(chainQRCodeBtn.mas_centerY);
    }];
    [self.signTimesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(13.0f);
        make.height.mas_equalTo(14.0f);
    }];
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

- (void)copyAddressBtnClick {
    [UIPasteboard generalPasteboard].string = self.artsData.art.item_hash;
    [[JLLoading sharedLoading] showMBSuccessTipMessage:@"复制成功" hideTime:KToastDismissDelayTimeInterval];
}

- (void)chainQRCodeBtnClick {
    if (self.chainQRCodeBlock) {
        self.chainQRCodeBlock(self.addressLabel.text);
    }
}

- (void)setArtsData:(Model_auction_meetings_arts_Data *)artsData {
    _artsData = artsData;
    self.addressLabel.text = [NSString stringWithFormat:@"证书地址：%@", artsData.art.item_hash];
    self.signTimesLabel.text = [NSString stringWithFormat:@"作品签名次数：%ld次", artsData.art.signature_count];
}
@end
