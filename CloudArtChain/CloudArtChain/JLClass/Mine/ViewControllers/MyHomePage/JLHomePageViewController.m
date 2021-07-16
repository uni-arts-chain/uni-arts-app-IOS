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

#import "JLHoveringView.h"
#import "JLHomePageEditHeaderView.h"

@interface JLHomePageViewController ()<JLHoveringListViewDelegate>
@property (nonatomic,   copy) NSArray <UIViewController *> *viewControllers;
@property (nonatomic,   copy) NSArray <NSString *> *titles;
@property (nonatomic, strong) UIButton *uploadWorkBtn;
@property (nonatomic, strong) JLHomePageEditHeaderView *homePageHeaderView;
@property (nonatomic, strong) JLHoveringView *hovering;
@end

@implementation JLHomePageViewController

- (void)viewDidLoad {
    WS(weakSelf)
    [super viewDidLoad];
    self.navigationItem.title = @"我的主页";
    [self addBackItem];
    if ([AppSingleton sharedAppSingleton].userBody == nil) {
        [AppSingleton loginInfonWithBlock:^{
            [weakSelf setupSubViews];
        }];
    } else {
        [self setupSubViews];
    }
}

- (void)setupSubViews {
    WS(weakSelf)
    [self.view addSubview:self.uploadWorkBtn];
    
    CGFloat height = kScreenHeight - KTouch_Responder_Height - KStatusBar_Navigation_Height - 47.0f;
    
    JLHoveringView *hovering = [[JLHoveringView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, height) deleaget:self];
    hovering.isMidRefresh = NO;
    [self.view addSubview:hovering];
    self.hovering = hovering;

    hovering.pageView.defaultTitleColor = JL_color_gray_999999;
    hovering.pageView.selectTitleColor = JL_color_gray_101010;
    hovering.pageView.lineColor = JL_color_gray_333333;
    hovering.pageView.lineWitdhScale = 0.18f;
    hovering.pageView.defaultTitleFont = kFontPingFangSCRegular(15.0f);
    hovering.pageView.selectTitleFont = kFontPingFangSCSCSemibold(16.0f);
        
    //设置头部刷新的方法。头部刷新的话isMidRefresh 必须为NO
    hovering.scrollView.mj_header = [JLRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf workListHeadRefresh];
    }];
}

- (void)workListHeadRefresh {
    JLWorksListViewController *workListVC = (JLWorksListViewController *)self.viewControllers[self.hovering.pageView.currentSelectedIndex];
    [workListVC headRefresh];
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
        NSString *descStr = [NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.desc] ? @"请输入描述内容" : [AppSingleton sharedAppSingleton].userBody.desc;
        CGFloat descHeight = [self getDescLabelHeight:descStr];
        _homePageHeaderView = [[JLHomePageEditHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, 206.0f + descHeight)];
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
                        NSString *descStr = [NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.desc] ? @"请输入描述内容" : [AppSingleton sharedAppSingleton].userBody.desc;
                        CGFloat descHeight = [weakSelf getDescLabelHeight:descStr];
                        weakSelf.homePageHeaderView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, 206.0f + descHeight);
                        [weakSelf.hovering reloadView];
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
                        NSString *descStr = [NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.desc] ? @"请输入描述内容" : [AppSingleton sharedAppSingleton].userBody.desc;
                        CGFloat descHeight = [weakSelf getDescLabelHeight:descStr];
                        weakSelf.homePageHeaderView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, 206.0f + descHeight);
                        [weakSelf.hovering reloadView];
                        weakSelf.homePageHeaderView.userData = response.body;
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
                NSString *descStr = [NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.desc] ? @"请输入描述内容" : [AppSingleton sharedAppSingleton].userBody.desc;
                CGFloat descHeight = [weakSelf getDescLabelHeight:descStr];
                weakSelf.homePageHeaderView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, 206.0f + descHeight);
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
    CGRect rect = [JLTool getAdaptionSizeWithAttributedText:attr font:kFontPingFangSCRegular(13.0f) labelWidth:kScreenWidth - 40.0f * 2 lineSpace:10.0f];
    return rect.size.height + 20.0f;
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
    //            artDetailData.aasm_state = @"online";
    //            JLWorksListViewController *prepareVC = (JLWorksListViewController *)weakSelf.viewControllers[0];
    //            [prepareVC offFromBiddingList:artDetailData];
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
                    UIAlertController *alertVC = [UIAlertController alertShowWithTitle:@"提示" message:@"检测到您已提交挂单申请。饭团密画现处于公测阶段，订单成交后，请联系客服，提交自己的手机号码、钱包地址、和订单号申请提现。公测结束后会上线自动提现功能，饭团密画感谢您的支持。" cancel:@"取消" cancelHandler:^{
                        
                    } confirm:@"联系客服" confirmHandler:^{
                        JLCustomerServiceViewController *customerServiceVC = [[JLCustomerServiceViewController alloc] init];
                        [weakSelf.navigationController pushViewController:customerServiceVC animated:YES];
                    }];
                    [weakSelf presentViewController:alertVC animated:YES completion:nil];
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
                    UIAlertController *alertVC = [UIAlertController alertShowWithTitle:@"提示" message:@"检测到您已提交挂单申请。饭团密画现处于公测阶段，订单成交后，请联系客服，提交自己的手机号码、钱包地址、和订单号申请提现。公测结束后会上线自动提现功能，饭团密画感谢您的支持。" cancel:@"取消" cancelHandler:^{
                        
                    } confirm:@"联系客服" confirmHandler:^{
                        JLCustomerServiceViewController *customerServiceVC = [[JLCustomerServiceViewController alloc] init];
                        [weakSelf.navigationController pushViewController:customerServiceVC animated:YES];
                    }];
                    [weakSelf presentViewController:alertVC animated:YES completion:nil];
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
                [[JLLoading sharedLoading] showMBSuccessTipMessage:@"已提交转让申请" hideTime:KToastDismissDelayTimeInterval];
                for (JLWorksListViewController *workListVC in weakSelf.viewControllers) {
                    [workListVC headRefresh];
                }
            };
            [weakSelf.navigationController pushViewController:transferVC animated:YES];
        };
        workListVC.auctionBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
            NSLog(@"拍卖");
            JLLaunchAuctionViewController *vc = [[JLLaunchAuctionViewController alloc] init];
            vc.artDetailData = artDetailData;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        workListVC.cancelAuctionBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
            NSLog(@"取消拍卖");
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
        _uploadWorkBtn.frame = CGRectMake(0.0f, kScreenHeight - KStatusBar_Navigation_Height - KTouch_Responder_Height - 47.0f, kScreenWidth, 47.0f + KTouch_Responder_Height);
        _uploadWorkBtn.backgroundColor = JL_color_gray_101010;
        [_uploadWorkBtn setTitle:@"上传作品" forState:UIControlStateNormal];
        [_uploadWorkBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _uploadWorkBtn.titleLabel.font = kFontPingFangSCRegular(17.0f);
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
