//
//  JLAuctionListCell.m
//  CloudArtChain
//
//  Created by jielian on 2021/8/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLAuctionListCell.h"
#import "NSDate+Extension.h"

@interface JLAuctionListCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *artImgView;

@property (nonatomic, strong) UILabel *artNameLabel;

@property (nonatomic, strong) UILabel *authorNameLabel;

@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) UILabel *nftAddressLabel;

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) Model_auctions_Data *auctionsData;

@property (nonatomic, strong) MASConstraint *rightBtnWidthConstraint;

@end

@implementation JLAuctionListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = JL_color_white_ffffff;
    _bgView.layer.cornerRadius = 5;
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.contentView).offset(11);
        make.bottom.equalTo(self.contentView).offset(-11);
    }];
    
    _artImgView = [[UIImageView alloc] init];
    _artImgView.layer.cornerRadius = 5;
    _artImgView.clipsToBounds = YES;
    _artImgView.contentMode = UIViewContentModeScaleAspectFit;
    [_bgView addSubview:_artImgView];
    [_artImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(19);
        make.left.equalTo(self.bgView).offset(13);
        make.size.mas_equalTo(CGSizeMake(102, 76));
    }];
    
    _artNameLabel = [[UILabel alloc] init];
    _artNameLabel.textColor = JL_color_gray_212121;
    _artNameLabel.font = kFontPingFangSCMedium(15);
    [_bgView addSubview:_artNameLabel];
    [_artNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.artImgView.mas_right).offset(12);
        make.top.equalTo(self.artImgView);
        make.right.equalTo(self.bgView).offset(-70);
    }];
    
    _numLabel = [[UILabel alloc] init];
    _numLabel.textColor = JL_color_gray_101010;
    _numLabel.textAlignment = NSTextAlignmentRight;
    _numLabel.font = kFontPingFangSCRegular(13);
    [_bgView addSubview:_numLabel];
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-20);
        make.centerY.equalTo(self.artNameLabel);
    }];
    
    _authorNameLabel = [[UILabel alloc] init];
    _authorNameLabel.textColor = JL_color_gray_212121;
    _authorNameLabel.font = kFontPingFangSCRegular(15);
    [_bgView addSubview:_authorNameLabel];
    [_authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.artNameLabel);
        make.centerY.equalTo(self.artImgView);
        make.right.equalTo(self.numLabel);
    }];
    
    _nftAddressLabel = [[UILabel alloc] init];
    _nftAddressLabel.textColor = JL_color_gray_101010;
    _nftAddressLabel.font = kFontPingFangSCRegular(13);
    [_bgView addSubview:_nftAddressLabel];
    [_nftAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.artNameLabel);
        make.bottom.equalTo(self.artImgView);
        make.right.equalTo(self.numLabel);
    }];
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.textColor = JL_color_gray_999999;
    _dateLabel.font = kFontPingFangSCRegular(13);
    [_bgView addSubview:_dateLabel];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.artImgView);
        make.top.equalTo(self.artImgView.mas_bottom).offset(22);
    }];
    
    _rightLabel = [[UILabel alloc] init];
    _rightLabel.textColor = JL_color_gray_212121;
    _rightLabel.textAlignment = NSTextAlignmentRight;
    _rightLabel.font = kFontPingFangSCRegular(13);
    [_bgView addSubview:_rightLabel];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.numLabel);
        make.centerY.equalTo(self.dateLabel);
    }];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.hidden = YES;
    _rightBtn.backgroundColor = JL_color_red_D32828;
    [_rightBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = kFontPingFangSCRegular(13);
    _rightBtn.layer.cornerRadius = 11;
    [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.numLabel);
        make.centerY.equalTo(self.dateLabel);
        make.height.mas_equalTo(@22);
        self.rightBtnWidthConstraint = make.width.mas_equalTo(@103);
    }];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.hidden = YES;
    _timeLabel.textColor = JL_color_red_D70000;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.font = kFontPingFangSCRegular(12);
    [_bgView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.numLabel);
        make.bottom.equalTo(self.bgView).offset(-11);
    }];
    
    [_bgView layoutIfNeeded];
    [_bgView addShadow:JL_color_gray_999999 cornerRadius:5 offset:CGSizeMake(0, 0)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_bgView layoutIfNeeded];
    [_bgView addShadow:JL_color_gray_999999 cornerRadius:5 offset:CGSizeMake(0, 0)];
}

