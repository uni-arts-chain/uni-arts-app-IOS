//
//  JLPopularOriginalCollectionViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/25.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLPopularOriginalCollectionViewCell.h"

@interface JLPopularOriginalCollectionViewCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView *auctioningView;
@end

@implementation JLPopularOriginalCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.imageView];
    [self addSubview:self.authorLabel];
    [self addSubview:self.descLabel];
    [self addSubview:self.addressLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.auctioningView];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-20.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.priceLabel.mas_top).offset(-12.0f);
        make.height.mas_equalTo(13.0f);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.addressLabel.mas_top).offset(-12.0f);
        make.height.mas_equalTo(13.0f);
    }];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.descLabel.mas_top).offset(-12.0f);
        make.height.mas_equalTo(16.0f);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self.authorLabel.mas_top).offset(-16.0f);
    }];
    [self.auctioningView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.width.mas_equalTo(45.0f);
        make.height.mas_equalTo(20.0f);
    }];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        ViewBorderRadius(_imageView, 5.0f, 0.0f, JL_color_clear);
    }
    return _imageView;
}

- (UILabel *)authorLabel {
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.font = kFontPingFangSCSCSemibold(16.0f);
        _authorLabel.textColor = JL_color_gray_101010;
    }
    return _authorLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = kFontPingFangSCRegular(13.0f);
        _descLabel.textColor = JL_color_gray_101010;
    }
    return _descLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = kFontPingFangSCRegular(13.0f);
        _addressLabel.textColor = JL_color_gray_909090;
    }
    return _addressLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = kFontPingFangSCSCSemibold(15.0f);
        _priceLabel.textColor = JL_color_gray_101010;
    }
    return _priceLabel;
}

- (UIView *)auctioningView {
    if (!_auctioningView) {
        _auctioningView = [[UIView alloc] init];
        
        UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_back_auctioning"]];
        [_auctioningView addSubview:backImageView];
        
        UILabel *statusLabel = [[UILabel alloc] init];
        statusLabel.font = kFontPingFangSCMedium(12.0f);
        statusLabel.textColor = JL_color_white_ffffff;
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.text = @"拍卖中";
        [_auctioningView addSubview:statusLabel];
        
        [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_auctioningView);
        }];
        [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_auctioningView);
        }];
        _auctioningView.hidden = YES;
    }
    return _auctioningView;
}

- (void)setArtsData:(Model_auction_meetings_arts_Data *)artsData {
    if (![NSString stringIsEmpty:artsData.art.img_main_file1[@"url"]]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:artsData.art.img_main_file1[@"url"]]];
    }
    self.authorLabel.text = artsData.art.author.display_name;
    self.descLabel.text = artsData.art.details;
    self.addressLabel.text = [NSString stringWithFormat:@"证书地址:%@", artsData.art.item_hash];
    self.priceLabel.text = [NSString stringWithFormat:@"%@ UART", artsData.start_price];
}

- (void)setPopularArtData:(Model_art_Detail_Data *)popularArtData {
    if (![NSString stringIsEmpty:popularArtData.img_main_file1[@"url"]]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:popularArtData.img_main_file1[@"url"]]];
    }
    self.authorLabel.text = popularArtData.author.display_name;
    self.descLabel.text = popularArtData.details;
    self.addressLabel.text = [NSString stringWithFormat:@"证书地址:%@", popularArtData.item_hash];
    self.priceLabel.text = [NSString stringWithFormat:@"%@ UART", popularArtData.price];
    
    if ([popularArtData.aasm_state isEqualToString:@"auctioning"]) {
        // 拍卖中
        self.auctioningView.hidden = NO;
    } else {
        self.auctioningView.hidden = YES;
    }
}

- (void)setThemeArtData:(Model_art_Detail_Data *)themeArtData {
    if (![NSString stringIsEmpty:themeArtData.img_main_file1[@"url"]]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:themeArtData.img_main_file1[@"url"]]];
    }
    self.authorLabel.text = themeArtData.author.display_name;
    self.descLabel.text = themeArtData.details;
    self.addressLabel.text = [NSString stringWithFormat:@"证书地址:%@", themeArtData.item_hash];
    self.priceLabel.text = [NSString stringWithFormat:@"%@ UART", themeArtData.price];
    
    if ([themeArtData.aasm_state isEqualToString:@"auctioning"]) {
        // 拍卖中
        self.auctioningView.hidden = NO;
    } else {
        self.auctioningView.hidden = YES;
    }
}

- (void)setCollectionArtData:(Model_art_Detail_Data *)collectionArtData {
    if (![NSString stringIsEmpty:collectionArtData.img_main_file1[@"url"]]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:collectionArtData.img_main_file1[@"url"]]];
    }
    self.authorLabel.text = collectionArtData.author.display_name;
    self.descLabel.text = collectionArtData.details;
    self.addressLabel.text = [NSString stringWithFormat:@"证书地址:%@", collectionArtData.item_hash];
    self.priceLabel.text = [NSString stringWithFormat:@"%@ UART", collectionArtData.price];
    
    if ([collectionArtData.aasm_state isEqualToString:@"auctioning"]) {
        // 拍卖中
        self.auctioningView.hidden = NO;
    } else {
        self.auctioningView.hidden = YES;
    }
}

- (void)setAuthorArtData:(Model_art_Detail_Data *)authorArtData {
    if (![NSString stringIsEmpty:authorArtData.img_main_file1[@"url"]]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:authorArtData.img_main_file1[@"url"]]];
    }
    self.authorLabel.text = authorArtData.author.display_name;
    self.descLabel.text = authorArtData.details;
    self.addressLabel.text = [NSString stringWithFormat:@"证书地址:%@", authorArtData.item_hash];
    self.priceLabel.text = [NSString stringWithFormat:@"%@ UART", authorArtData.price];
    
    if ([authorArtData.aasm_state isEqualToString:@"auctioning"]) {
        // 拍卖中
        self.auctioningView.hidden = NO;
    } else {
        self.auctioningView.hidden = YES;
    }
}

@end
