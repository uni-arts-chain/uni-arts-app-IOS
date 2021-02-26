//
//  JLCountDownTimerView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/21.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLCountDownTimerView.h"
#import "LSTTimer.h"

@interface JLCountDownTimerView ()
@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, strong) UIColor *seperateColor;
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, strong) UIColor *timeColor;

@property (nonatomic, strong) UILabel *hmsLab1;
@property (nonatomic, strong) UILabel *hmsLab2;
@property (nonatomic, strong) UILabel *hmsLab3;

@property (nonatomic, strong) UILabel *sepLab1;
@property (nonatomic, strong) UILabel *sepLab2;
@end

@implementation JLCountDownTimerView
- (instancetype)initWithSeconds:(NSInteger)seconds seperateColor:(UIColor *)seperateColor backColor:(UIColor *)backColor timeColor:(UIColor *)timeColor {
    if (self = [super init]) {
        self.seconds = seconds;
        self.seperateColor = seperateColor;
        self.backColor = backColor;
        self.timeColor = timeColor;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    WS(weakSelf)
    
    [self addSubview:self.hmsLab1];
    [self addSubview:self.sepLab1];
    [self addSubview:self.hmsLab2];
    [self addSubview:self.sepLab2];
    [self addSubview:self.hmsLab3];
    
    [self.hmsLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_greaterThanOrEqualTo(21.0f);
    }];
    [self.sepLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hmsLab1.mas_right);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(21.0f);
    }];
    [self.hmsLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sepLab1.mas_right);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(21.0f);
    }];
    [self.sepLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hmsLab2.mas_right);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(21.0f);
    }];
    [self.hmsLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sepLab2.mas_right);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(21.0f);
        make.right.equalTo(self);
    }];
    
    //时分秒
    [LSTTimer addMinuteTimerForTime:self.seconds handle:^(NSString * _Nonnull day, NSString * _Nonnull hour, NSString * _Nonnull minute, NSString * _Nonnull second, NSString * _Nonnull ms) {
        NSInteger realHour = day.integerValue * 24 + hour.integerValue;
        weakSelf.hmsLab1.text = realHour == 0 ? @"00" : @(realHour).stringValue;
        weakSelf.hmsLab2.text = minute;
        weakSelf.hmsLab3.text = second;
    }];
}

- (UILabel *)createSameLabel {
    UILabel *timeLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCSCSemibold(13.0f) textColor:self.timeColor ?: JL_color_white_ffffff textAlignment:NSTextAlignmentCenter];
    timeLabel.backgroundColor = self.backColor ?: JL_color_orange_FF8650;
    ViewBorderRadius(timeLabel, 4.0f, 0.0f, JL_color_clear);
    return timeLabel;
}

- (UILabel *)createSepLabel {
    UIColor *sepColor = self.seperateColor ?: JL_color_gray_606060;
    UILabel *sepLabel = [JLUIFactory labelInitText:@" ：" font:kFontPingFangSCSCSemibold(13.0f) textColor:sepColor textAlignment:NSTextAlignmentCenter];
    return sepLabel;
}

- (UILabel *)hmsLab1 {
    if (!_hmsLab1) {
        _hmsLab1 = [self createSameLabel];
    }
    return _hmsLab1;
}

- (UILabel *)hmsLab2 {
    if (!_hmsLab2) {
        _hmsLab2 = [self createSameLabel];
    }
    return _hmsLab2;
}

- (UILabel *)hmsLab3 {
    if (!_hmsLab3) {
        _hmsLab3 = [self createSameLabel];
    }
    return _hmsLab3;
}

- (UILabel *)sepLab1 {
    if (!_sepLab1) {
        _sepLab1 = [self createSepLabel];
    }
    return _sepLab1;
}

- (UILabel *)sepLab2 {
    if (!_sepLab2) {
        _sepLab2 = [self createSepLabel];
    }
    return _sepLab2;
}
@end
