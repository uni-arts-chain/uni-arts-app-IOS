//
//  JLChainQueryArtInfoView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/2.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLChainQueryArtInfoView.h"

@interface JLChainQueryArtInfoView ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *materialLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UILabel *creatorLabel;
@property (nonatomic, strong) UILabel *ownerLabel;
@end

@implementation JLChainQueryArtInfoView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.nameLabel];
    
    UILabel *materialTitleLabel = [JLUIFactory labelInitText:@"材料" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_909090 textAlignment:NSTextAlignmentLeft];
    [self addSubview:materialTitleLabel];
    [self addSubview:self.materialLabel];
    
    UILabel *sizeTitleLabel = [JLUIFactory labelInitText:@"尺寸" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_909090 textAlignment:NSTextAlignmentLeft];
    [self addSubview:sizeTitleLabel];
    [self addSubview:self.sizeLabel];
    
    UILabel *creatorTitleLabel = [JLUIFactory labelInitText:@"创作者" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_909090 textAlignment:NSTextAlignmentLeft];
    [self addSubview:creatorTitleLabel];
    [self addSubview:self.creatorLabel];
    
    UILabel *ownerTitleLabel = [JLUIFactory labelInitText:@"拥有者" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_909090 textAlignment:NSTextAlignmentLeft];
    [self addSubview:ownerTitleLabel];
    [self addSubview:self.ownerLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = JL_color_gray_DDDDDD;
    [self addSubview:lineView];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(35.0f);
        make.height.mas_equalTo(17.0);
    }];
    [materialTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(20.0f);
        make.height.mas_equalTo(15.0f);
        make.width.mas_equalTo(62.0f);
    }];
    [self.materialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(materialTitleLabel.mas_right);
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(materialTitleLabel.mas_top);
        make.height.mas_equalTo(15.0f);
    }];
    [sizeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(materialTitleLabel.mas_bottom).offset(20.0f);
        make.height.mas_equalTo(15.0f);
        make.width.mas_equalTo(62.0f);
    }];
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sizeTitleLabel.mas_right);
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(sizeTitleLabel.mas_top);
        make.height.mas_equalTo(15.0f);
    }];
    [creatorTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(sizeTitleLabel.mas_bottom).offset(20.0f);
        make.height.mas_equalTo(15.0f);
        make.width.mas_equalTo(62.0f);
    }];
    [self.creatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(creatorTitleLabel.mas_right);
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(creatorTitleLabel.mas_top);
        make.height.mas_equalTo(15.0f);
    }];
    [ownerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(creatorTitleLabel.mas_bottom).offset(20.0f);
        make.height.mas_equalTo(15.0f);
        make.width.mas_equalTo(62.0f);
    }];
    [self.ownerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ownerTitleLabel.mas_right);
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(ownerTitleLabel.mas_top);
        make.height.mas_equalTo(15.0f);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.bottom.equalTo(self);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(1.0f);
    }];
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [JLUIFactory labelInitText:@"《芭蕾少女》" font:kFontPingFangSCMedium(17.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (UILabel *)materialLabel {
    if (!_materialLabel) {
        _materialLabel = [JLUIFactory labelInitText:@"油布" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _materialLabel;
}

- (UILabel *)sizeLabel {
    if (!_sizeLabel) {
        _sizeLabel = [JLUIFactory labelInitText:@"100cmx100cm" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _sizeLabel;
}

- (UILabel *)creatorLabel {
    if (!_creatorLabel) {
        _creatorLabel = [JLUIFactory labelInitText:@"张大千" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _creatorLabel;
}

- (UILabel *)ownerLabel {
    if (!_ownerLabel) {
        _ownerLabel = [JLUIFactory labelInitText:@"张大千" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _ownerLabel;
}
@end
