//
//  JLHomePageCollectionViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/16.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLHomePageCollectionViewCell.h"

@interface JLHomePageCollectionViewCell ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *sellButton;
@property (nonatomic, strong) UIButton *offShelfButton;
@property (nonatomic, strong) UIButton *transferButton;

@property (nonatomic, strong) UIView *auctioningView;
@property (nonatomic, strong) UIView *live2DView;
@property (nonatomic, strong) UIImageView *playImgView;

@property (nonatomic, strong) Model_art_Detail_Data *artDetailData;
@end

@implementation JLHomePageCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.imageView];
    [self.backView addSubview:self.auctioningView];
    [self.backView addSubview:self.live2DView];
    
    [self.backView addSubview:self.bottomView];
    [self.bottomView addSubview:self.nameLabel];
    [self.bottomView addSubview:self.priceLabel];
    [self.bottomView addSubview:self.sellButton];
    [self.bottomView addSubview:self.offShelfButton];
    [self.bottomView addSubview:self.transferButton];
    [self.bottomView addSubview:self.playImgView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.backView);
        make.height.mas_equalTo(72.0f);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(13.0f);
        make.right.equalTo(self.bottomView).offset(-83.0f);
        make.top.equalTo(self.bottomView).offset(16.0f);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).offset(-12.0f);
        make.centerY.equalTo(self.nameLabel);
    }];
    [self.transferButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.bottomView);
        make.width.mas_equalTo(49.0f);
        make.height.mas_equalTo(37.0f);
    }];
    [self.sellButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.bottomView);
        make.width.mas_equalTo(49.0f);
        make.height.mas_equalTo(37.0f);
    }];
    [self.offShelfButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.bottomView);
        make.width.mas_equalTo(49.0f);
        make.height.mas_equalTo(37.0f);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.backView);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.auctioningView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.backView);
        make.width.mas_equalTo(45.0f);
        make.height.mas_equalTo(20.0f);
    }];
    [self.live2DView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView);
        make.bottom.equalTo(self.bottomView.mas_top).offset(-15.0f);
        make.width.mas_equalTo(43.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.playImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView).offset(14.0f);
        make.bottom.equalTo(self.imageView.mas_bottom).offset(-13.0f);
        make.width.height.mas_equalTo(@26.0f);
    }];
}

- (UIView *)backView {
    if (!_backView) {
        //WithFrame:CGRectMake(0.0f, 0.0f, (kScreenWidth - 15.0f * 2 - 14.0f) * 0.5f, 250.0f)
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = JL_color_white_ffffff;
        _backView.layer.cornerRadius = 5;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, (kScreenWidth - 12.0f * 2 - 12.0f) * 0.5f, 220.0f)];
    }
    return _imageView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = kFontPingFangSCMedium(13.0f);
        _nameLabel.textColor = JL_color_black_40414D;
        _nameLabel.numberOfLines = 1;
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = kFontPingFangSCRegular(13.0f);
        _priceLabel.textColor = JL_color_mainColor;
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}

- (UIButton *)sellButton {
    if (!_sellButton) {
        _sellButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sellButton setTitle:@"出售" forState:UIControlStateNormal];
        [_sellButton setTitleColor:JL_color_mainColor forState:UIControlStateNormal];
        _sellButton.titleLabel.font = kFontPingFangSCMedium(13.0f);
        _sellButton.hidden = YES;
        [_sellButton addTarget:self action:@selector(sellButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sellButton;
}

- (void)sellButtonClick {
    if (self.addToListBlock) {
        self.addToListBlock(self.artDetailData);
    }
}

- (UIButton *)offShelfButton {
    if (!_offShelfButton) {
        _offShelfButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_offShelfButton setTitle:@"下架" forState:UIControlStateNormal];
        [_offShelfButton setTitleColor:JL_color_mainColor forState:UIControlStateNormal];
        _offShelfButton.titleLabel.font = kFontPingFangSCMedium(13.0f);
        _offShelfButton.hidden = YES;
        [_offShelfButton addTarget:self action:@selector(offShelfButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _offShelfButton;
}

- (UIImageView *)playImgView {
    if (!_playImgView) {
        _playImgView = [[UIImageView alloc] init];
        _playImgView.hidden = YES;
        _playImgView.image = [UIImage imageNamed:@"nft_video_play_icon2"];
    }
    return _playImgView;
}

- (void)offShelfButtonClick {
    if (self.offFromListBlock) {
        self.offFromListBlock(self.artDetailData);
    }
}

- (UIButton *)transferButton {
    if (!_transferButton) {
        _transferButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_transferButton setTitle:@"赠送" forState:UIControlStateNormal];
        [_transferButton setTitleColor:JL_color_gray_87888F forState:UIControlStateNormal];
        _transferButton.titleLabel.font = kFontPingFangSCMedium(13.0f);
        [_transferButton addTarget:self action:@selector(transferButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _transferButton;
}

- (void)transferButtonClick {
    if (self.transferBlock) {
        self.transferBlock(self.artDetailData);
    }
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

- (UIView *)live2DView {
    if (!_live2DView) {
        _live2DView = [[UIView alloc] init];
        _live2DView.backgroundColor = JL_color_mainColor;
        _live2DView.hidden = YES;
        
        UILabel *live2DLabel = [JLUIFactory labelInitText:@"Live 2D" font:kFontPingFangSCMedium(10.0f) textColor:JL_color_white_ffffff textAlignment:NSTextAlignmentCenter];
        [_live2DView addSubview:live2DLabel];
        
        [live2DLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_live2DView);
        }];
    }
    return _live2DView;
}

- (void)setArtDetailData:(Model_art_Detail_Data *)artDetailData type:(JLWorkListType)listType {
    self.artDetailData = artDetailData;
    if (![NSString stringIsEmpty:artDetailData.img_main_file1[@"url"]]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:artDetailData.img_main_file1[@"url"]]];
    }
    self.nameLabel.text = artDetailData.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", [NSString stringIsEmpty:artDetailData.price] ? @"0" : artDetailData.price];
    if (self.marketLevel == 1 && ![NSString stringIsEmpty:artDetailData.primary_lowest_pirce]) {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@", artDetailData.primary_lowest_pirce];
    }else if (self.marketLevel == 2 && ![NSString stringIsEmpty:artDetailData.secondary_lowest_pirce]) {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@", artDetailData.secondary_lowest_pirce];
    }
    
    if ([artDetailData.aasm_state isEqualToString:@"auctioning"]) {
        // 拍卖中
        self.auctioningView.hidden = NO;
    } else {
        self.auctioningView.hidden = YES;
    }
    if (artDetailData.resource_type == 4) {
        self.playImgView.hidden = NO;
    }else {
        self.playImgView.hidden = YES;
    }
//    self.playImgView.hidden = [NSString stringIsEmpty:artDetailData.video_url];
    self.live2DView.hidden = [NSString stringIsEmpty:artDetailData.live2d_file];
    
    if (listType == JLWorkListTypeNotList) {
        self.sellButton.hidden = NO;
        self.offShelfButton.hidden = YES;
        self.transferButton.hidden = NO;
    } else {
        self.sellButton.hidden = YES;
        self.offShelfButton.hidden = NO;
        if (artDetailData.collection_mode == 3) {
            if (artDetailData.has_amount - artDetailData.selling_amount.intValue > 0) {
                self.transferButton.hidden = NO;
            } else {
                self.transferButton.hidden = YES;
            }
        } else {
            self.transferButton.hidden = YES;
        }
    }
}

@end
