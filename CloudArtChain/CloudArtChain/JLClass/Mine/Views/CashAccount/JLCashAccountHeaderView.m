//
//  JLCashAccountHeaderView.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/14.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLCashAccountHeaderView.h"

@interface JLCashAccountHeaderView ()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *accountLabel;

@property (nonatomic, strong) UIButton *withdrawBtn;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *detailTitleLabel;

@end

@implementation JLCashAccountHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _imgView = [[UIImageView alloc] init];
    _imgView.image = [UIImage imageNamed:@"cash_account_icon"];
    [self addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(24);
        make.left.equalTo(self).offset(14);
        make.width.height.mas_equalTo(@23);
    }];
    
    _accountLabel = [[UILabel alloc] init];
    _accountLabel.text = @"账户总额：¥188.88";
    _accountLabel.textColor = JL_color_gray_101010;
    _accountLabel.font = kFontPingFangSCMedium(17);
    [self addSubview:_accountLabel];
    [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView.mas_right).offset(11);
        make.centerY.equalTo(self.imgView);
        make.right.equalTo(self).offset(-121);
    }];
    
    _withdrawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _withdrawBtn.backgroundColor = JL_color_gray_101010;
    [_withdrawBtn setTitle:@"提现" forState:UIControlStateNormal];
    [_withdrawBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
    _withdrawBtn.titleLabel.font = kFontPingFangSCRegular(13);
    _withdrawBtn.layer.cornerRadius = 12;
    _withdrawBtn.layer.masksToBounds = YES;
    [_withdrawBtn addTarget:self action:@selector(withdrawBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_withdrawBtn];
    [_withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-24);
        make.centerY.equalTo(self.imgView);
        make.size.mas_equalTo(CGSizeMake(61, 24));
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = JL_color_gray_DDDDDD;
    [self addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView);
        make.top.equalTo(self.imgView.mas_bottom).offset(23);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(@1);
    }];
    
    _detailTitleLabel = [[UILabel alloc] init];
    _detailTitleLabel.text = @"账户明细";
    _detailTitleLabel.textColor = JL_color_gray_101010;
    _detailTitleLabel.font = kFontPingFangSCMedium(17);
    [self addSubview:_detailTitleLabel];
    [_detailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(17);
        make.bottom.equalTo(self);
    }];
}

#pragma mark - event response
- (void)withdrawBtnClick: (UIButton *)sender {
    if (_withdrawBlock) {
        _withdrawBlock();
    }
}

@end
