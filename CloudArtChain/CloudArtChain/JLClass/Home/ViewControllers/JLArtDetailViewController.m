//
//  JLArtDetailViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/1.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLArtDetailViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UITabBar+JLTool.h"
#import "UIButton+AxcButtonContentLayout.h"
#import "WMPhotoBrowser.h"
#import "LewPopupViewController.h"
#import "JLOrderSubmitViewController.h"
#import "JLCreatorPageViewController.h"
#import "JLHomePageViewController.h"
#import "JLSellWithSplitViewController.h"
#import "JLSellWithoutSplitViewController.h"
#import "JLWechatPayWebViewController.h"
#import "JLAlipayWebViewController.h"
#import "JLCustomerServiceViewController.h"

#import "NewPagedFlowView.h"
#import "JLArtDetailNamePriceView.h"
#import "JLArtChainTradeView.h"
#import "JLArtDetailSellingView.h"
#import "JLArtAuthorDetailView.h"
//#import "JLArtInfoView.h"
#import "JLArtEvaluateView.h"
//#import "JLArtDetailDescriptionView.h"
#import "JLChainQRCodeView.h"
#import "JLArtDetailVideoView.h"
#import "JLArtDetailShowCertificateView.h"

#import "NSDate+Extension.h"
#import "JLLive2DCacheManager.h"
#import "UIButton+TouchArea.h"

@interface JLArtDetailViewController ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>
@property (nonatomic, strong) UITabBar *bottomBar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NewPagedFlowView *pageFlowView;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UIButton *photoBrowserBtn;
@property (nonatomic, strong) JLArtDetailVideoView *videoView;
@property (nonatomic, strong) JLArtDetailNamePriceView *artDetailNamePriceView;
@property (nonatomic, strong) JLArtChainTradeView *artChainTradeView;
@property (nonatomic, strong) JLArtDetailSellingView *artSellingView;
@property (nonatomic, assign) BOOL artSellingViewOpen;
@property (nonatomic, strong) JLArtAuthorDetailView *artAuthorDetailView;
//@property (nonatomic, strong) JLArtInfoView *artInfoView;
@property (nonatomic, strong) JLArtEvaluateView *artEvaluateView;
//@property (nonatomic, strong) JLArtDetailDescriptionView *artDetailDescView;

@property (nonatomic, strong) MASConstraint *artSellingViewHeightConstraint;

@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *dislikeButton;
// 测试数据
@property (nonatomic, strong) NSArray *tempImageArray;
// 当前出售列表
@property (nonatomic, strong) NSArray *currentSellingList;
// 立即购买
@property (nonatomic, strong) UIButton *immediatelyBuyBtn;
/** live2d下载 task */
@property (nonatomic, strong) NSURLSessionTask *live2DDownloadTask;
@property (nonatomic, assign) NSInteger networkStatus;
/// 刷新数据（用户信息变更等）
@property (nonatomic, assign) BOOL isUpdateDatas;
@end

@implementation JLArtDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    self.networkStatus = [[NSUserDefaults standardUserDefaults] integerForKey:LOCALNOTIFICATION_JL_NETWORK_STATUS_CHANGED];

    [self addBackItem];
    if (self.artDetailData) {
        [self createSubView];
        [self requestSellingList];
    }else {
        [self updateArtDetailData];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChanged:) name:LOCALNOTIFICATION_JL_NETWORK_STATUS_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChanged:) name:LOCALNOTIFICATION_JL_USERINFO_CHANGED object:nil];
}

- (void)backClick {
    if (self.live2DDownloadTask) {
        [self.live2DDownloadTask cancel];
        self.live2DDownloadTask = nil;
        [[JLLoading sharedLoading] hideLoading];
    }
    if (!self.artDetailData.favorite_by_me && self.cancelFavorateBlock) {
        self.cancelFavorateBlock();
    }
    if (self.backBlock) {
        self.backBlock(self.artDetailData);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)networkStatusChanged: (NSNotification *)notification {
    NSDictionary *dict = notification.userInfo;
    _networkStatus = [dict[@"status"] integerValue];
}

- (void)userInfoChanged: (NSNotification *)notification {
    self.isUpdateDatas = YES;
    
    if (self.artDetailData) {
        [self updateArtDetailData];
    }
}

- (void)createSubView {
    
    [self initBottomUI];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomBar.mas_top);
        make.left.top.right.equalTo(self.view);
    }];
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView);
    }];
    if (self.artDetailData.resource_type == 4) {
        // 视频
        [self.contentView addSubview:self.videoView];
        [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(@250.0f);
        }];
    }else {
        // 主图
        [self.contentView addSubview:self.pageFlowView];
        [self.pageFlowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(@250.0f);
        }];
        // 页码
        [self.contentView addSubview:self.pageLabel];
        // 查看主图
        [self.contentView addSubview:self.photoBrowserBtn];
        
        [self.pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.pageFlowView).offset(-9.0f);
            make.width.mas_equalTo(35.0f);
            make.height.mas_equalTo(17.0f);
            make.centerX.equalTo(self.pageFlowView.mas_centerX);
        }];
        [self.photoBrowserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kScreenWidth - 23.0f - 16.0f);
            make.bottom.equalTo(self.pageFlowView.mas_bottom).offset(-10.0f);
            make.size.mas_equalTo(16.0f);
        }];
    }

    // 作品详情
    [self.contentView addSubview:self.artDetailNamePriceView];
    [self.artDetailNamePriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.artDetailData.resource_type == 4) {
            make.top.equalTo(self.videoView.mas_bottom);
            make.left.right.equalTo(self.videoView);
        }else {
            make.top.equalTo(self.pageFlowView.mas_bottom);
            make.left.right.equalTo(self.pageFlowView);
        }
        make.height.mas_equalTo(@94.0f);
    }];
    // 出售列表
    if (_marketLevel == 2 || _marketLevel == 0) {
        [self.contentView addSubview:self.artSellingView];
        [self.artSellingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.artDetailNamePriceView);
            make.top.equalTo(self.artDetailNamePriceView.mas_bottom);
            self.artSellingViewHeightConstraint = make.height.mas_equalTo(@90);
        }];
    }
    // 区块链交易信息
    NSLog(@"=======------%@", self.artDetailData.ath_price);
    [self.contentView addSubview:self.artChainTradeView];
    [self.artChainTradeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.artDetailNamePriceView);
        if (self.marketLevel == 2 || self.marketLevel == 0) {
            make.top.equalTo(self.artSellingView.mas_bottom).offset(12.0f);
            make.height.mas_equalTo(@211.0f);
        }else {
            make.top.equalTo(self.artDetailNamePriceView.mas_bottom).offset(12.0f);
            make.height.mas_equalTo(@163.0f);
        }
    }];
    // 创作者简介
    [self.contentView addSubview:self.artAuthorDetailView];
    [self.artAuthorDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.artChainTradeView.mas_bottom);
        make.left.right.equalTo(self.artChainTradeView);
        make.height.mas_equalTo(@204.0f);
    }];
    // 作品信息
