//
//  JLPopularOriginalCollectionViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/25.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLPopularOriginalCollectionViewCell.h"
#import "JLArtAuctionTimeView.h"

@interface JLPopularOriginalCollectionViewCell ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView *auctioningView;
@property (nonatomic, strong) UIView *live2DView;
@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) JLArtAuctionTimeView *timeView;
@end

@implementation JLPopularOriginalCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    [self.backView addShadow:[UIColor colorWithHexString:@"#404040"] cornerRadius:5.0f offsetX:0];
//}

- (void)createSubViews {
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.imageView];
    [self.backView addSubview:self.nameLabel];
    [self.backView addSubview:self.priceLabel];
    [self.backView addSubview:self.auctioningView];
    [self.backView addSubview:self.live2DView];
    [self.backView addSubview:self.videoView];
    [self.backView addSubview:self.timeView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView).offset(-8.0f);
        make.left.equalTo(self.backView).offset(8.0f);
        make.bottom.equalTo(self.backView).offset(-6.0f);
        make.height.mas_equalTo(19.0f);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(8.0f);
        make.bottom.equalTo(self.priceLabel.mas_top);
        make.height.mas_equalTo(19.0f);
        make.right.equalTo(self.backView).offset(-8.0f);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.backView);
        make.bottom.equalTo(self.nameLabel.mas_top).offset(-5.0f);
    }];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.imageView);
        make.height.mas_equalTo(@18);
    }];
    [self.auctioningView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.backView);
        make.width.mas_equalTo(45.0f);
        make.height.mas_equalTo(20.0f);
    }];
    [self.live2DView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(10.0f);
        make.width.mas_equalTo(43.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(10.0f);
        make.width.mas_equalTo(43.0f);
        make.height.mas_equalTo(15.0f);
    }];
}

- (UIView *)backView {
    if (!_backView) {
        //WithFrame:CGRectMake(0.0f, 0.0f, (kScreenWidth - 15.0f * 2 - 14.0f) * 0.5f, 250.0f)
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = JL_color_white_ffffff;
        _backView.layer.cornerRadius = 5;
        _backView.layer.shadowColor = [UIColor colorWithHexString:@"#404040"].CGColor;
        _backView.layer.shadowOpacity = 0.3f;
        _backView.layer.shadowOffset = CGSizeMake(0, 2);
        _backView.layer.shadowRadius = 5.0f;
//        ViewBorderRadius(_backView, 5.0f, 0.0f, JL_color_clear);
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

- (void)setArtsData:(Model_auction_meetings_arts_Data *)artsData {
    if (![NSString stringIsEmpty:artsData.art.img_main_file1[@"url"]]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:artsData.art.img_main_file1[@"url"]]];
        self.imageView.frame = CGRectMake(0.0f, 0.0f, (kScreenWidth - 15.0f * 2 - 14.0f) * 0.5f, self.frameHeight - 49.0f);
        [self.imageView setCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:CGSizeMake(5.0f, 5.0f)];
    }
    self.nameLabel.text = artsData.art.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", artsData.start_price];
}

- (void)setPopularArtData:(Model_art_Detail_Data *)popularArtData {
    if (![NSString stringIsEmpty:popularArtData.img_main_file1[@"url"]]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:popularArtData.img_main_file1[@"url"]]];
        self.imageView.frame = CGRectMake(0.0f, 0.0f, (kScreenWidth - 15.0f * 2 - 14.0f) * 0.5f, self.frameHeight - 49.0f);
        [self.imageView setCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:CGSizeMake(5.0f, 5.0f)];
    }
    self.nameLabel.text = popularArtData.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", popularArtData.price];
    
    if ([popularArtData.aasm_state isEqualToString:@"auctioning"]) {
        // 拍卖中
        self.auctioningView.hidden = NO;
    } else {
        self.auctioningView.hidden = YES;
    }
    if (popularArtData.resource_type == 4) {
        self.videoView.hidden = NO;
    }else {
        self.videoView.hidden = YES;
    }
//    self.playImgView.hidden = [NSString stringIsEmpty:popularArtData.video_url];
    self.live2DView.hidden = [NSString stringIsEmpty:popularArtData.live2d_file];
//    CGFloat itemW = (kScreenWidth - 15.0f * 2 - 14.0f) / 2;
//    CGFloat itemH = [self getcellHWithOriginSize:CGSizeMake(itemW, 49.0f + popularArtData.imgHeight) itemW:itemW];
//    self.backView.frame = CGRectMake(0.0f, 0.0f, itemW, itemH);
//    [self.backView addShadow:[UIColor colorWithHexString:@"#404040"] cornerRadius:5.0f offsetX:0];
}

- (void)setThemeArtData:(Model_art_Detail_Data *)themeArtData {
    if (![NSString stringIsEmpty:themeArtData.img_main_file1[@"url"]]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:themeArtData.img_main_file1[@"url"]]];
        self.imageView.frame = CGRectMake(0.0f, 0.0f, (kScreenWidth - 15.0f * 2 - 14.0f) * 0.5f, self.frameHeight - 49.0f);
        [self.imageView setCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:CGSizeMake(5.0f, 5.0f)];
    }
    self.nameLabel.text = themeArtData.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", themeArtData.price];
    
    if ([themeArtData.aasm_state isEqualToString:@"auctioning"]) {
        // 拍卖中
        self.auctioningView.hidden = NO;
    } else {
        self.auctioningView.hidden = YES;
    }
}

