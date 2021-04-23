//
//  JLOrderDetailProductTableViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/29.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLOrderDetailProductTableViewCell.h"

@interface JLOrderDetailProductTableViewCell ()
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIImageView *shadowImageView;
@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *authorNameLabel;
@property (nonatomic, strong) UILabel *certifyAddressLabel;

@property (nonatomic, strong) UILabel *numTitleLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *totalPriceTitleLabel;
@property (nonatomic, strong) UILabel *totalPriceLabel;
@end

@implementation JLOrderDetailProductTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.shadowView];
    [self.shadowView addSubview:self.shadowImageView];
    [self.shadowView addSubview:self.productImageView];
    [self.shadowView addSubview:self.authorNameLabel];
    [self.shadowView addSubview:self.productNameLabel];
    [self.shadowView addSubview:self.certifyAddressLabel];

    [self.shadowView addSubview:self.numTitleLabel];
    [self.shadowView addSubview:self.numLabel];
    [self.shadowView addSubview:self.totalPriceTitleLabel];
    [self.shadowView addSubview:self.totalPriceLabel];
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(5.0f);
        make.bottom.mas_equalTo(-5.0f);
    }];
    [self.shadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.shadowView);
    }];
    [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.0f);
        make.top.mas_equalTo(23.0f);
        make.width.mas_equalTo(102.0f);
        make.height.mas_equalTo(76.0f);
    }];
    [self.productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).offset(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(self.productImageView.mas_top);
    }];
    [self.authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productNameLabel.mas_left);
        make.centerY.equalTo(self.productImageView.mas_centerY);
    }];
    [self.certifyAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productNameLabel.mas_left);
        make.bottom.equalTo(self.productImageView.mas_bottom);
        make.right.mas_equalTo(-70.0f);
    }];
    
    [self.numTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_left);
        make.top.equalTo(self.productImageView.mas_bottom).offset(20.0f);
        make.width.mas_equalTo(80.0f);
        make.height.mas_equalTo(35.0f);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numTitleLabel.mas_right);
        make.top.equalTo(self.numTitleLabel.mas_top);
        make.right.mas_equalTo(-25.0f);
        make.height.mas_equalTo(self.numTitleLabel);
    }];
    [self.totalPriceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numTitleLabel.mas_left);
        make.top.equalTo(self.numTitleLabel.mas_bottom);
        make.width.mas_equalTo(80.0f);
        make.height.mas_equalTo(35.0f);
    }];
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalPriceTitleLabel.mas_right);
        make.top.equalTo(self.totalPriceTitleLabel.mas_top);
        make.right.mas_equalTo(-25.0f);
        make.height.mas_equalTo(35.0f);
        make.bottom.mas_equalTo(-8.0f);
    }];
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
    }
    return _shadowView;
}

- (UIImageView *)shadowImageView {
    if (!_shadowImageView) {
        _shadowImageView = [JLUIFactory imageViewInitImageName:@"icon_address_back"];
    }
    return _shadowImageView;
}

- (UIImageView *)productImageView {
    if (!_productImageView) {
        _productImageView = [[UIImageView alloc] init];
        ViewBorderRadius(_productImageView, 5.0f, 0.0f, JL_color_clear);
    }
    return _productImageView;
}


- (UILabel *)productNameLabel {
    if (!_productNameLabel) {
        _productNameLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCMedium(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _productNameLabel;
}

- (UILabel *)authorNameLabel {
    if (!_authorNameLabel) {
        _authorNameLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _authorNameLabel;
}

- (UILabel *)certifyAddressLabel {
    if (!_certifyAddressLabel) {
        _certifyAddressLabel = [JLUIFactory labelInitText:@"NFT地址：" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_999999 textAlignment:NSTextAlignmentLeft];
        _certifyAddressLabel.numberOfLines = 1;
    }
    return _certifyAddressLabel;
}

- (UILabel *)numTitleLabel {
    if (!_numTitleLabel) {
        _numTitleLabel = [JLUIFactory labelInitText:@"商品数量：" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _numTitleLabel;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [JLUIFactory labelInitText:@"10份" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentRight];
    }
    return _numLabel;
}

- (UILabel *)totalPriceTitleLabel {
    if (!_totalPriceTitleLabel) {
        _totalPriceTitleLabel = [JLUIFactory labelInitText:@"商品总价：" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _totalPriceTitleLabel;
}

- (UILabel *)totalPriceLabel {
    if (!_totalPriceLabel) {
        _totalPriceLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_red_D70000 textAlignment:NSTextAlignmentRight];
    }
    return _totalPriceLabel;
}

- (void)setOrderData:(Model_arts_sold_Data *)orderData {
    if (![NSString stringIsEmpty:orderData.art.img_main_file1[@"url"]]) {
        [self.productImageView sd_setImageWithURL:[NSURL URLWithString:orderData.art.img_main_file1[@"url"]]];
    }
    self.authorNameLabel.text = [NSString stringIsEmpty:orderData.art.author.display_name] ? @"" : orderData.art.author.display_name;
    self.productNameLabel.text = orderData.art.name;
    self.certifyAddressLabel.text = [NSString stringIsEmpty:orderData.art.item_hash] ? @"NFT地址：" : orderData.art.item_hash;
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%@", orderData.amount];
}
@end
