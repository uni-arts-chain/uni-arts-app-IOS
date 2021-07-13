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
#import "JLSettingViewController.h"
#import "JLTransferViewController.h"
#import "JLCustomerServiceViewController.h"

#import "JLCreatorPageNavView.h"
#import "JLHoveringView.h"
#import "JLHomePageEditHeaderView.h"

@interface JLHomePageViewController ()<JLHoveringListViewDelegate>
@property (nonatomic,   copy) NSArray <UIViewController *> *viewControllers;
@property (nonatomic,   copy) NSArray <NSString *> *titles;
@property (nonatomic, strong) UIButton *uploadWorkBtn;
@property (nonatomic, strong) JLHomePageEditHeaderView *homePageHeaderView;
@property (nonatomic, strong) JLHoveringView *hovering;
@property (nonatomic, strong) JLCreatorPageNavView *navView;
@end

@implementation JLHomePageViewController

- (void)viewDidLoad {
    WS(weakSelf)
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    
    if ([AppSingleton sharedAppSingleton].userBody == nil) {
        [AppSingleton loginInfonWithBlock:^{
            [weakSelf setupSubViews];
        }];
    } else {
        [self setupSubViews];
    }
    
    [self.view addSubview:self.navView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChanged:) name:LOCALNOTIFICATION_JL_USERINFO_CHANGED object:nil];
}

- (void)userInfoChanged: (NSNotification *)notification {
    self.homePageHeaderView.userData = [AppSingleton sharedAppSingleton].userBody;
}

- (JLCreatorPageNavView *)navView {
    if (!_navView) {
        _navView = [[JLCreatorPageNavView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KStatusBar_Navigation_Height)];
        _navView.bgView.alpha = 0;
        _navView.titleLabel.text = @"我的主页";
        WS(weakSelf)
        _navView.backBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _navView;
}

- (void)setupSubViews {
    WS(weakSelf)
    [self.view addSubview:self.uploadWorkBtn];
    
    CGFloat height = kScreenHeight - KTouch_Responder_Height - 44.0f;
    
    JLHoveringView *hovering = [[JLHoveringView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, height) deleaget:self];
    hovering.isMidRefresh = NO;
    [self.view addSubview:hovering];
    self.hovering = hovering;

    hovering.pageView.defaultTitleColor = JL_color_gray_87888F;
    hovering.pageView.selectTitleColor = JL_color_mainColor;
    hovering.pageView.lineColor = JL_color_mainColor;
    hovering.pageView.lineWitdhScale = 0.6f;
    hovering.pageView.defaultTitleFont = kFontPingFangSCMedium(14.0f);
    hovering.pageView.selectTitleFont = kFontPingFangSCSCSemibold(14.0f);
        
    //设置头部刷新的方法。头部刷新的话isMidRefresh 必须为NO
    hovering.scrollView.mj_header = [JLRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf workListHeadRefresh];
    }];
}

- (void)workListHeadRefresh {
    JLWorksListViewController *workListVC = (JLWorksListViewController *)self.viewControllers[self.hovering.pageView.currentSelectedIndex];
    [workListVC headRefresh];
}

#pragma mark - JLHoveringListViewDelegate
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

- (void)didScrollContentOffset:(CGPoint)offset {
    
    if (offset.y > 0) {
        self.navView.bgView.alpha = offset.y / (0.12 * kScreenWidth + KStatusBar_Navigation_Height);
    }else {
        self.navView.bgView.alpha = 0;
    }
}

- (JLHomePageEditHeaderView *)homePageHeaderView {
    if (!_homePageHeaderView) {
        WS(weakSelf)
        CGFloat descHeight = 242;
        if (![NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.desc]) {
            descHeight = [self getDescLabelHeight:[AppSingleton sharedAppSingleton].userBody.desc] + 200.0f;
        }
        _homePageHeaderView = [[JLHomePageEditHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, descHeight)];
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
                        CGFloat descHeight = 242;
                        if (![NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.desc]) {
                            descHeight = [weakSelf getDescLabelHeight:[AppSingleton sharedAppSingleton].userBody.desc] + 200.0f;
                        }
                        weakSelf.homePageHeaderView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, descHeight);
                        weakSelf.homePageHeaderView.userData = response.body;
                        [weakSelf.hovering reloadView];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:LOCALNOTIFICATION_JL_USERINFO_CHANGED object:nil];
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
                        CGFloat descHeight = 242;
                        if (![NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.desc]) {
                            descHeight = [weakSelf getDescLabelHeight:[AppSingleton sharedAppSingleton].userBody.desc] +200.0f;
                        }
                        weakSelf.homePageHeaderView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, descHeight);
                        weakSelf.homePageHeaderView.userData = response.body;
                        [weakSelf.hovering reloadView];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:LOCALNOTIFICATION_JL_USERINFO_CHANGED object:nil];
                    } else {
                        [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
                    }
                }];
            };
            [weakSelf.navigationController pushViewController:personalDescVC animated:YES];
        };
        _homePageHeaderView.avatarEditBlock = ^{
            JLSettingViewController *settingVC = [[JLSettingViewController alloc] init];
            settingVC.backBlock = ^{
                CGFloat descHeight = 242;
                if (![NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.desc]) {
                    descHeight = [weakSelf getDescLabelHeight:[AppSingleton sharedAppSingleton].userBody.desc] + 200.0f;
                }
                weakSelf.homePageHeaderView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, descHeight);
                [weakSelf.hovering reloadView];
                weakSelf.homePageHeaderView.userData = [AppSingleton sharedAppSingleton].userBody;
            };
            [weakSelf.navigationController pushViewController:settingVC animated:YES];
        };
    }
    return _homePageHeaderView;
}

