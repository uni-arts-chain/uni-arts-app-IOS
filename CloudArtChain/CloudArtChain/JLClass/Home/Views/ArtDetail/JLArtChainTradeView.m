//
//  JLArtChainTradeView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/23.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLArtChainTradeView.h"
#import "NSDate+Extension.h"

@interface JLArtChainTradeView ()
@property (nonatomic, strong) UIView *chainView;
@property (nonatomic, strong) UILabel *chainInfoTitleLabel;
@property (nonatomic, strong) UILabel *royaltyTitleLabel;
@property (nonatomic, strong) UILabel *royaltyLabel;
@property (nonatomic, strong) UILabel *royaltyDateTitleLabel;
@property (nonatomic, strong) UILabel *royaltyDateLabel;
@property (nonatomic, strong) UILabel *addressTitleLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *publishNumTitleLabel;
@property (nonatomic, strong) UILabel *publishNumLabel;
@property (nonatomic, strong) UILabel *lastPriceTitleLabel;
@property (nonatomic, strong) UILabel *lastPriceLabel;
@property (nonatomic, strong) UILabel *historyPriceTitleLabel;
@property (nonatomic, strong) UILabel *historyPriceLabel;
@property (nonatomic, strong) UIView *certificateBgView;
@property (nonatomic, strong) UIImageView *certificateImgView;
@end

@implementation JLArtChainTradeView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.chainView];
    [self.chainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.bottom.right.equalTo(self);
    }];
    
    [self.chainView addSubview:self.chainInfoTitleLabel];
    [self.chainView addSubview:self.royaltyTitleLabel];
    [self.chainView addSubview:self.royaltyLabel];
    [self.chainView addSubview:self.royaltyDateTitleLabel];
    [self.chainView addSubview:self.royaltyDateLabel];
    [self.chainView addSubview:self.addressTitleLabel];
    [self.chainView addSubview:self.addressLabel];
    [self.chainView addSubview:self.publishNumTitleLabel];
    [self.chainView addSubview:self.publishNumLabel];
    [self.chainView addSubview:self.lastPriceTitleLabel];
    [self.chainView addSubview:self.lastPriceLabel];
    [self.chainView addSubview:self.historyPriceTitleLabel];
    [self.chainView addSubview:self.historyPriceLabel];
    [self.chainView addSubview:self.certificateBgView];
    [self.chainView addSubview:self.certificateImgView];
    
    [self.chainInfoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.0f);
        make.top.mas_equalTo(10.0f);
        make.height.mas_equalTo(34.0f);
    }];
    [self.royaltyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chainInfoTitleLabel.mas_bottom);
        make.left.mas_equalTo(15.0f);
        make.height.mas_equalTo(25.0f);
    }];
    [self.royaltyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.royaltyTitleLabel);
        make.left.mas_equalTo(115.0f);
        make.right.mas_equalTo(-32.0f);
    }];
    [self.royaltyDateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.royaltyTitleLabel.mas_bottom);
        make.height.mas_equalTo(25.0f);
    }];
    [self.royaltyDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.royaltyDateTitleLabel);
        make.left.mas_equalTo(115.0f);
        make.right.mas_equalTo(-32.0f);
    }];
    [self.addressTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.royaltyDateTitleLabel.mas_bottom);
        make.height.mas_equalTo(25.0f);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addressTitleLabel);
        make.left.mas_equalTo(115.0f);
        make.right.mas_equalTo(-64.0f);
    }];
    [self.publishNumTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.addressTitleLabel.mas_bottom);
        make.height.mas_equalTo(25.0f);
    }];
    [self.publishNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.publishNumTitleLabel);
        make.left.mas_equalTo(115.0f);
        make.right.mas_equalTo(-32.0f);
    }];
    [self.lastPriceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.publishNumTitleLabel.mas_bottom);
        make.height.mas_equalTo(25.0f);
    }];
    [self.lastPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lastPriceTitleLabel);
        make.left.mas_equalTo(115.0f);
        make.right.mas_equalTo(-32.0f);
    }];
    [self.historyPriceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.lastPriceTitleLabel.mas_bottom);
        make.height.mas_equalTo(25.0f);
    }];
    [self.historyPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.historyPriceTitleLabel);
        make.left.mas_equalTo(115.0f);
        make.right.mas_equalTo(-32.0f);
    }];
    [self.certificateBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20.0f);
        make.centerY.equalTo(self.addressLabel);
    }];
    [self.certificateImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.certificateBgView).offset(-20);
        make.top.equalTo(self.certificateBgView).offset(10.0f);
        make.left.equalTo(self.certificateBgView);
        make.bottom.equalTo(self.certificateBgView).offset(-10.0f);
        make.size.mas_equalTo(CGSizeMake(16.0f, 20.0f));
    }];
}

- (UIView *)chainView {
    if (!_chainView) {
        _chainView = [[UIView alloc] init];
    }
    return _chainView;
}

- (UILabel *)chainInfoTitleLabel {
    if (!_chainInfoTitleLabel) {
        _chainInfoTitleLabel = [JLUIFactory labelInitText:@"数字信息" font:kFontPingFangSCSCSemibold(16.0f) textColor:JL_color_black_101220 textAlignment:NSTextAlignmentLeft];
    }
    return _chainInfoTitleLabel;
}

- (UILabel *)royaltyTitleLabel {
    if (!_royaltyTitleLabel) {
        _royaltyTitleLabel = [JLUIFactory labelInitText:@"版税比例" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_87888F textAlignment:NSTextAlignmentLeft];
    }
    return _royaltyTitleLabel;
}

