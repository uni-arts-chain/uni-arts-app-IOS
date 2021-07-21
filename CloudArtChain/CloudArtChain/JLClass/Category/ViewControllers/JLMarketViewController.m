//
//  JLMarketViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/14.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLMarketViewController.h"
#import "JLSegmentViewController.h"
#import "JLScrollTitleView.h"
#import "JLCategoryViewController.h"
#import "JLSearchViewController.h"

@interface JLMarketViewController ()<JLSegmentViewControllerDelegate, JLScrollTitleViewDelegate>

@property (nonatomic, strong) JLSegmentViewController *segmentVC;

@property (nonatomic, strong) JLScrollTitleView *headerView;

@end

@implementation JLMarketViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"市场";
    
    [self addRightItemImage:@"navigation_item_search_icon"];
    
    JLCategoryViewController *sellingVC = [[JLCategoryViewController alloc] init];
    sellingVC.type = JLCategoryViewControllerTypeSelling;
    sellingVC.topInset = 38;
    JLCategoryViewController *auctionVC = [[JLCategoryViewController alloc] init];
    auctionVC.type = JLCategoryViewControllerTypeAuctioning;
    auctionVC.topInset = 38;
    
    _segmentVC = [[JLSegmentViewController alloc] initWithFrame:self.view.bounds viewControllers:@[sellingVC, auctionVC]];
    _segmentVC.delegate = self;
    [self.view addSubview:_segmentVC.view];
    [self addChildViewController:_segmentVC];
    
    [self.view addSubview:self.headerView];
}

- (void)rightItemClick {
    JLSearchViewController *searchVC = [[JLSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - JLSegmentViewControllerDelegate
/// 手动滑动 偏移
- (void)scrollOffset:(CGPoint)offset {
    [self.headerView scrollOffset:offset.x];
}

#pragma mark - JLScrollTitleViewDelegate
- (void)didSelectIndex:(NSInteger)index {
    [_segmentVC moveToViewControllerAtIndex:index];
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
