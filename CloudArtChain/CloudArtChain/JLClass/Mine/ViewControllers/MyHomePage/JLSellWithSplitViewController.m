//
//  JLSellWithSplitViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/16.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLSellWithSplitViewController.h"
#import "JLBaseTextField.h"

@interface JLSellWithSplitViewController ()
@property (nonatomic, strong) UIView *artBalanceView;
@property (nonatomic, strong) UILabel *artBalanceTitleLabel;
@property (nonatomic, strong) UILabel *artBalanceLabel;

@property (nonatomic, strong) UIView *currentNumView;
@property (nonatomic, strong) UILabel *currentNumTitleLabel;
@property (nonatomic, strong) JLBaseTextField *currentNumTF;
@property (nonatomic, strong) UIView *currentNumLineView;
@property (nonatomic, strong) UILabel *currentNumUnitLabel;

//@property (nonatomic, strong) UIView *splitView;
//@property (nonatomic, strong) UILabel *splitTitleLabel;
//@property (nonatomic, strong) UISwitch *splitSwitch;

@property (nonatomic, strong) UIView *priceView;
@property (nonatomic, strong) UILabel *priceTitleLabel;
@property (nonatomic, strong) UILabel *priceUnitLabel;
@property (nonatomic, strong) JLBaseTextField *priceTF;
@property (nonatomic, strong) UILabel *priceUnitEndLabel;
@property (nonatomic, strong) UIView *priceLineView;

@property (nonatomic, strong) UIButton *sellButton;
@property (nonatomic, strong) NSString *lockAccountId;
@end

@implementation JLSellWithSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"出售";
    [self addBackItem];
    [self createSubviews];
    // 请求转账地址
    [self requestTransferAddress];
}

- (void)createSubviews {
    WS(weakSelf)
    [self.view addSubview:self.artBalanceView];
    [self.artBalanceView addSubview:self.artBalanceTitleLabel];
    [self.artBalanceView addSubview:self.artBalanceLabel];
    
    [self.view addSubview:self.currentNumView];
    [self.currentNumView addSubview:self.currentNumTitleLabel];
    [self.currentNumView addSubview:self.currentNumUnitLabel];
    [self.currentNumView addSubview:self.currentNumTF];
    [self.currentNumView addSubview:self.currentNumLineView];

    
//    [self.view addSubview:self.splitView];
//    [self.splitView addSubview:self.splitTitleLabel];
//    [self.splitView addSubview:self.splitSwitch];
    
    [self.view addSubview:self.priceView];
    [self.priceView addSubview:self.priceTitleLabel];
    [self.priceView addSubview:self.priceUnitLabel];
    [self.priceView addSubview:self.priceTF];
    [self.priceView addSubview:self.priceUnitEndLabel];
    [self.priceView addSubview:self.priceLineView];
    
    [self.view addSubview:self.sellButton];
    
    [self.artBalanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(15.0f);
        make.height.mas_equalTo(50.0f);
    }];
    [self.artBalanceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.artBalanceView);
    }];
    [self.artBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.artBalanceView);
    }];
    
    [self.currentNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(self.artBalanceView.mas_bottom);
        make.height.mas_equalTo(50.0f);
    }];
    [self.currentNumTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentNumView);
        make.centerY.equalTo(self.currentNumView.mas_centerY);
    }];
    [self.currentNumUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.currentNumView);
        make.centerY.equalTo(self.currentNumTitleLabel.mas_centerY);
    }];
    [self.currentNumTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.currentNumUnitLabel.mas_left).offset(-8.0f);
        make.bottom.equalTo(self.currentNumTitleLabel.mas_bottom);
        make.width.mas_equalTo(60.0f);
    }];
    [self.currentNumLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentNumTF.mas_left);
        make.right.equalTo(self.currentNumTF.mas_right);
        make.height.mas_equalTo(0.5f);
        make.top.equalTo(self.currentNumTF.mas_bottom);
    }];
    
