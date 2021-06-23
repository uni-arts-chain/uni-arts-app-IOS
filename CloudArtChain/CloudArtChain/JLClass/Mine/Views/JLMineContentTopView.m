//
//  JLMineContentTopView.m
//  CloudArtChain
//
//  Created by jielian on 2021/6/21.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLMineContentTopView.h"

@interface JLMineContentTopView ()

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UIImageView *headerImgView;

@property (nonatomic, strong) UIView *rightTextBgView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *integralLabel;

@property (nonatomic, strong) UIButton *setBtn;

@end

@implementation JLMineContentTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _bgImgView = [[UIImageView alloc] init];
    _bgImgView.image = [UIImage imageNamed:@"mine_top_bg"];
    [self addSubview:_bgImgView];
    [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    _headerImgView = [[UIImageView alloc] init];
    _headerImgView.image = [UIImage imageNamed:@"icon_mine_avatar_placeholder"];
    _headerImgView.layer.cornerRadius = 37.5;
    _headerImgView.layer.borderWidth = 2;
    _headerImgView.layer.borderColor = JL_color_white_ffffff.CGColor;
    _headerImgView.clipsToBounds = YES;
    _headerImgView.userInteractionEnabled = YES;
    [_headerImgView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImgViewDidTap:)]];
    [self addSubview:_headerImgView];
    [_headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(17);
        make.bottom.equalTo(self).offset(-72);
        make.width.height.mas_equalTo(@75);
    }];
    
    _rightTextBgView = [[UIView alloc] init];
    [self addSubview:_rightTextBgView];
    [_rightTextBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerImgView.mas_centerY);
        make.left.equalTo(self.headerImgView.mas_right).offset(12);
        make.right.equalTo(self);
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = @"未设置昵称";
    _nameLabel.textColor = JL_color_white_ffffff;
    _nameLabel.font = kFontPingFangSCSCSemibold(17);
    _nameLabel.numberOfLines = 2;
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_rightTextBgView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.rightTextBgView);
    }];
    
    _integralLabel = [[UILabel alloc] init];
    _integralLabel.text = @"平台积分：0";
    _integralLabel.textColor = JL_color_white_ffffff;
    _integralLabel.font = kFontPingFangSCMedium(14);
    _integralLabel.userInteractionEnabled = YES;
    [_integralLabel addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(integralLabelDidTap:)]];
    [_rightTextBgView addSubview:_integralLabel];
    [_integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(3);
        make.left.right.bottom.equalTo(self.rightTextBgView);
    }];
    
    _setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_setBtn setImage:[UIImage imageNamed:@"icon_mine_setting"] forState:UIControlStateNormal];
    [_setBtn addTarget:self action:@selector(setBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_setBtn];
    [_setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-11);
        make.centerY.equalTo(self.headerImgView.mas_top).offset(5);
        make.width.height.mas_equalTo(@44);
    }];
}

#pragma mark - event response
- (void)headerImgViewDidTap: (UITapGestureRecognizer *)ges {
    if (_delegate && [_delegate respondsToSelector:@selector(lookHomePage)]) {
        [_delegate lookHomePage];
    }
}

- (void)integralLabelDidTap: (UITapGestureRecognizer *)ges {
    if (_delegate && [_delegate respondsToSelector:@selector(lookWallet)]) {
        [_delegate lookWallet];
    }
}

- (void)setBtnClick: (UIButton *)snder {
    if (_delegate && [_delegate respondsToSelector:@selector(lookSetting)]) {
        [_delegate lookSetting];
    }
}

#pragma mark - public methods
- (void)refreshInfo {
    if (![NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.avatar[@"url"]]) {
        [_headerImgView setImageWithURL:[NSURL URLWithString:[AppSingleton sharedAppSingleton].userBody.avatar[@"url"]] placeholderImage:[UIImage imageNamed:@"icon_mine_avatar_placeholder"]];
    }
    self.nameLabel.text = [NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.display_name] ? @"未设置昵称" : [AppSingleton sharedAppSingleton].userBody.display_name;
}

#pragma mark - setters and getters
- (void)setAmount:(NSString *)amount {
    _amount = amount;
    
    self.integralLabel.text = [NSString stringWithFormat:@"平台积分：%@", amount];
}

@end
