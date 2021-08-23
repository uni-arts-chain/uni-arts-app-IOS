//
//  JLAuctionOfferRecordCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/18.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLAuctionOfferRecordCell.h"
#import "NSDate+Extension.h"

@interface JLAuctionOfferRecordCell ()
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@end

@implementation JLAuctionOfferRecordCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.userNameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.statusLabel];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.timeLabel.mas_left).offset(-20.0f);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.timeLabel.mas_right).offset(20.0f);
    }];
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
        _userNameLabel.numberOfLines = 1;
    }
    return _userNameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentCenter];
        _timeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _timeLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentRight];
        _statusLabel.numberOfLines = 1;
        _statusLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _statusLabel;
}

- (void)setBidHistory:(Model_auctions_bid_Data *)bidData indexPath:(NSIndexPath *)indexPath {
    self.userNameLabel.text = [NSString stringWithFormat:@"0x%@",bidData.member.address];
    NSDate *bidDate = [NSDate dateWithTimeIntervalSince1970:bidData.created_at.integerValue];
    self.timeLabel.text = [bidDate dateWithCustomFormat:@"yyyy.MM.dd HH:mm:ss"];
    
    if (indexPath.row == 0) {
        NSMutableAttributedString *attrs = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"领先￥%@", bidData.price]];
        [attrs addAttribute:NSForegroundColorAttributeName value:JL_color_red_D70000 range:NSMakeRange(0, attrs.length)];
        self.statusLabel.attributedText = attrs;
    }else {
        self.statusLabel.text = [NSString stringWithFormat:@"出局￥%@", bidData.price];
    }
}

- (void)setBidHistory:(BidHistory *)bidHistory indexPath:(NSIndexPath *)indexPath blockDate:(NSDate *)blockDate blockNumber:(UInt32)blockNumber {
    self.userNameLabel.text = [bidHistory.bidder address];
    NSTimeInterval currentInterval = [blockDate timeIntervalSince1970];
    NSTimeInterval auctionStartTimeInterval = ([bidHistory getDoubleBidTime] - blockNumber) * 6 +currentInterval;
    NSDate *bidDate = [NSDate dateWithTimeIntervalSince1970:auctionStartTimeInterval];
    self.timeLabel.text = [bidDate dateWithCustomFormat:@"yyyy.MM.dd HH:mm:ss"];
    
    NSString *priceString = @([bidHistory getBidPriceWithPrecision:[[JLViewControllerTool appDelegate].walletTool getAssetPrecision]]).stringValue;
    NSDecimalNumber *priceDecimalNumber = [NSDecimalNumber decimalNumberWithString:priceString];
    if (indexPath.row == 0) {
        self.statusLabel.text = [NSString stringWithFormat:@"领先 %@UART", priceDecimalNumber.stringValue];
        self.statusLabel.textColor = JL_color_red_D70000;
    } else {
        self.statusLabel.text = [NSString stringWithFormat:@"出局 %@UART", priceDecimalNumber.stringValue];
        self.statusLabel.textColor = JL_color_gray_101010;
    }
}
@end
