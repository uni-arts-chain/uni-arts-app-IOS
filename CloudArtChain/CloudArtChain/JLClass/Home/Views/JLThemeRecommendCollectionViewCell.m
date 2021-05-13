//
//  JLThemeRecommendCollectionViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/15.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLThemeRecommendCollectionViewCell.h"

@interface JLThemeRecommendCollectionViewCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView *auctioningView;
@property (nonatomic, strong) UIView *moreView;
@end

@implementation JLThemeRecommendCollectionViewCell
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
    [self addSubview:self.priceLabel];
    [self addSubview:self.auctioningView];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(25.0f);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(25.0f);
        make.right.equalTo(self.priceLabel.mas_left).offset(-16.0f);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self.nameLabel.mas_top);
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
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        ViewBorderRadius(_imageView, 5.0f, 0.0f, JL_color_clear);
    }
    return _imageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = kFontPingFangSCMedium(13.0f);
        _nameLabel.textColor = JL_color_gray_101010;
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = kFontPingFangSCRegular(12.0f);
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

- (UIView *)moreView {
    if (!_moreView) {
        _moreView = [[UIView alloc] init];
        _moreView.backgroundColor = JL_color_clear;
        
        UIImageView *maskImageView = [[UIImageView alloc] init];
        maskImageView.image = [UIImage imageNamed:@"icon_theme_see_more"];
        [_moreView addSubview:maskImageView];
        
        UILabel *moreLabel = [JLUIFactory labelInitText:@"查看更多" font:kFontPingFangSCRegular(11.0f) textColor:JL_color_white_ffffff textAlignment:NSTextAlignmentCenter];
        [_moreView addSubview:moreLabel];
        
        [maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_moreView);
            make.size.mas_equalTo(25.0f);
            make.centerX.equalTo(_moreView.mas_centerX);
        }];
        [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(_moreView);
            make.top.equalTo(maskImageView.mas_bottom).offset(14.0f);
        }];
    }
    return _moreView;
}

- (void)setThemeArtData:(Model_art_Detail_Data *)themeArtData totalCount:(NSInteger)totalCount index:(NSInteger)index {
    WS(weakSelf)
    if (index == totalCount - 1) {
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = [JL_color_gray_101010 colorWithAlphaComponent:0.5f];
        [self.imageView addSubview:backView];
        
        [backView addSubview:self.moreView];
        
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.imageView);
        }];
        [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(backView);
        }];
        if (![NSString stringIsEmpty:themeArtData.img_main_file1[@"url"]]) {
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:themeArtData.img_main_file1[@"url"]] options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                weakSelf.imageView.image = [self coreBlurImage:image withBlurNumber:15.0f];
            }];
        }
    } else {
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
}

/**
 使用CoreImage进行高斯模糊

 @param image 需要模糊的图片
 @param blur 模糊的范围 可以1~99
 @return 返回已经模糊过的图片
 */
- (UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage= [CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey]; [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

@end
