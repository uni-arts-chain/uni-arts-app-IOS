//
//  JLArtDetailPriceView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/18.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLArtDetailPriceView.h"

@interface JLArtDetailPriceView ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@end

@implementation JLArtDetailPriceView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.nameLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.infoLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(12.0f);
        make.height.mas_equalTo(25.0f);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-19.0f);
        make.height.mas_equalTo(25.0f);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.right.equalTo(self);
        make.bottom.mas_equalTo(-5.0f);
    }];
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCSCSemibold(19.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(17.0f) textColor:JL_color_red_D70000 textAlignment:NSTextAlignmentRight];
    }
    return _priceLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _infoLabel;
}

- (void)setArtsData:(Model_auction_meetings_arts_Data *)artsData {
    self.nameLabel.text = artsData.art.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", artsData.start_price];
    self.infoLabel.text = [NSString stringWithFormat:@"%@，%@x%@cm", [[AppSingleton sharedAppSingleton] getMaterialByID:@(artsData.art.material_id).stringValue], artsData.art.size_width, artsData.art.size_length];
}

@end
