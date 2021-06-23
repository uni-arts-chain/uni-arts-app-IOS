//
//  JLOrderDetailViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/28.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLOrderDetailViewController.h"
#import "JLInputLogisticsViewController.h"

#import "JLOrderDetailContentView.h"

@interface JLOrderDetailViewController ()

@property (nonatomic, strong) JLOrderDetailContentView *contentView;

@end

@implementation JLOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"";
    [self addBackItem];
    [self.view addSubview:self.contentView];
    
    self.contentView.orderDetailType = _orderDetailType;
    self.contentView.orderData = _orderData;
}

#pragma mark - setters and gettrs
- (JLOrderDetailContentView *)contentView {
    if (!_contentView) {
        _contentView = [[JLOrderDetailContentView alloc] initWithFrame:CGRectMake(0, -KStatusBar_Navigation_Height, kScreenWidth, kScreenHeight)];
    }
    return _contentView;
}

@end
