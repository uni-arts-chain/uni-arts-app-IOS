//
//  JLBoxTenCardView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/22.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBoxTenCardView.h"
#import "UIButton+TouchArea.h"
#import "NewPagedFlowView.h"
#import "JLBoxCardView.h"

@interface JLBoxTenCardView()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) NewPagedFlowView *pageFlowView;
@property (nonatomic, strong) UILabel *noticeLabel;
@property (nonatomic, strong) UIButton *homepageButton;
@end

@implementation JLBoxTenCardView
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
    [self addSubview:self.cardView];
    [self.cardView addSubview:self.pageFlowView];
    [self addSubview:self.noticeLabel];
    [self addSubview:self.homepageButton];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(60.0f);
    }];
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(35.0f, 15.0f, 90.0f, 15.0f));
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-14.0f);
        make.top.mas_equalTo(14.0f);
        make.size.mas_equalTo(13.0f);
    }];
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo(310.0f);
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

- (UIView *)cardView {
    if (!_cardView) {
        _cardView = [[UIView alloc] init];
        _cardView.backgroundColor = JL_color_clear;
    }
    return _cardView;
}

- (NewPagedFlowView *)pageFlowView {
    if (!_pageFlowView) {
        _pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frameWidth, 310.0f)];
        _pageFlowView.backgroundColor = JL_color_clear;
        _pageFlowView.delegate = self;
        _pageFlowView.dataSource = self;
        _pageFlowView.minimumPageAlpha = 0.0f;
        _pageFlowView.isOpenAutoScroll = NO;
        _pageFlowView.isCarousel = NO;
        [_pageFlowView reloadData];
    }
    return _pageFlowView;
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

#pragma mark NewPagedFlowView Datasource
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(self.frameWidth - 45.0f * 2, 310.0f);
}

- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return self.cardList.count;
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index {
    JLBoxCardView *bannerView = (JLBoxCardView *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[JLBoxCardView alloc] init];
    }
    bannerView.cardData = self.cardList[index];
    return bannerView;
}

- (void)setCardList:(NSArray *)cardList {
    _cardList = cardList;
    [self.pageFlowView reloadData];
}

@end
