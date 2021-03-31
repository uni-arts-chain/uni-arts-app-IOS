//
//  JLActionTimeView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/18.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLActionTimeView.h"
#import "JLCountDownTimerView.h"

@interface JLActionTimeView ()
@property (nonatomic, assign) JLActionTimeType timeType;
@property (nonatomic, assign) NSTimeInterval countDownInterval;

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *timeTitleLabel;
@property (nonatomic, strong) UIView *timeView;
@property (nonatomic, strong) UIButton *actionDescButton;
@end

@implementation JLActionTimeView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)setTimeType:(JLActionTimeType)timeType countDownInterval:(NSTimeInterval)countDownInterval {
    self.timeType = timeType;
    self.countDownInterval = countDownInterval;
    
    self.backImageView.image = self.timeType == JLActionTimeTypeFinished ? [UIImage imageNamed:@"icon_action_time_finished"] : [UIImage imageNamed:@"icon_action_time_running"];
    
    NSString *status;
    switch (self.timeType) {
        case JLActionTimeTypeWaiting:
            status = @"未开始";
            break;
        case JLActionTimeTypeRuning:
            status = @"拍卖中";
            break;
        case JLActionTimeTypeFinished:
            status = @"已结束";
            break;
        default:
            break;
    }
    self.statusLabel.text = status;
    
    NSString *timeTitle = @"距结束";
    if (self.timeType == JLActionTimeTypeWaiting) {
        timeTitle = @"距开始";
    }
    self.timeTitleLabel.text = timeTitle;
    
    JLCountDownTimerView *countDownTimerView = [[JLCountDownTimerView alloc] initWithSeconds:self.countDownInterval seperateColor:JL_color_white_ffffff backColor:JL_color_white_ffffff timeColor:self.timeType == JLActionTimeTypeFinished ? JL_color_gray_ADADAD : JL_color_orange_FF7F1F];
    [self.timeView addSubview:countDownTimerView];
    
    [countDownTimerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.timeView);
    }];
}

- (void)createSubViews {
    [self addSubview:self.backImageView];
    [self.backImageView addSubview:self.statusLabel];
    [self.backImageView addSubview:self.timeTitleLabel];
    [self.backImageView addSubview:self.timeView];
    [self.backImageView addSubview:self.actionDescButton];
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(12.0f);
        make.bottom.mas_equalTo(-12.0f);
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.centerY.equalTo(self.backImageView.mas_centerY);
    }];
    [self.timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusLabel.mas_right).offset(18.0f);
        make.centerY.equalTo(self.backImageView.mas_centerY);
    }];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeTitleLabel.mas_right).offset(12.0f);
        make.height.mas_equalTo(20.0f);
        make.centerY.equalTo(self.backImageView.mas_centerY);
    }];
    [self.actionDescButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20.0f);
        make.centerY.equalTo(self.backImageView);
    }];
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.userInteractionEnabled = YES;
    }
    return _backImageView;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCSCSemibold(19.0f) textColor:JL_color_white_ffffff textAlignment:NSTextAlignmentLeft];
    }
    return _statusLabel;
}

- (UILabel *)timeTitleLabel {
    if (!_timeTitleLabel) {
        _timeTitleLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_white_ffffff textAlignment:NSTextAlignmentLeft];
    }
    return _timeTitleLabel;
}

- (UIView *)timeView {
    if (!_timeView) {
        _timeView = [[UIView alloc] init];
    }
    return _timeView;
}

- (UIButton *)actionDescButton {
    if (!_actionDescButton) {
        _actionDescButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_actionDescButton setTitle:@"竞拍须知" forState:UIControlStateNormal];
        [_actionDescButton setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _actionDescButton.titleLabel.font = kFontPingFangSCRegular(13.0f);
        [_actionDescButton addTarget:self action:@selector(actionDescButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionDescButton;
}

- (void)actionDescButtonClick {
    if (self.actionDescBlock) {
        self.actionDescBlock();
    }
}
@end