//    [self.scrollView addSubview:self.artInfoView];
    // 艺术评析
    [self.contentView addSubview:self.artEvaluateView];
    [self.artEvaluateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.artAuthorDetailView.mas_bottom);
        make.left.right.equalTo(self.artAuthorDetailView);
        make.bottom.equalTo(self.contentView).offset(-20.0f);
    }];
    // 艺术品细节
//    [self.scrollView addSubview:self.artDetailDescView];
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (void)initBottomUI {
    self.bottomBar = [UITabBar tabbarWithDefaultShadowImageColor];
    [self.view addSubview:self.bottomBar];
    
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50.0f);
        make.bottom.equalTo(self.view).offset(-KTouch_Responder_Height);
    }];
    
    // 喜欢
    UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeButton setTitle:[NSString stringWithFormat:@"%ld喜欢", self.artDetailData.liked_count] forState:UIControlStateNormal];
    [likeButton setTitleColor:JL_color_black_40414D forState:UIControlStateNormal];
    likeButton.titleLabel.font = kFontPingFangSCMedium(11.0f);
    likeButton.backgroundColor = JL_color_white_ffffff;
    [likeButton setImage:[UIImage imageNamed:@"icon_product_like"] forState:UIControlStateNormal];
    [likeButton setImage:[UIImage imageNamed:@"icon_product_like_selected"] forState:UIControlStateSelected];
    [likeButton addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    likeButton.selected = self.artDetailData.liked_by_me;
    [self.bottomBar addSubview:likeButton];
    self.likeButton = likeButton;
    
    // 收藏
    UIButton *collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    [collectButton setTitleColor:JL_color_black_40414D forState:UIControlStateNormal];
    collectButton.titleLabel.font = kFontPingFangSCMedium(11.0f);
    collectButton.backgroundColor = JL_color_white_ffffff;
    [collectButton setImage:[UIImage imageNamed:@"icon_product_collect"] forState:UIControlStateNormal];
    [collectButton setImage:[UIImage imageNamed:@"icon_product_collect_selected"] forState:UIControlStateSelected];
    [collectButton addTarget:self action:@selector(collectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    collectButton.selected = self.artDetailData.favorite_by_me;
    [self.bottomBar addSubview:collectButton];
    
    // 立即购买
    UIButton *immediatelyBuyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [immediatelyBuyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [immediatelyBuyBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
    immediatelyBuyBtn.titleLabel.font = kFontPingFangSCSCSemibold(18.0f);
    immediatelyBuyBtn.backgroundColor = JL_color_mainColor;
    ViewBorderRadius(immediatelyBuyBtn, 18.0f, 0.0f, JL_color_clear);
    [immediatelyBuyBtn addTarget:self action:@selector(immediatelyBuyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBar addSubview:immediatelyBuyBtn];
    self.immediatelyBuyBtn = immediatelyBuyBtn;
    [self refreshImmediatelyBuyBtnStatus];
    
    [immediatelyBuyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7.0f);
        make.bottom.mas_equalTo(-7.0f);
        make.right.mas_equalTo(-12.0f);
        make.width.mas_equalTo(150.0f);
    }];
    [likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.0f);
        make.top.bottom.equalTo(self.bottomBar);
        make.width.mas_equalTo(60.0f);
    }];
    [collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(likeButton.mas_right);
        make.top.bottom.equalTo(self.bottomBar);
        make.width.mas_equalTo(60.0f);
    }];
    
    [likeButton layoutIfNeeded];
    [collectButton layoutIfNeeded];
    likeButton.axcUI_buttonContentLayoutType = AxcButtonContentLayoutStyleCenterImageTop;
    likeButton.axcUI_padding = 2.0f;
    
    collectButton.axcUI_buttonContentLayoutType = AxcButtonContentLayoutStyleCenterImageTop;
    collectButton.axcUI_padding = 2.0f;
}