//    [self.splitView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(15.0f);
//        make.right.mas_equalTo(-15.0f);
//        make.top.equalTo(self.currentNumView.mas_bottom);
//        make.height.mas_equalTo(50.0f);
//    }];
//    [self.splitTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.splitView);
//        make.centerY.equalTo(self.splitView.mas_centerY);
//    }];
//    [self.splitSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.splitView);
//        make.centerY.equalTo(self.splitView.mas_centerY);
//    }];
    
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(self.currentNumView.mas_bottom);
        make.height.mas_equalTo(50.0f);
    }];
    [self.priceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceView);
        make.centerY.equalTo(self.priceView.mas_centerY);
    }];
    [self.priceUnitEndLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceView);
        make.centerY.equalTo(self.priceTitleLabel.mas_centerY);
    }];
    [self.priceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceUnitEndLabel.mas_left).offset(-8.0f);
        make.bottom.equalTo(self.priceTitleLabel.mas_bottom);
        make.width.mas_equalTo(70.0f);
    }];
    [self.priceLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceTF.mas_left);
        make.right.equalTo(self.priceTF.mas_right);
        make.height.mas_equalTo(0.5f);
        make.top.equalTo(self.priceTF.mas_bottom);
    }];
    [self.priceUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceTF.mas_left).offset(-12.0f);
        make.centerY.equalTo(self.priceTF.mas_centerY);
    }];
    
    [self.sellButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceView.mas_bottom).offset(28.0f);
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(46.0f);
    }];
    
    [self.currentNumTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [weakSelf.currentNumTF markedTextRange];
            UITextPosition *position = [weakSelf.currentNumTF positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                NSString *result = [JLUtils trimSpace:x];
                if (result.intValue > (weakSelf.artDetailData.has_amount - weakSelf.artDetailData.selling_amount.intValue)) {
                    weakSelf.currentNumTF.text = @(weakSelf.artDetailData.has_amount - weakSelf.artDetailData.selling_amount.intValue).stringValue;
                } else {
                    weakSelf.currentNumTF.text = result;
                }
            }
        } else {
            NSString *result = [JLUtils trimSpace:x];
            if (result.intValue > (weakSelf.artDetailData.has_amount - weakSelf.artDetailData.selling_amount.intValue)) {
                weakSelf.currentNumTF.text = @(weakSelf.artDetailData.has_amount - weakSelf.artDetailData.selling_amount.intValue).stringValue;
            } else {
                weakSelf.currentNumTF.text = result;
            }
        }
    }];
    
    
    [self.priceTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [weakSelf.priceTF markedTextRange];
            UITextPosition *position = [weakSelf.priceTF positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                NSString *result = [JLUtils trimSpace:x];
                NSRange range = [result rangeOfString:@"."];
                if (range.location == NSNotFound) {
                    if ([NSString stringIsEmpty:result]) {
                        weakSelf.priceTF.text = result;
                    } else {
                        NSDecimalNumber *resultNumber = [[NSDecimalNumber decimalNumberWithString:result] roundDownScale:2];
                        weakSelf.priceTF.text = resultNumber.stringValue;
                    }
                } else {
                    if (range.location == result.length - 1) {
                        weakSelf.priceTF.text = result;
                    } else {
                        if ([NSString stringIsEmpty:result]) {
                            weakSelf.priceTF.text = result;
                        } else {
                            NSString *last = [result substringFromIndex:result.length - 1];
                            if ([last isEqualToString:@"0"]) {
                                weakSelf.priceTF.text = result;
                            } else {
                                NSDecimalNumber *resultNumber = [[NSDecimalNumber decimalNumberWithString:result] roundDownScale:2];
                                weakSelf.priceTF.text = resultNumber.stringValue;
                            }
                        }
                    }
                }
            }
        } else {
            NSString *result = [JLUtils trimSpace:x];
            NSRange range = [result rangeOfString:@"."];
            if (range.location == NSNotFound) {
                if ([NSString stringIsEmpty:result]) {
                    weakSelf.priceTF.text = result;
                } else {
                    NSDecimalNumber *resultNumber = [[NSDecimalNumber decimalNumberWithString:result] roundDownScale:2];
                    weakSelf.priceTF.text = resultNumber.stringValue;
                }
            } else {
                if (range.location == result.length - 1) {
                    weakSelf.priceTF.text = result;
                } else {
                    if ([NSString stringIsEmpty:result]) {
                        weakSelf.priceTF.text = result;
                    } else {
                        NSString *last = [result substringFromIndex:result.length - 1];
                        if ([last isEqualToString:@"0"]) {
                            weakSelf.priceTF.text = result;
                        } else {
                            NSDecimalNumber *resultNumber = [[NSDecimalNumber decimalNumberWithString:result] roundDownScale:2];
                            weakSelf.priceTF.text = resultNumber.stringValue;
                        }
                    }
                }
            }
        }
    }];
}

- (UIView *)artBalanceView {
    if (!_artBalanceView) {
        _artBalanceView = [[UIView alloc] init];
    }
    return _artBalanceView;
}

