//
//  JLAuctionDetailHeadView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/18.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLAuctionDetailHeadView.h"
#import "JLCountDownTimerView.h"

@interface JLAuctionDetailHeadView()
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIView *timeBackView;
@property (nonatomic, strong) UILabel *timeTitleLabel;
@property (nonatomic, strong) UIView *timeView;
@end

@implementation JLAuctionDetailHeadView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.headerImageView];
    [self addSubview:self.timeBackView];
    [self.timeBackView addSubview:self.timeTitleLabel];
    [self.timeBackView addSubview:self.timeView];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.timeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(33.0f);
    }];
    [self.timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16.0f);
        make.centerY.equalTo(self.timeBackView.mas_centerY);
    }];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeTitleLabel.mas_right).offset(16.0f);
        make.height.mas_equalTo(20.0f);
        make.centerY.equalTo(self.timeBackView.mas_centerY);
    }];
}

- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.backgroundColor = [UIColor randomColor];
    }
    return _headerImageView;
}

- (UIView *)timeBackView {
    if (!_timeBackView) {
        _timeBackView = [[UIView alloc] init];
        _timeBackView.backgroundColor = [UIColor colorWithHexString:@"#416773" alpha:0.5f];
    }
    return _timeBackView;
}

- (UILabel *)timeTitleLabel {
    if (!_timeTitleLabel) {
        _timeTitleLabel = [JLUIFactory labelInitText:@"距开始" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_white_ffffff textAlignment:NSTextAlignmentLeft];
    }
    return _timeTitleLabel;
}

- (UIView *)timeView {
    if (!_timeView) {
        _timeView = [[UIView alloc] init];
        
        JLCountDownTimerView *countDownTimerView = [[JLCountDownTimerView alloc] initWithSeconds:24 * 60 * 60 seperateColor:JL_color_white_ffffff backColor:JL_color_orange_FF8650 timeColor:JL_color_white_ffffff];
        [_timeView addSubview:countDownTimerView];
        
        [countDownTimerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_timeView);
        }];
    }
    return _timeView;
}

@end
