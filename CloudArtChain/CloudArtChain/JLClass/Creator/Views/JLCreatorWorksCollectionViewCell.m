//
//  JLCreatorWorksCollectionViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/1.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLCreatorWorksCollectionViewCell.h"

@interface JLCreatorWorksCollectionViewCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UIView *auctioningView;
@end

@implementation JLCreatorWorksCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.imageView];
    [self addSubview:self.priceLabel];
    [self addSubview:self.descLabel];
    [self addSubview:self.addressLabel];
    [self addSubview:self.auctioningView];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(13.0f);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.addressLabel.mas_top).offset(-12.0f);
        make.height.mas_equalTo(13.0f);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.descLabel.mas_top).offset(-12.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self.priceLabel.mas_top).offset(-23.0f);
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

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = kFontPingFangSCSCSemibold(15.0f);
        _priceLabel.textColor = JL_color_gray_101010;
    }
    return _priceLabel;
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

- (void)setDetailData:(Model_art_Detail_Data *)detailData {
    if (![NSString stringIsEmpty:detailData.img_main_file1[@"url"]]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:detailData.img_main_file1[@"url"]]];
    }
    self.priceLabel.text = [NSString stringWithFormat:@"%@ UART", detailData.price];
    self.descLabel.text = [NSString stringWithFormat:@"%@，%@", [[AppSingleton sharedAppSingleton] getMaterialByID:@(detailData.material_id).stringValue], detailData.name];
    self.addressLabel.text = [NSString stringWithFormat:@"证书地址:%@", [NSString stringIsEmpty:detailData.item_hash] ? @"" : detailData.item_hash];
    
    if ([detailData.aasm_state isEqualToString:@"auctioning"]) {
        // 拍卖中
        self.auctioningView.hidden = NO;
    } else {
        self.auctioningView.hidden = YES;
    }
}
@end
