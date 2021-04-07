//
//  JLAuctionPriceView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/18.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLAuctionPriceView.h"
#import "NSDate+Extension.h"

@interface JLAuctionPriceView ()
@property (nonatomic, strong) UILabel *startActionPriceTitleLabel;
@property (nonatomic, strong) UILabel *startActionPriceLabel;
@property (nonatomic, strong) UILabel *addPriceTitleLabel;
@property (nonatomic, strong) UILabel *addPriceLabel;
@property (nonatomic, strong) UILabel *startTimeTitleLabel;
@property (nonatomic, strong) UILabel *startTimeLabel;
@property (nonatomic, strong) UILabel *finishTimeTitleLabel;
@property (nonatomic, strong) UILabel *finishTimeLabel;
@end

@implementation JLAuctionPriceView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.startActionPriceTitleLabel];
    [self addSubview:self.startActionPriceLabel];
    [self addSubview:self.addPriceTitleLabel];
    [self addSubview:self.addPriceLabel];
    [self addSubview:self.startTimeTitleLabel];
    [self addSubview:self.startTimeLabel];
    [self addSubview:self.finishTimeTitleLabel];
    [self addSubview:self.finishTimeLabel];

    [self.startActionPriceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16.0f);
        make.top.mas_equalTo(13.0f);
        make.height.mas_equalTo(42.0f);
        make.width.mas_equalTo((kScreenWidth - 16.0f * 2) * 0.2f);
    }];
    [self.startActionPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startActionPriceTitleLabel.mas_right);
        make.top.equalTo(self.startActionPriceTitleLabel.mas_top);
        make.height.mas_equalTo(42.0f);
        make.width.mas_equalTo((kScreenWidth - 16.0f * 2) * 0.3f);
    }];
    [self.addPriceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startActionPriceLabel.mas_right);
        make.top.equalTo(self.startActionPriceTitleLabel.mas_top);
        make.height.mas_equalTo(42.0f);
        make.width.mas_equalTo(self.startActionPriceTitleLabel);
    }];
    [self.addPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addPriceTitleLabel.mas_right);
        make.top.equalTo(self.startActionPriceTitleLabel.mas_top);
        make.height.mas_equalTo(42.0f);
        make.right.mas_equalTo(-16.0f);
    }];
    [self.startTimeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startActionPriceTitleLabel.mas_left);
        make.top.equalTo(self.startActionPriceTitleLabel.mas_bottom);
        make.height.mas_equalTo(42.0f);
        make.width.mas_equalTo(self.startActionPriceTitleLabel.mas_width);
    }];
    [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startTimeTitleLabel.mas_right);
        make.top.equalTo(self.startTimeTitleLabel.mas_top);
        make.height.mas_equalTo(42.0f);
        make.width.mas_equalTo(self.startActionPriceLabel.mas_width);
    }];
    [self.finishTimeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startTimeLabel.mas_right);
        make.top.equalTo(self.startTimeTitleLabel.mas_top);
        make.height.mas_equalTo(42.0f);
        make.width.equalTo(self.addPriceTitleLabel.mas_width);
    }];
    [self.finishTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.finishTimeTitleLabel.mas_right);
        make.top.equalTo(self.startTimeTitleLabel.mas_top);
        make.height.mas_equalTo(42.0f);
        make.width.equalTo(self.addPriceLabel.mas_width);
    }];
}

- (UILabel *)createSameTitle:(NSString *)title {
    UILabel *label = [JLUIFactory labelInitText:title font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_909090 textAlignment:NSTextAlignmentLeft];
    return label;
}

- (UILabel *)createSameLabel:(NSString *)content {
    UILabel *label = [JLUIFactory labelInitText:content font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    return label;
}

- (UILabel *)startActionPriceTitleLabel {
    if (!_startActionPriceTitleLabel) {
        _startActionPriceTitleLabel = [self createSameTitle:@"起拍价"];
    }
    return _startActionPriceTitleLabel;
}

- (UILabel *)startActionPriceLabel {
    if (!_startActionPriceLabel) {
        _startActionPriceLabel = [self createSameLabel:@""];
    }
    return _startActionPriceLabel;
}

- (UILabel *)addPriceTitleLabel {
    if (!_addPriceTitleLabel) {
        _addPriceTitleLabel = [self createSameTitle:@"加价幅度"];
    }
    return _addPriceTitleLabel;
}

- (UILabel *)addPriceLabel {
    if (!_addPriceLabel) {
        _addPriceLabel = [self createSameLabel:@""];
    }
    return _addPriceLabel;
}

- (UILabel *)startTimeTitleLabel {
    if (!_startTimeTitleLabel) {
        _startTimeTitleLabel = [self createSameTitle:@"开始时间"];
    }
    return _startTimeTitleLabel;
}

- (UILabel *)startTimeLabel {
    if (!_startTimeLabel) {
        _startTimeLabel = [self createSameLabel:@""];
    }
    return _startTimeLabel;
}

- (UILabel *)finishTimeTitleLabel {
    if (!_finishTimeTitleLabel) {
        _finishTimeTitleLabel = [self createSameTitle:@"结束时间"];
    }
    return _finishTimeTitleLabel;
}

- (UILabel *)finishTimeLabel {
    if (!_finishTimeLabel) {
        _finishTimeLabel = [self createSameLabel:@""];
    }
    return _finishTimeLabel;
}

- (void)setArtsData:(Model_auction_meetings_arts_Data *)artsData {
    WS(weakSelf)
    self.startActionPriceLabel.text = [NSString stringWithFormat:@"%@ UART", [NSString stringIsEmpty:artsData.start_price] ? @"0" : artsData.start_price];
    self.addPriceLabel.text = [NSString stringWithFormat:@"%@ UART", [NSString stringIsEmpty:artsData.price_increment] ? @"0" : artsData.price_increment];
    NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970];
    [[JLViewControllerTool appDelegate].walletTool getBlockWithBlockNumberBlock:^(UInt32 blockNumber) {
        NSTimeInterval auctionStartTimeInterval = (artsData.art.auction_start_time.integerValue - blockNumber) * 6 + currentInterval;
        NSTimeInterval auctionEndTimeInterval = (artsData.art.auction_end_time.integerValue - blockNumber) * 6 + currentInterval;
        weakSelf.startTimeLabel.text = [[NSDate dateWithTimeIntervalSince1970:auctionStartTimeInterval] dateWithCustomFormat:@"MM.dd HH:mm"];
        weakSelf.finishTimeLabel.text = [[NSDate dateWithTimeIntervalSince1970:auctionEndTimeInterval] dateWithCustomFormat:@"MM.dd HH:mm"];
    }];
}

@end