- (UILabel *)royaltyLabel {
    if (!_royaltyLabel) {
        _royaltyLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_black_40414D textAlignment:NSTextAlignmentLeft];
        _royaltyLabel.numberOfLines = 1;
        _royaltyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _royaltyLabel;
}

- (UILabel *)royaltyDateTitleLabel {
    if (!_royaltyDateTitleLabel) {
        _royaltyDateTitleLabel = [JLUIFactory labelInitText:@"版税有效期" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_87888F textAlignment:NSTextAlignmentLeft];
    }
    return _royaltyDateTitleLabel;
}

- (UILabel *)royaltyDateLabel {
    if (!_royaltyDateLabel) {
        _royaltyDateLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_black_40414D textAlignment:NSTextAlignmentLeft];
        _royaltyDateLabel.numberOfLines = 1;
        _royaltyDateLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _royaltyDateLabel;
}

- (UILabel *)addressTitleLabel {
    if (!_addressTitleLabel) {
        _addressTitleLabel = [JLUIFactory labelInitText:@"识别码" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_87888F textAlignment:NSTextAlignmentLeft];
    }
    return _addressTitleLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_black_40414D textAlignment:NSTextAlignmentLeft];
        _addressLabel.numberOfLines = 1;
        _addressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _addressLabel;
}

- (UILabel *)publishNumTitleLabel {
    if (!_publishNumTitleLabel) {
        _publishNumTitleLabel = [JLUIFactory labelInitText:@"总发行份数" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_87888F textAlignment:NSTextAlignmentLeft];
    }
    return _publishNumTitleLabel;
}

- (UILabel *)publishNumLabel {
    if (!_publishNumLabel) {
        _publishNumLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_black_40414D textAlignment:NSTextAlignmentLeft];
        _publishNumLabel.numberOfLines = 1;
        _publishNumLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _publishNumLabel;
}

- (UILabel *)lastPriceTitleLabel {
    if (!_lastPriceTitleLabel) {
        _lastPriceTitleLabel = [JLUIFactory labelInitText:@"上次成交价格" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_87888F textAlignment:NSTextAlignmentLeft];
        _lastPriceTitleLabel.hidden = YES;
    }
    return _lastPriceTitleLabel;
}

- (UILabel *)lastPriceLabel {
    if (!_lastPriceLabel) {
        _lastPriceLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_black_40414D textAlignment:NSTextAlignmentLeft];
        _lastPriceLabel.hidden = YES;
        _lastPriceLabel.numberOfLines = 1;
        _lastPriceLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _lastPriceLabel;
}

- (UILabel *)historyPriceTitleLabel {
    if (!_historyPriceTitleLabel) {
        _historyPriceTitleLabel = [JLUIFactory labelInitText:@"历史最高价格" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_87888F textAlignment:NSTextAlignmentLeft];
        _historyPriceTitleLabel.hidden = YES;
    }
    return _historyPriceTitleLabel;
}

- (UILabel *)historyPriceLabel {
    if (!_historyPriceLabel) {
        _historyPriceLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_black_40414D textAlignment:NSTextAlignmentLeft];
        _historyPriceLabel.hidden = YES;
        _historyPriceLabel.numberOfLines = 1;
        _historyPriceLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _historyPriceLabel;
}

- (UIView *)certificateBgView {
    if (!_certificateBgView) {
        _certificateBgView = [[UIView alloc] init];
        _certificateBgView.userInteractionEnabled = YES;
        [_certificateBgView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(certificateBgViewDidTap:)]];
    }
    return _certificateBgView;
}

- (UIImageView *)certificateImgView {
    if (!_certificateImgView) {
        _certificateImgView = [[UIImageView alloc] init];
        _certificateImgView.image = [UIImage imageNamed:@"certificate_thumbnail"];
    }
    return _certificateImgView;
}

- (void)certificateBgViewDidTap: (UITapGestureRecognizer *)ges {
    if (_showCertificateBlock) {
        _showCertificateBlock();
    }
}

- (void)setArtDetailData:(Model_art_Detail_Data *)artDetailData {
    _artDetailData = artDetailData;
    if (![NSString stringIsEmpty:artDetailData.royalty]) {
        NSDecimalNumber *royaltyNumber = [NSDecimalNumber decimalNumberWithString:artDetailData.royalty];
        NSDecimalNumber *persentRoyaltyNumber = [royaltyNumber decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
        self.royaltyLabel.text = [NSString stringWithFormat:@"%@%%", persentRoyaltyNumber.stringValue];
        
        if ([NSString stringIsEmpty:artDetailData.royalty_expired_at]) {
            self.royaltyDateLabel.text = @"永久";
        }
    }
    if (![NSString stringIsEmpty:artDetailData.royalty_expired_at]) {
        NSDate *royaltyDate = [NSDate dateWithTimeIntervalSince1970:artDetailData.royalty_expired_at.doubleValue];
        self.royaltyDateLabel.text = [royaltyDate dateWithCustomFormat:@"yyyy-MM-dd"];
    }
    self.addressLabel.text = [NSString stringIsEmpty:artDetailData.item_hash] ? @"" : artDetailData.item_hash;
    self.publishNumLabel.text = [NSString stringWithFormat:@"%ld 份", artDetailData.total_amount];
    
    if (self.marketLevel == 0 || self.marketLevel == 2) {
        self.lastPriceTitleLabel.hidden = NO;
        self.lastPriceLabel.hidden = NO;
        self.historyPriceTitleLabel.hidden = NO;
        self.historyPriceLabel.hidden = NO;
        self.lastPriceLabel.text= [NSString stringWithFormat:@"￥ %@", artDetailData.price];
        self.historyPriceLabel.text = [NSString stringWithFormat:@"￥ %@", artDetailData.ath_price];
    }
}
@end