- (void)refreshImmediatelyBuyBtnStatus {
    if (self.artDetailType == JLArtDetailTypeSelfOrOffShelf) {
        // 判断是否可以拆分
        if (self.artDetailData.collection_mode == 3) {
            // 可以拆分
            // 判断是否有可售作品
            if (self.artDetailData.has_amount - self.artDetailData.selling_amount.intValue > 0) {
                // 有可出售的作品
                [self.immediatelyBuyBtn setTitle:@"出售" forState:UIControlStateNormal];
                self.immediatelyBuyBtn.enabled = YES;
                self.immediatelyBuyBtn.backgroundColor = JL_color_mainColor;
            } else {
                [self.immediatelyBuyBtn setTitle:@"出售" forState:UIControlStateNormal];
                self.immediatelyBuyBtn.enabled = NO;
                self.immediatelyBuyBtn.backgroundColor = JL_color_gray_BEBEBE;
            }
        } else {
            // 不可拆分
            if ([self.artDetailData.aasm_state isEqualToString:@"bidding"]) {
                [self.immediatelyBuyBtn setTitle:@"下架" forState:UIControlStateNormal];
                self.immediatelyBuyBtn.enabled = YES;
                self.immediatelyBuyBtn.backgroundColor = JL_color_mainColor;
            } else {
                [self.immediatelyBuyBtn setTitle:@"出售" forState:UIControlStateNormal];
                self.immediatelyBuyBtn.enabled = YES;
                self.immediatelyBuyBtn.backgroundColor = JL_color_mainColor;
            }
        }
    } else {
        // 判断是否可以拆分
        if (self.artDetailData.collection_mode == 3) {
            // 可以拆分
            [self.immediatelyBuyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
            self.immediatelyBuyBtn.enabled = YES;
            self.immediatelyBuyBtn.backgroundColor = JL_color_mainColor;
        }
    }
}

- (void)likeButtonClick:(UIButton *)sender {
    WS(weakSelf)
    if (![JLLoginUtil haveSelectedAccount]) {
        [JLLoginUtil presentCreateWallet];
    } else {
        if (sender.selected) {
            // 取消赞
            Model_art_cancel_like_Req *request = [[Model_art_cancel_like_Req alloc] init];
            request.art_id = self.artDetailData.ID;
            Model_art_cancel_like_Rsp *response = [[Model_art_cancel_like_Rsp alloc] init];
            response.request = request;
            [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
                if (netIsWork) {
                    weakSelf.artDetailData = response.body;
                    [weakSelf.likeButton setTitle:[NSString stringWithFormat:@"%ld喜欢", weakSelf.artDetailData.liked_count] forState:UIControlStateNormal];
                    weakSelf.likeButton.selected = weakSelf.artDetailData.liked_by_me;
                    [weakSelf.dislikeButton setTitle:[NSString stringWithFormat:@"%ld踩", weakSelf.artDetailData.dislike_count] forState:UIControlStateNormal];
                    weakSelf.dislikeButton.selected = weakSelf.artDetailData.disliked_by_me;
                } else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
                }
            }];
        } else {
            // 赞
            Model_arts_like_Req *request = [[Model_arts_like_Req alloc] init];
            request.art_id = self.artDetailData.ID;
            Model_arts_like_Rsp *response = [[Model_arts_like_Rsp alloc] init];
            response.request = request;
            [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
                if (netIsWork) {
                    weakSelf.artDetailData = response.body;
                    [weakSelf.likeButton setTitle:[NSString stringWithFormat:@"%ld喜欢", weakSelf.artDetailData.liked_count] forState:UIControlStateNormal];
                    weakSelf.likeButton.selected = weakSelf.artDetailData.liked_by_me;
                    [weakSelf.dislikeButton setTitle:[NSString stringWithFormat:@"%ld踩", weakSelf.artDetailData.dislike_count] forState:UIControlStateNormal];
                    weakSelf.dislikeButton.selected = weakSelf.artDetailData.disliked_by_me;
                } else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
                }
            }];
        }
        
    }
}

- (void)dislikeButtonClick:(UIButton *)sender {
    WS(weakSelf)
    if (![JLLoginUtil haveSelectedAccount]) {
        [JLLoginUtil presentCreateWallet];
    } else {
        if (sender.selected) {
            // 取消踩
            Model_art_cancel_dislike_Req *request = [[Model_art_cancel_dislike_Req alloc] init];
            request.art_id = self.artDetailData.ID;
            Model_art_cancel_dislike_Rsp *response = [[Model_art_cancel_dislike_Rsp alloc] init];
            response.request = request;
            [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
                if (netIsWork) {
                    weakSelf.artDetailData = response.body;
                    [weakSelf.likeButton setTitle:[NSString stringWithFormat:@"%ld喜欢", weakSelf.artDetailData.liked_count] forState:UIControlStateNormal];
                    weakSelf.likeButton.selected = weakSelf.artDetailData.liked_by_me;
                    [weakSelf.dislikeButton setTitle:[NSString stringWithFormat:@"%ld踩", weakSelf.artDetailData.dislike_count] forState:UIControlStateNormal];
                    weakSelf.dislikeButton.selected = weakSelf.artDetailData.disliked_by_me;
                } else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
                }
            }];
        } else {
            // 踩
            Model_art_dislike_Req *request = [[Model_art_dislike_Req alloc] init];
            request.art_id = self.artDetailData.ID;
            Model_art_dislike_Rsp *response = [[Model_art_dislike_Rsp alloc] init];
            response.request = request;
            [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
                if (netIsWork) {
                    weakSelf.artDetailData = response.body;
                    [weakSelf.likeButton setTitle:[NSString stringWithFormat:@"%ld喜欢", weakSelf.artDetailData.liked_count] forState:UIControlStateNormal];
                    weakSelf.likeButton.selected = weakSelf.artDetailData.liked_by_me;
                    [weakSelf.dislikeButton setTitle:[NSString stringWithFormat:@"%ld踩", weakSelf.artDetailData.dislike_count] forState:UIControlStateNormal];
                    weakSelf.dislikeButton.selected = weakSelf.artDetailData.disliked_by_me;
                } else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
                }
            }];
        }
    }
}

