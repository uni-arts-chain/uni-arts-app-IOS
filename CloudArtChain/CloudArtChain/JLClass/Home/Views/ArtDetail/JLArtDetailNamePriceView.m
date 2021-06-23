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
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
    }];
    
    [self.infoView addSubview:self.nameLabel];
    [self.infoView addSubview:self.priceLabel];
    [self.infoView addSubview:self.priceMaskView];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13.0f);
        make.top.mas_equalTo(17.0f);
        make.right.mas_equalTo(-24.0f);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(13);
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
        _nameLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCSCSemibold(16.0f) textColor:JL_color_black_191919 textAlignment:NSTextAlignmentLeft];
        _nameLabel.numberOfLines = 1;
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCSCSemibold(19.0f) textColor:JL_color_mainColor textAlignment:NSTextAlignmentLeft];
        _priceLabel.numberOfLines = 1;
        _priceLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _priceLabel;
}

- (void)setArtDetailData:(Model_art_Detail_Data *)artDetailData {
    _artDetailData = artDetailData;
    self.nameLabel.text = artDetailData.name;
    
    if ([NSString stringIsEmpty:artDetailData.price]) {
        self.priceLabel.text = [NSString stringWithFormat:@"¥ %@", artDetailData.price];
        return;
    }
    NSMutableAttributedString *attrs = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@", artDetailData.price]];
    [attrs addAttribute:NSFontAttributeName value:kFontPingFangSCSCSemibold(13) range:NSMakeRange(0, 1)];
    [attrs addAttribute:NSKernAttributeName value:@(4) range:NSMakeRange(0, 1)];
    self.priceLabel.attributedText = attrs;
}

@end
