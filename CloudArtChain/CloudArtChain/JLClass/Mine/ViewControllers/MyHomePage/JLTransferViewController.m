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
@property (nonatomic, strong) UIView *addressView;
@property (nonatomic, strong) UILabel *addressTitleLabel;
@property (nonatomic, strong) JLBaseTextField *addressTF;
@property (nonatomic, strong) UIButton *qrcodeScanBtn;

@property (nonatomic, strong) UIView *numView;
@property (nonatomic, strong) UILabel *numTitleLabel;
@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) JLStepper *numStepper;
@property (nonatomic, strong) UIButton *transferButton;

@property (nonatomic, strong) NSString *currentNumStr;
@end

@implementation JLTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"转让";
    [self addBackItem];
    self.currentNumStr = @"1";
    [self createSubviews];
}

- (void)createSubviews {
    WS(weakSelf)
    [self.view addSubview:self.addressView];
    [self.addressView addSubview:self.addressTitleLabel];
    [self.addressView addSubview:self.addressTF];
    [self.addressView addSubview:self.qrcodeScanBtn];
    
    [self.view addSubview:self.numView];
    [self.numView addSubview:self.numTitleLabel];
    [self.numView addSubview:self.balanceLabel];
    [self.numView addSubview:self.numStepper];
    
    [self.view addSubview:self.transferButton];
    
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(46.0f);
    }];
    [self.addressTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.bottom.equalTo(self.addressView);
    }];
    [self.qrcodeScanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.0f);
        make.centerY.equalTo(self.addressTitleLabel.mas_centerY);
        make.size.mas_equalTo(16.0f);
    }];
    [self.addressTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.qrcodeScanBtn.mas_left).offset(-12.0f);
        make.left.equalTo(self.addressTitleLabel.mas_right).offset(10.0f);
        make.top.bottom.equalTo(self.addressView);
    }];
    
    [self.numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.addressView.mas_bottom).offset(10.0f);
        make.height.mas_equalTo(46.0f);
    }];
    [self.numTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.bottom.equalTo(self.numView);
    }];
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numTitleLabel.mas_right).offset(0.0f);
        make.centerY.equalTo(self.numTitleLabel.mas_centerY);
    }];
    [self.numStepper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.numView).offset(-20.0f);
        make.width.mas_equalTo(75.0f);
        make.height.mas_equalTo(17.0f);
        make.centerY.equalTo(self.numTitleLabel.mas_centerY);
    }];
    
    [self.transferButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numView.mas_bottom).offset(28.0f);
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(46.0f);
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

- (UIView *)addressView {
    if (!_addressView) {
        _addressView = [[UIView alloc] init];
    }
    return _addressView;
}

- (UILabel *)addressTitleLabel {
    if (!_addressTitleLabel) {
        _addressTitleLabel = [JLUIFactory labelInitText:@"转让地址" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _addressTitleLabel;
}

- (JLBaseTextField *)addressTF {
    if (!_addressTF) {
        _addressTF = [[JLBaseTextField alloc]init];
        _addressTF.font = kFontPingFangSCRegular(16.0f);
        _addressTF.textColor = JL_color_gray_101010;
        _addressTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _addressTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _addressTF.spellCheckingType = UITextSpellCheckingTypeNo;
        _addressTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _addressTF.textAlignment = NSTextAlignmentRight;
        NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_BBBBBB, NSFontAttributeName: kFontPingFangSCRegular(16.0f)};
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"请输入转让地址" attributes:dic];
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
        _numTitleLabel = [JLUIFactory labelInitText:@"转让数量" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _numTitleLabel;
}

- (UILabel *)balanceLabel {
    if (!_balanceLabel) {
        _balanceLabel = [JLUIFactory labelInitText:[NSString stringWithFormat:@"（余额%ld）", self.artDetailData.has_amount - self.artDetailData.selling_amount.intValue] font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_999999 textAlignment:NSTextAlignmentLeft];
    }
    return _balanceLabel;
}

- (JLStepper *)numStepper {
    if (!_numStepper) {
        WS(weakSelf)
        _numStepper = [[JLStepper alloc] init];
        _numStepper.stepValue = 1;
        _numStepper.isValueEditable = YES;
        _numStepper.minValue = 1;
        _numStepper.maxValue = self.artDetailData.has_amount - self.artDetailData.selling_amount.intValue;
        _numStepper.value = 1;
        _numStepper.valueChanged = ^(double value) {
            weakSelf.currentNumStr = @(value).stringValue;
        };
    }
    return _numStepper;
}

- (UIButton *)transferButton {
    if (!_transferButton) {
        _transferButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_transferButton setTitle:@"转让" forState:UIControlStateNormal];
        [_transferButton setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _transferButton.titleLabel.font = kFontPingFangSCRegular(17.0f);
        _transferButton.backgroundColor = JL_color_gray_101010;
        ViewBorderRadius(_transferButton, 23.0f, 0.0f, JL_color_clear);
        [_transferButton addTarget:self action:@selector(transferButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _transferButton;
}

- (void)transferButtonClick {
    WS(weakSelf)
    [self.view endEditing:YES];
    
    if ([NSString stringIsEmpty:self.addressTF.text]) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请输入转让地址" hideTime:KToastDismissDelayTimeInterval];
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
                                [weakSelf.navigationController popViewControllerAnimated:YES];
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
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"地址错误" hideTime:KToastDismissDelayTimeInterval];
    }
}
@end
