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
#import "JLApplyCertListViewController.h"
#import "JLAuctionArtDetailViewController.h"
#import "JLLaunchAuctionViewController.h"
#import "JLModifyNickNameViewController.h"
#import "JLPersonalDescriptionViewController.h"
#import "JLSellWithoutSplitViewController.h"
#import "JLSellWithSplitViewController.h"

#import "JLHoveringView.h"
#import "JLHomePageEditHeaderView.h"

@interface JLHomePageViewController ()<JLHoveringListViewDelegate>
@property (nonatomic,   copy) NSArray <UIViewController *> *viewControllers;
@property (nonatomic,   copy) NSArray <NSString *> *titles;
@property (nonatomic, strong) UIButton *uploadWorkBtn;
@property (nonatomic, strong) JLHomePageEditHeaderView *homePageHeaderView;
@end

@implementation JLHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的主页";
    [self addBackItem];
    [self setupSubViews];
}

- (void)setupSubViews {
    [self.view addSubview:self.uploadWorkBtn];
    
    CGFloat height = kScreenHeight - KTouch_Responder_Height - KStatusBar_Navigation_Height - 47.0f;
    
    JLHoveringView *hovering = [[JLHoveringView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, height) deleaget:self];
    hovering.isMidRefresh = NO;
    [self.view addSubview:hovering];

    hovering.pageView.defaultTitleColor = JL_color_gray_999999;
    hovering.pageView.selectTitleColor = JL_color_gray_101010;
    hovering.pageView.lineColor = JL_color_gray_333333;
    hovering.pageView.lineWitdhScale = 0.18f;
    hovering.pageView.defaultTitleFont = kFontPingFangSCRegular(15.0f);
    hovering.pageView.selectTitleFont = kFontPingFangSCSCSemibold(16.0f);
        
        //设置头部刷新的方法。头部刷新的话isMidRefresh 必须为NO
    //    hovering.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        [hovering.scrollView.mj_header endRefreshing];
    //    }];
}

