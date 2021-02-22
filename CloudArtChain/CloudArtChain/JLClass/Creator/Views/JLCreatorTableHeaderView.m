//
//  JLCreatorTableHeaderView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/26.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLCreatorTableHeaderView.h"

@interface JLCreatorTableHeaderView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *platformImageView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *schoolLabel;
@property (nonatomic, strong) UIButton *pressBtn;
@end

@implementation JLCreatorTableHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.imageView];
    [self.imageView addSubview:self.platformImageView];
    [self.contentView addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.mas_equalTo(40.0f);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.platformImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView);
        make.top.mas_equalTo(15.0f);
        make.width.mas_equalTo(93.0f);
        make.height.mas_equalTo(30.0f);
    }];
    
    [self.bottomView addSubview:self.nameLabel];
    UIImageView *cityMaskImageView = [JLUIFactory imageViewInitImageName:@"icon_creator_city"];
    [self.bottomView addSubview:cityMaskImageView];
    [self.bottomView addSubview:self.cityLabel];
    UIImageView *schoolMaskImageView = [JLUIFactory imageViewInitImageName:@"icon_creator_school"];
    [self.bottomView addSubview:schoolMaskImageView];
    [self.bottomView addSubview:self.schoolLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13.0f);
        make.top.bottom.equalTo(self.bottomView);
    }];
    [self.schoolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10.0f);
        make.top.bottom.equalTo(self.bottomView);
    }];
    [schoolMaskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.schoolLabel.mas_left).offset(-5.0f);
        make.size.mas_equalTo(18.0f);
        make.centerY.equalTo(self.bottomView.mas_centerY);
    }];
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(schoolMaskImageView.mas_left).offset(-20.0f);
        make.top.bottom.equalTo(self.bottomView);
    }];
    [cityMaskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cityLabel.mas_left).offset(-3.0f);
        make.size.mas_equalTo(18.0f);
        make.centerY.equalTo(self.bottomView.mas_centerY);
    }];
    
    [self.contentView addSubview:self.pressBtn];
    [self.pressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(15.0f, 7.0f, self.frameWidth - 15.0f * 2, self.frameHeight - 7.0f * 2)];
        _contentView.backgroundColor = JL_color_white_ffffff;
        _contentView.layer.cornerRadius = 5.0f;
        _contentView.layer.masksToBounds = NO;
        _contentView.layer.shadowColor = JL_color_black.CGColor;
        _contentView.layer.shadowOpacity = 0.13f;
        _contentView.layer.shadowOffset = CGSizeZero;
        _contentView.layer.shadowRadius = 7.0f;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:_contentView.bounds];
        _contentView.layer.shadowPath = path.CGPath;
    }
    return _contentView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.contentView.frameWidth, self.contentView.frameHeight - 40.0f)];
        _imageView.backgroundColor = [UIColor randomColor];
        [_imageView setCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:CGSizeMake(5.0f, 5.0f)];
    }
    return _imageView;
}

- (UIImageView *)platformImageView {
    if (!_platformImageView) {
        _platformImageView = [JLUIFactory imageViewInitImageName:@"icon_creator_platform"];
    }
    return _platformImageView;
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
        _nameLabel.font = kFontPingFangSCSCSemibold(17.0f);
        _nameLabel.textColor = JL_color_gray_101010;
        _nameLabel.text = @"伍静";
    }
    return _nameLabel;
}

- (UILabel *)cityLabel {
    if (!_cityLabel) {
        _cityLabel = [JLUIFactory labelInitText:@"上海" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _cityLabel;
}

- (UILabel *)schoolLabel {
    if (!_schoolLabel) {
        _schoolLabel = [JLUIFactory labelInitText:@"中央美院油画系" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _schoolLabel;
}

- (UIButton *)pressBtn {
    if (!_pressBtn) {
        _pressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pressBtn addTarget:self action:@selector(pressBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pressBtn;
}

- (void)pressBtnClick {
    if (self.headerClickBlock) {
        self.headerClickBlock();
    }
}
@end
