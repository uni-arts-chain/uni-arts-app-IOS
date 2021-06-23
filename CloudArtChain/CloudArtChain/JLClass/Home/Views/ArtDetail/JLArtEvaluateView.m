//
//  JLArtEvaluateView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/2.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLArtEvaluateView.h"

@interface JLArtEvaluateView ()
@property (nonatomic, strong) Model_art_Detail_Data *artDetailData;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *evaluateLabel;
@property (nonatomic, strong) UIView *imageContentView;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *imageViewArray;
@end

@implementation JLArtEvaluateView
- (instancetype)initWithFrame:(CGRect)frame artDetailData:(Model_art_Detail_Data *)artDetailData; {
    if (self = [super initWithFrame:frame]) {
        self.artDetailData = artDetailData;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.bgView];
    
    [self.bgView addSubview:self.evaluateLabel];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(48.0f);
    }];
    
    if (self.artDetailData.detail_imgs.count) {
        [self.evaluateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView).offset(12.0f);
            make.right.equalTo(self.bgView).offset(-12.0f);
            make.top.equalTo(self.bgView).offset(20.0f);
        }];
        
        _imageContentView = [[UIView alloc] init];
        [self.bgView addSubview:_imageContentView];
        [_imageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.evaluateLabel.mas_bottom).offset(18.0f);
            make.left.equalTo(self.bgView).offset(12.0f);
            make.right.equalTo(self.bgView).offset(-12.0f);
            make.bottom.equalTo(self.bgView);
        }];
        
        UIImageView *lastImgView = nil;
        for (int i = 0; i < self.artDetailData.detail_imgs.count; i++) {
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.tag = 100 + i;
            imgView.userInteractionEnabled = YES;
            [imgView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgViewDidTap:)]];
            [_imageContentView addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (!lastImgView) {
                    make.top.equalTo(self.imageContentView);
                }else {
                    make.top.equalTo(lastImgView.mas_bottom).offset(20.0f);
                }
                make.left.right.equalTo(self.imageContentView);
                make.height.mas_equalTo(@200);
                if (i == self.artDetailData.detail_imgs.count - 1) {
                    make.bottom.equalTo(self.imageContentView).offset(-23.0f);
                }
            }];
            
            lastImgView = imgView;
            
            [self.imageViewArray addObject:imgView];
            
            [imgView sd_setImageWithURL:[NSURL URLWithString:self.artDetailData.detail_imgs[i]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                
                if (image) {
                    for (int j = 0; j < self.artDetailData.detail_imgs.count; j++) {
                        if ([imageURL.absoluteString isEqualToString:self.artDetailData.detail_imgs[j]]) {
                            [self.imageViewArray[j] mas_updateConstraints:^(MASConstraintMaker *make) {
                                make.height.mas_equalTo((kScreenWidth - 24.0f) * image.size.height / image.size.width);
                            }];
                        }
                    }
                }
            }];
        }
    }else {
        [self.evaluateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12.0f);
            make.right.mas_equalTo(-12.0f);
            make.top.equalTo(self.bgView).offset(20.0f);
            make.bottom.equalTo(self).offset(-23.0f);
        }];
    }
}

- (void)imgViewDidTap: (UITapGestureRecognizer *)ges {
    if (_lookImageBlock) {
        _lookImageBlock(ges.view.tag - 100, _artDetailData.detail_imgs);
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"作品信息";
        _titleLabel.textColor = JL_color_black_101220;
        _titleLabel.font = kFontPingFangSCSCSemibold(15);
        _titleLabel.jl_contentInsets = UIEdgeInsetsMake(5, 13, 0, 0);
    }
    return _titleLabel;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = JL_color_white_ffffff;
    }
    return _bgView;
}

- (UILabel *)evaluateLabel {
    if (!_evaluateLabel) {
        _evaluateLabel = [[UILabel alloc] init];
        _evaluateLabel.font = kFontPingFangSCMedium(12.0f);
        _evaluateLabel.textColor = JL_color_black_40414D;
        _evaluateLabel.numberOfLines = 0;
        if (![NSString stringIsEmpty:self.artDetailData.details]) {
            _evaluateLabel.text = self.artDetailData.details;
            NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
            paragraph.lineSpacing = 3.0f;
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_evaluateLabel.text];
            [attr addAttributes:@{NSParagraphStyleAttributeName: paragraph} range:NSMakeRange(0, _evaluateLabel.text.length)];
            _evaluateLabel.attributedText = attr;
        }
    }
    return _evaluateLabel;
}

- (CGFloat)getFrameBottom {
    [self layoutIfNeeded];
    return self.frameY + self.frameHeight;
}

- (NSMutableArray<UIImageView *> *)imageViewArray {
    if (!_imageViewArray) {
        _imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}

@end
