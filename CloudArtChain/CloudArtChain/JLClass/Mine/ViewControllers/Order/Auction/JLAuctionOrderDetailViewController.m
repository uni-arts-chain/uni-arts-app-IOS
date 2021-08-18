//
//  JLAuctionOrderDetailViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/20.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLAuctionOrderDetailViewController.h"
#import "JLAuctionOrderDetailContentView.h"
#import "JLAuctionDepositPayView.h"
#import "JLCashAccountPasswordAuthorizeView.h"

@interface JLAuctionOrderDetailViewController ()

@property (nonatomic, strong) JLAuctionOrderDetailContentView *contentView;

@end

@implementation JLAuctionOrderDetailViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    [self addBackItem];
    
    [self.view addSubview:self.contentView];
}

#pragma mark - setters and getters
- (JLAuctionOrderDetailContentView *)contentView {
    if (!_contentView) {
        _contentView = [[JLAuctionOrderDetailContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height)];
        _contentView.type = _type;
        _contentView.orderData = _orderData;
    }
    return _contentView;
}

@end
