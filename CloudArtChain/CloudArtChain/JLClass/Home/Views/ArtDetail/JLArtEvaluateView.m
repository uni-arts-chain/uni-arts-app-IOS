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
@property (nonatomic, strong) UILabel *evaluateLabel;
@property (nonatomic, strong) UIView *imageContentView;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *imageViewArray;
@end

@implementation JLArtEvaluateView
- (instancetype)initWithFrame:(CGRect)frame artDetailData:(Model_art_Detail_Data *)artDetailData; {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        self.artDetailData = artDetailData;
        [self createSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.frame;
    if (self.artDetailData.detail_imgs.count) {
        frame.size.height = self.imageContentView.frameBottom;
    }else {
        frame.size.height = self.evaluateLabel.frameBottom;
    }
    self.frame = frame;
}

- (void)createSubViews {
    UIView *titleView = [JLUIFactory titleViewWithTitle:@"作品信息"];
    [self addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(65.0f);
    }];
    [self addSubview:self.evaluateLabel];
    
    
    if (self.artDetailData.detail_imgs.count) {
        [self.evaluateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15.0f);
            make.right.mas_equalTo(-15.0f);
            make.top.equalTo(titleView.mas_bottom);
        }];
        
        _imageContentView = [[UIView alloc] init];
        [self addSubview:_imageContentView];
        [_imageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.evaluateLabel.mas_bottom).offset(10.0f);
            make.left.mas_equalTo(15.0f);
            make.right.mas_equalTo(-15.0f);
            make.bottom.equalTo(self);
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
                    make.top.equalTo(lastImgView.mas_bottom).offset(10.0f);
                }
                make.left.right.equalTo(self.imageContentView);
                make.height.mas_equalTo(@200);
                if (i == self.artDetailData.detail_imgs.count - 1) {
                    make.bottom.equalTo(self.imageContentView).offset(-10.0f);
                }
            }];
            
            lastImgView = imgView;
            
            [self.imageViewArray addObject:imgView];
            
            [imgView sd_setImageWithURL:[NSURL URLWithString:self.artDetailData.detail_imgs[i]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                
                if (image) {
                    for (int j = 0; j < self.artDetailData.detail_imgs.count; j++) {
                        if ([imageURL.absoluteString isEqualToString:self.artDetailData.detail_imgs[j]]) {
                            [self.imageViewArray[j] mas_updateConstraints:^(MASConstraintMaker *make) {
                                make.height.mas_equalTo((kScreenWidth - 30.0f) * image.size.height / image.size.width);
                            }];
                        }
                    }
                }
            }];
        }
    }else {
        [self.evaluateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15.0f);
            make.right.mas_equalTo(-15.0f);
            make.top.equalTo(titleView.mas_bottom);
            make.bottom.equalTo(self);
        }];
    }
}

- (void)imgViewDidTap: (UITapGestureRecognizer *)ges {
    if (_lookImageBlock) {
        _lookImageBlock(ges.view.tag - 100, _artDetailData.detail_imgs);
    }
}

- (UILabel *)evaluateLabel {
    if (!_evaluateLabel) {
        _evaluateLabel = [[UILabel alloc] init];
        _evaluateLabel.font = kFontPingFangSCRegular(14.0f);
        _evaluateLabel.textColor = JL_color_gray_101010;
        _evaluateLabel.numberOfLines = 0;
        if (![NSString stringIsEmpty:self.artDetailData.details]) {
            _evaluateLabel.text = self.artDetailData.details;
            NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
            paragraph.lineSpacing = 12.0f;
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
