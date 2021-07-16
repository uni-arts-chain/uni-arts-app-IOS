//
//  JLCashAccountViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/14.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLCashAccountViewController.h"
#import "JLCashAccountContentView.h"
#import "JLCashViewController.h"

@interface JLCashAccountViewController () <JLCashAccountContentViewDelegate>

@property (nonatomic, strong) JLCashAccountContentView *contentView;

@end

@implementation JLCashAccountViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"现金账户";
    [self addBackItem];
    
    [self.view addSubview:self.contentView];
    
    [self loadDatas];
}

#pragma mark - JLCashAccountContentViewDelegate
- (void)withdraw {
    JLCashViewController *vc = [[JLCashViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - loadDatas
- (void)loadDatas {
    NSArray *dataArray = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    self.contentView.dataArray = dataArray;
}

#pragma mark - setters and getters
- (JLCashAccountContentView *)contentView {
    if (!_contentView) {
        _contentView = [[JLCashAccountContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height)];
        _contentView.delegate = self;
    }
    return _contentView;
}

@end
