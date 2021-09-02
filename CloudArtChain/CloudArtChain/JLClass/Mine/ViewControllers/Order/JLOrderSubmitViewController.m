//
//  JLOrderSubmitViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/2.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLOrderSubmitViewController.h"
#import "JLEditAddressViewController.h"
#import "JLHomePageViewController.h"

#import "JLOrderDetailProductBottomPriceTableViewCell.h"
#import "JLOrderDetailPayMethodTableViewCell.h"
#import "JLCashAccountPasswordAuthorizeView.h"

@interface JLOrderSubmitViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) NSString *currentAmount;
@property (nonatomic, assign) JLOrderPayTypeName currentPayType;

@property (nonatomic, copy) NSString *cashAccountBalance;
@end

@implementation JLOrderSubmitViewController

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadCashAccount];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提交订单";
    [self addBackItem];
    
    if (self.auctionsData) {
        self.currentAmount = self.auctionsData.amount;
    }else {
        if (self.artDetailData.collection_mode == 3) {
            self.currentAmount = @"1";
        } else {
            self.currentAmount = self.sellingOrderData.amount;
        }
    }
    self.currentPayType = JLOrderPayTypeNameAccount;
}

- (void)createSubViews {
    [self.view addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.mas_equalTo(-KTouch_Responder_Height);
            make.height.mas_equalTo(46.0f);
        }];
        
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JL_color_white_ffffff;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100.0f;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[JLOrderDetailProductBottomPriceTableViewCell class] forCellReuseIdentifier:@"JLOrderDetailProductBottomPriceTableViewCell"];
        [_tableView registerClass:[JLOrderDetailPayMethodTableViewCell class] forCellReuseIdentifier:@"JLOrderDetailPayMethodTableViewCell"];
    }
    return _tableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = JL_color_white_ffffff;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = JL_color_gray_DDDDDD;
        [_bottomView addSubview:lineView];
        
        UILabel *payTitleLabel = [JLUIFactory labelInitText:@"待支付：" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
        [_bottomView addSubview:payTitleLabel];
        
        NSDecimalNumber *totalPriceNumber = [NSDecimalNumber decimalNumberWithString:self.sellingOrderData.price];
        if (![NSString stringIsEmpty:self.artDetailData.royalty]) {
            NSDecimalNumber *royaltyNumber = [NSDecimalNumber decimalNumberWithString:self.artDetailData.royalty];
//            ![self.artDetailData.author.ID isEqualToString:self.sellingOrderData.seller_id]
            if (self.sellingOrderData.need_royalty) {
                NSDecimalNumber *currentRoyaltyNumber = [[NSDecimalNumber decimalNumberWithString:self.sellingOrderData.price] decimalNumberByMultiplyingBy:royaltyNumber];
                totalPriceNumber = [totalPriceNumber decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:[currentRoyaltyNumber roundUpScale:2].stringValue]];
            }
        }
        
        NSString *priceString = [NSString stringWithFormat:@"¥%@", totalPriceNumber.stringValue];
        UILabel *priceLabel = [JLUIFactory labelInitText:priceString font:kFontPingFangSCRegular(14.0f) textColor:JL_color_red_D70000 textAlignment:NSTextAlignmentLeft];
        self.priceLabel = priceLabel;
        [_bottomView addSubview:priceLabel];
        
        UIButton *submitButton = [JLUIFactory buttonInitTitle:@"去支付" titleColor:JL_color_white_ffffff backgroundColor:JL_color_black font:kFontPingFangSCRegular(15.0f) addTarget:self action:@selector(submitBtnClick)];
        submitButton.contentEdgeInsets = UIEdgeInsetsZero;
        ViewBorderRadius(submitButton, 15.0f, 0.0f, JL_color_clear);
        [_bottomView addSubview:submitButton];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(_bottomView);
            make.height.mas_equalTo(1.0f);
        }];
        [payTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20.0f);
            make.centerY.equalTo(_bottomView.mas_centerY);
        }];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(payTitleLabel.mas_right).offset(5.0f);
            make.centerY.equalTo(_bottomView.mas_centerY);
        }];
        [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-16.0f);
            make.width.mas_equalTo(118.0f);
            make.height.mas_equalTo(30.0f);
            make.centerY.equalTo(_bottomView.mas_centerY);
        }];
    }
    return _bottomView;
}

