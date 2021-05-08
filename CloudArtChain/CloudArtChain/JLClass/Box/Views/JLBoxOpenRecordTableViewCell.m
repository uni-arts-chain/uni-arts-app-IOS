//
//  JLBoxOpenRecordTableViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/21.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBoxOpenRecordTableViewCell.h"
#import "NSDate+Extension.h"

@interface JLBoxOpenRecordTableViewCell ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *cardImageView;
@property (nonatomic, strong) UILabel *cardNameLabel;
@property (nonatomic, strong) UILabel *cardAuthorLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation JLBoxOpenRecordTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.cardImageView];
    [self.backView addSubview:self.cardNameLabel];
    [self.backView addSubview:self.cardAuthorLabel];
    [self.backView addSubview:self.addressLabel];
    [self.backView addSubview:self.timeLabel];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(10.0f);
        make.bottom.mas_equalTo(-10.0f);
    }];
    [self.cardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.0f);
        make.top.mas_equalTo(16.0f);
        make.width.mas_equalTo(102.0f);
        make.height.mas_equalTo(76.0f);
    }];
    [self.cardNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardImageView.mas_top);
        make.left.equalTo(self.cardImageView.mas_right).offset(13.0f);
        make.right.mas_equalTo(-12.0f);
    }];
    [self.cardAuthorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardNameLabel.mas_left);
        make.centerY.equalTo(self.cardImageView.mas_centerY);
        make.right.equalTo(self.cardNameLabel.mas_right);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardNameLabel.mas_left);
        make.bottom.equalTo(self.cardImageView.mas_bottom);
        make.right.equalTo(self.cardNameLabel.mas_right);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardImageView.mas_left);
        make.bottom.equalTo(self.backView);
        make.height.mas_equalTo(43.0f);
    }];
    [self.backView layoutIfNeeded];
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(15.0f, 10.0f, kScreenWidth - 15.0f * 2, 150.0f)];
        _backView.backgroundColor = JL_color_white_ffffff;
        [_backView addShadow:[UIColor colorWithHexString:@"#404040"] cornerRadius:5.0f offsetX:0];
    }
    return _backView;
}

- (UIImageView *)cardImageView {
    if (!_cardImageView) {
        _cardImageView = [[UIImageView alloc] init];
        _cardImageView.contentMode = UIViewContentModeScaleAspectFit;
        ViewBorderRadius(_cardImageView, 5.0f, 1.0f, JL_color_white_ffffff);
    }
    return _cardImageView;
}

- (UILabel *)cardNameLabel {
    if (!_cardNameLabel) {
        _cardNameLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCMedium(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _cardNameLabel;
}

- (UILabel *)cardAuthorLabel {
    if (!_cardAuthorLabel) {
        _cardAuthorLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _cardAuthorLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [JLUIFactory labelInitText:@"NFT地址：" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
        _addressLabel.numberOfLines = 1;
    }
    return _addressLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_999999 textAlignment:NSTextAlignmentLeft];
    }
    return _timeLabel;
}

- (void)setBoxHistoryData:(Model_blind_box_orders_history_Data *)boxHistoryData {
    if (![NSString stringIsEmpty:boxHistoryData.img_main_file1[@"url"]]) {
        [self.cardImageView sd_setImageWithURL:[NSURL URLWithString:boxHistoryData.img_main_file1[@"url"]]];
    }
    
    self.cardNameLabel.text = boxHistoryData.name;
    self.cardAuthorLabel.text = [NSString stringIsEmpty:boxHistoryData.author] ? @"" : boxHistoryData.author;
    self.addressLabel.text = [NSString stringWithFormat:@"NFT地址：%@", [NSString stringIsEmpty:boxHistoryData.nft_address] ? @"" : boxHistoryData.nft_address];
    
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:boxHistoryData.created_at.doubleValue];
    self.timeLabel.text = [createDate dateWithCustomFormat:@"yyyy/MM/dd HH:mm:ss"];
}
@end
