//
//  JLHomePageCollectionViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/16.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLHomePageCollectionViewCell.h"
#import "JLArtAuctionTimeView.h"

@interface JLHomePageCollectionViewCell ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) UIButton *sellButton;
@property (nonatomic, strong) UIButton *offShelfButton;
@property (nonatomic, strong) UIButton *transferButton;
/// 拍卖
@property (nonatomic, strong) UIButton *auctionBtn;
/// 取消拍卖
@property (nonatomic, strong) UIButton *cancelAuctionBtn;

@property (nonatomic, strong) UIView *live2DView;
@property (nonatomic, strong) UIView *videoView;

@property (nonatomic, strong) JLArtAuctionTimeView *timeView;

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

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backView addShadow:[UIColor colorWithHexString:@"#404040"] cornerRadius:5.0f offsetX:0];
}

- (void)createSubViews {
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.imageView];
    [self.backView addSubview:self.live2DView];
    [self.backView addSubview:self.videoView];
    [self.backView addSubview:self.timeView];
    
    [self.backView addSubview:self.bottomView];
    [self.bottomView addSubview:self.nameLabel];
    [self.bottomView addSubview:self.priceLabel];
    [self.bottomView addSubview:self.lineImageView];
    [self.bottomView addSubview:self.sellButton];
    [self.bottomView addSubview:self.offShelfButton];
    [self.bottomView addSubview:self.transferButton];
    [self.bottomView addSubview:self.auctionBtn];
    [self.bottomView addSubview:self.cancelAuctionBtn];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.backView);
        make.height.mas_equalTo(110.0f);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(10.0f);
        make.right.equalTo(self.bottomView).offset(-10.0f);
        make.top.equalTo(self.bottomView).offset(6.0f);
        make.height.mas_equalTo(20.0f);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(10.0f);
        make.right.equalTo(self.bottomView).offset(-10.0f);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(7);
        make.height.mas_equalTo(20.0f);
    }];
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLabel.mas_bottom).offset(10.0f);
        make.left.mas_equalTo(12.0f);
        make.right.mas_equalTo(-12.0f);
        make.height.mas_equalTo(1.0f);
    }];
    [self.transferButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineImageView.mas_bottom).offset(10.0f);
        make.right.equalTo(self.bottomView).offset(-10);
        make.width.mas_equalTo(43.0f);
        make.height.mas_equalTo(22.0f);
    }];
    [self.sellButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineImageView.mas_bottom).offset(10.0f);
        make.left.equalTo(self.bottomView).offset(10);
        make.width.mas_equalTo(43.0f);
        make.height.mas_equalTo(22.0f);
    }];
    [self.auctionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView);
        make.centerY.equalTo(self.sellButton);
        make.width.mas_equalTo(43.0f);
        make.height.mas_equalTo(22.0f);
    }];
    [self.offShelfButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineImageView.mas_bottom).offset(10.0f);
        make.right.equalTo(self.bottomView).offset(-10);
        make.width.mas_equalTo(56.0f);
        make.height.mas_equalTo(22.0f);
    }];
    [self.cancelAuctionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineImageView.mas_bottom).offset(10.0f);
        make.right.equalTo(self.bottomView).offset(-10);
        make.width.mas_equalTo(72.0f);
        make.height.mas_equalTo(22.0f);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.backView);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.imageView);
        make.height.mas_equalTo(@18);
    }];
    [self.live2DView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView);
        make.top.equalTo(self.backView).offset(10.0f);
        make.width.mas_equalTo(43.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView);
        make.top.equalTo(self.backView).offset(10.0f);
        make.width.mas_equalTo(43.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.contentView setNeedsLayout];
}

