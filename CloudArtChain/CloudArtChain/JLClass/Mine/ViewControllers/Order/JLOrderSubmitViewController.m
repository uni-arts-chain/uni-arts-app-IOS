//
//  JLOrderSubmitViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/2.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLOrderSubmitViewController.h"
#import "JLEditAddressViewController.h"
#import "JLWechatPayWebViewController.h"

#import "JLOrderDetailProductBottomPriceTableViewCell.h"
#import "JLOrderDetailPayMethodTableViewCell.h"

@interface JLOrderSubmitViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) NSString *currentAmount;
@property (nonatomic, assign) JLOrderPayType currentPayType;
@end

@implementation JLOrderSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提交订单";
    [self addBackItem];
    [self createSubViews];
    if (self.artDetailData.collection_mode == 3) {
        self.currentAmount = @"1";
    } else {
        self.currentAmount = self.sellingOrderData.amount;
    }
    self.currentPayType = JLOrderPayTypeWeChat;
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
        
        NSString *priceString = [NSString stringWithFormat:@"¥%@", self.sellingOrderData.price];
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

- (void)submitBtnClick {
    WS(weakSelf)
    Model_art_trades_Req *request = [[Model_art_trades_Req alloc] init];
    request.art_order_sn = self.sellingOrderData.sn;
    request.amount = self.currentAmount;
    request.order_from = @"ios";
    request.pay_type = self.currentPayType == JLOrderPayTypeWeChat ? @"wepay" : @"alipay";
    Model_art_trades_Rsp *response = [[Model_art_trades_Rsp alloc] init];
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            NSString *payUrl = response.body[@"url"];
            if (![NSString stringIsEmpty:payUrl]) {
                if (weakSelf.buySuccessBlock) {
                    weakSelf.buySuccessBlock(weakSelf.currentPayType ,payUrl);
                }
//                [weakSelf.navigationController popViewControllerAnimated:NO];
            }
        }
    }];
    
//    WS(weakSelf)
//    [[JLViewControllerTool appDelegate].walletTool authorizeWithAnimated:YES cancellable:YES with:^(BOOL success) {
//        if (success) {
//            [[JLViewControllerTool appDelegate].walletTool acceptSaleOrderConfirmWithCallbackBlock:^(BOOL success, NSString * _Nullable message) {
//                if (success) {
//                    [weakSelf.navigationController popToRootViewControllerAnimated:true];
//                    [[JLLoading sharedLoading] showMBSuccessTipMessage:@"购买成功" hideTime:KToastDismissDelayTimeInterval];
//                }
//            }];
//        }
//    }];
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
        };
        return cell;
    } else {
        JLOrderDetailPayMethodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLOrderDetailPayMethodTableViewCell" forIndexPath:indexPath];
        cell.selectedMethodBlock = ^(JLOrderPayType payType) {
            weakSelf.currentPayType = payType;
        };
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