- (void)setCollectionArtData:(Model_art_Detail_Data *)collectionArtData {
    if (![NSString stringIsEmpty:collectionArtData.img_main_file1[@"url"]]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:collectionArtData.img_main_file1[@"url"]]];
        self.imageView.frame = CGRectMake(0.0f, 0.0f, (kScreenWidth - 15.0f * 2 - 14.0f) * 0.5f, self.frameHeight - 49.0f);
        [self.imageView setCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:CGSizeMake(5.0f, 5.0f)];
    }
    self.nameLabel.text = collectionArtData.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", collectionArtData.price];
    
    if ([collectionArtData.aasm_state isEqualToString:@"auctioning"]) {
        // 拍卖中
        self.auctioningView.hidden = NO;
    } else {
        self.auctioningView.hidden = YES;
    }
    if (collectionArtData.resource_type == 4) {
        self.videoView.hidden = NO;
    }else {
        self.videoView.hidden = YES;
    }
//    self.playImgView.hidden = [NSString stringIsEmpty:collectionArtData.video_url];
    self.live2DView.hidden = [NSString stringIsEmpty:collectionArtData.live2d_file];
//    CGFloat itemW = (kScreenWidth - 15.0f * 2 - 14.0f) / 2;
//    CGFloat itemH = [self getcellHWithOriginSize:CGSizeMake(itemW, 49.0f + collectionArtData.imgHeight) itemW:itemW];
//    self.backView.frame = CGRectMake(0.0f, 0.0f, itemW, itemH);
//    [self.backView addShadow:[UIColor colorWithHexString:@"#404040"] cornerRadius:5.0f offsetX:0];
}

- (void)setAuthorArtData:(Model_art_Detail_Data *)authorArtData {
    if (![NSString stringIsEmpty:authorArtData.img_main_file1[@"url"]]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:authorArtData.img_main_file1[@"url"]]];
        self.imageView.frame = CGRectMake(0.0f, 0.0f, (kScreenWidth - 15.0f * 2 - 14.0f) * 0.5f, self.frameHeight - 49.0f);
        [self.imageView setCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:CGSizeMake(5.0f, 5.0f)];
    }
    self.nameLabel.text = authorArtData.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", authorArtData.price];
    
    if ([authorArtData.aasm_state isEqualToString:@"auctioning"]) {
        // 拍卖中
        self.auctioningView.hidden = NO;
    } else {
        self.auctioningView.hidden = YES;
    }
    if (authorArtData.resource_type == 4) {
        self.videoView.hidden = NO;
    }else {
        self.videoView.hidden = YES;
    }
//    self.playImgView.hidden = [NSString stringIsEmpty:authorArtData.video_url];
    self.live2DView.hidden = [NSString stringIsEmpty:authorArtData.live2d_file];
//    CGFloat itemW = (kScreenWidth - 15.0f * 2 - 14.0f) / 2;
//    CGFloat itemH = [self getcellHWithOriginSize:CGSizeMake(itemW, 49.0f + authorArtData.imgHeight) itemW:itemW];
//    self.backView.frame = CGRectMake(0.0f, 0.0f, itemW, itemH);
//    [self.backView addShadow:[UIColor colorWithHexString:@"#404040"] cornerRadius:5.0f offsetX:0];
}

- (void)setAuctionsData:(Model_auctions_Data *)auctionsData {
    _auctionsData = auctionsData;
    
    if (![NSString stringIsEmpty:auctionsData.art.img_main_file1[@"url"]]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:auctionsData.art.img_main_file1[@"url"]]];
        self.imageView.frame = CGRectMake(0.0f, 0.0f, (kScreenWidth - 15.0f * 2 - 14.0f) * 0.5f, self.frameHeight - 49.0f);
        [self.imageView setCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:CGSizeMake(5.0f, 5.0f)];
    }
    self.nameLabel.text = auctionsData.art.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", auctionsData.start_price];
    
    if ([auctionsData.art.aasm_state isEqualToString:@"auctioning"]) {
        // 拍卖中
        self.auctioningView.hidden = NO;
    } else {
        self.auctioningView.hidden = YES;
    }
    if (auctionsData.art.resource_type == 4) {
        self.videoView.hidden = NO;
    }else {
        self.videoView.hidden = YES;
    }
//    self.playImgView.hidden = [NSString stringIsEmpty:authorArtData.video_url];
    self.live2DView.hidden = [NSString stringIsEmpty:auctionsData.art.live2d_file];
    
    self.timeView.hidden = NO;
    self.timeView.auctionsData = auctionsData;
    
//    CGFloat itemW = (kScreenWidth - 15.0f * 2 - 14.0f) / 2;
//    CGFloat itemH = [self getcellHWithOriginSize:CGSizeMake(itemW, 49.0f + auctionsData.art.imgHeight) itemW:itemW];
//    self.backView.frame = CGRectMake(0.0f, 0.0f, itemW, itemH);
//    [self.backView addShadow:[UIColor colorWithHexString:@"#404040"] cornerRadius:5.0f offsetX:0];
}

//计算cell的高度
- (float)getcellHWithOriginSize:(CGSize)originSize itemW:(float)itemW {
    return itemW * originSize.height / originSize.width;
}

@end