#pragma mark - event response
- (void)rightBtnClick: (UIButton *)sender {
    if (self.payBlock) {
        self.payBlock(_auctionsData.ID);
    }
}

#pragma mark - public methods
- (void)setAuctionsData: (Model_auctions_Data *)auctionsData type: (JLAuctionHistoryType)type {
    _auctionsData = auctionsData;
    
    if (![NSString stringIsEmpty:_auctionsData.art.img_main_file1[@"url"]]) {
        [_artImgView sd_setImageWithURL:[NSURL URLWithString:_auctionsData.art.img_main_file1[@"url"]]];
    }
    _authorNameLabel.text = [NSString stringIsEmpty:_auctionsData.art.author.display_name] ? @"" : _auctionsData.art.author.display_name;
    _artNameLabel.text = _auctionsData.art.name;
    _nftAddressLabel.text = [NSString stringWithFormat:@"NFT地址：%@", [NSString stringIsEmpty:_auctionsData.art.item_hash] ? @"" : _auctionsData.art.item_hash];
    _dateLabel.text = [[NSDate dateWithTimeIntervalSince1970:_auctionsData.created_at.integerValue] stringWithFormat: @"MM/dd HH:mm:ss"];
    _numLabel.text = [NSString stringWithFormat:@"X%@",_auctionsData.amount];
    
    _rightBtn.hidden = YES;
    _timeLabel.hidden = YES;
    _rightLabel.hidden = NO;
    if (type == JLAuctionHistoryTypeAttend) {
        // 已参与
        _rightLabel.text = [NSString stringWithFormat:@"已缴纳保证金 ￥%@", _auctionsData.deposit_amount];
            
        NSMutableAttributedString *attrs = [[NSMutableAttributedString alloc] initWithString:_rightLabel.text];
        NSRange range = NSMakeRange(_rightLabel.text.length - _auctionsData.deposit_amount.length - 1, _auctionsData.deposit_amount.length + 1);
        [attrs addAttribute:NSForegroundColorAttributeName value:JL_color_red_D70000 range:range];
        [attrs addAttribute:NSFontAttributeName value:kFontPingFangSCRegular(15) range:range];
        _rightLabel.attributedText = attrs;
    }else if (type == JLAuctionHistoryTypeBid) {
        // 已出价
        _rightLabel.text = [NSString stringWithFormat:@"已出价 ￥%@", _auctionsData.current_user_highest_price];
        
        NSMutableAttributedString *attrs = [[NSMutableAttributedString alloc] initWithString:_rightLabel.text];
        NSRange range = NSMakeRange(_rightLabel.text.length - _auctionsData.current_user_highest_price.length - 1, _auctionsData.current_user_highest_price.length + 1);
        [attrs addAttribute:NSForegroundColorAttributeName value:JL_color_red_D70000 range:range];
        [attrs addAttribute:NSFontAttributeName value:kFontPingFangSCRegular(15) range:range];
        _rightLabel.attributedText = attrs;
    }else if (type == JLAuctionHistoryTypeWins) {
        // 已中标
        _rightBtn.hidden = NO;
        _timeLabel.hidden = NO;
        _rightLabel.hidden = YES;
        
        _rightBtn.userInteractionEnabled = YES;
        _rightBtn.backgroundColor = JL_color_red_D32828;
        
        // 最终实付价格
        NSDecimalNumber *resultPrice = [self getResultPayMoney];
        
        [_rightBtn setTitle:[NSString stringWithFormat:@"去支付 ￥%@", resultPrice.stringValue] forState:UIControlStateNormal];
        CGFloat width = [JLTool getAdaptionSizeWithText:[NSString stringWithFormat:@"去支付 ￥%@", resultPrice.stringValue] labelHeight:22 font:_rightBtn.titleLabel.font].width + 28;
        [_rightBtnWidthConstraint uninstall];
        [_rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            self.rightBtnWidthConstraint = make.width.mas_equalTo(@(width));
        }];
        
        // 剩余支付时间
        NSInteger hasPayTime = _auctionsData.end_time.integerValue + _auctionsData.pay_timeout.integerValue - _auctionsData.server_timestamp.integerValue;
        
        if (hasPayTime <= 0) {
            _rightBtn.userInteractionEnabled = NO;
            _rightBtn.backgroundColor = JL_color_gray_DDDDDD;
            _timeLabel.text = @"超时未支付，已扣除保证金";
        }else {
            if (_auctionsData.is_paying) {
                // 支付处理中
                _rightBtn.userInteractionEnabled = NO;
                _rightBtn.backgroundColor = JL_color_gray_DDDDDD;
                [_rightBtn setTitle:@"支付处理中" forState:UIControlStateNormal];
            }else {
                if ([_auctionsData.aasm_state isEqualToString:@"paid"]) {
                    // 已支付
                    _rightBtn.userInteractionEnabled = NO;
                    _rightBtn.backgroundColor = JL_color_gray_DDDDDD;
                    [_rightBtn setTitle:@"已支付" forState:UIControlStateNormal];
                }else {
                    _timeLabel.text = [NSString stringWithFormat:@"请在%02ld:%02ld:%02ld内完成支付，否则将扣除保证金",labs(hasPayTime) / (24 * 3600) * 24 + (labs(hasPayTime) / 3600) % 24, (labs(hasPayTime) / 60) % 60, (labs(hasPayTime) % 60)];
                }
            }
        }
    }else if (type == JLAuctionHistoryTypeFinish) {
        if (_auctionsData.is_settlement) {
            // 正在结算
            _rightLabel.text = @"正在结算中";
        }else {
            // 已结束 是否中标
            if (_auctionsData.buyer && [auctionsData.buyer.ID isEqualToString:[AppSingleton sharedAppSingleton].userBody.ID]) {
                if (_auctionsData.is_paying) {
                    // 支付处理中
                    _rightLabel.text = @"支付处理中";
                }else {
                    if ([_auctionsData.aasm_state isEqualToString:@"paid"]) {
                        // 已支付
                        _rightLabel.text = @"中标已支付";
                    }else {
                        _rightLabel.text = [NSString stringWithFormat:@"中标未支付，已扣除保证金￥%@", _auctionsData.deposit_amount];
                        
                    }
                }
            }else {
                _rightLabel.text = @"未中标";
            }
        }
    }
}

