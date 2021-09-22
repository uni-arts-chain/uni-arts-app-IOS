//
//  JLMultiChainWalletInfoListCell.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/22.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLMultiChainWalletInfoListCell.h"

@interface JLMultiChainWalletInfoListCell ()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UILabel *amountLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) MASConstraint *titleLabelCenterYConstraint;

@end

@implementation JLMultiChainWalletInfoListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _imgView = [[UIImageView alloc] init];
    _imgView.layer.cornerRadius = 20;
    _imgView.clipsToBounds = YES;
    [self.contentView addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(@40);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = JL_color_gray_101010;
    _titleLabel.font = kFontPingFangSCSCSemibold(16);
    _titleLabel.numberOfLines = 2;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        self.titleLabelCenterYConstraint = make.centerY.equalTo(self.imgView.mas_centerY).offset(-12);
        make.left.equalTo(self.imgView.mas_right).offset(15);
        make.right.equalTo(self.contentView).offset(-150);
    }];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.textColor = JL_color_gray_999999;
    _descLabel.font = kFontPingFangSCRegular(13);
    [self.contentView addSubview:_descLabel];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.imgView).offset(2);
    }];
    
    _amountLabel = [[UILabel alloc] init];
    _amountLabel.textColor = JL_color_gray_101010;
    _amountLabel.font = kFontPingFangSCRegular(15);
    _amountLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_amountLabel];
    [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-25);
        make.centerY.equalTo(self.contentView);
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = JL_color_gray_DDDDDD;
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(@1);
    }];
}

#pragma mark - setters and getters
- (void)setStyle:(NSInteger)style {
    _style = style;
    
    [_titleLabelCenterYConstraint uninstall];
    if (_style == 0) {
        _descLabel.hidden = NO;
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.imgView.mas_centerY).offset(-12);
        }];
    }else {
        _descLabel.hidden = YES;
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.imgView.mas_centerY);
        }];
    }
}

- (void)setWalletInfo:(JLMultiWalletInfo *)walletInfo {
    _walletInfo = walletInfo;
    
    _titleLabel.text = _walletInfo.chainSymbol;
    _descLabel.text = _walletInfo.chainName;
    _imgView.image = [UIImage imageNamed:_walletInfo.chainImageNamed];
}

- (void)setAmount:(NSString *)amount {
    _amount = amount;
    
    _amountLabel.text = _amount;
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
