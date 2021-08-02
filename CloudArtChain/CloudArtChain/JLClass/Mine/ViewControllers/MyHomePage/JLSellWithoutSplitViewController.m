//
//  JLSellWithoutSplitViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/16.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLSellWithoutSplitViewController.h"
#import "JLBaseTextField.h"

@interface JLSellWithoutSplitViewController ()
@property (nonatomic, strong) UIView *artPriceView;
@property (nonatomic, strong) UILabel *artPriceTitleLabel;
@property (nonatomic, strong) UILabel *artPriceLabel;

@property (nonatomic, strong) UIView *currentPriceView;
@property (nonatomic, strong) UILabel *currentPriceTitleLabel;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) JLBaseTextField *currentPriceTF;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIButton *sellButton;
@property (nonatomic, strong) NSString *lockAccountId;
@end

@implementation JLSellWithoutSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"出售";
    [self addBackItem];
    [self createSubViews];
    // 请求转账地址
    [self requestTransferAddress];
}

- (void)createSubViews {
    WS(weakSelf)
    [self.view addSubview:self.artPriceView];
    [self.artPriceView addSubview:self.artPriceTitleLabel];
    [self.artPriceView addSubview:self.artPriceLabel];
    
    [self.view addSubview:self.currentPriceView];
    [self.currentPriceView addSubview:self.currentPriceTitleLabel];
    [self.currentPriceView addSubview:self.unitLabel];
    [self.currentPriceView addSubview:self.currentPriceTF];
    [self.currentPriceView addSubview:self.lineView];
    
    [self.view addSubview:self.sellButton];
    
    [self.artPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(15.0f);
        make.height.mas_equalTo(50.0f);
    }];
    [self.artPriceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.artPriceView);
    }];
    [self.artPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.artPriceView);
    }];
    
    [self.currentPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(self.artPriceView.mas_bottom);
        make.height.mas_equalTo(50.0f);
    }];
    [self.currentPriceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentPriceView);
        make.centerY.equalTo(self.currentPriceView.mas_centerY);
    }];
    [self.currentPriceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.currentPriceView);
        make.bottom.equalTo(self.currentPriceTitleLabel.mas_bottom);
        make.width.mas_equalTo(100.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentPriceTF.mas_left);
        make.right.equalTo(self.currentPriceTF.mas_right);
        make.height.mas_equalTo(0.5f);
        make.top.equalTo(self.currentPriceTF.mas_bottom);
    }];
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.currentPriceTF.mas_left).offset(-12.0f);
        make.centerY.equalTo(self.currentPriceTF.mas_centerY);
    }];
    [self.sellButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.currentPriceView.mas_bottom).offset(28.0f);
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(46.0f);
    }];
    
    [self.currentPriceTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [weakSelf.currentPriceTF markedTextRange];
            UITextPosition *position = [weakSelf.currentPriceTF positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                NSString *result = [JLUtils trimSpace:x];
                NSRange range = [result rangeOfString:@"."];
                if (range.location == NSNotFound) {
                    if ([NSString stringIsEmpty:result]) {
                        weakSelf.currentPriceTF.text = result;
                    } else {
                        NSDecimalNumber *resultNumber = [[NSDecimalNumber decimalNumberWithString:result] roundDownScale:2];
                        weakSelf.currentPriceTF.text = resultNumber.stringValue;
                    }
                } else {
                    if (range.location == result.length - 1) {
                        weakSelf.currentPriceTF.text = result;
                    } else {
                        if ([NSString stringIsEmpty:result]) {
                            weakSelf.currentPriceTF.text = result;
                        } else {
                            NSString *last = [result substringFromIndex:result.length - 1];
                            if ([last isEqualToString:@"0"]) {
                                weakSelf.currentPriceTF.text = result;
                            } else {
                                NSDecimalNumber *resultNumber = [[NSDecimalNumber decimalNumberWithString:result] roundDownScale:2];
                                weakSelf.currentPriceTF.text = resultNumber.stringValue;
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
                    weakSelf.currentPriceTF.text = result;
                } else {
                    NSDecimalNumber *resultNumber = [[NSDecimalNumber decimalNumberWithString:result] roundDownScale:2];
                    weakSelf.currentPriceTF.text = resultNumber.stringValue;
                }
            } else {
                if (range.location == result.length - 1) {
                    weakSelf.currentPriceTF.text = result;
                } else {
                    if ([NSString stringIsEmpty:result]) {
                        weakSelf.currentPriceTF.text = result;
                    } else {
                        NSString *last = [result substringFromIndex:result.length - 1];
                        if ([last isEqualToString:@"0"]) {
                            weakSelf.currentPriceTF.text = result;
                        } else {
                            NSDecimalNumber *resultNumber = [[NSDecimalNumber decimalNumberWithString:result] roundDownScale:2];
                            weakSelf.currentPriceTF.text = resultNumber.stringValue;
                        }
                    }
                }
            }
        }
    }];
}

