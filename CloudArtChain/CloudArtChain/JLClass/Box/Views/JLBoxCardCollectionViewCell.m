//
//  JLBoxCardCollectionViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/20.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBoxCardCollectionViewCell.h"

@interface JLBoxCardCollectionViewCell()
@property (nonatomic, strong) UIImageView *cardImageView;
@property (nonatomic, strong) UIView *rareView;
@property (nonatomic, strong) UIView *hadView;
@property (nonatomic, strong) UIView *live2DView;
@property (nonatomic, strong) UIImageView *playImgView;
@end

@implementation JLBoxCardCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.cardImageView];
    [self.cardImageView addSubview:self.rareView];
    [self.cardImageView addSubview:self.hadView];
    [self.cardImageView addSubview:self.live2DView];
    [self.cardImageView addSubview:self.playImgView];
    
    [self.cardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.rareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardImageView);
        make.top.mas_equalTo(20.0f);
        make.width.mas_equalTo(37.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.hadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardImageView);
        make.top.equalTo(self.rareView.mas_bottom).offset(6.0f);
        make.width.mas_equalTo(37.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.live2DView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardImageView);
        make.bottom.equalTo(self.cardImageView).offset(-15.0f);
        make.width.mas_equalTo(43.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.playImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardImageView).offset(9.0f);
        make.bottom.equalTo(self.cardImageView.mas_bottom).offset(-12.0f);
        make.width.height.mas_equalTo(@26.0f);
    }];
}

- (UIImageView *)cardImageView {
    if (!_cardImageView) {
        _cardImageView = [[UIImageView alloc] init];
        ViewBorderRadius(_cardImageView, 5.0f, 0.0f, JL_color_clear);
    }
    return _cardImageView;
}

- (UIView *)rareView {
    if (!_rareView) {
        _rareView = [[UIView alloc] init];
        _rareView.backgroundColor = JL_color_black;
        
        UIImageView *rareImageView = [JLUIFactory imageViewInitImageName:@"icon_box_rare"];
        [_rareView addSubview:rareImageView];
        
        UILabel *rareLabel = [JLUIFactory labelInitText:@"稀有" font:kFontPingFangSCSCSemibold(9.0f) textColor:JL_color_yellow_FFCC5E textAlignment:NSTextAlignmentCenter];
        [_rareView addSubview:rareLabel];
        
        [rareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(2.0f);
            make.size.mas_equalTo(9.0f);
            make.centerY.equalTo(_rareView.mas_centerY);
        }];
        [rareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rareImageView.mas_right);
            make.top.bottom.right.equalTo(_rareView);
        }];
    }
    return _rareView;
}

- (UIView *)hadView {
    if (!_hadView) {
        _hadView = [[UIView alloc] init];
        _hadView.backgroundColor = JL_color_black;
        
        UILabel *hadLabel = [JLUIFactory labelInitText:@"已拥有" font:kFontPingFangSCSCSemibold(9.0f) textColor:JL_color_green_00DEBC textAlignment:NSTextAlignmentCenter];
        [_hadView addSubview:hadLabel];
        
        [hadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_hadView);
        }];
    }
    return _hadView;
}

- (UIView *)live2DView {
    if (!_live2DView) {
        _live2DView = [[UIView alloc] init];
        _live2DView.backgroundColor = JL_color_black;
        
        UILabel *live2DLabel = [JLUIFactory labelInitText:@"Live 2D" font:kFontPingFangSCMedium(10.0f) textColor:JL_color_white_ffffff textAlignment:NSTextAlignmentCenter];
        [_live2DView addSubview:live2DLabel];
        
        [live2DLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_live2DView);
        }];
    }
    return _live2DView;
}

- (UIImageView *)playImgView {
    if (!_playImgView) {
        _playImgView = [[UIImageView alloc] init];
        _playImgView.hidden = YES;
        _playImgView.image = [UIImage imageNamed:@"nft_video_play_icon2"];
    }
    return _playImgView;
}

- (void)setCardGroupData:(Model_blind_boxes_card_groups_Data *)cardGroupData {
    if (![NSString stringIsEmpty:cardGroupData.art.img_main_file1[@"url"]]) {
        [self.cardImageView sd_setImageWithURL:[NSURL URLWithString:cardGroupData.art.img_main_file1[@"url"]]];
    }
    self.rareView.hidden = [NSString stringIsEmpty:cardGroupData.special_attr];
    self.hadView.hidden = !cardGroupData.art.is_owner;
//    if (cardGroupData.resource_type == 4) {
//        self.playImgView.hidden = NO;
//    }else {
//        self.playImgView.hidden = YES;
//    }
//        self.playImgView.hidden = [NSString stringIsEmpty:themeArtData.video_url];
    self.live2DView.hidden = [NSString stringIsEmpty:cardGroupData.art.live2d_file];
}
@end