- (UIView *)backView {
    if (!_backView) {
        //WithFrame:CGRectMake(0.0f, 0.0f, (kScreenWidth - 15.0f * 2 - 14.0f) * 0.5f, 250.0f)
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = JL_color_white_ffffff;
        ViewBorderRadius(_backView, 5.0f, 0.0f, JL_color_clear);
    }
    return _backView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, (kScreenWidth - 15.0f * 2 - 14.0f) * 0.5f, 220.0f)];
        [_imageView setCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:CGSizeMake(5.0f, 5.0f)];
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
        _nameLabel.font = kFontPingFangSCMedium(14.0f);
        _nameLabel.textColor = JL_color_gray_101010;
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = kFontPingFangSCRegular(13.0f);
        _priceLabel.textColor = JL_color_gray_101010;
    }
    return _priceLabel;
}

- (UIImageView *)lineImageView {
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] init];
        _lineImageView.image = [UIImage imageNamed:@"icon_homepage_line"];
    }
    return _lineImageView;
}

- (UIButton *)sellButton {
    if (!_sellButton) {
        _sellButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sellButton setTitle:@"出售" forState:UIControlStateNormal];
        [_sellButton setTitleColor:JL_color_gray_101010 forState:UIControlStateNormal];
        _sellButton.titleLabel.font = kFontPingFangSCRegular(13.0f);
        _sellButton.hidden = YES;
        [_sellButton addTarget:self action:@selector(sellButtonClick) forControlEvents:UIControlEventTouchUpInside];
        ViewBorderRadius(_sellButton, 11.0f, 1.0f, JL_color_gray_101010);
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
        [_offShelfButton setTitleColor:JL_color_gray_101010 forState:UIControlStateNormal];
        _offShelfButton.titleLabel.font = kFontPingFangSCRegular(13.0f);
        _offShelfButton.hidden = YES;
        [_offShelfButton addTarget:self action:@selector(offShelfButtonClick) forControlEvents:UIControlEventTouchUpInside];
        ViewBorderRadius(_offShelfButton, 11.0f, 1.0f, JL_color_gray_101010);
    }
    return _offShelfButton;
}

- (void)offShelfButtonClick {
    if (self.offFromListBlock) {
        self.offFromListBlock(self.artDetailData);
    }
}

- (UIButton *)transferButton {
    if (!_transferButton) {
        _transferButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_transferButton setTitle:@"转让" forState:UIControlStateNormal];
        [_transferButton setTitleColor:JL_color_gray_101010 forState:UIControlStateNormal];
        _transferButton.titleLabel.font = kFontPingFangSCRegular(13.0f);
        [_transferButton addTarget:self action:@selector(transferButtonClick) forControlEvents:UIControlEventTouchUpInside];
        ViewBorderRadius(_transferButton, 11.0f, 1.0f, JL_color_gray_101010);
    }
    return _transferButton;
}

- (void)transferButtonClick {
    if (self.transferBlock) {
        self.transferBlock(self.artDetailData);
    }
}

- (UIButton *)auctionBtn {
    if (!_auctionBtn) {
        _auctionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_auctionBtn setTitle:@"拍卖" forState:UIControlStateNormal];
        [_auctionBtn setTitleColor:JL_color_gray_101010 forState:UIControlStateNormal];
        _auctionBtn.titleLabel.font = kFontPingFangSCRegular(13.0f);
        [_auctionBtn addTarget:self action:@selector(auctionBtnClick) forControlEvents:UIControlEventTouchUpInside];
        ViewBorderRadius(_auctionBtn, 11.0f, 1.0f, JL_color_gray_101010);
    }
    return _auctionBtn;
}

- (void)auctionBtnClick {
    if (self.auctionBlock) {
        self.auctionBlock(self.artDetailData);
    }
}

