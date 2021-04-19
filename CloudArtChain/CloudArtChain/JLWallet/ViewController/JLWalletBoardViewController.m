//
//  JLWalletBoardViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/21.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLWalletBoardViewController.h"
#import "JLCreateWalletViewController.h"

@interface JLWalletBoardViewController ()
@property (nonatomic, strong) UIImageView *noticeImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIButton *createWalletBtn;
@property (nonatomic, strong) UIButton *importWalletBtn;
@end

@implementation JLWalletBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"钱包登录";
    [self addBackItem];
    [self createView];
}

- (void)backClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)createView {
    [self.view addSubview:self.noticeImageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.subtitleLabel];
    [self.view addSubview:self.createWalletBtn];
    [self.view addSubview:self.importWalletBtn];
    
    [self.noticeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(45.0f);
        make.width.mas_equalTo(299.0f);
        make.height.mas_equalTo(236.0f);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.noticeImageView.mas_bottom).offset(28.0f);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(22.0f);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [self.importWalletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-KTouch_Responder_Height - 90.0f);
        make.left.mas_equalTo(56.0f);
        make.right.mas_equalTo(-56.0f);
        make.height.mas_equalTo(46.0f);
    }];
    [self.createWalletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.importWalletBtn.mas_top).offset(-24.0f);
        make.left.mas_equalTo(56.0f);
        make.right.mas_equalTo(-56.0f);
        make.height.mas_equalTo(46.0f);
    }];
}

- (UIImageView *)noticeImageView {
    if (!_noticeImageView) {
        _noticeImageView = [JLUIFactory imageViewInitImageName:@"icon_wallet_board"];
    }
    return _noticeImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"钱包是登录云画链唯一方式" font:kFontPingFangSCSCSemibold(18.0f) textColor:JL_color_black_34394C textAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [JLUIFactory labelInitText:@"钱包信息只存储在链上，请务必保管好！" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_999999 textAlignment:NSTextAlignmentCenter];
    }
    return _subtitleLabel;
}

- (UIButton *)createWalletBtn {
    if (!_createWalletBtn) {
        _createWalletBtn = [JLUIFactory buttonInitTitle:@"创建钱包" titleColor:JL_color_white_ffffff backgroundColor:JL_color_blue_50C3FF font:kFontPingFangSCRegular(17.0f) addTarget:self action:@selector(createWalletBtnClick)];
        ViewBorderRadius(_createWalletBtn, 23.0f, 0, JL_color_clear);
    }
    return _createWalletBtn;
}

- (void)createWalletBtnClick {
    JLCreateWalletViewController *createWalletVC = [[JLCreateWalletViewController alloc] init];
    [self.navigationController pushViewController:createWalletVC animated:YES];
}

- (void)createDefaultWallet {
    JLCreateWalletViewController *createWalletVC = [[JLCreateWalletViewController alloc] init];
    [self.navigationController pushViewController:createWalletVC animated:NO];
    [createWalletVC createDefaultWallet];
}

- (UIButton *)importWalletBtn {
    if (!_importWalletBtn) {
        _importWalletBtn = [JLUIFactory buttonInitTitle:@"导入钱包" titleColor:JL_color_blue_50C3FF backgroundColor:JL_color_white_ffffff font:kFontPingFangSCRegular(17.0f) addTarget:self action:@selector(importWalletBtnClick)];
        ViewBorderRadius(_importWalletBtn, 23.0f, 1.0f, JL_color_blue_50C3FF);
    }
    return _importWalletBtn;
}

- (void)importWalletBtnClick {
    [[JLViewControllerTool appDelegate].walletTool toolShowAccountRestore:self.navigationController];
}

@end
