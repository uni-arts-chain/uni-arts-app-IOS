//
//  JLBoxOneCardView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/21.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBoxOneCardView.h"
#import "UIButton+TouchArea.h"

@interface JLBoxOneCardView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *cardImageView;
@property (nonatomic, strong) UIView *rareView;
@property (nonatomic, strong) UIView *live2DView;
@property (nonatomic, strong) UILabel *cardNameLabel;
@property (nonatomic, strong) UILabel *noticeLabel;
@property (nonatomic, strong) UIButton *homepageButton;
@end

@implementation JLBoxOneCardView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.backImageView];
    [self addSubview:self.closeButton];
    [self addSubview:self.cardImageView];
    [self.cardImageView addSubview:self.rareView];
    [self.cardImageView addSubview:self.live2DView];
    [self addSubview:self.cardNameLabel];
    [self addSubview:self.noticeLabel];
    [self addSubview:self.homepageButton];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(65.0f);
    }];
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(35.0f, 15.0f, 90.0f, 15.0f));
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-14.0f);
        make.top.mas_equalTo(14.0f);
        make.size.mas_equalTo(13.0f);
    }];
    [self.cardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(55.0f);
        make.right.mas_equalTo(-55.0f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(6.0f);
        make.height.mas_equalTo(250.0f);
    }];
    [self.rareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardImageView);
        make.top.mas_equalTo(20.0f);
        make.width.mas_equalTo(37.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.live2DView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardImageView);
        make.bottom.equalTo(self.cardImageView).offset(-15.0f);
        make.width.mas_equalTo(43.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.cardNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardImageView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(50.0f);
    }];
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.mas_equalTo(-5.0f);
        make.height.mas_equalTo(52.0f);
    }];
    [self.homepageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.noticeLabel.mas_top);
        make.width.mas_equalTo(155.0f);
        make.height.mas_equalTo(40.0f);
        make.centerX.equalTo(self.mas_centerX);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"恭喜获得" font:kFontPingFangSCMedium(17.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"icon_box_card_close"] forState:UIControlStateNormal];
        [_closeButton edgeTouchAreaWithTop:20.0f right:20.0f bottom:20.0f left:20.0f];
        [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (void)closeButtonClick {
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [JLUIFactory imageViewInitImageName:@"icon_box_card_back"];
    }
    return _backImageView;
}

- (UIImageView *)cardImageView {
    if (!_cardImageView) {
        _cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(55.0f, self.titleLabel.frameBottom + 15.0f, self.frameWidth - 55.0f * 2, 250.0f)];
        _cardImageView.backgroundColor = [UIColor randomColor];
        [_cardImageView addShadow:[UIColor colorWithHexString:@"#404040"] cornerRadius:5.0f offsetX:0];
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
        _cardNameLabel = [JLUIFactory labelInitText:@"哈利波特" font:kFontPingFangSCMedium(17.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentCenter];
    }
    return _cardNameLabel;
}

- (UILabel *)noticeLabel {
    if (!_noticeLabel) {
        _noticeLabel = [JLUIFactory labelInitText:@"获得的NFT作品，可在“我的主页“查看" font:kFontPingFangSCRegular(12.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentCenter];
    }
    return _noticeLabel;
}

- (UIButton *)homepageButton {
    if (!_homepageButton) {
        _homepageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_homepageButton setTitle:@"去主页查看" forState:UIControlStateNormal];
        [_homepageButton setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _homepageButton.titleLabel.font = kFontPingFangSCRegular(16.0f);
        _homepageButton.backgroundColor = JL_color_gray_101010;
        ViewBorderRadius(_homepageButton, 20.0f, 0.0f, JL_color_clear);
        [_homepageButton addTarget:self action:@selector(homepageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _homepageButton;
}

- (void)homepageButtonClick {
    if (self.homepageBlock) {
        self.homepageBlock();
    }
}

@end
