//
//  JLNewHomeViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/8/13.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLNewHomeViewController.h"
#import "JLHoveringViewController.h"
#import "JLArtListViewController.h"
#import "JLScrollTitleView.h"

@interface JLNewHomeViewController () <JLHoveringViewControllerDelegate, JLScrollTitleViewDelegate>

@property (nonatomic, strong) JLScrollTitleView *headerView;

@end

@implementation JLNewHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"主页";
    [self addBackItem];
    
    JLHoveringViewController *vc = [[JLHoveringViewController alloc] init];
    vc.delegate = self;
    vc.view.frame = self.view.bounds;
    [self.view addSubview:vc.view];
    [self addChildViewController:vc];
}

#pragma mark - JLHoveringViewControllerDelegate
- (UIView *)topHeaderView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frameWidth, 200)];
    label.textColor = [UIColor redColor];
    label.backgroundColor = JL_color_blue_CFEFFF;
    label.text = @"topHeaderView";
    
    return label;
}

- (UIView *)middleHoverView {
    return self.headerView;
}

- (NSArray<UIViewController *> *)viewControllers {
    JLArtListViewController *sellingVC = [[JLArtListViewController alloc] init];
    sellingVC.type = JLArtListTypeMarketSelling;
    sellingVC.isNeedRefresh = YES;
    JLArtListViewController *auctionVC = [[JLArtListViewController alloc] init];
    auctionVC.type = JLArtListTypeMarketAuctioning;
    sellingVC.isNeedRefresh = YES;
    
    return @[sellingVC, auctionVC];
}

#pragma mark - JLScrollTitleViewDelegate
- (void)didSelectIndex:(NSInteger)index {
    
}

#pragma mark - setters and getters
- (JLScrollTitleView *)headerView {
    if (!_headerView) {
        _headerView = [[JLScrollTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 38)];
        _headerView.delegate = self;
        _headerView.titleArray = @[@"寄售",@"拍卖"];
    }
    return _headerView;
}

@end