- (CGFloat)getDescLabelHeight:(NSString *)descStr {
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:descStr];
    CGRect rect = [JLTool getAdaptionSizeWithAttributedText:attr font:kFontPingFangSCRegular(12) labelWidth:kScreenWidth - 24.0f * 2 lineSpace:2.0f];
    return rect.size.height;
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
            // 上架
            artDetailData.aasm_state = @"bidding";
            JLWorksListViewController *biddingVC = (JLWorksListViewController *)weakSelf.viewControllers[1];
            [biddingVC addToBiddingList:artDetailData];
        };
        workListVC.offFromListBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData, JLWorkListType workListType) {
            {
                JLArtDetailViewController *artDetailVC = [[JLArtDetailViewController alloc] init];
                artDetailVC.artDetailType = artDetailData.is_owner ? JLArtDetailTypeSelfOrOffShelf : JLArtDetailTypeDetail;
                artDetailVC.artDetailData = artDetailData;
                artDetailVC.backBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
                    for (JLWorksListViewController *workListVC in weakSelf.viewControllers) {
                        [workListVC headRefresh];
                    }
                };
                [weakSelf.navigationController pushViewController:artDetailVC animated:YES];
            }
        };
        workListVC.artDetailBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData, JLWorkListType workListType) {
            if ([artDetailData.aasm_state isEqualToString:@"auctioning"]) {
                // 拍卖中
                JLAuctionArtDetailViewController *auctionDetailVC = [[JLAuctionArtDetailViewController alloc] init];
                auctionDetailVC.artDetailType = artDetailData.is_owner ? JLAuctionArtDetailTypeSelf : JLAuctionArtDetailTypeDetail;
                Model_auction_meetings_arts_Data *meetingsArtsData = [[Model_auction_meetings_arts_Data alloc] init];
                meetingsArtsData.art = artDetailData;
                auctionDetailVC.artsData = meetingsArtsData;
                [weakSelf.navigationController pushViewController:auctionDetailVC animated:YES];
            } else {
                JLArtDetailViewController *artDetailVC = [[JLArtDetailViewController alloc] init];
                if ([AppSingleton sharedAppSingleton].userBody.is_official_account) {
                    artDetailVC.marketLevel = 1;
                }else {
                    artDetailVC.marketLevel = 2;
                }
                artDetailVC.artDetailType = artDetailData.is_owner ? JLArtDetailTypeSelfOrOffShelf : JLArtDetailTypeDetail;
                artDetailVC.artDetailData = artDetailData;
                artDetailVC.backBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
                    for (JLWorksListViewController *workListVC in weakSelf.viewControllers) {
                        [workListVC headRefresh];
                    }
                };
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
                JLWorksListViewController *biddingVC = (JLWorksListViewController *)weakSelf.viewControllers[1];
                [biddingVC addToBiddingList:artDetailData];
                
                JLWorksListViewController *prepareVC = (JLWorksListViewController *)weakSelf.viewControllers[0];
                [prepareVC launchAuctionFromNotList:indexPath];
                [[JLLoading sharedLoading] showMBSuccessTipMessage:@"发起拍卖成功" hideTime:KToastDismissDelayTimeInterval];
            };
            [weakSelf.navigationController pushViewController:launchAuctionVC animated:YES];
        };
        workListVC.sellBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
            if (artDetailData.collection_mode == 3) {
                // 可以拆分
                JLSellWithSplitViewController *sellWithSplitVC = [[JLSellWithSplitViewController alloc] init];
                sellWithSplitVC.artDetailData = artDetailData;
                sellWithSplitVC.sellBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
                    for (JLWorksListViewController *workListVC in weakSelf.viewControllers) {
                        [workListVC headRefresh];
                    }
//                    JLWorksListViewController *biddingVC = (JLWorksListViewController *)weakSelf.viewControllers[1];
//                    [biddingVC addToBiddingList:artDetailData];
                    
                    // 用户提示
                    [JLAlertTipView alertWithTitle:@"提示" message:@"检测到您已提交挂单申请。萌易现处于公测阶段，订单成交后，请联系客服，提交自己的手机号码、钱包地址、和订单号申请提现。公测结束后会上线自动提现功能，萌易感谢您的支持。" doneTitle:@"联系客服" cancelTitle:@"取消" done:^{
                        JLCustomerServiceViewController *customerServiceVC = [[JLCustomerServiceViewController alloc] init];
                        [weakSelf.navigationController pushViewController:customerServiceVC animated:YES];
                    } cancel:nil];
                };
                [weakSelf.navigationController pushViewController:sellWithSplitVC animated:YES];
            } else {
                // 不可拆分
                JLSellWithoutSplitViewController *sellWithoutSplitVC = [[JLSellWithoutSplitViewController alloc] init];
                sellWithoutSplitVC.artDetailData = artDetailData;
                sellWithoutSplitVC.sellBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
                    for (JLWorksListViewController *workListVC in weakSelf.viewControllers) {
                        [workListVC headRefresh];
                    }
//                    JLWorksListViewController *biddingVC = (JLWorksListViewController *)weakSelf.viewControllers[1];
//                    [biddingVC addToBiddingList:artDetailData];
                    
                    // 用户提示
                    [JLAlertTipView alertWithTitle:@"提示" message:@"检测到您已提交挂单申请。萌易现处于公测阶段，订单成交后，请联系客服，提交自己的手机号码、钱包地址、和订单号申请提现。公测结束后会上线自动提现功能，萌易感谢您的支持。" doneTitle:@"联系客服" cancelTitle:@"取消" done:^{
                        JLCustomerServiceViewController *customerServiceVC = [[JLCustomerServiceViewController alloc] init];
                        [weakSelf.navigationController pushViewController:customerServiceVC animated:YES];
                    } cancel:nil];
                };
                [weakSelf.navigationController pushViewController:sellWithoutSplitVC animated:YES];
            }
        };
        workListVC.endRefreshBlock = ^{
            [weakSelf.hovering.scrollView.mj_header endRefreshing];
        };
        workListVC.transferBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
            JLTransferViewController *transferVC = [[JLTransferViewController alloc] init];
            transferVC.artDetailData = artDetailData;
            __weak JLTransferViewController *weakTransferVC = transferVC;
            transferVC.transferSuccessBlock = ^{
                [weakTransferVC.navigationController popViewControllerAnimated:YES];
                [[JLLoading sharedLoading] showMBSuccessTipMessage:@"已提交赠送申请" hideTime:KToastDismissDelayTimeInterval];
                for (JLWorksListViewController *workListVC in weakSelf.viewControllers) {
                    [workListVC headRefresh];
                }
            };
            [weakSelf.navigationController pushViewController:transferVC animated:YES];
        };
        [workListVCArray addObject:workListVC];
    }];
    return workListVCArray.copy;
}

