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
@property (nonatomic, strong) UILabel *royaltyLabel;
@property (nonatomic, strong) UILabel *royaltyDateLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *publishNumLabel;
@property (nonatomic, strong) UILabel *transactionTimesLabel;
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
    
    UILabel *chainInfoTitleLabel = [JLUIFactory labelInitText:@"区块链信息" font:kFontPingFangSCSCSemibold(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    [self.chainView addSubview:chainInfoTitleLabel];
    [self.chainView addSubview:self.royaltyLabel];
    [self.chainView addSubview:self.royaltyDateLabel];
    [self.chainView addSubview:self.addressLabel];
    [self.chainView addSubview:self.publishNumLabel];
    [self.chainView addSubview:self.transactionTimesLabel];
    
    [chainInfoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(14.0f);
        make.height.mas_equalTo(32.0f);
    }];
    [self.royaltyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(chainInfoTitleLabel.mas_bottom);
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-32.0f);
        make.height.mas_equalTo(30.0f);
    }];
    [self.royaltyDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.royaltyLabel.mas_bottom);
        make.height.mas_equalTo(30.0f);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.royaltyDateLabel.mas_bottom);
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-32.0f);
        make.height.mas_equalTo(30.0f);
    }];
    [self.publishNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.addressLabel.mas_bottom);
        make.height.mas_equalTo(30.0f);
    }];
    [self.transactionTimesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.publishNumLabel.mas_bottom);
        make.height.mas_equalTo(30.0f);
    }];
}

- (UIView *)chainView {
    if (!_chainView) {
        _chainView = [[UIView alloc] init];
    }
    return _chainView;
}

- (UILabel *)royaltyLabel {
    if (!_royaltyLabel) {
        _royaltyLabel = [JLUIFactory labelInitText:@"版税比例：" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _royaltyLabel;
}

- (UILabel *)royaltyDateLabel {
    if (!_royaltyDateLabel) {
        _royaltyDateLabel = [JLUIFactory labelInitText:@"版税有效期：" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _royaltyDateLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [JLUIFactory labelInitText:@"NFT地址：" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _addressLabel;
}

- (UILabel *)publishNumLabel {
    if (!_publishNumLabel) {
        _publishNumLabel = [JLUIFactory labelInitText:@"发行份数：" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _publishNumLabel;
}

- (UILabel *)transactionTimesLabel {
    if (!_transactionTimesLabel) {
        _transactionTimesLabel = [JLUIFactory labelInitText:@"交易次数：0次" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _transactionTimesLabel;
}

- (void)setArtDetailData:(Model_art_Detail_Data *)artDetailData {
    _artDetailData = artDetailData;
    if (![NSString stringIsEmpty:artDetailData.royalty]) {
        NSDecimalNumber *royaltyNumber = [NSDecimalNumber decimalNumberWithString:artDetailData.royalty];
        NSDecimalNumber *persentRoyaltyNumber = [royaltyNumber decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
        self.royaltyLabel.text = [NSString stringWithFormat:@"版税比例：%@%%", persentRoyaltyNumber.stringValue];
        
        if ([NSString stringIsEmpty:artDetailData.royalty_expired_at]) {
            self.royaltyDateLabel.text = @"版税有效期：永久";
        }
    }
    if (![NSString stringIsEmpty:artDetailData.royalty_expired_at]) {
        NSDate *royaltyDate = [NSDate dateWithTimeIntervalSince1970:artDetailData.royalty_expired_at.doubleValue];
        self.royaltyDateLabel.text = [NSString stringWithFormat:@"版税有效期：%@", [royaltyDate dateWithCustomFormat:@"yyyy-MM-dd"]];
    }
    self.addressLabel.text = [NSString stringWithFormat:@"NFT地址：%@", [NSString stringIsEmpty:artDetailData.item_hash] ? @"" : artDetailData.item_hash];
    self.publishNumLabel.text = [NSString stringWithFormat:@"发行份数：%ld份", artDetailData.total_amount];
    self.transactionTimesLabel.text = [NSString stringWithFormat:@"交易次数：%@次", artDetailData.trades_count];
}
@end