- (UIButton *)cancelAuctionBtn {
    if (!_cancelAuctionBtn) {
        _cancelAuctionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelAuctionBtn.hidden = YES;
        [_cancelAuctionBtn setTitle:@"取消拍卖" forState:UIControlStateNormal];
        [_cancelAuctionBtn setTitleColor:JL_color_gray_101010 forState:UIControlStateNormal];
        _cancelAuctionBtn.titleLabel.font = kFontPingFangSCRegular(13.0f);
        [_cancelAuctionBtn addTarget:self action:@selector(cancelAuctionBtnClick) forControlEvents:UIControlEventTouchUpInside];
        ViewBorderRadius(_cancelAuctionBtn, 11.0f, 1.0f, JL_color_gray_101010);
    }
    return _cancelAuctionBtn;
}

- (void)cancelAuctionBtnClick {
    if (self.cancelAuctionBlock) {
        self.cancelAuctionBlock(self.auctionsData);
    }
}

- (UIView *)live2DView {
    if (!_live2DView) {
        _live2DView = [[UIView alloc] init];
        _live2DView.backgroundColor = JL_color_black;
        _live2DView.hidden = YES;
        
        UILabel *live2DLabel = [JLUIFactory labelInitText:@"Live 2D" font:kFontPingFangSCMedium(10.0f) textColor:JL_color_white_ffffff textAlignment:NSTextAlignmentCenter];
        [_live2DView addSubview:live2DLabel];
        
        [live2DLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_live2DView);
        }];
    }
    return _live2DView;
}

- (UIView *)videoView {
    if (!_videoView) {
        _videoView = [[UIView alloc] init];
        _videoView.backgroundColor = JL_color_black;
        _videoView.hidden = YES;
        
        UIImageView *playImgView = [[UIImageView alloc] init];
        playImgView.image = [UIImage imageNamed:@"nft_video_play_icon3"];
        [_videoView addSubview:playImgView];
        [playImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_videoView);
            make.left.equalTo(_videoView).offset(4);
            make.width.height.mas_equalTo(@10);
        }];
        
        UILabel *label = [JLUIFactory labelInitText:@"视频" font:kFontPingFangSCMedium(10.0f) textColor:JL_color_white_ffffff textAlignment:NSTextAlignmentLeft];
        [_videoView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(playImgView.mas_right).offset(5);
            make.centerY.equalTo(playImgView);
        }];
    }
    return _videoView;
}

- (JLArtAuctionTimeView *)timeView {
    if (!_timeView) {
        _timeView = [[JLArtAuctionTimeView alloc] init];
        _timeView.hidden = YES;
    }
    return _timeView;
}

- (void)setArtDetailData:(Model_art_Detail_Data *)artDetailData type:(JLWorkListType)listType {
    self.artDetailData = artDetailData;
    if (![NSString stringIsEmpty:artDetailData.img_main_file1[@"url"]]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:artDetailData.img_main_file1[@"url"]]];
        self.imageView.frame = CGRectMake(0.0f, 0.0f, (kScreenWidth - 15.0f * 2 - 14.0f) * 0.5f, self.frameHeight - 110.0f);
        [self.imageView setCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:CGSizeMake(5.0f, 5.0f)];
    }
    self.nameLabel.text = artDetailData.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", [NSString stringIsEmpty:artDetailData.price] ? @"0" : artDetailData.price];
    
    if (artDetailData.resource_type == 4) {
        self.videoView.hidden = NO;
    }else {
        self.videoView.hidden = YES;
    }
