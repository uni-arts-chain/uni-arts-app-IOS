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
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIImageView *orderNoImageView;
@property (nonatomic, strong) UILabel *orderNoLabel;
@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *cerAddressLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *priceTitleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *royaltyLabel;
@property (nonatomic, strong) UIImageView *auctionFlagImgView;
@end

@implementation JLSinglePurchaseOrderListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.shadowView addShadow:[UIColor colorWithHexString:@"#404040"] cornerRadius:5.0f offsetX:0];
}

- (void)createSubViews {
    [self.contentView addSubview:self.shadowView];
    
    [self.shadowView addSubview:self.orderNoImageView];
    [self.shadowView addSubview:self.orderNoLabel];

    [self.shadowView addSubview:self.productImageView];
    [self.shadowView addSubview:self.productNameLabel];
    [self.shadowView addSubview:self.authorLabel];
    [self.shadowView addSubview:self.cerAddressLabel];
    [self.shadowView addSubview:self.numLabel];
    
    [self.shadowView addSubview:self.timeLabel];
    [self.shadowView addSubview:self.priceTitleLabel];
    [self.shadowView addSubview:self.priceLabel];
    [self.shadowView addSubview:self.royaltyLabel];
    
    [self.shadowView addSubview:self.auctionFlagImgView];
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10.0f, 15.0f, 10.0f, 15.0f));
    }];
    
    [self.orderNoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16.0f);
        make.top.mas_equalTo(18.0f);
        make.width.mas_equalTo(13.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.orderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderNoImageView.mas_right).offset(8.0f);
        make.right.mas_equalTo(-12.0f);
        make.centerY.equalTo(self.orderNoImageView.mas_centerY);
    }];
    
    [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.0f);
        make.top.equalTo(self.orderNoImageView.mas_bottom).offset(20.0f);
        make.width.mas_equalTo(102.0f);
        make.height.mas_equalTo(76.0f);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20.0f);
        make.top.equalTo(self.productImageView.mas_top);
    }];
    [self.productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).offset(12.0f);
        make.top.equalTo(self.productImageView.mas_top);
        make.right.equalTo(self.numLabel.mas_left).offset(-8.0f);
    }];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productNameLabel.mas_left);
        make.right.equalTo(self.shadowView).offset(-10.0f);
        make.centerY.equalTo(self.productImageView.mas_centerY);
    }];
    [self.cerAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productNameLabel.mas_left);
        make.bottom.equalTo(self.productImageView.mas_bottom);
        make.right.mas_equalTo(-45.0f);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.0f);
        make.bottom.equalTo(self.shadowView);
        make.height.mas_equalTo(43.0f);
    }];
    [self.royaltyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20.0f);
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
    [self.auctionFlagImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.shadowView);
        make.size.mas_equalTo(CGSizeMake(31, 24));
    }];
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] initWithFrame:CGRectMake(15.0f, 10.0f, kScreenWidth - 15.0f * 2, 200.0f - 10.0f * 2)];
        _shadowView.backgroundColor = JL_color_white_ffffff;
    }
    return _shadowView;
}

- (UIImageView *)orderNoImageView {
    if (!_orderNoImageView) {
        _orderNoImageView = [JLUIFactory imageViewInitImageName:@"icon_mine_order_orderno"];
    }
    return _orderNoImageView;
}

- (UILabel *)orderNoLabel {
    if (!_orderNoLabel) {
        _orderNoLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
        _orderNoLabel.adjustsFontSizeToFitWidth = YES;
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
        _productNameLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCMedium(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
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
        _authorLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
        _authorLabel.numberOfLines = 1;
        _authorLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _authorLabel;
}

- (UILabel *)cerAddressLabel {
    if (!_cerAddressLabel) {
        _cerAddressLabel = [JLUIFactory labelInitText:@"藏品地址：" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
        _cerAddressLabel.numberOfLines = 1;
    }
    return _cerAddressLabel;
}


- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_999999 textAlignment:NSTextAlignmentLeft];
    }
    return _timeLabel;
}

- (UILabel *)priceTitleLabel {
    if (!_priceTitleLabel) {
        _priceTitleLabel = [JLUIFactory labelInitText:@"实付款：" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentRight];
    }
    return _priceTitleLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_red_D70000 textAlignment:NSTextAlignmentRight];
    }
    return _priceLabel;
}