- (void)collectButtonClick:(UIButton *)sender {
    WS(weakSelf)
    if (![JLLoginUtil haveSelectedAccount]) {
        [JLLoginUtil presentCreateWallet];
    } else {
        if (sender.selected) {
            // 取消收藏作品
            Model_art_unfavorite_Req *request = [[Model_art_unfavorite_Req alloc] init];
            request.art_id = self.artDetailData.ID;
            Model_art_unfavorite_Rsp *response = [[Model_art_unfavorite_Rsp alloc] init];
            response.request = request;
            [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
                if (netIsWork) {
                    weakSelf.artDetailData = response.body;
                    sender.selected = weakSelf.artDetailData.favorite_by_me;
                } else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
                }
            }];
        } else {
            // 收藏作品
            Model_art_favorite_Req *request = [[Model_art_favorite_Req alloc] init];
            request.art_id = self.artDetailData.ID;
            Model_art_favorite_Rsp *response = [[Model_art_favorite_Rsp alloc] init];
            response.request = request;
            [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
                if (netIsWork) {
                    weakSelf.artDetailData = response.body;
                    sender.selected = weakSelf.artDetailData.favorite_by_me;
                } else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
                }
            }];
        }
    }
}

- (void)immediatelyBuyBtnClick {
    WS(weakSelf)
    if (![JLLoginUtil haveSelectedAccount]) {
        [JLLoginUtil presentCreateWallet];
    } else {
        if (self.artDetailType == JLArtDetailTypeSelfOrOffShelf) {
            // 判断是否可以拆分
            if (self.artDetailData.collection_mode == 3) {
                // 可以拆分
                // 判断是否有可售作品
                if (self.artDetailData.has_amount - self.artDetailData.selling_amount.intValue > 0) {
                    // 有可出售的作品 跳转到出售
                    JLSellWithSplitViewController *sellWithSplitVC = [[JLSellWithSplitViewController alloc] init];
                    sellWithSplitVC.artDetailData = self.artDetailData;
                    sellWithSplitVC.sellBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
                        // 刷新艺术品详情
                        weakSelf.artDetailData = artDetailData;
                        // 跟新作品价格
                        weakSelf.artDetailNamePriceView.artDetailData = artDetailData;
                        // 判断是否有可售作品
                        if (weakSelf.artDetailData.has_amount - weakSelf.artDetailData.selling_amount.intValue > 0) {
                            // 有可出售的作品
                            [weakSelf.immediatelyBuyBtn setTitle:@"出售" forState:UIControlStateNormal];
                        } else {
                            weakSelf.immediatelyBuyBtn.enabled = NO;
                            weakSelf.immediatelyBuyBtn.backgroundColor = JL_color_gray_BEBEBE;
                        }
                        // 请求出售列表
                        [weakSelf requestSellingList];
                        
                        // 用户提示
                        [JLAlertTipView alertWithTitle:@"提示" message:@"检测到您已提交挂单申请。萌易现处于公测阶段，订单成交后，请联系客服，提交自己的手机号码、钱包地址、和订单号申请提现。公测结束后会上线自动提现功能，萌易感谢您的支持。" doneTitle:@"联系客服" cancelTitle:@"取消" done:^{
                            JLCustomerServiceViewController *customerServiceVC = [[JLCustomerServiceViewController alloc] init];
                            [weakSelf.navigationController pushViewController:customerServiceVC animated:YES];
                        } cancel:nil];
                    };
                    [weakSelf.navigationController pushViewController:sellWithSplitVC animated:YES];
                }
            } else {
                if ([weakSelf.artDetailData.aasm_state isEqualToString:@"bidding"]) {
                    // 跳转到 下架
                    if (weakSelf.currentSellingList.count > 0) {
                        [JLAlertTipView alertWithTitle:@"提示" message:@"确认下架？" doneTitle:@"确定" cancelTitle:@"取消" done:^{
                            Model_arts_id_orders_Data *orderData = [weakSelf.currentSellingList firstObject];
                            [[JLViewControllerTool appDelegate].walletTool authorizeWithAnimated:YES cancellable:YES with:^(BOOL success) {
                                if (success) {
                                    [weakSelf artOffFromSellingList:orderData.sn];
                                }
                            }];
                        } cancel:nil];
                    }
                } else {
                    // 出售
                    // 不可拆分
                    JLSellWithoutSplitViewController *sellWithoutSplitVC = [[JLSellWithoutSplitViewController alloc] init];
                    sellWithoutSplitVC.artDetailData = self.artDetailData;
                    sellWithoutSplitVC.sellBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
                        // 刷新艺术品详情
                        weakSelf.artDetailData = artDetailData;
                        // 更新作品价格
                        weakSelf.artDetailNamePriceView.artDetailData = artDetailData;
                        
                        if ([weakSelf.artDetailData.aasm_state isEqualToString:@"bidding"]) {
                            [weakSelf.immediatelyBuyBtn setTitle:@"下架" forState:UIControlStateNormal];
                        } else {
                            [weakSelf.immediatelyBuyBtn setTitle:@"出售" forState:UIControlStateNormal];
                        }
                        
                        // 用户提示
                        [JLAlertTipView alertWithTitle:@"提示" message:@"检测到您已提交挂单申请。萌易现处于公测阶段，订单成交后，请联系客服，提交自己的手机号码、钱包地址、和订单号申请提现。公测结束后会上线自动提现功能，萌易感谢您的支持。" doneTitle:@"联系客服" cancelTitle:@"取消" done:^{
                            JLCustomerServiceViewController *customerServiceVC = [[JLCustomerServiceViewController alloc] init];
                            [weakSelf.navigationController pushViewController:customerServiceVC animated:YES];
                        } cancel:nil];
                    };
                    [weakSelf.navigationController pushViewController:sellWithoutSplitVC animated:YES];
                }
            }
        } else {
            // 判断是否可以拆分 不可以拆分
            if (self.artDetailData.collection_mode != 3) {
                if (self.currentSellingList.count > 0) {
                    JLOrderSubmitViewController *orderSubmitVC = [[JLOrderSubmitViewController alloc] init];
                    orderSubmitVC.artDetailData = self.artDetailData;
                    orderSubmitVC.sellingOrderData = [self.currentSellingList firstObject];
                    __weak JLOrderSubmitViewController *weakOrderSubmitVC = orderSubmitVC;
                    orderSubmitVC.buySuccessBlock = ^(JLOrderPayType payType, NSString * _Nonnull payUrl) {
                        [weakOrderSubmitVC.navigationController popViewControllerAnimated:NO];
                        // 退出详情页面
                        if (weakSelf.buySuccessDeleteBlock) {
                            weakSelf.buySuccessDeleteBlock(payType, payUrl);
                        }
//                        [weakSelf.navigationController popViewControllerAnimated:NO];
                    };
                    [self.navigationController pushViewController:orderSubmitVC animated:YES];
                }
            } else {
                // 可以拆分作品，直接购买最低价作品
                if (self.currentSellingList.count > 0) {
                    Model_arts_id_orders_Data *minPriceSellingOrderData = [self.currentSellingList firstObject];
                    for (Model_arts_id_orders_Data *sellingOrderData in self.currentSellingList) {
                        if ([[NSDecimalNumber decimalNumberWithString:sellingOrderData.price] isLessThan:[NSDecimalNumber decimalNumberWithString:minPriceSellingOrderData.price]]) {
                            minPriceSellingOrderData = sellingOrderData;
                        }
                    }
                    JLOrderSubmitViewController *orderSubmitVC = [[JLOrderSubmitViewController alloc] init];
                    orderSubmitVC.artDetailData = weakSelf.artDetailData;
                    orderSubmitVC.sellingOrderData = minPriceSellingOrderData;
                    __weak JLOrderSubmitViewController *weakOrderSubmitVC = orderSubmitVC;
                    orderSubmitVC.buySuccessBlock = ^(JLOrderPayType payType, NSString * _Nonnull payUrl) {
                        [weakOrderSubmitVC.navigationController popViewControllerAnimated:NO];
//                        if (payType == JLOrderPayTypeWeChat) {
//                            // 打开支付页面
//                            JLWechatPayWebViewController *payWebVC = [[JLWechatPayWebViewController alloc] init];
//                            payWebVC.payUrl = payUrl;
//                            [weakSelf.navigationController pushViewController:payWebVC animated:YES];
//                        } else {
//                            JLAlipayWebViewController *payWebVC = [[JLAlipayWebViewController alloc] init];
//                            payWebVC.payUrl = payUrl;
//                            [weakSelf.navigationController pushViewController:payWebVC animated:YES];
//                        }
                        [JLAlertTipView alertWithTitle:@"提示" message:@"购买成功!" doneTitle:@"好的" done:nil];
                        [weakSelf requestSellingList];
                    };
                    [weakSelf.navigationController pushViewController:orderSubmitVC animated:YES];
                }
            }
        }
    }
}

