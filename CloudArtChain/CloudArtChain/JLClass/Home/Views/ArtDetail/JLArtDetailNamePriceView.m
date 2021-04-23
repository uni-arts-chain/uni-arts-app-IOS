//
//  JLArtDetailNamePriceView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/23.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLArtDetailNamePriceView.h"

@interface JLArtDetailNamePriceView ()
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView *priceMaskView;
@end

@implementation JLArtDetailNamePriceView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.infoView];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = JL_color_gray_BEBEBE;
    [self addSubview:lineView];
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(89.5f);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.infoView.mas_bottom);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(0.5f);
    }];
    
    [self.infoView addSubview:self.nameLabel];
    [self.infoView addSubview:self.priceLabel];
    [self.infoView addSubview:self.priceMaskView];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(10.0f);
        make.height.mas_equalTo(39.0f);
        make.right.mas_equalTo(-15.0f);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.height.mas_equalTo(38.0f);
    }];
    [self.priceMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel.mas_right).offset(12.0f);
        make.height.mas_equalTo(14.0f);
        make.centerY.equalTo(self.priceLabel.mas_centerY);
    }];
}

- (UIView *)infoView {
    if (!_infoView) {
        _infoView = [[UIView alloc] init];
    }
    return _infoView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCSCSemibold(19.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCSCSemibold(18.0f) textColor:JL_color_red_D70000 textAlignment:NSTextAlignmentLeft];
    }
    return _priceLabel;
}

- (UIView *)priceMaskView {
    if (!_priceMaskView) {
        _priceMaskView = [[UIView alloc] init];
        ViewBorderRadius(_priceMaskView, 2.0f, 1.0f, JL_color_gray_1A1A1A);
    }
    return _priceMaskView;
}

- (void)setArtDetailData:(Model_art_Detail_Data *)artDetailData {
    _artDetailData = artDetailData;
    self.nameLabel.text = artDetailData.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@", artDetailData.price];
}

@end
