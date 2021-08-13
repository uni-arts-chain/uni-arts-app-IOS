//
//  JLCashAccountCell.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/14.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLCashAccountCell.h"
#import "NSDate+Extension.h"

@interface JLCashAccountCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation JLCashAccountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = JL_color_gray_333333;
    _titleLabel.font = kFontPingFangSCRegular(15);
    _titleLabel.numberOfLines = 0;
    _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(16);
        make.left.equalTo(self.contentView).offset(18);
        make.right.equalTo(self.contentView).offset(-150);
    }];
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.textColor = JL_color_gray_999999;
    _dateLabel.font = kFontPingFangSCRegular(12);
    [self.contentView addSubview:_dateLabel];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
        make.bottom.equalTo(self.contentView).offset(-12);
    }];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = JL_color_gray_101010;
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.font = kFontPingFangSCRegular(15);
    [self.contentView addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-19);
        make.centerY.equalTo(self.contentView);
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = JL_color_gray_DDDDDD;
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(19);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-19);
        make.height.mas_equalTo(@1);
    }];
    
}

#pragma mark - setters and getters
- (void)setAccountHistoryData:(Model_account_history_Data *)accountHistoryData {
    _accountHistoryData = accountHistoryData;
    
    _titleLabel.text = _accountHistoryData.message;
    _dateLabel.text = [[NSDate dateWithTimeIntervalSince1970:_accountHistoryData.created_at.integerValue] dateWithCustomFormat:@"yyyy-MM-dd HH:mm:ss"];
    _priceLabel.text = _accountHistoryData.amount;
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