- (UILabel *)artBalanceTitleLabel {
    if (!_artBalanceTitleLabel) {
        _artBalanceTitleLabel = [JLUIFactory labelInitText:@"作品库存" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _artBalanceTitleLabel;
}

- (UILabel *)artBalanceLabel {
    if (!_artBalanceLabel) {
        _artBalanceLabel = [JLUIFactory labelInitText:[NSString stringWithFormat:@"%ld份", self.artDetailData.has_amount - self.artDetailData.selling_amount.intValue] font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentRight];
    }
    return _artBalanceLabel;
}

- (UIView *)currentNumView {
    if (!_currentNumView) {
        _currentNumView = [[UIView alloc] init];
    }
    return _currentNumView;
}

- (UILabel *)currentNumTitleLabel {
    if (!_currentNumTitleLabel) {
        _currentNumTitleLabel = [JLUIFactory labelInitText:@"本次出售份数" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _currentNumTitleLabel;
}

- (JLBaseTextField *)currentNumTF {
    if (!_currentNumTF) {
        _currentNumTF = [[JLBaseTextField alloc]init];
        _currentNumTF.font = kFontPingFangSCRegular(16.0f);
        _currentNumTF.textColor = JL_color_gray_101010;
        _currentNumTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _currentNumTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _currentNumTF.spellCheckingType = UITextSpellCheckingTypeNo;
        _currentNumTF.textFieldType = TextFieldType_withdrawAmout;
        _currentNumTF.keyboardType = UIKeyboardTypeNumberPad;
        _currentNumTF.text = @"0";
        _currentNumTF.textAlignment = NSTextAlignmentCenter;
    }
    return _currentNumTF;
}

- (UIView *)currentNumLineView {
    if (!_currentNumLineView) {
        _currentNumLineView = [[UIView alloc] init];
        _currentNumLineView.backgroundColor = JL_color_gray_BEBEBE;
    }
    return _currentNumLineView;
}

- (UILabel *)currentNumUnitLabel {
    if (!_currentNumUnitLabel) {
        _currentNumUnitLabel = [JLUIFactory labelInitText:@"份" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentRight];
    }
    return _currentNumUnitLabel;
}


//- (UIView *)splitView {
//    if (!_splitView) {
//        _splitView = [[UIView alloc] init];
//    }
//    return _splitView;
//}
//
//- (UILabel *)splitTitleLabel {
//    if (!_splitTitleLabel) {
//        _splitTitleLabel = [JLUIFactory labelInitText:@"是否拆开售卖" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
//    }
//    return _splitTitleLabel;
//}
//
//- (UISwitch *)splitSwitch {
//    if (!_splitSwitch) {
//        _splitSwitch = [[UISwitch alloc] init];
//        _splitSwitch.on = NO;
//        [_splitSwitch addTarget:self action:@selector(splitSwitchChange) forControlEvents:UIControlEventValueChanged];
//    }
//    return _splitSwitch;
//}

//- (void)splitSwitchChange {
//    if (self.splitSwitch.isOn) {
//        self.priceTitleLabel.text = @"设置作品价格";
//    } else {
//        self.priceTitleLabel.text = @"设置作品总价";
//    }
//}


- (UIView *)priceView {
    if (!_priceView) {
        _priceView = [[UIView alloc] init];
    }
    return _priceView;
}

- (UILabel *)priceTitleLabel {
    if (!_priceTitleLabel) {
        _priceTitleLabel = [JLUIFactory labelInitText:@"每份价格" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _priceTitleLabel;
}

- (UILabel *)priceUnitLabel {
    if (!_priceUnitLabel) {
        _priceUnitLabel = [JLUIFactory labelInitText:@"¥" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _priceUnitLabel;
}

- (UIView *)priceLineView {
    if (!_priceLineView) {
        _priceLineView = [[UIView alloc] init];
        _priceLineView.backgroundColor = JL_color_gray_BEBEBE;
    }
    return _priceLineView;
}

- (JLBaseTextField *)priceTF {
    if (!_priceTF) {
        _priceTF = [[JLBaseTextField alloc]init];
        _priceTF.font = kFontPingFangSCRegular(16.0f);
        _priceTF.textColor = JL_color_gray_101010;
        _priceTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _priceTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _priceTF.spellCheckingType = UITextSpellCheckingTypeNo;
        _priceTF.textFieldType = TextFieldType_withdrawAmout;
        _priceTF.keyboardType = UIKeyboardTypeDecimalPad;
        _priceTF.text = @"0";
        _priceTF.textAlignment = NSTextAlignmentCenter;
    }
    return _priceTF;
}

- (UILabel *)priceUnitEndLabel {
    if (!_priceUnitEndLabel) {
        _priceUnitEndLabel = [JLUIFactory labelInitText:@"/份" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _priceUnitEndLabel;
}

- (UIButton *)sellButton {
    if (!_sellButton) {
        _sellButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sellButton setTitle:@"出售" forState:UIControlStateNormal];
        [_sellButton setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _sellButton.titleLabel.font = kFontPingFangSCRegular(17.0f);
        _sellButton.backgroundColor = JL_color_mainColor;
        ViewBorderRadius(_sellButton, 23.0f, 0.0f, JL_color_clear);
        [_sellButton addTarget:self action:@selector(sellButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sellButton;
}

- (void)sellButtonClick {
    WS(weakSelf)
    [self.view endEditing:YES];
    if ([NSString stringIsEmpty:self.currentNumTF.text] || self.currentNumTF.text.intValue == 0) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请输入本次出售份数" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    if ([NSString stringIsEmpty:self.priceTF.text] || self.currentNumTF.text.doubleValue == 0) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请设置每份价格" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    
    NSString *sellAmount = [JLUtils trimSpace:weakSelf.currentNumTF.text];
    NSString *sellPrice = [JLUtils trimSpace:weakSelf.priceTF.text];
    if (![NSString stringIsEmpty:self.lockAccountId]) {
        [[JLViewControllerTool appDelegate].walletTool getAccountBalanceWithBalanceBlock:^(NSString * _Nonnull amount) {
            NSDecimalNumber *amountNumber = [NSDecimalNumber decimalNumberWithString:amount];
            if ([amountNumber isGreaterThanZero]) {
                [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
                [[JLViewControllerTool appDelegate].walletTool productSellCallWithAccountId:weakSelf.lockAccountId collectionId:weakSelf.artDetailData.collection_id.intValue itemId:weakSelf.artDetailData.item_id.intValue value:weakSelf.currentNumTF.text block:^(BOOL success, NSString * _Nonnull message) {
                    [[JLLoading sharedLoading] hideLoading];
                    if (success) {
                        [[JLViewControllerTool appDelegate].walletTool authorizeWithAnimated:YES cancellable:YES with:^(BOOL success) {
                            if (success) {
                                [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
                                [[JLViewControllerTool appDelegate].walletTool productSellConfirmWithBlock:^(NSString * _Nullable transferSignedMessage) {
                                    if ([NSString stringIsEmpty:transferSignedMessage]) {
                                        [[JLLoading sharedLoading] hideLoading];
                                        [[JLLoading sharedLoading] showMBFailedTipMessage:@"签名错误" hideTime:KToastDismissDelayTimeInterval];
                                    } else {
                                        // 发送网络请求
                                        Model_art_orders_Req *request = [[Model_art_orders_Req alloc] init];
                                        request.art_id = weakSelf.artDetailData.ID;
                                        request.amount = sellAmount;
                                        request.price = sellPrice;
                                        request.currency = @"rmb";
                                        request.encrpt_extrinsic_message = transferSignedMessage;
                                        Model_art_orders_Rsp *response = [[Model_art_orders_Rsp alloc] init];
                                        [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
                                            [[JLLoading sharedLoading] hideLoading];
                                            if (netIsWork) {
                                                [weakSelf.navigationController popViewControllerAnimated:YES];
                                                if (weakSelf.sellBlock) {
                                                    weakSelf.sellBlock(response.body);
                                                }
                                            } else {
                                                [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
                                            }
                                        }];
                                    }
                                }];
                            }
                        }];
                    } else {
                        [[JLLoading sharedLoading] showMBFailedTipMessage:message hideTime:KToastDismissDelayTimeInterval];
                    }
                }];
            } else {
                UIAlertController *alertController = [UIAlertController alertShowWithTitle:@"提示" message:@"当前积分为0，无法进行操作\r\n（购买NFT卡片可获得积分）" confirm:@"确定"];
                [weakSelf presentViewController:alertController animated:YES completion:nil];
            }
        }];
    }
}

- (void)requestTransferAddress {
    WS(weakSelf)
    Model_art_orders_lock_account_id_Req *request = [[Model_art_orders_lock_account_id_Req alloc] init];
    Model_art_orders_lock_account_id_Rsp *resonse = [[Model_art_orders_lock_account_id_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:resonse callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            weakSelf.lockAccountId = resonse.body[@"lock_account_id"];
            if ([weakSelf.lockAccountId hasPrefix:@"0x"]) {
                weakSelf.lockAccountId = [weakSelf.lockAccountId substringFromIndex:2];
            }
        }
    }];
}
@end
