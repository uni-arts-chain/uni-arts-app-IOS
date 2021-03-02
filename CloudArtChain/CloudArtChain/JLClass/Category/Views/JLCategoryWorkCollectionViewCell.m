//
//  JLCategoryWorkCollectionViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/28.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLCategoryWorkCollectionViewCell.h"

@interface JLCategoryWorkCollectionViewCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@end

@implementation JLCategoryWorkCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.imageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.infoLabel];
    [self addSubview:self.priceLabel];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-18.0f);
        make.right.left.equalTo(self);
        make.height.mas_equalTo(15.0f);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.priceLabel.mas_top).offset(-13.0f);
        make.right.left.mas_equalTo(self);
        make.height.mas_equalTo(13.0f);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.infoLabel.mas_top).offset(-11.0f);
        make.right.left.mas_equalTo(self);
        make.height.mas_equalTo(15.0f);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self.nameLabel.mas_top).offset(-17.0f);
    }];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [JLUIFactory imageViewInitImageName:@""];
        ViewBorderRadius(_imageView, 5.0f, 0.0f, JL_color_clear);
    }
    return _imageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCSCSemibold(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentRight];
    }
    return _nameLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentRight];
    }
    return _infoLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCSCSemibold(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentRight];
    }
    return _priceLabel;
}

- (void)setArtDetailData:(Model_art_Detail_Data *)artDetailData {
    if (![NSString stringIsEmpty:artDetailData.img_main_file1[@"url"]]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:artDetailData.img_main_file1[@"url"]]];
    }
    self.nameLabel.text = artDetailData.author.display_name;
    self.infoLabel.text = [NSString stringWithFormat:@"%@，%@", [[AppSingleton sharedAppSingleton] getArtCategoryByID:@(artDetailData.category_id).stringValue], artDetailData.name];
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@", artDetailData.price];
}
@end
