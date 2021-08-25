//
//  JLAuctionSubmitOrderContentInfoView.m
//  CloudArtChain
//
//  Created by jielian on 2021/8/17.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLAuctionSubmitOrderContentInfoView.h"

@interface JLAuctionSubmitOrderContentInfoView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *authorLabel;

@property (nonatomic, strong) UILabel *nftAddressLabel;

@property (nonatomic, strong) UILabel *numTitleLabel;

@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) UILabel *priceTitleLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *royaltyTitleLabel;

@property (nonatomic, strong) UILabel *royaltyLabel;

@property (nonatomic, strong) UILabel *depositTitleLabel;

@property (nonatomic, strong) UILabel *depositLabel;

@end

@implementation JLAuctionSubmitOrderContentInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = JL_color_white_ffffff;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _bgView = [[UIView alloc] init];
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _imgView = [[UIImageView alloc] init];
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    _imgView.layer.cornerRadius = 5;
    _imgView.clipsToBounds = YES;
    [_bgView addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(23);
        make.left.equalTo(self.bgView).offset(12);
        make.size.mas_equalTo(CGSizeMake(102, 76));
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = JL_color_gray_212121;
    _nameLabel.font = kFontPingFangSCMedium(15);
    [_bgView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView);
        make.left.equalTo(self.imgView.mas_right).offset(16);
        make.right.equalTo(self.bgView).offset(-15);
    }];
    
    _authorLabel = [[UILabel alloc] init];
    _authorLabel.textColor = JL_color_gray_212121;
    _authorLabel.font = kFontPingFangSCRegular(15);
    [_bgView addSubview:_authorLabel];
    [_authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.centerY.equalTo(self.imgView);
    }];
    
    _nftAddressLabel = [[UILabel alloc] init];
    _nftAddressLabel.textColor = JL_color_gray_101010;
    _nftAddressLabel.font = kFontPingFangSCRegular(13);
    [_bgView addSubview:_nftAddressLabel];
    [_nftAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.bottom.equalTo(self.imgView);
    }];
    
    _numTitleLabel = [[UILabel alloc] init];
    _numTitleLabel.text = @"拍卖数量";
    _numTitleLabel.textColor = JL_color_gray_212121;
    _numTitleLabel.font = kFontPingFangSCRegular(14);
    [_bgView addSubview:_numTitleLabel];
    [_numTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView);
        make.top.equalTo(self.imgView.mas_bottom).offset(17);
    }];
    
    _numLabel = [[UILabel alloc] init];
    _numLabel.textColor = JL_color_gray_212121;
    _numLabel.font = kFontPingFangSCRegular(14);
    _numLabel.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:_numLabel];
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-23);
        make.centerY.equalTo(self.numTitleLabel);
    }];
    
    _priceTitleLabel = [[UILabel alloc] init];
    _priceTitleLabel.text = @"拍中价";
    _priceTitleLabel.textColor = JL_color_gray_212121;
    _priceTitleLabel.font = kFontPingFangSCRegular(14);
    [_bgView addSubview:_priceTitleLabel];
    [_priceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numTitleLabel);
        make.top.equalTo(self.numTitleLabel.mas_bottom).offset(17);
    }];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = JL_color_red_D70000;
    _priceLabel.font = kFontPingFangSCRegular(14);
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-23);
        make.centerY.equalTo(self.priceTitleLabel);
    }];
    
    _royaltyTitleLabel = [[UILabel alloc] init];
    _royaltyTitleLabel.text = @"版税（0%）";
    _royaltyTitleLabel.textColor = JL_color_gray_212121;
    _royaltyTitleLabel.font = kFontPingFangSCRegular(14);
    [_bgView addSubview:_royaltyTitleLabel];
    [_royaltyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceTitleLabel);
        make.top.equalTo(self.priceTitleLabel.mas_bottom).offset(17);
    }];
    
    _royaltyLabel = [[UILabel alloc] init];
    _royaltyLabel.text = @"￥0";
    _royaltyLabel.textColor = JL_color_gray_212121;
    _royaltyLabel.font = kFontPingFangSCRegular(14);
    _royaltyLabel.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:_royaltyLabel];
    [_royaltyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-23);
        make.centerY.equalTo(self.royaltyTitleLabel);
    }];
    
    _depositTitleLabel = [[UILabel alloc] init];
    _depositTitleLabel.text = @"已缴纳保证金";
    _depositTitleLabel.textColor = JL_color_gray_212121;
    _depositTitleLabel.font = kFontPingFangSCRegular(14);
    [_bgView addSubview:_depositTitleLabel];
    [_depositTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.royaltyTitleLabel);
        make.top.equalTo(self.royaltyTitleLabel.mas_bottom).offset(17);
        make.bottom.equalTo(self.bgView).offset(-18);
    }];
    
    _depositLabel = [[UILabel alloc] init];
    _depositLabel.textColor = JL_color_gray_212121;
    _depositLabel.font = kFontPingFangSCRegular(14);
    _depositLabel.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:_depositLabel];
    [_depositLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-23);
        make.centerY.equalTo(self.depositTitleLabel);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addShadow:JL_color_gray_999999 cornerRadius:5 offset:CGSizeMake(0, 0)];
}

#pragma mark - setters and getters
- (void)setAuctionsData:(Model_auctions_Data *)auctionsData {
    _auctionsData = auctionsData;
    
    if (![NSString stringIsEmpty:_auctionsData.art.img_main_file1[@"url"]]) {
        [_imgView sd_setImageWithURL:[NSURL URLWithString:_auctionsData.art.img_main_file1[@"url"]]];
    }
    _authorLabel.text = [NSString stringIsEmpty:_auctionsData.art.author.display_name] ? @"" : _auctionsData.art.author.display_name;
    _nameLabel.text = _auctionsData.art.name;
    _nftAddressLabel.text = [NSString stringWithFormat:@"NFT地址：%@", [NSString stringIsEmpty:_auctionsData.art.item_hash] ? @"" : _auctionsData.art.item_hash];
    _numLabel.text = _auctionsData.amount;
    _priceLabel.text = [NSString stringWithFormat:@"￥%@", _auctionsData.win_price];
    _depositLabel.text = [NSString stringWithFormat:@"￥%@", _auctionsData.deposit_amount];
    
    if (![NSString stringIsEmpty:_auctionsData.art.royalty]) {
        NSDecimalNumber *royaltyNumber = [NSDecimalNumber decimalNumberWithString:_auctionsData.art.royalty];
        NSDecimalNumber *persentRoyaltyNumber = [royaltyNumber decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
        _royaltyTitleLabel.text = [NSString stringWithFormat:@"版税（%@%%）", persentRoyaltyNumber.stringValue];
        
        NSDecimalNumber *winPrice = [NSDecimalNumber decimalNumberWithString:_auctionsData.win_price];
        NSDecimalNumber *royaltyPrice = [[royaltyNumber decimalNumberByMultiplyingBy:winPrice] roundDownScale:2];
        _royaltyLabel.text = [NSString stringWithFormat:@"￥%@", royaltyPrice.stringValue];
    }
}

@end
