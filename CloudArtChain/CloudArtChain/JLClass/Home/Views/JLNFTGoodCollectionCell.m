//
//  JLNFTGoodCollectionCell.m
//  CloudArtChain
//
//  Created by jielian on 2021/6/18.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLNFTGoodCollectionCell.h"

@interface JLNFTGoodCollectionCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIView *live2DView;

@property (nonatomic, strong) UIImageView *playImgView;

@property (nonatomic, strong) MASConstraint *imageViewHeightConstraint;

@end

@implementation JLNFTGoodCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = JL_color_white_ffffff;
    _bgView.layer.cornerRadius = 5;
    _bgView.layer.masksToBounds = YES;
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView);
    }];
    
    _imageView = [[UIImageView alloc] init];
    [_bgView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bgView);
        self.imageViewHeightConstraint = make.height.mas_equalTo(@170);
    }];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.font = kFontPingFangSCRegular(13.0f);
    _priceLabel.textColor = JL_color_red_FF4832;
    [_bgView addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(13.0f);
        make.right.equalTo(self.bgView).offset(-12.0f);
        make.bottom.equalTo(self.bgView).offset(-12.0f);
        make.height.mas_equalTo(11.0f);
    }];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.font = kFontPingFangSCMedium(13.0f);
    _descLabel.textColor = JL_color_black_40414D;
    _descLabel.numberOfLines = 2;
    _descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_bgView addSubview:_descLabel];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.priceLabel);
        make.top.equalTo(self.imageView.mas_bottom).offset(14.0f);
    }];
    
    _live2DView = [[UIView alloc] init];
    _live2DView.backgroundColor = JL_color_black;
    _live2DView.hidden = YES;
    UILabel *live2DLabel = [JLUIFactory labelInitText:@"Live 2D" font:kFontPingFangSCMedium(10.0f) textColor:JL_color_white_ffffff textAlignment:NSTextAlignmentCenter];
    [_live2DView addSubview:live2DLabel];
    [live2DLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_live2DView);
    }];
    [_bgView addSubview: _live2DView];
    [_live2DView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView);
        make.bottom.equalTo(self.imageView).offset(-15.0f);
        make.width.mas_equalTo(43.0f);
        make.height.mas_equalTo(15.0f);
    }];
    
    _playImgView = [[UIImageView alloc] init];
    _playImgView.hidden = YES;
    _playImgView.image = [UIImage imageNamed:@"nft_video_play_icon2"];
    [_bgView addSubview:_playImgView];
    [_playImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView).offset(9.0f);
        make.bottom.equalTo(self.imageView.mas_bottom).offset(-12.0f);
        make.width.height.mas_equalTo(@26.0f);
    }];
}

#pragma mark - setters and getters
- (void)setArtDetailData:(Model_art_Detail_Data *)artDetailData {
    _artDetailData = artDetailData;
    
    if (![NSString stringIsEmpty:_artDetailData.img_main_file1[@"url"]]) {

        [_imageViewHeightConstraint uninstall];
        [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.imageViewHeightConstraint = make.height.mas_equalTo(@(_artDetailData.imgHeight));
        }];
        
        [_imageView sd_setImageWithURL:[NSURL URLWithString:_artDetailData.img_main_file1[@"url"]]];
    }
    self.descLabel.text = _artDetailData.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", _artDetailData.price];
    if (_artDetailData.resource_type == 4) {
        self.playImgView.hidden = NO;
    }else {
        self.playImgView.hidden = YES;
    }
    self.live2DView.hidden = [NSString stringIsEmpty:_artDetailData.live2d_file];
}

@end
