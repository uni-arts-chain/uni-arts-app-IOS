//
//  JLArtAuctionTimeView.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/22.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLArtAuctionTimeView.h"

@interface JLArtAuctionTimeView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *timeLabel;

/// 剩余结束秒数
@property (nonatomic, assign) NSInteger endTime;

/// 剩余开始秒数
@property (nonatomic, assign) NSInteger startTime;

@end

@implementation JLArtAuctionTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _bgView = [[UIView alloc] init];
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.centerX.equalTo(self);
    }];
    
    _imgView = [[UIImageView alloc] init];
    _imgView.image = [UIImage imageNamed:@"auction_countdown_icon"];
    [_bgView addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.width.height.mas_equalTo(@9);
        make.centerY.equalTo(self.bgView);
    }];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.text = @"00:00:00";
    _timeLabel.textColor = JL_color_white_ffffff;
    _timeLabel.font = kFontPingFangSCMedium(11);
    [_bgView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView.mas_right).offset(5);
        make.right.equalTo(self.bgView);
        make.top.bottom.equalTo(self.bgView);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addGradientFromColor:JL_color_orange_FFC63D toColor:JL_color_orange_FF9E2C];
    [self bringSubviewToFront:_bgView];
}

#pragma mark - private methods
- (void)countDownValue {
        
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 上线时间
    NSDate *startSaleDate = [dateFormatter dateFromString:_artDetailData.auction_start_time];
    NSTimeInterval startTimeOffset = [startSaleDate timeIntervalSince1970];
    // 下线时间
    NSDate *endSaleDate = [dateFormatter dateFromString:_artDetailData.auction_end_time];
    NSTimeInterval endTimeOffset = [endSaleDate timeIntervalSince1970];
    
    self.startTime = _artDetailData.server_time - startTimeOffset;
    self.endTime = endTimeOffset - _artDetailData.server_time;
    
    if (self.endTime <= 0) { // 表示活动已经结束 失效
        _timeLabel.text = @"00:00:00";
    }else { // 表示活动有效 未开始或者进行中
        if (self.startTime < 0) { // 未开始
            _timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",labs(self.startTime) / (24 * 3600) * 24 + (labs(self.startTime) / 3600) % 24, (labs(self.startTime) / 60) % 60, (labs(self.startTime) % 60)];
        }else { // 已开始
            _timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",labs(self.endTime) / (24 * 3600) * 24 + (labs(self.endTime) / 3600) % 24, (labs(self.endTime) / 60) % 60, (labs(self.endTime) % 60)];
        }
    }
}

#pragma mark - setters and getters
- (void)setArtDetailData:(Model_art_Detail_Data *)artDetailData {
    _artDetailData = artDetailData;
    
    [self countDownValue];
}

@end
