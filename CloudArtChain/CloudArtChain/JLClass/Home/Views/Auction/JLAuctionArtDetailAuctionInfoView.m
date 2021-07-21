//
//  JLAuctionArtDetailAuctionInfoView.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/20.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLAuctionArtDetailAuctionInfoView.h"

@interface JLAuctionArtDetailAuctionInfoView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *startPriceImgView;

@property (nonatomic, strong) UILabel *startPriceLabel;

@property (nonatomic, strong) UIImageView *addPriceImgView;

@property (nonatomic, strong) UILabel *addPriceLabel;

@property (nonatomic, strong) UIImageView *startTimeImgView;

@property (nonatomic, strong) UILabel *startTimeLabel;

@property (nonatomic, strong) UIImageView *endTimeImgView;

@property (nonatomic, strong) UILabel *endTimeLabel;

@end

@implementation JLAuctionArtDetailAuctionInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = JL_color_white_ffffff;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"拍卖详情";
    _titleLabel.textColor = JL_color_gray_101010;
    _titleLabel.font = kFontPingFangSCSCSemibold(16);
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
    }];
    
    _startPriceImgView = [[UIImageView alloc] init];
    _startPriceImgView.image = [UIImage imageNamed:@"icon_auction_start_price"];
    [self addSubview:_startPriceImgView];
    [_startPriceImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(18);
        make.left.equalTo(self.titleLabel);
        make.width.height.mas_equalTo(@20);
    }];
    
    _startPriceLabel = [[UILabel alloc] init];
    _startPriceLabel.text = @"起拍价：";
    _startPriceLabel.textColor = JL_color_gray_101010;
    _startPriceLabel.font = kFontPingFangSCRegular(15);
    [self addSubview:_startPriceLabel];
    [_startPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startPriceImgView.mas_right).offset(7);
        make.centerY.equalTo(self.startPriceImgView);
        make.right.equalTo(self.titleLabel);
    }];
    
    _addPriceImgView = [[UIImageView alloc] init];
    _addPriceImgView.image = [UIImage imageNamed:@"icon_auction_add_price"];
    [self addSubview:_addPriceImgView];
    [_addPriceImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startPriceImgView.mas_bottom).offset(20);
        make.left.equalTo(self.startPriceImgView);
        make.width.height.mas_equalTo(@20);
    }];
    
    _addPriceLabel = [[UILabel alloc] init];
    _addPriceLabel.text = @"加价幅度：";
    _addPriceLabel.textColor = JL_color_gray_101010;
    _addPriceLabel.font = kFontPingFangSCRegular(15);
    [self addSubview:_addPriceLabel];
    [_addPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addPriceImgView.mas_right).offset(7);
        make.centerY.equalTo(self.addPriceImgView);
        make.right.equalTo(self.titleLabel);
    }];
    
    _startTimeImgView = [[UIImageView alloc] init];
    _startTimeImgView.image = [UIImage imageNamed:@"icon_auction_start_time"];
    [self addSubview:_startTimeImgView];
    [_startTimeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addPriceImgView.mas_bottom).offset(20);
        make.left.equalTo(self.addPriceImgView);
        make.width.height.mas_equalTo(@20);
    }];
    
    _startTimeLabel = [[UILabel alloc] init];
    _startTimeLabel.text = @"开始时间：";
    _startTimeLabel.textColor = JL_color_gray_101010;
    _startTimeLabel.font = kFontPingFangSCRegular(15);
    [self addSubview:_startTimeLabel];
    [_startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startTimeImgView.mas_right).offset(7);
        make.centerY.equalTo(self.startTimeImgView);
        make.right.equalTo(self.titleLabel);
    }];
    
    _endTimeImgView = [[UIImageView alloc] init];
    _endTimeImgView.image = [UIImage imageNamed:@"icon_auction_end_time"];
    [self addSubview:_endTimeImgView];
    [_endTimeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startTimeImgView.mas_bottom).offset(20);
        make.left.equalTo(self.startTimeImgView);
        make.width.height.mas_equalTo(@20);
    }];
    
    _endTimeLabel = [[UILabel alloc] init];
    _endTimeLabel.text = @"结束时间：";
    _endTimeLabel.textColor = JL_color_gray_101010;
    _endTimeLabel.font = kFontPingFangSCRegular(15);
    [self addSubview:_endTimeLabel];
    [_endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.endTimeImgView.mas_right).offset(7);
        make.centerY.equalTo(self.endTimeImgView);
        make.right.equalTo(self.titleLabel);
    }];
}

#pragma mark - setters and getters
- (void)setArtDetailData:(Model_art_Detail_Data *)artDetailData {
    _artDetailData = artDetailData;
    
    
}

@end
