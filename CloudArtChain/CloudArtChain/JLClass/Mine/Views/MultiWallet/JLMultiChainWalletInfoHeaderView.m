//
//  JLMultiChainWalletInfoHeaderView.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/22.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLMultiChainWalletInfoHeaderView.h"
#import "JLScrollTitleView.h"

#import "UIButton+TouchArea.h"

@interface JLMultiChainWalletInfoHeaderView ()<JLScrollTitleViewDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *settingBtn;

@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UILabel *walletNameLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIButton *pasteBtn;
@property (nonatomic, strong) UIButton *qrCodeBtn;

@property (nonatomic, strong) JLScrollTitleView *headerView;

@property (nonatomic, copy) NSArray *titleArray;

@end

@implementation JLMultiChainWalletInfoHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _bgView = [[UIView alloc] init];
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    _bgImgView = [[UIImageView alloc] init];
    _bgImgView.image = [UIImage imageNamed:@"icon_qianbao_bg"];
    [_bgView addSubview:_bgImgView];
    [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(@220);
    }];
    
    _avatarImgView = [[UIImageView alloc] init];
    _avatarImgView.image = [UIImage imageNamed:@"icon_mine_avatar_placeholder"];
    _avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarImgView.layer.cornerRadius = 33;
    _avatarImgView.layer.borderWidth = 3;
    _avatarImgView.layer.borderColor = JL_color_white_ffffff.CGColor;
    _avatarImgView.clipsToBounds = YES;
    [_bgView addSubview:_avatarImgView];
    [_avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(38);
        make.centerX.equalTo(self.bgView);
        make.width.height.mas_equalTo(@66);
    }];
    
    _walletNameLabel = [[UILabel alloc] init];
    _walletNameLabel.text = @"钱包";
    _walletNameLabel.textColor = JL_color_white_ffffff;
    _walletNameLabel.font = kFontPingFangSCMedium(16);
    _walletNameLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_walletNameLabel];
    [_walletNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImgView.mas_bottom).offset(16);
        make.left.right.equalTo(self.bgView);
    }];
    
    _addressLabel = [[UILabel alloc] init];
    _addressLabel.text = @"钱包地址：";
    _addressLabel.textColor = JL_color_white_ffffff;
    _addressLabel.font = kFontPingFangSCRegular(13);
    _addressLabel.textAlignment = NSTextAlignmentCenter;
    _addressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [_bgView addSubview:_addressLabel];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.walletNameLabel.mas_bottom).offset(24);
        make.centerX.equalTo(self.walletNameLabel);
        make.width.mas_equalTo(@220);
    }];
    
    _pasteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_pasteBtn setImage:[[UIImage imageNamed:@"icon_wallet_address_copy"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_pasteBtn addTarget:self action:@selector(pasteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_pasteBtn edgeTouchAreaWithTop:6 right:6 bottom:6 left:6];
    [_bgView addSubview:_pasteBtn];
    [_pasteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressLabel.mas_right).offset(12);
        make.centerY.equalTo(self.addressLabel);
        make.width.height.mas_equalTo(@10);
    }];
    
    _qrCodeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_qrCodeBtn setImage:[[UIImage imageNamed:@"icon_wallet_address_qrcode"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_qrCodeBtn addTarget:self action:@selector(qrCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_qrCodeBtn edgeTouchAreaWithTop:6 right:6 bottom:6 left:6];
    [_bgView addSubview:_qrCodeBtn];
    [_qrCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pasteBtn.mas_right).offset(12);
        make.centerY.equalTo(self.pasteBtn);
        make.width.height.mas_equalTo(@10);
    }];
    
    _settingBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_settingBtn setImage:[[[UIImage imageNamed:@"icon_mine_setting"] jl_imageWithTintColor:JL_color_white_ffffff blendMode:kCGBlendModeDestinationIn] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_settingBtn addTarget:self action:@selector(settingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_settingBtn];
    [_settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView);
        make.top.equalTo(self.bgView);
        make.width.height.mas_equalTo(@54);
    }];
    
    _headerView = [[JLScrollTitleView alloc] initWithFrame:CGRectMake(0, self.frameHeight - 40, self.frameWidth, 40)];
    _headerView.backgroundColor = JL_color_white_ffffff;
    _headerView.isShowBottomLine = YES;
    _headerView.delegate = self;
    _headerView.titleArray = self.titleArray;
    [_bgView addSubview:_headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.bgView);
        make.height.mas_equalTo(@40);
    }];
    
    if (![NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.avatar[@"url"]]) {
        [_avatarImgView sd_setImageWithURL:[NSURL URLWithString:[AppSingleton sharedAppSingleton].userBody.avatar[@"url"]] placeholderImage:[UIImage imageNamed:@"icon_mine_avatar_placeholder"]];
    }
}

#pragma mark - JLScrollTitleViewDelegate
- (void)didSelectIndex:(NSInteger)index {
    if (_delegate && [_delegate respondsToSelector:@selector(didTitleWithIndex:)]) {
        [_delegate didTitleWithIndex:index];
    }
}

#pragma mark - event response
- (void)pasteBtnClick: (UIButton *)sender {
    [UIPasteboard generalPasteboard].string = [NSString stringIsEmpty:_walletInfo.address] ? @"" : _walletInfo.address;
    [[JLLoading sharedLoading] showMBSuccessTipMessage:@"复制成功" hideTime: KToastDismissDelayTimeInterval];
}

- (void)qrCodeBtnClick: (UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(lookAddressQRCode:)]) {
        [_delegate lookAddressQRCode:_walletInfo.address];
    }
}

- (void)settingBtnClick: (UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(settting)]) {
        [_delegate settting];
    }
}

#pragma mark - public methods
- (void)scrollOffset: (CGFloat)offset {
    [_headerView scrollOffset:offset];
}

#pragma mark - setters and getters
- (void)setWalletInfo:(JLMultiWalletInfo *)walletInfo {
    _walletInfo = walletInfo;
    
    _walletNameLabel.text = _walletInfo.walletName == nil ? @"钱包" : _walletInfo.walletName;
    _addressLabel.text = [NSString stringWithFormat:@"钱包地址：%@", _walletInfo.address];
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"TOKENS",@"NFTS"];
    }
    return _titleArray;
}

@end
