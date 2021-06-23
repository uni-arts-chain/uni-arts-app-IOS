//
//  JLSinglePurchaseOrderListCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/1.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLSinglePurchaseOrderListCell.h"
#import "UIImage+Color.h"
#import "NSDate+Extension.h"

@interface JLSinglePurchaseOrderListCell()
@property (nonatomic, strong) UIImageView *shadowView;
@property (nonatomic, strong) UILabel *orderNoLabel;
@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *cerAddressLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *priceTitleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *royaltyLabel;
@end

@implementation JLSinglePurchaseOrderListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = JL_color_clear;
        self.contentView.backgroundColor = JL_color_clear;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.shadowView];
    
    [self.shadowView addSubview:self.orderNoLabel];

    [self.shadowView addSubview:self.productImageView];
    [self.shadowView addSubview:self.productNameLabel];
    [self.shadowView addSubview:self.authorLabel];
    [self.shadowView addSubview:self.cerAddressLabel];
    [self.shadowView addSubview:self.numLabel];
    
    [self.shadowView addSubview:self.lineView];
    [self.shadowView addSubview:self.timeLabel];
    [self.shadowView addSubview:self.priceTitleLabel];
    [self.shadowView addSubview:self.priceLabel];
    [self.shadowView addSubview:self.royaltyLabel];
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(12.0f);
        make.right.equalTo(self.contentView).offset(-12.0f);
        make.bottom.equalTo(self.contentView).offset(-12.0f);
    }];
    
    [self.orderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shadowView).offset(12.0f);
        make.top.equalTo(self.shadowView).offset(10.0f);
        make.height.mas_equalTo(@13.0f);
    }];
    
    [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shadowView).offset(12.0f);
        make.top.equalTo(self.shadowView).offset(39.0f);
        make.width.mas_equalTo(56.0f);
        make.height.mas_equalTo(56.0f);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shadowView).offset(-20.0f);
        make.top.equalTo(self.productImageView.mas_top);
    }];
    [self.productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).offset(12.0f);
        make.top.equalTo(self.productImageView.mas_top).offset(-3.0f);
        make.right.equalTo(self.numLabel.mas_left).offset(-8.0f);
    }];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productNameLabel.mas_left);
        make.right.equalTo(self.shadowView).offset(-10.0f);
        make.centerY.equalTo(self.productImageView.mas_centerY).offset(2.0f);
    }];
    [self.cerAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productNameLabel.mas_left);
        make.bottom.equalTo(self.productImageView.mas_bottom).offset(3.0f);
        make.right.equalTo(self.shadowView).offset(-45.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView);
        make.top.equalTo(self.productImageView.mas_bottom).offset(11.0f);
        make.right.equalTo(self.shadowView).offset(-13.0f);
        make.height.mas_equalTo(@1.0f);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shadowView).offset(12.0f);
        make.bottom.equalTo(self.shadowView).offset(-10.0f);
    }];
    [self.royaltyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shadowView).offset(-11.0f);
        make.centerY.equalTo(self.timeLabel.mas_centerY);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.royaltyLabel.mas_left);
        make.centerY.equalTo(self.timeLabel.mas_centerY);
    }];
    [self.priceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceLabel.mas_left);
        make.centerY.equalTo(self.priceLabel.mas_centerY);
    }];
}

- (UIImageView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(12.0f, 0.0f, kScreenWidth - 12.0f * 2, 144.0f)];
        _shadowView.image = [UIImage imageNamed:@"order_list_bg"];
    }
    return _shadowView;
}

- (UILabel *)orderNoLabel {
    if (!_orderNoLabel) {
        _orderNoLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCMedium(13.0f) textColor:JL_color_gray_87888F textAlignment:NSTextAlignmentLeft];
    }
    return _orderNoLabel;
}

- (UIImageView *)productImageView {
    if (!_productImageView) {
        _productImageView = [[UIImageView alloc] init];
        _productImageView.contentMode = UIViewContentModeScaleAspectFit;
        ViewBorderRadius(_productImageView, 5.0f, 0, JL_color_clear);
    }
    return _productImageView;
}

- (UILabel *)productNameLabel {
    if (!_productNameLabel) {
        _productNameLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCSCSemibold(15.0f) textColor:JL_color_black_40414D textAlignment:NSTextAlignmentLeft];
    }
    return _productNameLabel;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentRight];
    }
    return _numLabel;
}

- (UILabel *)authorLabel {
    if (!_authorLabel) {
        _authorLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_black_40414D textAlignment:NSTextAlignmentLeft];
        _authorLabel.numberOfLines = 1;
        _authorLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _authorLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = JL_color_gray_EDEDEE;
    }
    return _lineView;
}

- (UILabel *)cerAddressLabel {
    if (!_cerAddressLabel) {
        _cerAddressLabel = [JLUIFactory labelInitText:@"NFT地址：" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_black_40414D textAlignment:NSTextAlignmentLeft];
        _cerAddressLabel.numberOfLines = 1;
    }
    return _cerAddressLabel;
}


- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_87888F textAlignment:NSTextAlignmentLeft];
    }
    return _timeLabel;
}

- (UILabel *)priceTitleLabel {
    if (!_priceTitleLabel) {
        _priceTitleLabel = [JLUIFactory labelInitText:@"实付款 " font:kFontPingFangSCRegular(14.0f) textColor:JL_color_red_EF4136 textAlignment:NSTextAlignmentRight];
    }
    return _priceTitleLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_red_EF4136 textAlignment:NSTextAlignmentRight];
    }
    return _priceLabel;
}

- (UILabel *)royaltyLabel {
    if (!_royaltyLabel) {
        _royaltyLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_red_EF4136 textAlignment:NSTextAlignmentRight];
    }
    return _royaltyLabel;
}

- (void)setSoldData:(Model_arts_sold_Data *)soldData {
    self.orderNoLabel.text = [NSString stringWithFormat:@"订单编号: %@", soldData.sn];
    if (![NSString stringIsEmpty:soldData.art.img_main_file1[@"url"]]) {
        [self.productImageView sd_setImageWithURL:[NSURL URLWithString:soldData.art.img_main_file1[@"url"]]];
    } else {
        self.productImageView.image = nil;
    }
    
    NSDate *buy_time = [NSDate dateWithTimeIntervalSince1970:soldData.finished_at.doubleValue];
    self.timeLabel.text = [buy_time dateWithCustomFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    self.authorLabel.text = [NSString stringIsEmpty:soldData.art.author.display_name] ? @"" : soldData.art.author.display_name;
    
    self.productNameLabel.text = soldData.art.name;
    
    self.cerAddressLabel.text = [NSString stringWithFormat:@"NFT地址：%@", [NSString stringIsEmpty:soldData.art.item_hash] ? @"" : soldData.art.item_hash];
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", soldData.total_price];
    
    self.royaltyLabel.text = [NSString stringWithFormat:@"(含版税¥%@)", soldData.royalty];
    
    if (soldData.art.collection_mode == 3) {
        // 可拆分作品，显示购买数量
        self.numLabel.text = [NSString stringWithFormat:@"X%@", [NSDecimalNumber decimalNumberWithString:soldData.amount].stringValue];
    } else {
        self.numLabel.text = @"";
    }
}
@end
