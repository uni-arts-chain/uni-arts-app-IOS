//
//  JLUploadWorkSampleView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/17.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLUploadWorkSampleView.h"

@interface JLUploadWorkSampleView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UIImageView *secondImageView;
@property (nonatomic, strong) UIImageView *thirdImageView;
@end

@implementation JLUploadWorkSampleView
- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = JL_color_gray_F6F6F6;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.firstImageView];
    [self addSubview:self.secondImageView];
    [self addSubview:self.thirdImageView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(35.0f);
    }];
    [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5.0f);
        make.height.mas_equalTo(87.0f);
        make.bottom.mas_equalTo(-20.0f);
    }];
    [self.secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstImageView.mas_right).offset(17.0f);
        make.top.equalTo(self.firstImageView);
        make.height.equalTo(self.firstImageView);
        make.bottom.equalTo(self.firstImageView);
        make.width.equalTo(self.firstImageView);
    }];
    [self.thirdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.secondImageView.mas_right).offset(17.0f);
        make.top.equalTo(self.firstImageView);
        make.height.equalTo(self.firstImageView);
        make.bottom.equalTo(self.firstImageView);
        make.width.equalTo(self.firstImageView);
        make.right.mas_equalTo(-15.0f);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"示例图：" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_606060 textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UIImageView *)firstImageView {
    if (!_firstImageView) {
        _firstImageView = [[UIImageView alloc] init];
        _firstImageView.backgroundColor = [UIColor randomColor];
        ViewBorderRadius(_firstImageView, 5.0f, 0.0f, JL_color_clear);
    }
    return _firstImageView;
}

- (UIImageView *)secondImageView {
    if (!_secondImageView) {
        _secondImageView = [[UIImageView alloc] init];
        _secondImageView.backgroundColor = [UIColor randomColor];
        ViewBorderRadius(_secondImageView, 5.0f, 0.0f, JL_color_clear);
    }
    return _secondImageView;
}

- (UIImageView *)thirdImageView {
    if (!_thirdImageView) {
        _thirdImageView = [[UIImageView alloc] init];
        _thirdImageView.backgroundColor = [UIColor randomColor];
        ViewBorderRadius(_thirdImageView, 5.0f, 0.0f, JL_color_clear);
    }
    return _thirdImageView;
}
@end
