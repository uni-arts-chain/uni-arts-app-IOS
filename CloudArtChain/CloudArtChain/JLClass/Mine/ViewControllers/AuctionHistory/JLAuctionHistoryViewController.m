//
//  JLAuctionHistoryViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/8/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLAuctionHistoryViewController.h"
#import "JLSegmentViewController.h"
#import "JLAuctionListViewController.h"
#import "JLScrollTitleView.h"

@interface JLAuctionHistoryViewController ()<JLSegmentViewControllerDelegate, JLScrollTitleViewDelegate>

@property (nonatomic, strong) JLSegmentViewController *segmentVC;

@property (nonatomic, strong) JLScrollTitleView *headerView;

@property (nonatomic, assign) CGFloat headerHeight;

@end

@implementation JLAuctionHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"拍卖纪录";
    [self addBackItem];
    
    self.headerHeight = 30;
    
    JLAuctionListViewController *attendVC = [[JLAuctionListViewController alloc] init];
    attendVC.type = JLAuctionHistoryTypeAttend;
    attendVC.topInset = self.headerHeight;
    JLAuctionListViewController *bidVC = [[JLAuctionListViewController alloc] init];
    bidVC.type = JLAuctionHistoryTypeBid;
    bidVC.topInset = self.headerHeight;
    JLAuctionListViewController *winVC = [[JLAuctionListViewController alloc] init];
    winVC.type = JLAuctionHistoryTypeWins;
    winVC.topInset = self.headerHeight;
    JLAuctionListViewController *finishVC = [[JLAuctionListViewController alloc] init];
    finishVC.type = JLAuctionHistoryTypeFinish;
    finishVC.topInset = self.headerHeight;
    
    _segmentVC = [[JLSegmentViewController alloc] initWithFrame:self.view.bounds viewControllers:@[attendVC, bidVC, winVC, finishVC] defaultIndex:_defaultType];
    _segmentVC.delegate = self;
    [self addChildViewController:_segmentVC];
    [self.view addSubview:_segmentVC.view];
    
    [self.view addSubview:self.headerView];
    
    // 超时未支付通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAllVCDatas) name:LOCALNOTIFICATION_JL_OVERDUE_PAYMENT_AUCTION object:nil];
    // 支付成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAllVCDatas) name:LOCALNOTIFICATION_JL_CASHACCOUNT_PAY_SUCCESS_AUCTION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAllVCDatas) name:LOCALNOTIFICATION_H5PAYFIHISHEDGOBACK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAllVCDatas) name:LOCALNOTIFICATION_JL_ALIPAYRESULTNOTIFICATION object:nil];
    // 拍卖结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAllVCDatas) name:LOCALNOTIFICATION_JL_END_AUCTION object:nil];
    // 出价成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAllVCDatas) name:LOCALNOTIFICATION_JL_OFFER_SUCCESS_AUCTION object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"释放了: %@", self.class);
}

#pragma mark - Notification
/// 刷新所有数据
- (void)refreshAllVCDatas {
    for (UIViewController *vc in _segmentVC.viewControllers) {
        [((JLAuctionListViewController *)vc) refreshDatas];
    }
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
        _headerView = [[JLScrollTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.headerHeight)];
        _headerView.backgroundColor = JL_color_white_ffffff;
        _headerView.defaultTitleColor = JL_color_gray_212121;
        _headerView.selectedTitleColor = JL_color_gray_212121;
        _headerView.defaultTitleFont = kFontPingFangSCRegular(14);
        _headerView.selectedTitlFont = kFontPingFangSCSCSemibold(15);
        _headerView.bottomLineSize = CGSizeMake(25, 2);
        _headerView.delegate = self;
        _headerView.defaultIndex = _defaultType;
        _headerView.titleArray = @[@"已参与",
                                   @"已出价",
                                   @"已中标",
                                   @"已结束"];
    }
    return _headerView;
}

@end
