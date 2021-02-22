//
//  JLArtDetailDescriptionView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/2.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLArtDetailDescriptionView.h"

@interface JLArtDetailDescriptionView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UILabel *firstDescLabel;
@property (nonatomic, strong) UIImageView *secondImageView;
@property (nonatomic, strong) UILabel *secondDescLabel;
@end

@implementation JLArtDetailDescriptionView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.frame;
    frame.size.height = self.contentView.frameBottom;
    self.frame = frame;
}

- (void)createSubViews {
    UIView *titleView = [JLUIFactory titleViewWithTitle:@"艺术品细节"];
    [self addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(65.0f);
    }];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(titleView.mas_bottom);
    }];
    [self.contentView addSubview:self.firstImageView];
    [self.contentView addSubview:self.firstDescLabel];
    [self.contentView addSubview:self.secondImageView];
    [self.contentView addSubview:self.secondDescLabel];
    
    [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(250.0f);
    }];
    [self.firstDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(self.firstImageView.mas_bottom).offset(28.0f);
    }];
    [self.secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.firstDescLabel.mas_bottom).offset(28.0f);
        make.height.mas_equalTo(250.0f);
    }];
    [self.secondDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(self.secondImageView.mas_bottom).offset(28.0f);
        make.bottom.equalTo(self.contentView).offset(-28.0f);
    }];
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UIImageView *)firstImageView {
    if (!_firstImageView) {
        _firstImageView = [[UIImageView alloc] init];
        _firstImageView.backgroundColor = [UIColor randomColor];
    }
    return _firstImageView;
}

- (UILabel *)firstDescLabel {
    if (!_firstDescLabel) {
        _firstDescLabel = [[UILabel alloc] init];
        _firstDescLabel.font = kFontPingFangSCRegular(14.0f);
        _firstDescLabel.textColor = JL_color_gray_101010;
        _firstDescLabel.numberOfLines = 0;
        _firstDescLabel.text = @"艺术创作于我而言，就似把各式各样的水注进无数的被子之中，然而杯子越空，创作发挥的空间也就越大。也正是这种“空”决定着水的这种深度，而水位的高低——表达内容的多少，会形成一种类似节奏关系，一种我不断追逐的可生长的力量关系，这种类节奏关系就是我的兴趣所在，而“空”变成了其中的支撑点...";
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 12.0f;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_firstDescLabel.text];
        [attr addAttributes:@{NSParagraphStyleAttributeName: paragraph} range:NSMakeRange(0, _firstDescLabel.text.length)];
        _firstDescLabel.attributedText = attr;
    }
    return _firstDescLabel;
}

- (UIImageView *)secondImageView {
    if (!_secondImageView) {
        _secondImageView = [[UIImageView alloc] init];
        _secondImageView.backgroundColor = [UIColor randomColor];
    }
    return _secondImageView;
}

- (UILabel *)secondDescLabel {
    if (!_secondDescLabel) {
        _secondDescLabel = [[UILabel alloc] init];
        _secondDescLabel.font = kFontPingFangSCRegular(14.0f);
        _secondDescLabel.textColor = JL_color_gray_101010;
        _secondDescLabel.numberOfLines = 0;
        _secondDescLabel.text = @"艺术创作于我而言，就似把各式各样的水注进无数的被子之中，然而杯子越空，创作发挥的空间也就越大。也正是这种“空”决定着水的这种深度，而水位的高低——表达内容的多少，会形成一种类似节奏关系，一种我不断追逐的可生长的力量关系，这种类节奏关系就是我的兴趣所在，而“空”变成了其中的支撑点...\r\n\t\t\t\t\t\t\t\t——创作者自述";
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 12.0f;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_secondDescLabel.text];
        [attr addAttributes:@{NSParagraphStyleAttributeName: paragraph} range:NSMakeRange(0, _secondDescLabel.text.length)];
        _secondDescLabel.attributedText = attr;
    }
    return _secondDescLabel;
}
@end