- (void)artOffFromSellingList:(NSString *)order_sn {
    WS(weakSelf)
    Model_art_orders_cancel_Req *request = [[Model_art_orders_cancel_Req alloc] init];
    request.sn = order_sn;
    Model_art_orders_cancel_Rsp *response = [[Model_art_orders_cancel_Rsp alloc] init];
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            weakSelf.artDetailData = response.body;
            // 更新作品价格
            weakSelf.artDetailNamePriceView.artDetailData = response.body;
            [weakSelf refreshImmediatelyBuyBtnStatus];
            // 请求出售列表
            [weakSelf requestSellingList];
        }
    }];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = JL_color_gray_F6F6F6;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (NewPagedFlowView *)pageFlowView {
    if (!_pageFlowView) {
        _pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, 250.0f)];
        _pageFlowView.backgroundColor = JL_color_white_ffffff;
        _pageFlowView.autoTime = 5.0f;
        _pageFlowView.delegate = self;
        _pageFlowView.dataSource = self;
        _pageFlowView.minimumPageAlpha = 0.4f;
        _pageFlowView.isOpenAutoScroll = NO;
        [_pageFlowView reloadData];
    }
    return _pageFlowView;
}

- (UILabel *)pageLabel {
    if (!_pageLabel) {
        _pageLabel = [[UILabel alloc] init];
        _pageLabel.backgroundColor = [JL_color_black colorWithAlphaComponent:0.4f];
        _pageLabel.font = kFontPingFangSCRegular(12.0f);
        _pageLabel.textColor = JL_color_white_ffffff;
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        _pageLabel.text = [NSString stringWithFormat:@"1/%ld", (long)[self numberOfPagesInFlowView:self.pageFlowView]];
        ViewBorderRadius(_pageLabel, 8.5f, 0.0f, JL_color_clear);
    }
    return _pageLabel;
}

- (UIButton *)photoBrowserBtn {
    if (!_photoBrowserBtn) {
        _photoBrowserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoBrowserBtn setImage:[UIImage imageNamed:@"icon_home_artdetail_photo_browser"] forState:UIControlStateNormal];
        [_photoBrowserBtn addTarget:self action:@selector(photoBrowserBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_photoBrowserBtn edgeTouchAreaWithTop:20.0f right:20.0f bottom:20.0f left:20.0f];
    }
    return _photoBrowserBtn;
}

