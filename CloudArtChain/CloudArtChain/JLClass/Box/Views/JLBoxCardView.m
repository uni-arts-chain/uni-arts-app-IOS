//
//  JLBoxCardView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/22.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBoxCardView.h"

static const CGFloat ImageViewMaxWidth = 185.0f;
static const CGFloat ImageViewMaxHeight = 250.0f;

@interface JLBoxCardView ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *imageShadowView;
@property (nonatomic, strong) UIImageView *cardImageView;
@property (nonatomic, strong) UILabel *cardNameLabel;

@property (nonatomic, strong) UIView *rareView;
@property (nonatomic, strong) UIView *live2DView;
@end

@implementation JLBoxCardView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.backView];
    [self.backView addSubview:self.imageShadowView];
    [self.backView addSubview:self.cardImageView];
    [self.cardImageView addSubview:self.rareView];
    [self.cardImageView addSubview:self.live2DView];
    [self addSubview:self.cardNameLabel];
    
    [self.cardNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(50.0f);
    }];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self.cardNameLabel.mas_top);
    }];
    [self.imageShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.backView);
    }];
    [self.cardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.backView);
    }];
    [self.rareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0.0f);
        make.top.mas_equalTo(20.0f);
        make.width.mas_equalTo(37.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.live2DView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0.0f);
        make.bottom.mas_equalTo(-15.0f);
        make.width.mas_equalTo(43.0f);
        make.height.mas_equalTo(15.0f);
    }];
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
    }
    return _backView;
}

- (UIView *)imageShadowView {
    if (!_imageShadowView) {
        _imageShadowView = [[UIView alloc] init];
        _imageShadowView.backgroundColor = JL_color_white_ffffff;
    }
    return _imageShadowView;
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

- (UILabel *)cardNameLabel {
    if (!_cardNameLabel) {
        _cardNameLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCMedium(17.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentCenter];
    }
    return _cardNameLabel;
}

- (void)setCardData:(Model_blind_box_orders_open_Data *)cardData {
    _cardData = cardData;
    if (![NSString stringIsEmpty:cardData.img_main_file1[@"url"]]) {
        [self.cardImageView sd_setImageWithURL:[NSURL URLWithString:cardData.img_main_file1[@"url"]]];
    }
    self.cardNameLabel.text = cardData.name;
    self.rareView.hidden = [NSString stringIsEmpty:cardData.special_attr];
    self.live2DView.hidden = !(cardData.resource_type == 3);
    
    CGSize imageSize = [self getImageSize];
    
    self.imageShadowView.frame = CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
    [self.imageShadowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.backView);
        make.width.mas_equalTo(imageSize.width);
        make.height.mas_equalTo(imageSize.height);
    }];
    [self.imageShadowView addShadow:[UIColor colorWithHexString:@"#404040"] cornerRadius:5.0f offsetX:0.0f];
    
    self.cardImageView.frame = CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
    [self.cardImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.backView);
        make.width.mas_equalTo(imageSize.width);
        make.height.mas_equalTo(imageSize.height);
    }];
}

- (CGSize)getImageSize {
    CGFloat currentImageWdith = ImageViewMaxWidth;
    CGFloat currentImageHeight = self.cardData.imgHeight;
    if (currentImageHeight > ImageViewMaxHeight) {
        currentImageHeight = ImageViewMaxHeight;
        currentImageWdith = ImageViewMaxWidth * ImageViewMaxHeight / self.cardData.imgHeight;
    }
    return CGSizeMake(currentImageWdith, currentImageHeight);
}

@end
