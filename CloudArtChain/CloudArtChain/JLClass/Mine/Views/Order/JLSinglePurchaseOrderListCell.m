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
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *cerAddressLabel;
@property (nonatomic, strong) UILabel *priceLabel;
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
    
    [self.shadowView addSubview:self.timeLabel];
    [self.shadowView addSubview:self.stateLabel];
    [self.shadowView addSubview:self.productImageView];
    [self.shadowView addSubview:self.authorLabel];
    [self.shadowView addSubview:self.productNameLabel];
    [self.shadowView addSubview:self.cerAddressLabel];
    [self.shadowView addSubview:self.priceLabel];
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10.0f, 15.0f, 10.0f, 15.0f));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.0f);
        make.top.mas_equalTo(15.0f);
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10.0f);
        make.centerY.equalTo(self.timeLabel.mas_centerY);
    }];
    [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.0f);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(24.0f);
        make.width.mas_equalTo(102.0f);
        make.height.mas_equalTo(76.0f).priority(1000);
        make.bottom.mas_equalTo(-23.0f);
    }];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).offset(17.0f);
        make.top.equalTo(self.productImageView.mas_top);
    }];
    [self.productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.authorLabel.mas_left);
        make.centerY.equalTo(self.productImageView.mas_centerY);
    }];
    [self.cerAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.authorLabel.mas_left);
        make.bottom.equalTo(self.productImageView.mas_bottom);
        make.right.mas_equalTo(-70.0f);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-13.0f);
        make.centerY.equalTo(self.authorLabel.mas_centerY);
    }];
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = JL_color_white_ffffff;
    }
    return _shadowView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_999999 textAlignment:NSTextAlignmentLeft];
    }
    return _timeLabel;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [JLUIFactory labelInitText:@"交易成功" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_red_D70000 textAlignment:NSTextAlignmentRight];
    }
    return _stateLabel;
}

- (UIImageView *)productImageView {
    if (!_productImageView) {
        _productImageView = [[UIImageView alloc] init];
        ViewBorderRadius(_productImageView, 5.0f, 0, JL_color_clear);
    }
    return _productImageView;
}

- (UILabel *)authorLabel {
    if (!_authorLabel) {
        _authorLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _authorLabel;
}

- (UILabel *)productNameLabel {
    if (!_productNameLabel) {
        _productNameLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCMedium(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _productNameLabel;
}

- (UILabel *)cerAddressLabel {
    if (!_cerAddressLabel) {
        _cerAddressLabel = [JLUIFactory labelInitText:@"证书地址：" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_999999 textAlignment:NSTextAlignmentLeft];
        _cerAddressLabel.numberOfLines = 1;
    }
    return _cerAddressLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentRight];
    }
    return _priceLabel;
}

- (void)setSoldData:(Model_arts_sold_Data *)soldData {
    if (![NSString stringIsEmpty:soldData.art.img_main_file1[@"url"]]) {
        [self.productImageView sd_setImageWithURL:[NSURL URLWithString:soldData.art.img_main_file1[@"url"]]];
    }
    
    NSDate *buy_time = [NSDate dateWithTimeIntervalSince1970:soldData.buy_time.doubleValue];
    self.timeLabel.text = [buy_time dateWithCustomFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    self.authorLabel.text = [NSString stringIsEmpty:soldData.art.author.display_name] ? @"" : soldData.art.author.display_name;
    
    self.productNameLabel.text = soldData.art.name;
    
    self.cerAddressLabel.text = [NSString stringWithFormat:@"证书地址：%@", [NSString stringIsEmpty:soldData.art.item_hash] ? @"" : soldData.art.item_hash];
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", soldData.amount];
}
@end