- (void)photoBrowserBtnClick {
    WS(weakSelf)
    if ([NSString stringIsEmpty:self.artDetailData.live2d_file]) {
        if (self.tempImageArray.count > 0) {
            //图片查看
            WMPhotoBrowser *browser = [WMPhotoBrowser new];
            //数据源
            browser.dataSource = [self.tempImageArray mutableCopy];
            browser.downLoadNeeded = YES;
            browser.currentPhotoIndex = self.pageFlowView.currentPageIndex;
            browser.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [[JLTool currentViewController] presentViewController:browser animated:YES completion:nil];
        }
    } else {
        NSString *live2d_file = self.artDetailData.live2d_file;
        NSString *live2d_ipfs_url = self.artDetailData.live2d_ipfs_zip_url;
        NSString *cacheFolder = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"Live2DFiles"];
        NSString *path = [cacheFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/%@.model3.json", self.artDetailData.ID, live2d_file, live2d_file]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            // 查找是否有背景图片
            NSString *jsonDirPath = [cacheFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/", self.artDetailData.ID, live2d_file]];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSArray *contents = [fileManager contentsOfDirectoryAtPath:jsonDirPath error:nil];
            NSEnumerator *e = [contents objectEnumerator];
            NSString *fileName;
            NSString *backImageName = @"";
            while (fileName = [e nextObject]) {
                if ([fileName containsString:@"BG"] && ![fileName containsString:@"MACOS"]) {
                    backImageName = fileName;
                }
            }
            // 查看Live2D
            [self showLive2D:backImageName];
        } else {
            [[JLLoading sharedLoading] showProgressWithView:self.view message:@"正在下载Live2D文件" progress:0.0f];
            self.live2DDownloadTask = [[JLLive2DCacheManager shareManager] downLive2DWithPath:live2d_ipfs_url fileID:self.artDetailData.ID fileKey:[NSString stringWithFormat:@"%@.zip", live2d_file] progressBlock:^(CGFloat progress) {
                [[JLLoading sharedLoading] showProgressWithView:weakSelf.view message:@"正在下载Live2D文件" progress:progress];
            } success:^(NSURL *URL, NSString *backImageName) {
                [[JLLoading sharedLoading] hideLoading];
                [weakSelf showLive2D: backImageName];
            } fail:^(NSString *message) {
                [[JLLoading sharedLoading] hideLoading];
                [[JLLoading sharedLoading] showMBFailedTipMessage:message hideTime:KToastDismissDelayTimeInterval];
            }];
        }
    }
}

- (void)showLive2D:(NSString *)backImageName {
    NSString *live2d_file = self.artDetailData.live2d_file;
    NSString *live2d_ipfs_url = self.artDetailData.live2d_ipfs_zip_url;
    NSString *cacheFolder = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"Live2DFiles"];
    NSString *path = [cacheFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/%@.model3.json", self.artDetailData.ID, live2d_file, live2d_file]];
    AppDelegate* delegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    [self presentViewController:delegate.lAppViewController animated:YES completion:nil];
    NSString *modelPath = [cacheFolder stringByAppendingString:[NSString stringWithFormat:@"/%@/%@/", self.artDetailData.ID, live2d_file]];
    NSString *modelJsonName = [NSString stringWithFormat:@"%@.model3.json", live2d_file];
    NSString *backImagePath = @"";
    if (![NSString stringIsEmpty:backImageName]) {
        backImagePath = [modelPath stringByAppendingPathComponent:backImageName];
    }
    [delegate initializeCubismWithBack:backImagePath];
    [delegate changeSence:modelPath jsonName:modelJsonName];
}

#pragma mark NewPagedFlowView Datasource
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView{
    return CGSizeMake(kScreenWidth, 250.0f);
}

- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return self.tempImageArray.count;
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] init];
    }
    ///在这里下载网络图片
    NSString *bannerModel = nil;
    if (index < self.tempImageArray.count) {
        bannerModel = self.tempImageArray[index];
    }
    if (![NSString stringIsEmpty:bannerModel]) {
        [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:bannerModel] placeholderImage:nil];
        bannerView.mainImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", pageNumber + 1, (long)[self numberOfPagesInFlowView:self.pageFlowView]];
}

- (JLArtDetailVideoView *)videoView {
    if (!_videoView) {
        _videoView = [[JLArtDetailVideoView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, 250.0f)];
        
//        NSString *urlStr = self.artDetailData.video_url;
        NSString *urlStr = self.artDetailData.img_main_file2[@"url"];
        WS(weakSelf)
        _videoView.playOrStopBlock = ^(NSInteger status) {
            
            if ([NSString stringIsEmpty:urlStr]) {
                [[JLLoading sharedLoading] showMBFailedTipMessage:@"播放失败，资源无效!" hideTime:1.5];
                return;
            }
            if (weakSelf.networkStatus == AFNetworkReachabilityStatusUnknown ||
                weakSelf.networkStatus == AFNetworkReachabilityStatusNotReachable) {
                [JLAlert jlalertDefaultView:@"当前无网络或网络不可用，请稍后再试!" cancel:@"好的"];
                return;
            }else if (weakSelf.networkStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
                [JLAlert jlalertView:@"提示" message:@"当前网络不是Wifi，继续播放将消耗数据流量，是否继续播放？" cancel:@"取消" cancelBlock:^{
                    
                } confirm:@"播放" confirmBlock:^{
                    AVPlayerViewController *aVPlayerViewController = [[AVPlayerViewController alloc] init];
                    aVPlayerViewController.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:urlStr]];
                    [weakSelf presentViewController:aVPlayerViewController animated:YES completion:^{
                        [aVPlayerViewController.player play];
                    }];
                }];
            }else {
                AVPlayerViewController *aVPlayerViewController = [[AVPlayerViewController alloc] init];
                aVPlayerViewController.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:urlStr]];
                [weakSelf presentViewController:aVPlayerViewController animated:YES completion:^{
                    [aVPlayerViewController.player play];
                }];
            }
        };
        _videoView.artDetailData = self.artDetailData;
    }
    return _videoView;
}

- (JLArtDetailNamePriceView *)artDetailNamePriceView {
    if (!_artDetailNamePriceView) {
        _artDetailNamePriceView = [[JLArtDetailNamePriceView alloc] initWithFrame:CGRectMake(0.0f, self.pageFlowView.frameBottom, kScreenWidth, 94.0f)];
        _artDetailNamePriceView.artDetailData = self.artDetailData;
    }
    return _artDetailNamePriceView;
}

