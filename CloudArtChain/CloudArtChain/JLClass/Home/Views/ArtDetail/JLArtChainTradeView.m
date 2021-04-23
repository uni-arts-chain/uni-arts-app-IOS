//
//  JLArtChainTradeView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/23.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLArtChainTradeView.h"

@interface JLArtChainTradeView ()
@property (nonatomic, strong) UIView *chainView;
@property (nonatomic, strong) UILabel *addressLabel;
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
    [self.chainView addSubview:self.addressLabel];
    
    [self.chainView addSubview:self.transactionTimesLabel];
    
    [chainInfoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(14.0f);
        make.height.mas_equalTo(32.0f);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(chainInfoTitleLabel.mas_bottom);
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-32.0f);
        make.height.mas_equalTo(30.0f);
    }];
    [self.transactionTimesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.addressLabel.mas_bottom);
        make.height.mas_equalTo(30.0f);
    }];
}

- (UIView *)chainView {
    if (!_chainView) {
        _chainView = [[UIView alloc] init];
    }
    return _chainView;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [JLUIFactory labelInitText:@"NFT地址：" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _addressLabel;
}

- (UILabel *)transactionTimesLabel {
    if (!_transactionTimesLabel) {
        _transactionTimesLabel = [JLUIFactory labelInitText:@"交易次数：0次" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _transactionTimesLabel;
}

- (void)setArtDetailData:(Model_art_Detail_Data *)artDetailData {
    _artDetailData = artDetailData;
    self.addressLabel.text = [NSString stringWithFormat:@"NFT地址：%@", artDetailData.item_hash];
    self.transactionTimesLabel.text = [NSString stringWithFormat:@"交易次数：%@次", artDetailData.trades_count];
}
@end
