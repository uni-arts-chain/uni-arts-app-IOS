//
//  JLOrderDetailProductBottomPriceTableViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/4.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLOrderDetailProductBottomPriceTableViewCell.h"
#import "JLStepper.h"

@interface JLOrderDetailProductBottomPriceTableViewCell ()
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) UILabel *authorNameLabel;
@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *certifyAddressLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *numTitleLabel;
@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIView *lineView1;
@property (nonatomic, strong) UILabel *totalPriceTitleLabel;
@property (nonatomic, strong) UILabel *totalPriceLabel;
@property (nonatomic, strong) UIView *lineView2;
@property (nonatomic, strong) UILabel *royaltyTitleLabel;
@property (nonatomic, strong) UILabel *royaltyLabel;

@property (nonatomic, strong) Model_arts_id_orders_Data *sellingOrderData;
@property (nonatomic, strong) Model_art_Detail_Data *artDetailData;
@end

@implementation JLOrderDetailProductBottomPriceTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = JL_color_vcBgColor;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.shadowView];
    [self.shadowView addSubview:self.titleLabel];
    [self.shadowView addSubview:self.productImageView];
    [self.shadowView addSubview:self.productNameLabel];
    [self.shadowView addSubview:self.authorNameLabel];
    [self.shadowView addSubview:self.certifyAddressLabel];
    [self.shadowView addSubview:self.numTitleLabel];
    [self.shadowView addSubview:self.balanceLabel];
    [self.shadowView addSubview:self.numLabel];
    [self.shadowView addSubview:self.totalPriceTitleLabel];
    [self.shadowView addSubview:self.totalPriceLabel];
    [self.shadowView addSubview:self.royaltyTitleLabel];
    [self.shadowView addSubview:self.royaltyLabel];
    
    [self.shadowView addSubview:self.lineView];
    [self.shadowView addSubview:self.lineView1];
    [self.shadowView addSubview:self.lineView2];
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-12.0f);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shadowView).offset(12.0f);
        make.right.equalTo(self.shadowView).offset(-12.0f);
        make.top.equalTo(self.shadowView).offset(16.0f);
    }];
    [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shadowView).offset(12.0f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(17.0f);
        make.width.mas_equalTo(56.0f);
        make.height.mas_equalTo(56.0f);
    }];
    [self.productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).offset(12.0f);
        make.top.equalTo(self.productImageView.mas_top).offset(-3.0f);
        make.right.equalTo(self.shadowView).offset(-12.0f);
    }];
    [self.authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productNameLabel.mas_left);
        make.right.equalTo(self.shadowView).offset(-12.0f);
        make.centerY.equalTo(self.productImageView.mas_centerY).offset(2.0f);
    }];
    [self.certifyAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productNameLabel.mas_left);
        make.bottom.equalTo(self.productImageView.mas_bottom).offset(3.0f);
        make.right.equalTo(self.shadowView).offset(-45.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shadowView).offset(12.0f);
        make.top.equalTo(self.productImageView.mas_bottom).offset(20.0f);
        make.width.mas_equalTo((kScreenWidth - 24.0f));
        make.height.mas_equalTo(@1);
    }];
    [self.numTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_left);
        make.top.equalTo(self.productImageView.mas_bottom).offset(20.0f);
        make.height.mas_equalTo(37.0f);
    }];
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numTitleLabel.mas_right).offset(7.0f);
        make.centerY.equalTo(self.numTitleLabel.mas_centerY);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shadowView).offset(-15.0f);
        make.centerY.equalTo(self.numTitleLabel.mas_centerY);
    }];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numTitleLabel.mas_bottom);
        make.left.equalTo(self.numTitleLabel);
        make.right.equalTo(self.shadowView).offset(-12.0f);
        make.height.mas_equalTo(@1);
    }];
    [self.totalPriceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_left);
        make.top.equalTo(self.numTitleLabel.mas_bottom);
        make.height.mas_equalTo(37.0f);
    }];
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shadowView).offset(-12.0f);
        make.centerY.equalTo(self.totalPriceTitleLabel.mas_centerY);
    }];
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalPriceTitleLabel.mas_bottom);
        make.left.equalTo(self.totalPriceTitleLabel);
        make.right.equalTo(self.shadowView).offset(-12.0f);
        make.height.mas_equalTo(@1);
    }];
    [self.royaltyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_left);
        make.top.equalTo(self.totalPriceTitleLabel.mas_bottom);
        make.height.mas_equalTo(37.0f);
        make.bottom.equalTo(self.shadowView);
    }];
    [self.royaltyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shadowView).offset(-12.0f);
        make.centerY.equalTo(self.royaltyTitleLabel.mas_centerY);
    }];
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = JL_color_white_ffffff;
    }
    return _shadowView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"作品信息" font:kFontPingFangSCSCSemibold(16) textColor:JL_color_black_101220 textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UIImageView *)productImageView {
    if (!_productImageView) {
        _productImageView = [[UIImageView alloc] init];
        _productImageView.contentMode = UIViewContentModeScaleAspectFit;
        ViewBorderRadius(_productImageView, 5.0f, 0.0f, JL_color_clear);
    }
    return _productImageView;
}