- (JLArtDetailSellingView *)artSellingView {
    if (!_artSellingView) {
        WS(weakSelf)
        _artSellingView = [[JLArtDetailSellingView alloc] initWithFrame:CGRectMake(0.0f, self.artDetailNamePriceView.frameBottom, kScreenWidth, 55.0f + 35.0f)];
        _artSellingView.lookUserInfoBlock = ^(Model_arts_id_orders_Data * _Nonnull sellOrderData) {
            // 判断是否是自己
            if (sellOrderData.is_mine) {
                JLHomePageViewController *homePageVC = [[JLHomePageViewController alloc] init];
                [weakSelf.navigationController pushViewController:homePageVC animated:YES];
            } else {
                JLCreatorPageViewController *creatorPageVC = [[JLCreatorPageViewController alloc] init];
                creatorPageVC.authorId = sellOrderData.seller_id;
                creatorPageVC.followOrCancelBlock = ^(Model_art_author_Data * _Nonnull authorData) {
                    weakSelf.artDetailData.author = authorData;
                };
                [weakSelf.navigationController pushViewController:creatorPageVC animated:YES];
            }
        };
        _artSellingView.offFromListBlock = ^(Model_arts_id_orders_Data * _Nonnull sellOrderData) {
            [[JLViewControllerTool appDelegate].walletTool authorizeWithAnimated:YES cancellable:YES with:^(BOOL success) {
                if (success) {
                    [weakSelf artOffFromSellingList:sellOrderData.sn];
                }
            }];
        };
        _artSellingView.buyBlock = ^(Model_arts_id_orders_Data * _Nonnull sellOrderData) {
            JLOrderSubmitViewController *orderSubmitVC = [[JLOrderSubmitViewController alloc] init];
            orderSubmitVC.artDetailData = weakSelf.artDetailData;
            orderSubmitVC.sellingOrderData = sellOrderData;
            __weak JLOrderSubmitViewController *weakOrderSubmitVC = orderSubmitVC;
            orderSubmitVC.buySuccessBlock = ^(JLOrderPayType payType, NSString * _Nonnull payUrl) {
                [weakOrderSubmitVC.navigationController popViewControllerAnimated:NO];
//                if (payType == JLOrderPayTypeWeChat) {
//                    // 打开支付页面
//                    JLWechatPayWebViewController *payWebVC = [[JLWechatPayWebViewController alloc] init];
//                    payWebVC.payUrl = payUrl;
//                    [weakSelf.navigationController pushViewController:payWebVC animated:YES];
//                } else {
//                    JLAlipayWebViewController *payWebVC = [[JLAlipayWebViewController alloc] init];
//                    payWebVC.payUrl = payUrl;
//                    [weakSelf.navigationController pushViewController:payWebVC animated:YES];
//                }
                [JLAlertTipView alertWithTitle:@"提示" message:@"购买成功!" doneTitle:@"好的" done:nil];
                [weakSelf requestSellingList];
            };
            [weakSelf.navigationController pushViewController:orderSubmitVC animated:YES];
        };
        _artSellingView.openCloseListBlock = ^(BOOL isOpen) {
            CGFloat height = 55.0f + 35.0f;
            if (isOpen) {
                height = 55.0f + 35.0f + 38.0f * (weakSelf.currentSellingList.count) + 48.0f;
            } else {
                height = 55.0f + 35.0f + 38.0f * (weakSelf.currentSellingList.count > 4 ? 4 : weakSelf.currentSellingList.count) + (weakSelf.currentSellingList.count > 4 ? 48.0f : 0.0f);
            }
            [weakSelf.artSellingViewHeightConstraint uninstall];
            [weakSelf.artSellingView mas_updateConstraints:^(MASConstraintMaker *make) {
                weakSelf.artSellingViewHeightConstraint = make.height.mas_equalTo(@(height));
            }];
        };
    }
    return _artSellingView;
}

- (JLArtChainTradeView *)artChainTradeView {
    if (!_artChainTradeView) {
        _artChainTradeView = [[JLArtChainTradeView alloc] initWithFrame:CGRectMake(0.0f, self.artDetailData.collection_mode == 3 ? self.artDetailNamePriceView.frameBottom + 12.0f : self.artDetailNamePriceView.frameBottom, kScreenWidth, 188.0f)];
        _artChainTradeView.marketLevel = self.marketLevel;
        _artChainTradeView.artDetailData = self.artDetailData;
        WS(weakSelf)
        _artChainTradeView.showCertificateBlock = ^{
            [JLArtDetailShowCertificateView showWithArtDetailData:weakSelf.artDetailData];
        };
    }
    return _artChainTradeView;
}

- (JLArtAuthorDetailView *)artAuthorDetailView {
    if (!_artAuthorDetailView) {
        WS(weakSelf)
        _artAuthorDetailView = [[JLArtAuthorDetailView alloc] initWithFrame:CGRectMake(0.0f, self.artChainTradeView.frameBottom, kScreenWidth, 204.0f)];
        _artAuthorDetailView.artDetailData = self.artDetailData;
        _artAuthorDetailView.introduceBlock = ^{
            // 判断是否是自己
            if ([weakSelf.artDetailData.author.ID isEqualToString: [AppSingleton sharedAppSingleton].userBody.ID]) {
                JLHomePageViewController *homePageVC = [[JLHomePageViewController alloc] init];
                [weakSelf.navigationController pushViewController:homePageVC animated:YES];
            } else {
                JLCreatorPageViewController *creatorPageVC = [[JLCreatorPageViewController alloc] init];
                creatorPageVC.authorData = weakSelf.artDetailData.author;
                creatorPageVC.followOrCancelBlock = ^(Model_art_author_Data * _Nonnull authorData) {
                    weakSelf.artDetailData.author = authorData;
                };
                [weakSelf.navigationController pushViewController:creatorPageVC animated:YES];
            }
        };
    }
    return _artAuthorDetailView;
}

//- (JLArtInfoView *)artInfoView {
//    if (!_artInfoView) {
//        _artInfoView = [[JLArtInfoView alloc] initWithFrame:CGRectMake(0.0f, self.artAuthorDetailView.frameBottom, kScreenWidth, 250.0f)];
//        _artInfoView.artDetailData = self.artDetailData;
//    }
//    return _artInfoView;
//}

