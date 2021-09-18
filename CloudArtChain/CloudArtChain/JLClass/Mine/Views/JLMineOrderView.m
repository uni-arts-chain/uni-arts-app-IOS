//
//  JLMineOrderView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/26.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLMineOrderView.h"
#import "UIButton+AxcButtonContentLayout.h"

@interface JLMineOrderView()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *cashAccountView;
@property (nonatomic, strong) UIView *walletView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *mainWaletView;
@property (nonatomic, strong) UIView *multiWalletView;

@property (nonatomic, strong) UILabel *cashAccountLabel;
@property (nonatomic, strong) UILabel *pointLabel;
@end

@implementation JLMineOrderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.imageView];
    [self.imageView addSubview:self.cashAccountView];
    [self.imageView addSubview:self.walletView];
    [self.imageView addSubview:self.lineView];
    [self.cashAccountView addSubview:self.mainWaletView];
    [self.walletView addSubview:self.multiWalletView];
//    [self.cashAccountView addSubview:self.cashAccountLabel];
//    [self.walletView addSubview:self.pointLabel];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.bottom.equalTo(self);
    }];
    [self.cashAccountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.imageView);
        make.width.mas_equalTo((self.frameWidth - 30) / 2);
    }];
    [self.walletView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.imageView);
        make.left.equalTo(self.cashAccountView.mas_right);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imageView);
        make.bottom.equalTo(self.imageView).offset(-25);
        make.size.mas_equalTo(CGSizeMake(1, 13));
    }];
    [self.mainWaletView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.cashAccountView);
        make.centerY.equalTo(self.lineView);
        make.height.mas_equalTo(@20);
    }];
    [self.multiWalletView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.walletView);
        make.centerY.equalTo(self.lineView);
        make.height.mas_equalTo(@20);
    }];
//    [self.cashAccountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.cashAccountView);
//        make.centerY.equalTo(self.lineView);
//    }];
//    [self.pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.walletView);
//        make.centerY.equalTo(self.lineView);
//    }];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [JLUIFactory imageViewInitImageName:@"icon_mine_point"];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UIView *)cashAccountView {
    if (!_cashAccountView) {
        _cashAccountView = [[UIView alloc] init];
        _cashAccountView.userInteractionEnabled = YES;
        [_cashAccountView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cashAccountViewDidTap:)]];
    }
    return _cashAccountView;
}

- (UIView *)walletView {
    if (!_walletView) {
        _walletView = [[UIView alloc] init];
        _walletView.userInteractionEnabled = YES;
        [_walletView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(walletViewDidTap:)]];
    }
    return _walletView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = JL_color_white_ffffff;
    }
    return _lineView;
}

- (UIView *)mainWaletView {
    if (!_mainWaletView) {
        _mainWaletView = [[UIView alloc] init];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_mine_wallet_main"];
        [_mainWaletView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_mainWaletView);
            make.centerY.equalTo(_mainWaletView);
            make.width.height.mas_equalTo(@17);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"主链钱包";
        label.textColor = JL_color_white_ffffff;
        label.font = kFontPingFangSCMedium(15);
        [_mainWaletView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView.mas_right).offset(10);
            make.centerY.equalTo(imgView);
            make.right.equalTo(_mainWaletView);
        }];
    }
    return _mainWaletView;
}

- (UIView *)multiWalletView {
    if (!_multiWalletView) {
        _multiWalletView = [[UIView alloc] init];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_mine_wallet_multi"];
        [_multiWalletView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_multiWalletView);
            make.centerY.equalTo(_multiWalletView);
            make.width.height.mas_equalTo(@17);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"多链钱包";
        label.textColor = JL_color_white_ffffff;
        label.font = kFontPingFangSCMedium(15);
        [_multiWalletView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView.mas_right).offset(10);
            make.centerY.equalTo(imgView);
            make.right.equalTo(_multiWalletView);
        }];
    }
    return _multiWalletView;
}

- (UILabel *)pointLabel {
    if (!_pointLabel) {
        _pointLabel = [JLUIFactory labelInitText:@"区块链积分：0" font:kFontPingFangSCMedium(15.0f) textColor:JL_color_white_ffffff textAlignment:NSTextAlignmentCenter];
    }
    return _pointLabel;
}

- (UILabel *)cashAccountLabel {
    if (!_cashAccountLabel) {
        _cashAccountLabel = [JLUIFactory labelInitText:@"现金账户：--" font:kFontPingFangSCMedium(15.0f) textColor:JL_color_white_ffffff textAlignment:NSTextAlignmentCenter];
    }
    return _cashAccountLabel;
}

- (void)cashAccountViewDidTap: (UITapGestureRecognizer *)ges {
    if (self.cashAccountBlock) {
        self.cashAccountBlock();
    }
}

- (void)walletViewDidTap: (UITapGestureRecognizer *)ges {
    if (self.walletBlock) {
        self.walletBlock();
    }
}

- (void)setCurrentAccountBalance:(NSString *)amount {
    self.pointLabel.text = [NSString stringWithFormat:@"区块链积分：%@", amount];
}

- (void)setCashAccountBalance:(NSString *)amount {
    self.cashAccountLabel.text = [NSString stringWithFormat:@"现金账户：￥%@", amount];
}

@end
