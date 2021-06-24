//
//  JLTransferViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/5/13.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLTransferViewController.h"
#import "JLBaseTextField.h"
#import "JLStepper.h"
#import "JLScanViewController.h"
#import "UIButton+TouchArea.h"

@interface JLTransferViewController ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *addressView;
@property (nonatomic, strong) UILabel *addressTitleLabel;
@property (nonatomic, strong) JLBaseTextField *addressTF;
@property (nonatomic, strong) UIButton *qrcodeScanBtn;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *numView;
@property (nonatomic, strong) UILabel *numTitleLabel;
@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIButton *transferButton;

@property (nonatomic, strong) NSString *currentNumStr;
@end

@implementation JLTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"赠送";
    [self addBackItem];
    self.currentNumStr = @"1";
    [self createSubviews];
}

- (void)createSubviews {
    WS(weakSelf)
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.addressView];
    [self.addressView addSubview:self.addressTitleLabel];
    [self.addressView addSubview:self.addressTF];
    [self.addressView addSubview:self.qrcodeScanBtn];
        
    [self.bgView addSubview:self.numView];
    [self.numView addSubview:self.numTitleLabel];
    [self.numView addSubview:self.balanceLabel];
    [self.numView addSubview:self.numLabel];
    
    [self.bgView addSubview:self.lineView];
    
    [self.view addSubview:self.transferButton];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(18);
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.height.mas_equalTo(@108);
    }];
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.bgView);
        make.height.mas_equalTo(54.0f);
    }];
    [self.addressTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressView).offset(12.0f);
        make.top.bottom.equalTo(self.addressView);
    }];
    [self.qrcodeScanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addressView).offset(-12.0f);
        make.centerY.equalTo(self.addressTitleLabel.mas_centerY);
        make.size.mas_equalTo(16.0f);
    }];
    [self.addressTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.qrcodeScanBtn.mas_left).offset(-31.0f);
        make.left.equalTo(self.addressTitleLabel.mas_right).offset(10.0f);
        make.top.bottom.equalTo(self.addressView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(12);
        make.right.equalTo(self.bgView).offset(-12);
        make.centerY.equalTo(self.bgView);
        make.height.mas_equalTo(@1);
    }];
    
    [self.numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.addressView.mas_bottom);
        make.height.mas_equalTo(54.0f);
    }];
    [self.numTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numView).offset(12.0f);
        make.top.bottom.equalTo(self.numView);
    }];
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numTitleLabel.mas_right).offset(0.0f);
        make.centerY.equalTo(self.numTitleLabel.mas_centerY);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.numView).offset(-12.0f);
        make.centerY.equalTo(self.numTitleLabel.mas_centerY);
    }];
    
    [self.transferButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_bottom).offset(157.0f);
        make.left.mas_equalTo(63.0f);
        make.right.mas_equalTo(-63.0f);
        make.height.mas_equalTo(44.0f);
    }];
    
    [self.addressTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [weakSelf.addressTF markedTextRange];
            UITextPosition *position = [weakSelf.addressTF positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                NSString *result = [JLUtils trimSpace:x];
                weakSelf.addressTF.text = result;
            }
        } else {
            NSString *result = [JLUtils trimSpace:x];
            weakSelf.addressTF.text = result;
        }
    }];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = JL_color_white_ffffff;
        _bgView.layer.cornerRadius = 8;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = JL_color_gray_EDEDEE;
    }
    return _lineView;
}

- (UIView *)addressView {
    if (!_addressView) {
        _addressView = [[UIView alloc] init];
    }
    return _addressView;
}

- (UILabel *)addressTitleLabel {
    if (!_addressTitleLabel) {
        _addressTitleLabel = [JLUIFactory labelInitText:@"赠送对象" font:kFontPingFangSCSCSemibold(16.0f) textColor:JL_color_black_101220 textAlignment:NSTextAlignmentLeft];
    }
    return _addressTitleLabel;
}

- (JLBaseTextField *)addressTF {
    if (!_addressTF) {
        _addressTF = [[JLBaseTextField alloc]init];
        _addressTF.font = kFontPingFangSCRegular(14.0f);
        _addressTF.textColor = JL_color_black_101220;
        _addressTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _addressTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _addressTF.spellCheckingType = UITextSpellCheckingTypeNo;
        _addressTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _addressTF.textAlignment = NSTextAlignmentRight;
        NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_87888F, NSFontAttributeName: kFontPingFangSCRegular(14.0f)};
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"请输入赠送对象识别码" attributes:dic];
        _addressTF.attributedPlaceholder = attr;
    }
    return _addressTF;
}