- (JLArtEvaluateView *)artEvaluateView {
    if (!_artEvaluateView) {
        NSMutableArray *arr = [NSMutableArray array];
        if (![NSString stringIsEmpty:self.artDetailData.img_detail_file1[@"url"]]) {
            [arr addObject:self.artDetailData.img_detail_file1[@"url"]];
        }
        if (![NSString stringIsEmpty:self.artDetailData.img_detail_file2[@"url"]]) {
            [arr addObject:self.artDetailData.img_detail_file2[@"url"]];
        }
        if (![NSString stringIsEmpty:self.artDetailData.img_detail_file3[@"url"]]) {
            [arr addObject:self.artDetailData.img_detail_file3[@"url"]];
        }
        self.artDetailData.detail_imgs = [arr copy];
        _artEvaluateView = [[JLArtEvaluateView alloc] initWithFrame:CGRectMake(0.0f, self.artAuthorDetailView.frameBottom, kScreenWidth, 0.0f) artDetailData:self.artDetailData];
        _artEvaluateView.lookImageBlock = ^(NSInteger index, NSArray * _Nonnull imageArray) {
            //图片查看
            WMPhotoBrowser *browser = [WMPhotoBrowser new];
            //数据源
            browser.dataSource = [imageArray mutableCopy];
            browser.downLoadNeeded = YES;
            browser.currentPhotoIndex = index;
            browser.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [[JLTool currentViewController] presentViewController:browser animated:YES completion:nil];
        };
    }
    return _artEvaluateView;
}

//- (JLArtDetailDescriptionView *)artDetailDescView {
//    if (!_artDetailDescView) {
//        _artDetailDescView = [[JLArtDetailDescriptionView alloc] initWithFrame:CGRectMake(0.0f, [self.artEvaluateView getFrameBottom], kScreenWidth, 0.0f) artDetailData:self.artDetailData];
//    }
//    return _artDetailDescView;
//}

- (NSArray *)tempImageArray {
    if (!_tempImageArray) {
        NSMutableArray *tempArray = [NSMutableArray array];
        NSString *fileImage1 = self.artDetailData.img_main_file1[@"url"];
        NSString *fileImage2 = self.artDetailData.img_main_file2[@"url"];
        NSString *fileImage3 = self.artDetailData.img_main_file3[@"url"];
        if (![NSString stringIsEmpty:fileImage1]) {
            [tempArray addObject:fileImage1];
        }
        if (![NSString stringIsEmpty:fileImage2]) {
            [tempArray addObject:fileImage2];
        }
        if (![NSString stringIsEmpty:fileImage3]) {
            [tempArray addObject:fileImage3];
        }
        _tempImageArray = [tempArray copy];
    }
    return _tempImageArray;
}

// 请求出售列表
- (void)requestSellingList {
    WS(weakSelf)
    Model_arts_id_orders_Req *request = [[Model_arts_id_orders_Req alloc] init];
    request.ID = self.artDetailData ? self.artDetailData.ID : self.artDetailId;
    request.page = 1;
    request.per_page = 9999;
    if (self.marketLevel == 1) {
        request.market_level = @"primary";
    }else if (self.marketLevel == 2) {
        request.market_level = @"secondary";
    }
    Model_arts_id_orders_Rsp *response = [[Model_arts_id_orders_Rsp alloc] init];
    response.request = request;
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            weakSelf.currentSellingList = response.body;
            
            if (self.marketLevel == 0 || self.marketLevel == 2) {
                if (response.body.count == 4) {
                    weakSelf.artSellingViewOpen = NO;
                }
                
                weakSelf.artSellingView.sellingArray = weakSelf.currentSellingList;
                CGFloat height = 55.0f + 35.0f;
                if (weakSelf.artSellingViewOpen) {
                    height = 55.0f + 35.0f + 38.0f * (weakSelf.currentSellingList.count) + 48.0f;
                } else {
                    height = 55.0f + 35.0f + 38.0f * (weakSelf.currentSellingList.count > 4 ? 4 : weakSelf.currentSellingList.count) + (weakSelf.currentSellingList.count > 4 ? 48.0f : 0.0f);
                }
                [weakSelf.artSellingViewHeightConstraint uninstall];
                [weakSelf.artSellingView mas_updateConstraints:^(MASConstraintMaker *make) {
                    weakSelf.artSellingViewHeightConstraint = make.height.mas_equalTo(@(height));
                }];
            }
        }
        if (!weakSelf.artDetailData) {
            [weakSelf updateArtDetailData];
        }else {
            [[JLLoading sharedLoading] hideLoading];
        }
    }];
}

// 更新艺术品信息
- (void)updateArtDetailData {
    WS(weakSelf)
    Model_arts_detail_Req *reqeust = [[Model_arts_detail_Req alloc] init];
    reqeust.art_id = self.artDetailData ? self.artDetailData.ID : self.artDetailId;
    Model_arts_detail_Rsp *response = [[Model_arts_detail_Rsp alloc] init];
    response.request = reqeust;
    
    if (!self.artDetailData) {
        [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    }
    [JLNetHelper netRequestGetParameters:reqeust respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            if (!weakSelf.artDetailData) {
                weakSelf.artDetailData = response.body;
                
                if (weakSelf.isUpdateDatas) {
                    weakSelf.artAuthorDetailView.artDetailData = weakSelf.artDetailData;
                }else {
                    weakSelf.artDetailType = weakSelf.artDetailData.is_owner ? JLArtDetailTypeSelfOrOffShelf : JLArtDetailTypeDetail;
                    [weakSelf createSubView];
                    
                    [weakSelf requestSellingList];
                }
            }else {
                weakSelf.artDetailData = response.body;
                if (weakSelf.isUpdateDatas) {
                    weakSelf.artAuthorDetailView.artDetailData = weakSelf.artDetailData;
                }
            }
        }
    }];
}
@end
