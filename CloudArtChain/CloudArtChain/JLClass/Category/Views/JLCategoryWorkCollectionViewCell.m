//
//  JLCategoryWorkCollectionViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/28.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLCategoryWorkCollectionViewCell.h"

@interface JLCategoryWorkCollectionViewCell ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIView *auctioningView;
@end

@implementation JLCategoryWorkCollectionViewCell
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

- (void)setArtDetailData:(Model_art_Detail_Data *)artDetailData {
    if (![NSString stringIsEmpty:artDetailData.img_main_file1[@"url"]]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:artDetailData.img_main_file1[@"url"]]];
        self.imageView.frame = CGRectMake(0.0f, 0.0f, (kScreenWidth - 15.0f * 2 - 14.0f) * 0.5f, self.frameHeight - self.nameLabel.frameHeight);
        [self.imageView setCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:CGSizeMake(5.0f, 5.0f)];
    }
    self.nameLabel.text = artDetailData.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", artDetailData.price];
    
    if ([artDetailData.aasm_state isEqualToString:@"auctioning"]) {
        // 拍卖中
        self.auctioningView.hidden = NO;
    } else {
        self.auctioningView.hidden = YES;
    }
    CGFloat itemW = (kScreenWidth - 15.0f * 2 - 14.0f) / 2;
    CGFloat itemH = [self getcellHWithOriginSize:CGSizeMake(itemW, 30.0f + artDetailData.imgHeight) itemW:itemW];
    self.backView.frame = CGRectMake(0.0f, 0.0f, itemW, itemH);
    [self.backView addShadow:[UIColor colorWithHexString:@"#404040"] cornerRadius:5.0f offsetX:0];
}

//计算cell的高度
- (float)getcellHWithOriginSize:(CGSize)originSize itemW:(float)itemW {
    return itemW * originSize.height / originSize.width;
}
@end
