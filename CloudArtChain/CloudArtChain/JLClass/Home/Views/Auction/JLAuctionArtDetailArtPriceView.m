//
//  JLAuctionArtDetailArtPriceView.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/19.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLAuctionArtDetailArtPriceView.h"

@interface JLAuctionArtDetailArtPriceView ()

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *currentPriceLabel;

@property (nonatomic, strong) UILabel *startPriceLabel;

@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation JLAuctionArtDetailArtPriceView

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
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = JL_color_gray_101010;
    _nameLabel.font = kFontPingFangSCSCSemibold(19);
    _nameLabel.numberOfLines = 0;
    _nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(10);
    }];
    
    _currentPriceLabel = [[UILabel alloc] init];
    _currentPriceLabel.text = @"当前价：";
    _currentPriceLabel.textColor = JL_color_gray_101010;
    _currentPriceLabel.font = kFontPingFangSCRegular(14);
    [self addSubview:_currentPriceLabel];
    [_currentPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(7);
    }];
    
    _startPriceLabel = [[UILabel alloc] init];
    _startPriceLabel.text = @"起拍价：";
    _startPriceLabel.textColor = JL_color_gray_999999;
    _startPriceLabel.font = kFontPingFangSCRegular(14);
    [self addSubview:_startPriceLabel];
    [_startPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentPriceLabel);
        make.top.equalTo(self.currentPriceLabel.mas_bottom).offset(10);
    }];
    
    _numLabel = [[UILabel alloc] init];
    _numLabel.text = @"拍卖份数：1";
    _numLabel.textColor = JL_color_gray_101010;
    _numLabel.font = kFontPingFangSCRegular(14);
    _numLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_numLabel];
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self.currentPriceLabel);
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = JL_color_gray_BEBEBE;
    [self addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startPriceLabel.mas_bottom).offset(16);
        make.left.equalTo(self.currentPriceLabel);
        make.right.equalTo(self.numLabel);
        make.height.mas_equalTo(@1);
        make.bottom.equalTo(self);
    }];
    
}

#pragma mark - setters and getters
- (void)setArtDetailData:(Model_art_Detail_Data *)artDetailData {
    _artDetailData = artDetailData;
    
    _nameLabel.text = _artDetailData.name;
    _currentPriceLabel.text = [NSString stringWithFormat:@"当前价：￥%@", _artDetailData.price];
    if (![NSString stringIsEmpty:_artDetailData.price]) {
        NSMutableAttributedString *attrs = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前价：￥%@", _artDetailData.price]];
        [attrs addAttribute:NSFontAttributeName value:kFontPingFangSCSCSemibold(18) range:NSMakeRange(attrs.length - _artDetailData.price.length - 1, _artDetailData.price.length + 1)];
        [attrs addAttribute:NSForegroundColorAttributeName value:JL_color_red_D70000 range:NSMakeRange(attrs.length - _artDetailData.price.length - 1, _artDetailData.price.length + 1)];
        _currentPriceLabel.attributedText = attrs;
    }
    _startPriceLabel.text = [NSString stringWithFormat:@"起拍价：￥%@", _artDetailData.price];
    _numLabel.text = [NSString stringWithFormat:@"拍卖份数：%ld", 2];
}

@end
