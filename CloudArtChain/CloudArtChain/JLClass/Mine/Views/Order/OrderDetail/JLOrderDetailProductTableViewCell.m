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
@property (nonatomic, strong) UILabel *authorNameLabel;
@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *certifyAddressLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *noteTitleLabel;
@property (nonatomic, strong) UILabel *noteLabel;
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
    [self.shadowView addSubview:self.priceLabel];
    [self.shadowView addSubview:self.noteTitleLabel];
    [self.shadowView addSubview:self.noteLabel];
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
    [self.authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).offset(15.0f);
        make.top.equalTo(self.productImageView.mas_top);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-13.0f);
        make.centerY.equalTo(self.authorNameLabel.mas_centerY);
    }];
    [self.productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.authorNameLabel.mas_left);
        make.centerY.equalTo(self.productImageView.mas_centerY);
    }];
    [self.certifyAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.authorNameLabel.mas_left);
        make.bottom.equalTo(self.productImageView.mas_bottom);
    }];
    [self.noteTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_left);
        make.top.equalTo(self.productImageView.mas_bottom).offset(25.0f);
        make.width.mas_equalTo(80.0f);
    }];
    [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.noteTitleLabel.mas_right);
        make.top.equalTo(self.productImageView.mas_bottom).offset(25.0f);
        make.right.mas_equalTo(-13.0f);
    }];
    [self.totalPriceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.noteTitleLabel.mas_left);
        make.top.equalTo(self.noteLabel.mas_bottom).offset(23.0f);
        make.width.mas_equalTo(80.0f);
    }];
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalPriceTitleLabel.mas_right);
        make.top.equalTo(self.noteLabel.mas_bottom).offset(23.0f);
        make.bottom.mas_equalTo(-16.0f);
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
        _productImageView.backgroundColor = [UIColor randomColor];
        ViewBorderRadius(_productImageView, 5.0f, 0.0f, JL_color_clear);
    }
    return _productImageView;
}

- (UILabel *)authorNameLabel {
    if (!_authorNameLabel) {
        _authorNameLabel = [JLUIFactory labelInitText:@"伍静" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _authorNameLabel;
}

- (UILabel *)productNameLabel {
    if (!_productNameLabel) {
        _productNameLabel = [JLUIFactory labelInitText:@"金葡萄" font:kFontPingFangSCMedium(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _productNameLabel;
}

- (UILabel *)certifyAddressLabel {
    if (!_certifyAddressLabel) {
        _certifyAddressLabel = [JLUIFactory labelInitText:@"证书地址：00000010111..." font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_999999 textAlignment:NSTextAlignmentLeft];
    }
    return _certifyAddressLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [JLUIFactory labelInitText:@"¥950" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentRight];
    }
    return _priceLabel;
}

- (UILabel *)noteTitleLabel {
    if (!_noteTitleLabel) {
        _noteTitleLabel = [JLUIFactory labelInitText:@"留言备注：" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _noteTitleLabel;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [JLUIFactory labelInitText:@"请发顺丰，可以到付" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
        _noteLabel.numberOfLines = 0;
    }
    return _noteLabel;
}

- (UILabel *)totalPriceTitleLabel {
    if (!_totalPriceTitleLabel) {
        _totalPriceTitleLabel = [JLUIFactory labelInitText:@"商品总价：" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _totalPriceTitleLabel;
}

- (UILabel *)totalPriceLabel {
    if (!_totalPriceLabel) {
        _totalPriceLabel = [JLUIFactory labelInitText:@"¥950" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_red_D70000 textAlignment:NSTextAlignmentLeft];
    }
    return _totalPriceLabel;
}

@end