/// 计算总价
- (NSDecimalNumber *)calculateTotalPrice: (NSString *)amount {
    
    NSDecimalNumber *onePrice = [NSDecimalNumber decimalNumberWithString:self.sellingOrderData.price];
    NSDecimalNumber *count = [NSDecimalNumber decimalNumberWithString:amount];
    NSDecimalNumber *totalPriceNumber = [onePrice decimalNumberByMultiplyingBy:count];
    if (![NSString stringIsEmpty:self.artDetailData.royalty]) {
        NSDecimalNumber *royaltyNumber = [NSDecimalNumber decimalNumberWithString:self.artDetailData.royalty];
        if (self.sellingOrderData.need_royalty) {
            NSDecimalNumber *currentRoyaltyNumber = [totalPriceNumber decimalNumberByMultiplyingBy:royaltyNumber];
            totalPriceNumber = [totalPriceNumber decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:[currentRoyaltyNumber roundUpScale:2].stringValue]];
        }
    }
    
    return totalPriceNumber;
}

- (void)submitBtnClick {
    WS(weakSelf)
    if (self.currentPayType == JLOrderPayTypeNameAccount) {
        [JLCashAccountPasswordAuthorizeView showWithTitle:@"输入加码射线密码完成支付" complete:^(NSString * _Nonnull passwords) {
            [[JLViewControllerTool appDelegate].walletTool authorizeWithPasswords:passwords with:^(BOOL success) {
                if (success) {
                    NSLog(@"密码验证成功");
                    [weakSelf commitToService];
                }else {
                    NSLog(@"密码验证失败");
                    [[JLLoading sharedLoading] showMBFailedTipMessage:@"密码验证失败！" hideTime:KToastDismissDelayTimeInterval];
                }
            }];
        } cancel:nil];
    }else {
        [self commitToService];
    }
}

- (void)commitToService {
    WS(weakSelf)
    Model_art_trades_Req *request = [[Model_art_trades_Req alloc] init];
    if (self.auctionsData) {
        request.auction_id = self.auctionsData.ID;
    }else {
        request.art_order_sn = self.sellingOrderData.sn;
        request.amount = self.currentAmount;
    }
    request.order_from = @"ios";
    request.pay_type = self.currentPayType;
    Model_art_trades_Rsp *response = [[Model_art_trades_Rsp alloc] init];
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            if (weakSelf.currentPayType == JLOrderPayTypeNameAccount) {
                if (weakSelf.buySuccessBlock) {
                    weakSelf.buySuccessBlock(weakSelf.currentPayType,@"");
                }
            }else {
                NSString *payUrl = response.body[@"url"];
                if (![NSString stringIsEmpty:payUrl]) {
                    if (weakSelf.buySuccessBlock) {
                        weakSelf.buySuccessBlock(weakSelf.currentPayType ,payUrl);
                    }
                }
            }
            if (self.auctionsData) {
                JLHomePageViewController *vc = [[JLHomePageViewController alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else {
                [weakSelf.navigationController popViewControllerAnimated:NO];
            }
        }
    }];
}

/// 获取现金账户
- (void)loadCashAccount {
    WS(weakSelf)
    Model_accounts_Req *request = [[Model_accounts_Req alloc] init];
    Model_accounts_Rsp *response = [[Model_accounts_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            for (Model_account_Data *model in response.body) {
                if ([model.currency_code isEqualToString:@"rmb"]) {
                    weakSelf.cashAccountBalance = model.balance;
                    break;
                }
            }
        }
        
        [self createSubViews];
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    if (indexPath.row == 0) {
        JLOrderDetailProductBottomPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLOrderDetailProductBottomPriceTableViewCell" forIndexPath:indexPath];
        [cell setArtDetailData:self.artDetailData sellingOrderData:self.sellingOrderData];
        cell.totalPriceChangeBlock = ^(NSString * _Nonnull totalPrice, NSString * _Nonnull amount) {
            weakSelf.priceLabel.text = [NSString stringWithFormat:@"¥%@", totalPrice];
            weakSelf.currentAmount = amount;
            
            /// 刷新支付方式
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cell;
    } else {
        JLOrderDetailPayMethodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLOrderDetailPayMethodTableViewCell" forIndexPath:indexPath];
        
        cell.selectedMethodBlock = ^(JLOrderPayTypeName payType) {
            NSLog(@"选择的支付方式: %@", payType);
            weakSelf.currentPayType = payType;
        };
        
        cell.payType = self.currentPayType;
        cell.cashAccountBalance = self.cashAccountBalance;
        cell.buyTotalPrice = [self calculateTotalPrice:self.currentAmount].stringValue;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
@end
