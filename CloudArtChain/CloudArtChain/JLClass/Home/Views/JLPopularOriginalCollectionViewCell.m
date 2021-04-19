//
//  JLPopularOriginalCollectionViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/25.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLPopularOriginalCollectionViewCell.h"

@interface JLPopularOriginalCollectionViewCell ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView *auctioningView;
@end

@implementation JLPopularOriginalCollectionViewCell
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
    [self.backView addSubview:self.nameLabel];
    [self.backView addSubview:self.priceLabel];
    [self.backView addSubview:self.auctioningView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView).offset(-8.0f);
        make.bottom.equalTo(self.backView);
        make.height.mas_equalTo(30.0f);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(8.0f);
        make.bottom.equalTo(self.backView);
        make.height.mas_equalTo(30.0f);
        make.right.equalTo(self.priceLabel.mas_left).offset(-16.0f);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.backView);
        make.bottom.equalTo(self.nameLabel.mas_top);
    }];
    [self.auctioningView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.backView);
        make.width.mas_equalTo(45.0f);
        make.height.mas_equalTo(20.0f);
    }];
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
        _priceLabel.textAlignment = NSTextAlignmentRight;
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

- (void)setArtsData:(Model_auction_meetings_arts_Data *)artsData {
    if (![NSString stringIsEmpty:artsData.art.img_main_file1[@"url"]]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:artsData.art.img_main_file1[@"url"]]];
    }
    self.nameLabel.text = artsData.art.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", artsData.start_price];
}

- (void)setPopularArtData:(Model_art_Detail_Data *)popularArtData {
    if (![NSString stringIsEmpty:popularArtData.img_main_file1[@"url"]]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:popularArtData.img_main_file1[@"url"]]];
    }
    self.nameLabel.text = popularArtData.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", popularArtData.price];
    
    if ([popularArtData.aasm_state isEqualToString:@"auctioning"]) {
        // 拍卖中
        self.auctioningView.hidden = NO;
    } else {
        self.auctioningView.hidden = YES;
    }
}

- (void)setThemeArtData:(Model_art_Detail_Data *)themeArtData {
    if (![NSString stringIsEmpty:themeArtData.img_main_file1[@"url"]]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:themeArtData.img_main_file1[@"url"]]];
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
    }
    self.nameLabel.text = collectionArtData.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", collectionArtData.price];
    
    if ([collectionArtData.aasm_state isEqualToString:@"auctioning"]) {
        // 拍卖中
        self.auctioningView.hidden = NO;
    } else {
        self.auctioningView.hidden = YES;
    }
}

- (void)setAuthorArtData:(Model_art_Detail_Data *)authorArtData {
    if (![NSString stringIsEmpty:authorArtData.img_main_file1[@"url"]]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:authorArtData.img_main_file1[@"url"]]];
    }
    self.nameLabel.text = authorArtData.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", authorArtData.price];
    
    if ([authorArtData.aasm_state isEqualToString:@"auctioning"]) {
        // 拍卖中
        self.auctioningView.hidden = NO;
    } else {
        self.auctioningView.hidden = YES;
    }
    CGFloat itemW = (kScreenWidth - 15.0f * 2 - 14.0f) / 2;
    CGFloat itemH = [self getcellHWithOriginSize:CGSizeMake(itemW, 30.0f + authorArtData.imgHeight) itemW:itemW];
    self.backView.frame = CGRectMake(0.0f, 0.0f, itemW, itemH);
    [self.backView addShadow:[UIColor colorWithHexString:@"#404040"] cornerRadius:5.0f offsetX:0];
}

//计算cell的高度
- (float)getcellHWithOriginSize:(CGSize)originSize itemW:(float)itemW {
    return itemW * originSize.height / originSize.width;
}

@end
