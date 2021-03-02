//
//  JLAuctionView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/21.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLAuctionView.h"
#import "NSDate+Extension.h"

@interface JLAuctionView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *timeMaskImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *numMaskImageView;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIButton *entryButton;
@end

@implementation JLAuctionView
- (instancetype)init {
    if (self = [super init]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.mas_equalTo(85.0f);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.bottomView addSubview:self.titleLabel];
    [self.bottomView addSubview:self.timeMaskImageView];
    [self.bottomView addSubview:self.timeLabel];
    [self.bottomView addSubview:self.numMaskImageView];
    [self.bottomView addSubview:self.numLabel];
    [self.bottomView addSubview:self.entryButton];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(16.0f);
        make.right.mas_equalTo(-15.0f);
    }];
    [self.timeMaskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.size.mas_equalTo(12.0f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(14.0f);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeMaskImageView.mas_right).offset(8.0f);
        make.centerY.equalTo(self.timeMaskImageView);
    }];
    [self.numMaskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).offset(10.0f);
        make.width.mas_equalTo(16.0f);
        make.height.mas_equalTo(14.0f);
        make.centerY.equalTo(self.timeMaskImageView);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numMaskImageView.mas_right).offset(8.0f);
        make.centerY.equalTo(self.numMaskImageView);
    }];
    [self.entryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-17.0f);
        make.centerY.equalTo(self.numLabel);
        make.width.mas_equalTo(50.0f);
        make.height.mas_equalTo(24.0f);
        make.left.equalTo(self.numLabel.mas_right).offset(8.0f);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.layer.cornerRadius = 5.0f;
    self.contentView.layer.masksToBounds = NO;
    self.contentView.layer.shadowColor = JL_color_black.CGColor;
    self.contentView.layer.shadowOpacity = 0.13f;
    self.contentView.layer.shadowOffset = CGSizeZero;
    self.contentView.layer.shadowRadius = 7.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.contentView.bounds];
    self.contentView.layer.shadowPath = path.CGPath;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = JL_color_white_ffffff;
    }
    return _contentView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth - 15.0f * 2, 115.0f)];
        [_imageView setCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:CGSizeMake(5.0f, 5.0f)];
    }
    return _imageView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCMedium(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UIImageView *)timeMaskImageView {
    if (!_timeMaskImageView) {
        _timeMaskImageView = [JLUIFactory imageViewInitImageName:@"icon_home_auction_time"];
    }
    return _timeMaskImageView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
        _timeLabel.adjustsFontSizeToFitWidth = true;
    }
    return _timeLabel;
}

- (UIImageView *)numMaskImageView {
    if (!_numMaskImageView) {
        _numMaskImageView = [JLUIFactory imageViewInitImageName:@"icon_home_auction_num"];
    }
    return _numMaskImageView;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
        _numLabel.adjustsFontSizeToFitWidth = true;
    }
    return _numLabel;
}

- (UIButton *)entryButton {
    if (!_entryButton) {
        _entryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_entryButton setTitle:@"进入" forState:UIControlStateNormal];
        [_entryButton setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _entryButton.titleLabel.font = kFontPingFangSCMedium(13.0f);
        _entryButton.backgroundColor = JL_color_blue_50C3FF;
        ViewBorderRadius(_entryButton, 12.0f, 0.0f, JL_color_clear);
        [_entryButton addTarget:self action:@selector(entryButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _entryButton;
}

- (void)entryButtonClick {
    if (self.entryBlock) {
        self.entryBlock();
    }
}

- (void)setAuctionData:(Model_auction_meetings_Data *)auctionData {
    if (![NSString stringIsEmpty:auctionData.img_file[@"url"]]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:auctionData.img_file[@"url"]]];
    }
    self.titleLabel.text = auctionData.topic;
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:auctionData.start_at.doubleValue];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:auctionData.end_at.doubleValue];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@", [startDate dateWithCustomFormat:@"MM/dd HH:mm"], [endDate dateWithCustomFormat:@"MM/dd HH:mm"]];
    self.numLabel.text = [NSString stringWithFormat:@"%ld件", auctionData.art_size];
}
@end
