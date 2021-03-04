//
//  JLHomePageViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/26.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLHomePageViewController.h"
#import "JLWorksListViewController.h"
#import "JLUploadWorkViewController.h"
#import "JLArtDetailViewController.h"

#import "JLHoveringView.h"
#import "JLHomePageHeaderView.h"

@interface JLHomePageViewController ()<JLHoveringListViewDelegate>
@property (nonatomic,   copy) NSArray <UIViewController *> *viewControllers;
@property (nonatomic,   copy) NSArray <NSString *> *titles;
@property (nonatomic, strong) UIButton *uploadWorkBtn;
@property (nonatomic, strong) JLHomePageHeaderView *homePageHeaderView;
@end

@implementation JLHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"创作者主页";
    [self addBackItem];
    [self setupSubViews];
}

- (void)setupSubViews {
    [self.view addSubview:self.uploadWorkBtn];
    
    CGFloat height = kScreenHeight - KTouch_Responder_Height - KStatusBar_Navigation_Height - 47.0f;
    
    JLHoveringView *hovering = [[JLHoveringView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, height) deleaget:self];
    hovering.isMidRefresh = NO;
    [self.view addSubview:hovering];

    hovering.pageView.defaultTitleColor = JL_color_gray_101010;
    hovering.pageView.selectTitleColor = JL_color_blue_38B2F1;
    hovering.pageView.lineColor = JL_color_blue_38B2F1;
    hovering.pageView.defaultTitleFont = kFontPingFangSCRegular(15.0f);
    hovering.pageView.selectTitleFont = kFontPingFangSCSCSemibold(17.0f);
        
        //设置头部刷新的方法。头部刷新的话isMidRefresh 必须为NO
    //    hovering.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        [hovering.scrollView.mj_header endRefreshing];
    //    }];
}

- (NSArray *)listView {
    NSMutableArray *tableViewArray = [NSMutableArray array];
    for (JLWorksListViewController *worksListVC in self.viewControllers) {
        [tableViewArray addObject:worksListVC.tableView];
    }
    return [tableViewArray copy];
}

- (UIView *)headView {
    return self.homePageHeaderView;
}

- (NSArray<UIViewController *> *)listCtroller {
    return self.viewControllers;
}

- (NSArray<NSString *> *)listTitle {
    return self.titles;
}

- (JLHomePageHeaderView *)homePageHeaderView {
    if (!_homePageHeaderView) {
        _homePageHeaderView = [[JLHomePageHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, 350.0f)];
        _homePageHeaderView.userData = [AppSingleton sharedAppSingleton].userBody;
    }
    return _homePageHeaderView;
}

- (NSArray <UIViewController *> *)viewControllers {
    if (!_viewControllers) {
        _viewControllers = [self setupViewControllers];
    }
    return _viewControllers;
}

- (NSArray <UIViewController *> *)setupViewControllers {
    NSMutableArray <UIViewController *> *workListVCArray = [NSMutableArray arrayWithCapacity:0];
    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JLWorksListViewController *workListVC = [[JLWorksListViewController alloc] init];
        workListVC.workListType = idx;
        workListVC.addToListBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
            artDetailData.aasm_state = @"bidding";
            JLWorksListViewController *biddingVC = (JLWorksListViewController *)[self.viewControllers firstObject];
            [biddingVC addToBiddingList:artDetailData];
        };
        workListVC.offFromListBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
            artDetailData.aasm_state = @"online";
            JLWorksListViewController *prepareVC = (JLWorksListViewController *)self.viewControllers[1];
            [prepareVC offFromBiddingList:artDetailData];
        };
        workListVC.artDetailBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
            JLArtDetailViewController *artDetailVC = [[JLArtDetailViewController alloc] init];
            artDetailVC.artDetailType = JLArtDetailTypeSelfOrOffShelf;
            artDetailVC.artDetailData = artDetailData;
            [self.navigationController pushViewController:artDetailVC animated:YES];
        };
        [workListVCArray addObject:workListVC];
    }];
    return workListVCArray.copy;
}

- (NSArray <NSString *> *)titles {
    if (!_titles) {
        _titles = @[@"已上架", @"未上架"];
    }
    return _titles;
}

- (UIButton *)uploadWorkBtn {
    if (!_uploadWorkBtn) {
        _uploadWorkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _uploadWorkBtn.frame = CGRectMake(0.0f, kScreenHeight - KStatusBar_Navigation_Height - KTouch_Responder_Height - 47.0f, kScreenWidth, 47.0f);
        _uploadWorkBtn.backgroundColor = JL_color_blue_38B2F1;
        [_uploadWorkBtn setTitle:@"上传作品" forState:UIControlStateNormal];
        [_uploadWorkBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _uploadWorkBtn.titleLabel.font = kFontPingFangSCRegular(17.0f);
        [_uploadWorkBtn addTarget:self action:@selector(uploadWorkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadWorkBtn;
}

- (void)uploadWorkBtnClick {
    JLUploadWorkViewController *uploadWorkVC = [[JLUploadWorkViewController alloc] init];
    [self.navigationController pushViewController:uploadWorkVC animated:YES];
}
@end