- (NSArray <NSString *> *)titles {
    if (!_titles) {
        _titles = @[@"持有的商品", @"出售的商品"];
    }
    return _titles;
}

- (UIButton *)uploadWorkBtn {
    if (!_uploadWorkBtn) {
        _uploadWorkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _uploadWorkBtn.frame = CGRectMake(0.0f, kScreenHeight - KTouch_Responder_Height - 44.0f, kScreenWidth, 44.0f + KTouch_Responder_Height);
        _uploadWorkBtn.backgroundColor = JL_color_mainColor;
        [_uploadWorkBtn setTitle:@"上传作品" forState:UIControlStateNormal];
        [_uploadWorkBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _uploadWorkBtn.titleLabel.font = kFontPingFangSCMedium(16);
        [_uploadWorkBtn addTarget:self action:@selector(uploadWorkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadWorkBtn;
}

- (void)uploadWorkBtnClick {
    WS(weakSelf)
    JLUploadWorkViewController *uploadWorkVC = [[JLUploadWorkViewController alloc] init];
    __weak typeof(uploadWorkVC) weakUploadVC = uploadWorkVC;
    uploadWorkVC.checkProcessBlock = ^{
        [weakUploadVC.navigationController popViewControllerAnimated:YES];
        for (JLWorksListViewController *workListVC in weakSelf.viewControllers) {
            [workListVC headRefresh];
        }
    };
    uploadWorkVC.uploadSuccessBackBlock = ^{
        for (JLWorksListViewController *workListVC in weakSelf.viewControllers) {
            [workListVC headRefresh];
        }
    };
    [weakSelf.navigationController pushViewController:uploadWorkVC animated:YES];
}
@end
