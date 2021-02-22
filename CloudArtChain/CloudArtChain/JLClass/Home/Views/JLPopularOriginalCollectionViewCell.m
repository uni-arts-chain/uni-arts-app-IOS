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
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor randomColor];
        ViewBorderRadius(_imageView, 5.0f, 0.0f, JL_color_clear);
    }
    return _imageView;
}

- (UILabel *)authorLabel {
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.font = kFontPingFangSCSCSemibold(16.0f);
        _authorLabel.textColor = JL_color_gray_101010;
        _authorLabel.text = @"宋先生";
    }
    return _authorLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = kFontPingFangSCRegular(13.0f);
        _descLabel.textColor = JL_color_gray_101010;
        _descLabel.text = @"布画油画，月夜繁星";
    }
    return _descLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = kFontPingFangSCRegular(13.0f);
        _addressLabel.textColor = JL_color_gray_909090;
        _addressLabel.text = @"证书地址:0xaqweradfasdfqef909090";
    }
    return _addressLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = kFontPingFangSCSCSemibold(15.0f);
        _priceLabel.textColor = JL_color_gray_101010;
        _priceLabel.text = @"¥ 950";
    }
    return _priceLabel;
}
@end
