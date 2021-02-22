//
//  JLPurchaseOrderViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/20.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLPurchaseOrderViewController.h"
#import "JLPurchaseOrderListViewController.h"

@interface JLPurchaseOrderViewController ()
@property (nonatomic, strong) NSArray *itemTitleArray;
@end

@implementation JLPurchaseOrderViewController
- (id)init {
    self = [super init];
    if (self) {
        [self initTitleView];
    }
    return self;
}

#pragma mark - 设置顶部菜单
- (void)initTitleView {
    self.selectIndex = 0;
    self.itemMargin = 30.0f;
    self.titleFontName = kFontNamePingFangSCMedium;
    self.titleColorNormal = JL_color_gray_101010;
    self.titleColorSelected = JL_color_blue_38B2F1;
    self.titleSizeNormal = 15.0f;
    self.titleSizeSelected = 15.0f;
    self.menuViewLayoutMode = WMMenuViewLayoutModeScatter;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.automaticallyCalculatesItemWidths = YES;
    self.progressWidth = 40.0f;
    self.progressHeight = 3.0f;
    self.menuView.lineColor = JL_color_blue_38B2F1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuView.scrollView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"买入订单";
    [self addBackItem];
}

- (NSArray*)itemTitleArray {
    if (!_itemTitleArray) {
        _itemTitleArray = @[@"全部订单", @"待支付", @"进行中", @"已完成"];
    }
    return _itemTitleArray;
}

#pragma mark - WMPageController代理
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return self.itemTitleArray.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.itemTitleArray[index];
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    JLPurchaseOrderListViewController *orderListVC = [[JLPurchaseOrderListViewController alloc] init];
    orderListVC.state = index;
    return orderListVC;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0.0f, 0.0f, kScreenWidth, 40.0f);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0.0f, 40.0f, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height - 40.0f);
}

@end
