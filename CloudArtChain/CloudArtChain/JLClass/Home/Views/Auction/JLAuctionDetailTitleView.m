//
//  JLAuctionDetailTitleView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/18.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLAuctionDetailTitleView.h"
#import "NSDate+Extension.h"

@interface JLAuctionDetailTitleView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *timeMaskImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation JLAuctionDetailTitleView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.timeMaskImageView];
    [self addSubview:self.timeLabel];
    [self addSubview:self.lineView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(30.0f);
    }];
    [self.timeMaskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16.0f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(25.0f);
        make.size.mas_equalTo(14.0f);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeMaskImageView.mas_right).offset(7.0f);
        make.centerY.equalTo(self.timeMaskImageView.mas_centerY);
        make.right.mas_equalTo(-15.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.bottom.equalTo(self);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(0.5f);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCMedium(19.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UIImageView *)timeMaskImageView {
    if (!_timeMaskImageView) {
        _timeMaskImageView = [JLUIFactory imageViewInitImageName:@"icon_auction_time"];
    }
    return _timeMaskImageView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _timeLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = JL_color_gray_DDDDDD;
    }
    return _lineView;
}

- (void)setAuctionMeetingData:(Model_auction_meetings_Data *)auctionMeetingData {
    self.titleLabel.text = auctionMeetingData.topic;
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:auctionMeetingData.start_at.doubleValue];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:auctionMeetingData.end_at.doubleValue];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@", [startDate dateWithCustomFormat:@"MM/dd HH:mm"], [endDate dateWithCustomFormat:@"MM/dd HH:mm"]];
}

@end