#pragma mark - private methods
/// 最终实付款
- (NSDecimalNumber *)getResultPayMoney {
    // 拍中价格
    NSDecimalNumber *winPrice = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    if (![NSString stringIsEmpty:_auctionsData.win_price]) {
        winPrice = [NSDecimalNumber decimalNumberWithString:_auctionsData.win_price];
    }
    // 版税价格
    NSDecimalNumber *royaltyPrice = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    if (![NSString stringIsEmpty:_auctionsData.art.royalty]) {
        NSDecimalNumber *royaltyNumber = [NSDecimalNumber decimalNumberWithString:_auctionsData.art.royalty];
        if ([royaltyNumber isGreaterThanZero]) {
            royaltyPrice = [royaltyNumber decimalNumberByMultiplyingBy:winPrice];
        }
    }
    // 保证金
    NSDecimalNumber *depositPrice = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    if (![NSString stringIsEmpty:_auctionsData.deposit_amount]) {
        depositPrice = [NSDecimalNumber decimalNumberWithString:_auctionsData.deposit_amount];
    }
    // 最终实付价格
    NSDecimalNumber *resultPrice = [[[winPrice decimalNumberByAdding:royaltyPrice] decimalNumberBySubtracting: depositPrice] roundDownScale:2];
    
    return resultPrice;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