- (UILabel *)royaltyLabel {
    if (!_royaltyLabel) {
        _royaltyLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentRight];
    }
    return _royaltyLabel;
}

- (UIImageView *)auctionFlagImgView {
    if (!_auctionFlagImgView) {
        _auctionFlagImgView = [[UIImageView alloc] init];
        _auctionFlagImgView.image = [UIImage imageNamed:@"icon_auction_order_flag"];
    }
    return _auctionFlagImgView;
}

- (void)setSoldData:(Model_arts_sold_Data *)soldData {
    self.orderNoLabel.text = soldData.sn;
    if (![NSString stringIsEmpty:soldData.art.img_main_file1[@"url"]]) {
        [self.productImageView sd_setImageWithURL:[NSURL URLWithString:soldData.art.img_main_file1[@"url"]]];
    } else {
        self.productImageView.image = nil;
    }
    
    NSDate *buy_time = [NSDate dateWithTimeIntervalSince1970:soldData.finished_at.doubleValue];
    self.timeLabel.text = [buy_time dateWithCustomFormat:@"MM/dd HH:mm:ss"];
    
    self.authorLabel.text = [NSString stringIsEmpty:soldData.art.author.display_name] ? @"" : soldData.art.author.display_name;
    
    self.productNameLabel.text = soldData.art.name;
    
    self.cerAddressLabel.text = [NSString stringWithFormat:@"藏品地址：%@", [NSString stringIsEmpty:soldData.art.item_hash] ? @"" : soldData.art.item_hash];
    
    if ([[soldData.trade_refer lowercaseString] isEqualToString:@"auction"]) {
        self.auctionFlagImgView.hidden = NO;
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@", [self getResultPayMoney:soldData.auction].stringValue];
        if (![NSString stringIsEmpty:soldData.auction.royalty] &&
            [[NSDecimalNumber decimalNumberWithString:soldData.auction.royalty] isGreaterThanZero]) {
            self.royaltyLabel.text = [NSString stringWithFormat:@"(含版税¥%@)", soldData.auction.royalty];
        }else {
            self.royaltyLabel.text = @"";
        }
    }else {
        self.auctionFlagImgView.hidden = YES;
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@", soldData.total_price];
        if (![NSString stringIsEmpty:soldData.royalty] &&
            [[NSDecimalNumber decimalNumberWithString:soldData.royalty] isGreaterThanZero]) {
            self.royaltyLabel.text = [NSString stringWithFormat:@"(含版税¥%@)", soldData.royalty];
        }else {
            self.royaltyLabel.text = @"";
        }
    }
    
    if (soldData.art.collection_mode == 3) {
        // 可拆分作品，显示购买数量
        self.numLabel.text = [NSString stringWithFormat:@"X%@", [NSDecimalNumber decimalNumberWithString:soldData.amount].stringValue];
    } else {
        self.numLabel.text = @"";
    }
    [self.shadowView addShadow:[UIColor colorWithHexString:@"#404040"] cornerRadius:5.0f offsetX:0];
}

/// 最终实付款
- (NSDecimalNumber *)getResultPayMoney: (Model_auctions_Data *)auctionsData {
    // 拍中价格
    NSDecimalNumber *winPrice = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    if (![NSString stringIsEmpty:auctionsData.win_price]) {
        winPrice = [NSDecimalNumber decimalNumberWithString:auctionsData.win_price];
    }
    // 版税价格
    NSDecimalNumber *royaltyPrice = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    if (![NSString stringIsEmpty:auctionsData.royalty] &&
        [[NSDecimalNumber decimalNumberWithString:auctionsData.royalty] isGreaterThanZero]) {
        royaltyPrice = [NSDecimalNumber decimalNumberWithString:auctionsData.royalty];
    }
    // 保证金
    NSDecimalNumber *depositPrice = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    if (![NSString stringIsEmpty:auctionsData.deposit_amount]) {
        depositPrice = [NSDecimalNumber decimalNumberWithString:auctionsData.deposit_amount];
    }
    // 最终实付价格(拍中价(包含保证金)+版税价)
    NSDecimalNumber *resultPrice = [[winPrice decimalNumberByAdding:royaltyPrice] roundDownScale:2];
    
    return resultPrice;
}

@end
