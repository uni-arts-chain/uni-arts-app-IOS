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
@property (nonatomic, strong) UIImageView *shadowImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) UILabel *authorNameLabel;
@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *certifyAddressLabel;
@property (nonatomic, strong) UILabel *numTitleLabel;
@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) JLStepper *numStepper;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *totalPriceTitleLabel;
@property (nonatomic, strong) UILabel *totalPriceLabel;

@property (nonatomic, strong) Model_arts_id_orders_Data *sellingOrderData;
@end

@implementation JLOrderDetailProductBottomPriceTableViewCell
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
    [self.shadowView addSubview:self.titleLabel];
    [self.shadowView addSubview:self.productImageView];
    [self.shadowView addSubview:self.productNameLabel];
    [self.shadowView addSubview:self.authorNameLabel];
    [self.shadowView addSubview:self.certifyAddressLabel];
    [self.shadowView addSubview:self.numTitleLabel];
    [self.shadowView addSubview:self.balanceLabel];
    [self.shadowView addSubview:self.numStepper];
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
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(17.0f);
    }];
    [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(17.0f);
        make.width.mas_equalTo(102.0f);
        make.height.mas_equalTo(76.0f);
    }];
    [self.productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).offset(15.0f);
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
        make.top.equalTo(self.productImageView.mas_bottom).offset(10.0f);
        make.height.mas_equalTo(32.0f);
    }];
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numTitleLabel.mas_right);
        make.centerY.equalTo(self.numTitleLabel.mas_centerY);
    }];
    [self.numStepper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shadowView).offset(-20.0f);
        make.width.mas_equalTo(75.0f);
        make.height.mas_equalTo(17.0f);
        make.centerY.equalTo(self.numTitleLabel.mas_centerY);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shadowView).offset(-20.0f);
        make.centerY.equalTo(self.numTitleLabel.mas_centerY);
    }];
    [self.totalPriceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_left);
        make.top.equalTo(self.numTitleLabel.mas_bottom);
        make.height.mas_equalTo(32.0f);
        make.bottom.equalTo(self.shadowView).offset(-10.0f);
    }];
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shadowView).offset(-23.0f);
        make.centerY.equalTo(self.totalPriceTitleLabel.mas_centerY);
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

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"作品信息" font:kFontPingFangSCMedium(17.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UIImageView *)productImageView {
    if (!_productImageView) {
        _productImageView = [[UIImageView alloc] init];
        ViewBorderRadius(_productImageView, 5.0f, 0.0f, JL_color_clear);
    }
    return _productImageView;
}

- (UILabel *)authorNameLabel {
    if (!_authorNameLabel) {
        _authorNameLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _authorNameLabel;
}

- (UILabel *)productNameLabel {
    if (!_productNameLabel) {
        _productNameLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCMedium(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _productNameLabel;
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
        _numTitleLabel = [JLUIFactory labelInitText:@"购买数量" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _numTitleLabel;
}

- (UILabel *)balanceLabel {
    if (!_balanceLabel) {
        _balanceLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(12.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _balanceLabel;
}

- (JLStepper *)numStepper {
    if (!_numStepper) {
        WS(weakSelf)
        _numStepper = [[JLStepper alloc] init];
        _numStepper.stepValue = 1;
        _numStepper.isValueEditable = YES;
        _numStepper.valueChanged = ^(double value) {
            NSDecimalNumber *valueNumber = [NSDecimalNumber decimalNumberWithString:@(value).stringValue];
            NSDecimalNumber *priceNumber = [NSDecimalNumber decimalNumberWithString:weakSelf.sellingOrderData.price];
            NSDecimalNumber *totalPriceNumber = [valueNumber decimalNumberByMultiplyingBy:priceNumber];
            weakSelf.totalPriceLabel.text = [NSString stringWithFormat:@"¥%@", totalPriceNumber.stringValue];
            if (weakSelf.totalPriceChangeBlock) {
                weakSelf.totalPriceChangeBlock(totalPriceNumber.stringValue, @(value).stringValue);
            }
        };
    }
    return _numStepper;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentRight];
    }
    return _numLabel;
}

- (UILabel *)totalPriceTitleLabel {
    if (!_totalPriceTitleLabel) {
        _totalPriceTitleLabel = [JLUIFactory labelInitText:@"商品总价" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _totalPriceTitleLabel;
}

- (UILabel *)totalPriceLabel {
    if (!_totalPriceLabel) {
        _totalPriceLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_red_D70000 textAlignment:NSTextAlignmentRight];
    }
    return _totalPriceLabel;
}

- (void)setArtDetailData:(Model_art_Detail_Data *)artDetailData sellingOrderData:(Model_arts_id_orders_Data *)sellingOrderData {
    self.sellingOrderData = sellingOrderData;
    
    if (![NSString stringIsEmpty:artDetailData.img_main_file1[@"url"]]) {
        [self.productImageView sd_setImageWithURL:[NSURL URLWithString:artDetailData.img_main_file1[@"url"]]];
    }
    self.authorNameLabel.text = [NSString stringIsEmpty:artDetailData.author.display_name] ? @"" : artDetailData.author.display_name;
    self.productNameLabel.text = artDetailData.name;
    self.certifyAddressLabel.text = [NSString stringWithFormat:@"NFT地址：%@", [NSString stringIsEmpty:artDetailData.item_hash] ? @"" : artDetailData.item_hash];
    
    if (artDetailData.collection_mode == 3) {
        self.balanceLabel.text = [NSString stringWithFormat:@"（剩余%@）", sellingOrderData.amount];
        
        self.numStepper.hidden = NO;
        self.numLabel.hidden = YES;
        self.numStepper.minValue = 1;
        self.numStepper.maxValue = sellingOrderData.amount.intValue;
        self.numStepper.value = 1;
    } else {
        self.balanceLabel.text = @"";
        self.numStepper.hidden = YES;
        self.numLabel.hidden = NO;
        self.numLabel.text = sellingOrderData.amount;
    }
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%@", [NSDecimalNumber decimalNumberWithString:sellingOrderData.price].stringValue];
}
@end