//    self.playImgView.hidden = [NSString stringIsEmpty:artDetailData.video_url];
    self.live2DView.hidden = [NSString stringIsEmpty:artDetailData.live2d_file];
    
    if (listType == JLWorkListTypeNotList) {
        self.sellButton.hidden = NO;
        self.offShelfButton.hidden = YES;
        self.transferButton.hidden = NO;
        [self.transferButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineImageView.mas_bottom).offset(10.0f);
            make.right.equalTo(self.bottomView).offset(-10);
            make.width.mas_equalTo(43.0f);
            make.height.mas_equalTo(22.0f);
        }];
    } else if (listType == JLWorkListTypeListed) {
        self.sellButton.hidden = YES;
        self.auctionBtn.hidden = YES;
        self.offShelfButton.hidden = NO;
        if (artDetailData.collection_mode == 3) {
            if (artDetailData.has_amount - artDetailData.selling_amount.intValue > 0) {
                self.transferButton.hidden = NO;
                [self.transferButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.lineImageView.mas_bottom).offset(10.0f);
                    make.left.equalTo(self.bottomView).offset(10);
                    make.width.mas_equalTo(43.0f);
                    make.height.mas_equalTo(22.0f);
                }];
            } else {
                self.transferButton.hidden = YES;
            }
        } else {
            self.transferButton.hidden = YES;
        }
    }
    
    CGFloat itemW = (kScreenWidth - 15.0f * 2 - 14.0f) / 2;
    CGFloat itemH = [self getcellHWithOriginSize:CGSizeMake(itemW, 110.0f + artDetailData.imgHeight) itemW:itemW];
    self.backView.frame = CGRectMake(0.0f, 0.0f, itemW, itemH);
    [self.backView addShadow:[UIColor colorWithHexString:@"#404040"] cornerRadius:5.0f offsetX:0];
}

- (void)setAuctionsData:(Model_auctions_Data *)auctionsData {
    _auctionsData = auctionsData;
    if (![NSString stringIsEmpty:auctionsData.art.img_main_file1[@"url"]]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:auctionsData.art.img_main_file1[@"url"]]];
        self.imageView.frame = CGRectMake(0.0f, 0.0f, (kScreenWidth - 15.0f * 2 - 14.0f) * 0.5f, self.frameHeight - 110.0f);
        [self.imageView setCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:CGSizeMake(5.0f, 5.0f)];
    }
    self.nameLabel.text = auctionsData.art.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", [NSString stringIsEmpty:auctionsData.art.price] ? @"0" : auctionsData.art.price];
    
    if (auctionsData.art.resource_type == 4) {
        self.videoView.hidden = NO;
    }else {
        self.videoView.hidden = YES;
    }
//    self.playImgView.hidden = [NSString stringIsEmpty:artDetailData.video_url];
    self.live2DView.hidden = [NSString stringIsEmpty:auctionsData.art.live2d_file];
    
    self.cancelAuctionBtn.hidden = NO;
    self.sellButton.hidden = YES;
    self.auctionBtn.hidden = YES;
    self.offShelfButton.hidden = YES;
    self.transferButton.hidden = YES;
    
    if (auctionsData.can_cancel) {
        self.cancelAuctionBtn.userInteractionEnabled = YES;
        [self.cancelAuctionBtn setTitleColor:JL_color_gray_101010 forState:UIControlStateNormal];
        ViewBorderRadius(self.cancelAuctionBtn, 11.0f, 1.0f, JL_color_gray_101010);
    }else {
        self.cancelAuctionBtn.userInteractionEnabled = NO;
        [self.cancelAuctionBtn setTitleColor:[UIColor colorWithHexString:@"#D2D2D2"] forState:UIControlStateNormal];
        ViewBorderRadius(self.cancelAuctionBtn, 11.0f, 1.0f, [UIColor colorWithHexString:@"#D2D2D2"]);
    }
    
    self.timeView.hidden = NO;
    self.timeView.isShowStatus = YES;
    self.timeView.auctionsData = auctionsData;
    
    CGFloat itemW = (kScreenWidth - 15.0f * 2 - 14.0f) / 2;
    CGFloat itemH = [self getcellHWithOriginSize:CGSizeMake(itemW, 110.0f + auctionsData.art.imgHeight) itemW:itemW];
    self.backView.frame = CGRectMake(0.0f, 0.0f, itemW, itemH);
    [self.backView addShadow:[UIColor colorWithHexString:@"#404040"] cornerRadius:5.0f offsetX:0];
}

//计算cell的高度
- (float)getcellHWithOriginSize:(CGSize)originSize itemW:(float)itemW {
    return itemW * originSize.height / originSize.width;
}


@end