- (UIView *)artPriceView {
    if (!_artPriceView) {
        _artPriceView = [[UIView alloc] init];
    }
    return _artPriceView;
}

- (UILabel *)artPriceTitleLabel {
    if (!_artPriceTitleLabel) {
        _artPriceTitleLabel = [JLUIFactory labelInitText:@"当前价格" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _artPriceTitleLabel;
}

- (UILabel *)artPriceLabel {
    if (!_artPriceLabel) {
        _artPriceLabel = [JLUIFactory labelInitText:[NSString stringWithFormat:@"¥%@", [NSString stringIsEmpty:self.artDetailData.price] ? @"0" : self.artDetailData.price] font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentRight];
    }
    return _artPriceLabel;
}

- (UIView *)currentPriceView {
    if (!_currentPriceView) {
        _currentPriceView = [[UIView alloc] init];
    }
    return _currentPriceView;
}

- (UILabel *)currentPriceTitleLabel {
    if (!_currentPriceTitleLabel) {
        _currentPriceTitleLabel = [JLUIFactory labelInitText:@"本次出售价格" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _currentPriceTitleLabel;
}

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [JLUIFactory labelInitText:@"¥" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _unitLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = JL_color_gray_BEBEBE;
    }
    return _lineView;
}

- (JLBaseTextField *)currentPriceTF {
    if (!_currentPriceTF) {
        _currentPriceTF = [[JLBaseTextField alloc]init];
        _currentPriceTF.font = kFontPingFangSCRegular(16.0f);
        _currentPriceTF.textColor = JL_color_gray_101010;
        _currentPriceTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _currentPriceTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _currentPriceTF.spellCheckingType = UITextSpellCheckingTypeNo;
        _currentPriceTF.textFieldType = TextFieldType_withdrawAmout;
        _currentPriceTF.keyboardType = UIKeyboardTypeDecimalPad;
        _currentPriceTF.text = @"0";
        _currentPriceTF.textAlignment = NSTextAlignmentCenter;
    }
    return _currentPriceTF;
}

- (UIButton *)sellButton {
    if (!_sellButton) {
        _sellButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sellButton setTitle:@"出售" forState:UIControlStateNormal];
        [_sellButton setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _sellButton.titleLabel.font = kFontPingFangSCRegular(17.0f);
        _sellButton.backgroundColor = JL_color_gray_101010;
        ViewBorderRadius(_sellButton, 23.0f, 0.0f, JL_color_clear);
        [_sellButton addTarget:self action:@selector(sellButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sellButton;
}

- (void)sellButtonClick {
    WS(weakSelf)
    [self.view endEditing:YES];
    if ([NSString stringIsEmpty:self.currentPriceTF.text] || self.currentPriceTF.text.doubleValue == 0) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请设置本次出售价格" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    
    NSString *sellPrice = [JLUtils trimSpace:self.currentPriceTF.text];
    if (![NSString stringIsEmpty:self.lockAccountId]) {
        [[JLViewControllerTool appDelegate].walletTool getAccountBalanceWithBalanceBlock:^(NSString * _Nonnull amount) {
            NSDecimalNumber *amountNumber = [NSDecimalNumber decimalNumberWithString:amount];
            if ([amountNumber isGreaterThanZero]) {
                [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
                [[JLViewControllerTool appDelegate].walletTool productSellCallWithAccountId:weakSelf.lockAccountId collectionId:weakSelf.artDetailData.collection_id.intValue itemId:weakSelf.artDetailData.item_id.intValue value:@"1" block:^(BOOL success, NSString * _Nonnull message) {
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
                                        request.amount = @"1";
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