- (UILabel *)authorNameLabel {
    if (!_authorNameLabel) {
        _authorNameLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_black_40414D textAlignment:NSTextAlignmentLeft];
        _authorNameLabel.numberOfLines = 1;
        _authorNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _authorNameLabel;
}

- (UILabel *)productNameLabel {
    if (!_productNameLabel) {
        _productNameLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCSCSemibold(15.0f) textColor:JL_color_black_40414D textAlignment:NSTextAlignmentLeft];
        _productNameLabel.numberOfLines = 1;
        _productNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _productNameLabel;
}

- (UILabel *)certifyAddressLabel {
    if (!_certifyAddressLabel) {
        _certifyAddressLabel = [JLUIFactory labelInitText:@"识别码：" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_black_40414D textAlignment:NSTextAlignmentLeft];
        _certifyAddressLabel.numberOfLines = 1;
    }
    return _certifyAddressLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = JL_color_gray_EDEDEE;
    }
    return _lineView;
}

- (UILabel *)numTitleLabel {
    if (!_numTitleLabel) {
        _numTitleLabel = [JLUIFactory labelInitText:@"购买数量" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_87888F textAlignment:NSTextAlignmentLeft];
    }
    return _numTitleLabel;
}

- (UILabel *)balanceLabel {
    if (!_balanceLabel) {
        _balanceLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(11.0f) textColor:JL_color_gray_87888F textAlignment:NSTextAlignmentLeft];
    }
    return _balanceLabel;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [JLUIFactory labelInitText:@"x1" font:kFontPingFangSCRegular(12.0f) textColor:JL_color_black_40414D textAlignment:NSTextAlignmentRight];
    }
    return _numLabel;
}

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = JL_color_gray_EDEDEE;
    }
    return _lineView1;
}

- (UILabel *)totalPriceTitleLabel {
    if (!_totalPriceTitleLabel) {
        _totalPriceTitleLabel = [JLUIFactory labelInitText:@"商品总价" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_87888F textAlignment:NSTextAlignmentLeft];
    }
    return _totalPriceTitleLabel;
}

- (UILabel *)totalPriceLabel {
    if (!_totalPriceLabel) {
        _totalPriceLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_mainColor textAlignment:NSTextAlignmentRight];
    }
    return _totalPriceLabel;
}

- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = JL_color_gray_EDEDEE;
    }
    return _lineView2;
}

- (UILabel *)royaltyTitleLabel {
    if (!_royaltyTitleLabel) {
        _royaltyTitleLabel = [JLUIFactory labelInitText:@"版税（0%）" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_87888F textAlignment:NSTextAlignmentLeft];
    }
    return _royaltyTitleLabel;
}

- (UILabel *)royaltyLabel {
    if (!_royaltyLabel) {
        _royaltyLabel = [JLUIFactory labelInitText:@"¥ 0" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_mainColor textAlignment:NSTextAlignmentRight];
    }
    return _royaltyLabel;
}

- (void)setArtDetailData:(Model_art_Detail_Data *)artDetailData sellingOrderData:(Model_arts_id_orders_Data *)sellingOrderData {
    self.artDetailData = artDetailData;
    self.sellingOrderData = sellingOrderData;
    
    if (![NSString stringIsEmpty:artDetailData.img_main_file1[@"url"]]) {
        [self.productImageView sd_setImageWithURL:[NSURL URLWithString:artDetailData.img_main_file1[@"url"]]];
    }
    self.authorNameLabel.text = [NSString stringIsEmpty:artDetailData.author.display_name] ? @"" : artDetailData.author.display_name;
    self.productNameLabel.text = artDetailData.name;
    self.certifyAddressLabel.text = [NSString stringWithFormat:@"识别码：%@", [NSString stringIsEmpty:artDetailData.item_hash] ? @"" : artDetailData.item_hash];
    
    self.balanceLabel.text = [NSString stringWithFormat:@"剩余: %@", sellingOrderData.amount];
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %@", [NSDecimalNumber decimalNumberWithString:sellingOrderData.price].stringValue];
    if (![NSString stringIsEmpty:artDetailData.royalty]) {
        NSDecimalNumber *royaltyNumber = [NSDecimalNumber decimalNumberWithString:artDetailData.royalty];
        NSDecimalNumber *royaltyPersentNumber = [royaltyNumber decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
        self.royaltyTitleLabel.text = [NSString stringWithFormat:@"版税（%@%%）", royaltyPersentNumber.stringValue];
        
        // [artDetailData.author.ID isEqualToString:sellingOrderData.seller_id]
        if (self.sellingOrderData.need_royalty) {
            NSDecimalNumber *currentRoyaltyNumber = [[NSDecimalNumber decimalNumberWithString:sellingOrderData.price] decimalNumberByMultiplyingBy:royaltyNumber];
            self.royaltyLabel.text = [NSString stringWithFormat:@"¥ %@", [currentRoyaltyNumber roundUpScale:2].stringValue];
        } else {
            self.royaltyLabel.text = @"¥ 0";
        }
    }
}
@end
