//
//  JLDappMoreViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/27.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappMoreViewController.h"
#import "JLDappMoreContentView.h"

@interface JLDappMoreViewController ()<JLDappMoreContentViewDelegate>

@property (nonatomic, strong) JLDappMoreContentView *contentView;

@end

@implementation JLDappMoreViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [self getNavigationTitle];
    [self addBackItem];
    
    [self.view addSubview:self.contentView];
    
    [self loadDatas];
}

#pragma mark - JLDappMoreContentViewDelegate
- (void)lookDappWithUrl:(NSString *)url {
    JLLog(@"查看Dapp url: %@", url);
}

#pragma mark - loadDatas
- (void)loadDatas {
    self.contentView.dataArray = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
}

#pragma mark - private methods
- (NSString *)getNavigationTitle {
    if (_type == JLDappMoreViewControllerTypeCollect) {
        return @"收藏";
    }else if (_type == JLDappMoreViewControllerTypeRecently) {
        return @"最近";
    }
    else if (_type == JLDappMoreViewControllerTypeRecommend) {
        return @"推荐";
    }
    else if (_type == JLDappMoreViewControllerTypeTransaction) {
        return @"交易";
    }
    return @"更多";
}

#pragma mark - setters and getters
- (JLDappMoreContentView *)contentView {
    if (!_contentView) {
        _contentView = [[JLDappMoreContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height)];
        _contentView.delegate = self;
    }
    return _contentView;
}

@end