- (NSArray *)listView {
    NSMutableArray *tableViewArray = [NSMutableArray array];
    for (JLWorksListViewController *worksListVC in self.viewControllers) {
        [tableViewArray addObject:worksListVC.collectionView];
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

- (JLHomePageEditHeaderView *)homePageHeaderView {
    if (!_homePageHeaderView) {
        WS(weakSelf)
        _homePageHeaderView = [[JLHomePageEditHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, 350.0f)];
        _homePageHeaderView.userData = [AppSingleton sharedAppSingleton].userBody;
        
        _homePageHeaderView.nameEditBlock = ^{
            JLModifyNickNameViewController *modifyNickNameVC = [[JLModifyNickNameViewController alloc] init];
            modifyNickNameVC.saveBlock = ^(NSString * _Nonnull nickName) {
                Model_members_change_user_info_Req *request = [[Model_members_change_user_info_Req alloc] init];
                request.display_name = nickName;
                Model_members_change_user_info_Rsp *response = [[Model_members_change_user_info_Rsp alloc] init];
                [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
                [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
                    [[JLLoading sharedLoading] hideLoading];
                    if (netIsWork) {
                        [AppSingleton sharedAppSingleton].userBody = response.body;
                        weakSelf.homePageHeaderView.userData = response.body;
                    } else {
                        [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
                    }
                }];
            };
            [weakSelf.navigationController pushViewController:modifyNickNameVC animated:YES];
        };
        
        _homePageHeaderView.descEditBlock = ^{
            JLPersonalDescriptionViewController *personalDescVC = [[JLPersonalDescriptionViewController alloc] init];
            personalDescVC.saveBlock = ^(NSString * _Nonnull desc) {
                Model_members_change_user_info_Req *request = [[Model_members_change_user_info_Req alloc] init];
                request.desc = desc;
                Model_members_change_user_info_Rsp *response = [[Model_members_change_user_info_Rsp alloc] init];
                [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
                [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
                    [[JLLoading sharedLoading] hideLoading];
                    if (netIsWork) {
                        [AppSingleton sharedAppSingleton].userBody = response.body;
                        weakSelf.homePageHeaderView.userData = response.body;
                    } else {
                        [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
                    }
                }];
            };
            [weakSelf.navigationController pushViewController:personalDescVC animated:YES];
        };
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
    WS(weakSelf)
    NSMutableArray <UIViewController *> *workListVCArray = [NSMutableArray arrayWithCapacity:0];
    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JLWorksListViewController *workListVC = [[JLWorksListViewController alloc] init];
        workListVC.workListType = idx;
        workListVC.addToListBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
            artDetailData.aasm_state = @"bidding";
            JLWorksListViewController *biddingVC = (JLWorksListViewController *)self.viewControllers[1];
            [biddingVC addToBiddingList:artDetailData];
        };
        workListVC.offFromListBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
            artDetailData.aasm_state = @"online";
            JLWorksListViewController *prepareVC = (JLWorksListViewController *)self.viewControllers[0];
            [prepareVC offFromBiddingList:artDetailData];
        };
        workListVC.artDetailBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
            if ([artDetailData.aasm_state isEqualToString:@"auctioning"]) {
                // 拍卖中
                JLAuctionArtDetailViewController *auctionDetailVC = [[JLAuctionArtDetailViewController alloc] init];
                auctionDetailVC.artDetailType = [artDetailData.member.ID isEqualToString:[AppSingleton sharedAppSingleton].userBody.ID] ? JLAuctionArtDetailTypeSelf : JLAuctionArtDetailTypeDetail;
                Model_auction_meetings_arts_Data *meetingsArtsData = [[Model_auction_meetings_arts_Data alloc] init];
                meetingsArtsData.art = artDetailData;
                auctionDetailVC.artsData = meetingsArtsData;
                [weakSelf.navigationController pushViewController:auctionDetailVC animated:YES];
            } else {
                JLArtDetailViewController *artDetailVC = [[JLArtDetailViewController alloc] init];
                artDetailVC.artDetailType = [artDetailData.member.ID isEqualToString:[AppSingleton sharedAppSingleton].userBody.ID] ? JLArtDetailTypeSelfOrOffShelf : JLArtDetailTypeDetail;
                artDetailVC.artDetailData = artDetailData;
                [weakSelf.navigationController pushViewController:artDetailVC animated:YES];
            }
        };
        workListVC.applyAddCertBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
            JLApplyCertListViewController *applyCertListVC = [[JLApplyCertListViewController alloc] init];
            [weakSelf.navigationController pushViewController:applyCertListVC animated:YES];
        };
        workListVC.launchAuctionBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData, NSIndexPath * _Nonnull indexPath) {
            JLLaunchAuctionViewController *launchAuctionVC = [[JLLaunchAuctionViewController alloc] init];
            launchAuctionVC.artDetailData = artDetailData;
            __block JLLaunchAuctionViewController *weakLaunchAuctionVC = launchAuctionVC;
            launchAuctionVC.createAuctionBlock = ^(NSString * _Nonnull startTime, NSString * _Nonnull finishTime) {
                [weakLaunchAuctionVC.navigationController popViewControllerAnimated:YES];
                // 拍卖中
                artDetailData.aasm_state = @"auctioning";
                artDetailData.auction_start_time = startTime;
                artDetailData.auction_end_time = finishTime;
                JLWorksListViewController *biddingVC = (JLWorksListViewController *)self.viewControllers[1];
                [biddingVC addToBiddingList:artDetailData];
                
                JLWorksListViewController *prepareVC = (JLWorksListViewController *)self.viewControllers[0];
                [prepareVC launchAuctionFromNotList:indexPath];
                [[JLLoading sharedLoading] showMBSuccessTipMessage:@"发起拍卖成功" hideTime:KToastDismissDelayTimeInterval];
            };
            [weakSelf.navigationController pushViewController:launchAuctionVC animated:YES];
        };
        workListVC.sellBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
            JLSellWithSplitViewController *sellWithSplitVC = [[JLSellWithSplitViewController alloc] init];
            sellWithSplitVC.artDetailData = artDetailData;
            [weakSelf.navigationController pushViewController:sellWithSplitVC animated:YES];
            
//            JLSellWithoutSplitViewController *sellWithoutSplitVC = [[JLSellWithoutSplitViewController alloc] init];
//            sellWithoutSplitVC.artDetailData = artDetailData;
//            [weakSelf.navigationController pushViewController:sellWithoutSplitVC animated:YES];
        };
        [workListVCArray addObject:workListVC];
    }];
    return workListVCArray.copy;
}

- (NSArray <NSString *> *)titles {
    if (!_titles) {
        _titles = @[@"持有的NFT", @"出售的NFT"];
    }
    return _titles;
}

- (UIButton *)uploadWorkBtn {
    if (!_uploadWorkBtn) {
        _uploadWorkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _uploadWorkBtn.frame = CGRectMake(0.0f, kScreenHeight - KStatusBar_Navigation_Height - KTouch_Responder_Height - 47.0f, kScreenWidth, 47.0f);
        _uploadWorkBtn.backgroundColor = JL_color_gray_101010;
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
