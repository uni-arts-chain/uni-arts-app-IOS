//
//  JLAnnounceCollectionViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/28.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLAnnounceCollectionViewCell.h"
#import "UIButton+TouchArea.h"

@interface JLAnnounceCollectionViewCell ()
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UIButton *firstButton;
@property (nonatomic, strong) UIButton *secondButton;
@end

@implementation JLAnnounceCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    UIView *firstDotView = [[UIView alloc] init];
    firstDotView.backgroundColor = JL_color_blue_B2CDFF;
    ViewBorderRadius(firstDotView, 1.5f, 0.0f, JL_color_clear);
    [self addSubview:firstDotView];
    [self addSubview:self.firstLabel];
    [self addSubview:self.firstButton];
    
    UIView *secondDotView = [[UIView alloc] init];
    secondDotView.backgroundColor = JL_color_blue_B2CDFF;
    ViewBorderRadius(secondDotView, 1.5f, 0.0f, JL_color_clear);
    [self addSubview:secondDotView];
    [self addSubview:self.secondLabel];
    [self addSubview:self.secondButton];
    
    [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self);
        make.left.mas_equalTo(13.0f);
        make.height.mas_equalTo(13.0f);
    }];
    [self.firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self);
        make.left.mas_equalTo(13.0f);
        make.height.mas_equalTo(13.0f);
    }];
    [firstDotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.size.mas_equalTo(3.0f);
        make.centerY.equalTo(self.firstLabel.mas_centerY);
    }];
    [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(self);
        make.left.mas_equalTo(13.0f);
        make.height.mas_equalTo(13.0f);
    }];
    [self.secondButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(self);
        make.left.mas_equalTo(13.0f);
        make.height.mas_equalTo(13.0f);
    }];
    [secondDotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.size.mas_equalTo(3.0f);
        make.centerY.equalTo(self.secondLabel.mas_centerY);
    }];
}

- (void)setAnnounceArray:(NSArray *)announceArray {
    if (announceArray.count == 0) {
        return;
    } else if (announceArray.count == 1) {
        self.firstLabel.text = announceArray[0];
    } else {
        self.firstLabel.text = announceArray[0];
        self.secondLabel.text = announceArray[1];
    }
}

- (UILabel *)firstLabel {
    if (!_firstLabel) {
        _firstLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _firstLabel;
}

- (UILabel *)secondLabel {
    if (!_secondLabel) {
        _secondLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _secondLabel;
}

- (UIButton *)firstButton {
    if (!_firstButton) {
        _firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_firstButton edgeTouchAreaWithTop:12.0f right:0.0f bottom:12.0f left:0.0f];
        [_firstButton addTarget:self action:@selector(firstButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _firstButton;
}

- (void)firstButtonClick {
    if (self.announceBlock) {
        self.announceBlock(0);
    }
}

- (UIButton *)secondButton {
    if (!_secondButton) {
        _secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_secondButton edgeTouchAreaWithTop:12.0f right:0.0f bottom:12.0f left:0.0f];
        [_secondButton addTarget:self action:@selector(secondButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _secondButton;
}

- (void)secondButtonClick {
    if (self.announceBlock) {
        self.announceBlock(1);
    }
}


@end