- (UIButton *)qrcodeScanBtn {
    if (!_qrcodeScanBtn) {
        _qrcodeScanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_qrcodeScanBtn edgeTouchAreaWithTop:12.0f right:12.0f bottom:12.0f left:12.0f];
        [_qrcodeScanBtn setBackgroundImage:[UIImage imageNamed:@"icon_wallet_transfer_qrcodescan"] forState:UIControlStateNormal];
        [_qrcodeScanBtn addTarget:self action:@selector(qrcodeScanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qrcodeScanBtn;
}

- (void)qrcodeScanBtnClick {
    WS(weakSelf)
    JLScanViewController *scanVC = [JLScanViewController new];
    scanVC.scanType = JLScanTypeAddress;
    scanVC.qrCode = YES;
    scanVC.resultBlock = ^(NSString *scanResult) {
        NSLog(@"%@", scanResult);
        weakSelf.addressTF.text = scanResult;
    };
    scanVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:scanVC animated:YES completion:nil];
}

- (UIView *)numView {
    if (!_numView) {
        _numView = [[UIView alloc] init];
    }
    return _numView;
}

- (UILabel *)numTitleLabel {
    if (!_numTitleLabel) {
        _numTitleLabel = [JLUIFactory labelInitText:@"赠送数量" font:kFontPingFangSCSCSemibold(16.0f) textColor:JL_color_black_101220 textAlignment:NSTextAlignmentLeft];
    }
    return _numTitleLabel;
}

- (UILabel *)balanceLabel {
    if (!_balanceLabel) {
        _balanceLabel = [JLUIFactory labelInitText:[NSString stringWithFormat:@"（余额%ld）", self.artDetailData.has_amount - self.artDetailData.selling_amount.intValue] font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_999999 textAlignment:NSTextAlignmentLeft];
    }
    return _balanceLabel;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.text = @"1";
        _numLabel.textColor = JL_color_black_101220;
        _numLabel.textAlignment = NSTextAlignmentRight;
        _numLabel.font = kFontPingFangSCMedium(15);
    }
    return _numLabel;
}

- (UIButton *)transferButton {
    if (!_transferButton) {
        _transferButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_transferButton setTitle:@"赠送" forState:UIControlStateNormal];
        [_transferButton setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _transferButton.titleLabel.font = kFontPingFangSCMedium(17.0f);
        _transferButton.backgroundColor = JL_color_mainColor;
        ViewBorderRadius(_transferButton, 22.0f, 0.0f, JL_color_clear);
        [_transferButton addTarget:self action:@selector(transferButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _transferButton;
}

- (void)transferButtonClick {
    WS(weakSelf)
    [self.view endEditing:YES];
    
    if ([NSString stringIsEmpty:self.addressTF.text]) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请输入赠送地址" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    NSString *transferAddress = self.addressTF.text;
    if ([self.addressTF.text hasPrefix:@"0x"]) {
        transferAddress = [self.addressTF.text substringFromIndex:2];
    }
    
    NSString *accountId = [[JLViewControllerTool appDelegate].walletTool addressVerifyWithAddress:transferAddress];
    
    if (![NSString stringIsEmpty:accountId]) {
        //判断余额
        [[JLViewControllerTool appDelegate].walletTool getAccountBalanceWithBalanceBlock:^(NSString *amount) {
            NSDecimalNumber *amountNumber = [NSDecimalNumber decimalNumberWithString:amount];
            if ([amountNumber isGreaterThanZero]) {
                [[JLViewControllerTool appDelegate].walletTool authorizeWithAnimated:YES cancellable:YES with:^(BOOL success) {
                    if (success) {
                        [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
                        [[JLViewControllerTool appDelegate].walletTool productSellTransferCallWithAccountId:accountId collectionId:weakSelf.artDetailData.collection_id.intValue itemId:weakSelf.artDetailData.item_id.intValue value:weakSelf.currentNumStr block:^(BOOL success, NSString * _Nullable message) {
                            [[JLLoading sharedLoading] hideLoading];
                            if (success) {
//                                [weakSelf.navigationController popViewControllerAnimated:YES];
                                if (weakSelf.transferSuccessBlock) {
                                    weakSelf.transferSuccessBlock();
                                }
                            } else {
                                [[JLLoading sharedLoading] showMBFailedTipMessage:message hideTime:KToastDismissDelayTimeInterval];
                            }
                        }];
                    }
                }];
            } else {
                UIAlertController *alertController = [UIAlertController alertShowWithTitle:@"提示" message:@"当前积分为0，无法进行操作\r\n（购买NFT卡片可获得积分）" confirm:@"确定"];
                [weakSelf presentViewController:alertController animated:YES completion:nil];
            }
        }];
    } else {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"识别码错误" hideTime:KToastDismissDelayTimeInterval];
    }
}
@end
