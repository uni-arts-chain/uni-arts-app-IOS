//
//  JLArtDetailViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/1.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLArtDetailViewController.h"
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

#import "NSDate+Extension.h"
#import "JLLive2DCacheManager.h"
#import "UIButton+TouchArea.h"

@interface JLArtDetailViewController ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>
@property (nonatomic, strong) UITabBar *bottomBar;
@property (nonatomic, strong) UIView *certificateView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NewPagedFlowView *pageFlowView;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UIButton *photoBrowserBtn;
@property (nonatomic, strong) JLArtDetailNamePriceView *artDetailNamePriceView;
@property (nonatomic, strong) JLArtChainTradeView *artChainTradeView;
@property (nonatomic, strong) JLArtDetailSellingView *artSellingView;
@property (nonatomic, assign) BOOL artSellingViewOpen;
@property (nonatomic, strong) JLArtAuthorDetailView *artAuthorDetailView;
//@property (nonatomic, strong) JLArtInfoView *artInfoView;
@property (nonatomic, strong) JLArtEvaluateView *artEvaluateView;
//@property (nonatomic, strong) JLArtDetailDescriptionView *artDetailDescView;

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
@end

@implementation JLArtDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    [self addBackItem];
    [self createSubView];
    [self requestSellingList];
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.artEvaluateView.frameBottom);
}

- (void)createSubView {
    [self initBottomUI];
    [self.view addSubview:self.certificateView];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomBar.mas_top);
        make.left.top.right.equalTo(self.view);
    }];
    // 主图
    [self.scrollView addSubview:self.pageFlowView];
    // 页码
    [self.pageFlowView addSubview:self.pageLabel];
    // 查看主图
    [self.scrollView addSubview:self.photoBrowserBtn];
    
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
    // 作品详情
    [self.scrollView addSubview:self.artDetailNamePriceView];
    if (self.artDetailData.collection_mode == 3) {
        // 出售列表
        [self.scrollView addSubview:self.artSellingView];
    }
    // 区块链交易信息
    [self.scrollView addSubview:self.artChainTradeView];
    // 创作者简介
    [self.scrollView addSubview:self.artAuthorDetailView];
    // 作品信息
//    [self.scrollView addSubview:self.artInfoView];
    // 艺术评析
    [self.scrollView addSubview:self.artEvaluateView];
    // 艺术品细节
//    [self.scrollView addSubview:self.artDetailDescView];
}

- (void)initBottomUI {
    self.bottomBar = [UITabBar tabbarWithDefaultShadowImageColor];
    [self.bottomBar addShadow:[UIColor colorWithHexString:@"#404040"] cornerRadius:5.0f offsetX:0];
    [self.view addSubview:self.bottomBar];
    
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(54.0f);
        make.bottom.equalTo(self.view).offset(-KTouch_Responder_Height);
    }];
    
    // 喜欢
    UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeButton setTitle:[NSString stringWithFormat:@"%ld喜欢", self.artDetailData.liked_count] forState:UIControlStateNormal];
    [likeButton setTitleColor:JL_color_gray_101010 forState:UIControlStateNormal];
    likeButton.titleLabel.font = kFontPingFangSCRegular(10.0f);
    likeButton.backgroundColor = JL_color_white_ffffff;
    [likeButton setImage:[UIImage imageNamed:@"icon_product_like"] forState:UIControlStateNormal];
    [likeButton setImage:[UIImage imageNamed:@"icon_product_like_selected"] forState:UIControlStateSelected];
    [likeButton addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    likeButton.axcUI_buttonContentLayoutType = AxcButtonContentLayoutStyleCenterImageTop;
    likeButton.axcUI_padding = 10.0f;
    likeButton.selected = self.artDetailData.liked_by_me;
    [self.bottomBar addSubview:likeButton];
    self.likeButton = likeButton;
    
    // 踩
    UIButton *dislikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dislikeButton setTitle:[NSString stringWithFormat:@"%ld踩", self.artDetailData.dislike_count] forState:UIControlStateNormal];
    [dislikeButton setTitleColor:JL_color_gray_101010 forState:UIControlStateNormal];
    dislikeButton.titleLabel.font = kFontPingFangSCRegular(10.0f);
    dislikeButton.backgroundColor = JL_color_white_ffffff;
    [dislikeButton setImage:[UIImage imageNamed:@"icon_product_dislike"] forState:UIControlStateNormal];
    [dislikeButton setImage:[UIImage imageNamed:@"icon_product_dislike_selected"] forState:UIControlStateSelected];
    [dislikeButton addTarget:self action:@selector(dislikeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    dislikeButton.axcUI_buttonContentLayoutType = AxcButtonContentLayoutStyleCenterImageTop;
    dislikeButton.axcUI_padding = 10.0f;
    dislikeButton.selected = self.artDetailData.disliked_by_me;
    [self.bottomBar addSubview:dislikeButton];
    self.dislikeButton = dislikeButton;
    
    // 收藏
    UIButton *collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    [collectButton setTitleColor:JL_color_gray_101010 forState:UIControlStateNormal];
    collectButton.titleLabel.font = kFontPingFangSCRegular(10.0f);
    collectButton.backgroundColor = JL_color_white_ffffff;
    [collectButton setImage:[UIImage imageNamed:@"icon_product_collect"] forState:UIControlStateNormal];
    [collectButton setImage:[UIImage imageNamed:@"icon_product_collect_selected"] forState:UIControlStateSelected];
    [collectButton addTarget:self action:@selector(collectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    collectButton.axcUI_buttonContentLayoutType = AxcButtonContentLayoutStyleCenterImageTop;
    collectButton.axcUI_padding = 10.0f;
    collectButton.selected = self.artDetailData.favorite_by_me;
    [self.bottomBar addSubview:collectButton];
    
    // 立即购买
    UIButton *immediatelyBuyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [immediatelyBuyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [immediatelyBuyBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
    immediatelyBuyBtn.titleLabel.font = kFontPingFangSCRegular(15.0f);
    immediatelyBuyBtn.backgroundColor = JL_color_red_D70000;
    ViewBorderRadius(immediatelyBuyBtn, 17.0f, 0.0f, JL_color_clear);
    [immediatelyBuyBtn addTarget:self action:@selector(immediatelyBuyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBar addSubview:immediatelyBuyBtn];
    self.immediatelyBuyBtn = immediatelyBuyBtn;
    [self refreshImmediatelyBuyBtnStatus];
    
    [immediatelyBuyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10.0f);
        make.bottom.mas_equalTo(-10.0f);
        make.right.mas_equalTo(-15.0f);
        make.width.mas_equalTo(137.0f);
    }];
    [likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.0f);
        make.top.bottom.equalTo(self.bottomBar);
        make.width.mas_equalTo(60.0f);
    }];
    [dislikeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(likeButton.mas_right);
        make.top.bottom.equalTo(self.bottomBar);
        make.width.mas_equalTo(60.0f);
    }];
    [collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dislikeButton.mas_right);
        make.top.bottom.equalTo(self.bottomBar);
        make.width.mas_equalTo(60.0f);
    }];
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
                self.immediatelyBuyBtn.backgroundColor = JL_color_red_D70000;
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
                self.immediatelyBuyBtn.backgroundColor = JL_color_red_D70000;
            } else {
                [self.immediatelyBuyBtn setTitle:@"出售" forState:UIControlStateNormal];
                self.immediatelyBuyBtn.enabled = YES;
                self.immediatelyBuyBtn.backgroundColor = JL_color_red_D70000;
            }
        }
    } else {
        // 判断是否可以拆分
        if (self.artDetailData.collection_mode == 3) {
            // 可以拆分
            [self.immediatelyBuyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
            self.immediatelyBuyBtn.enabled = YES;
            self.immediatelyBuyBtn.backgroundColor = JL_color_red_D70000;
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
                        // 判断是否有可售作品
                        if (self.artDetailData.has_amount - self.artDetailData.selling_amount.intValue > 0) {
                            // 有可出售的作品
                            [weakSelf.immediatelyBuyBtn setTitle:@"出售" forState:UIControlStateNormal];
                        } else {
                            weakSelf.immediatelyBuyBtn.enabled = NO;
                            weakSelf.immediatelyBuyBtn.backgroundColor = JL_color_gray_BEBEBE;
                        }
                        // 请求出售列表
                        [weakSelf requestSellingList];
                        
                        // 用户提示
                        UIAlertController *alertVC = [UIAlertController alertShowWithTitle:@"提示" message:@"检测到您已提交挂单申请。饭团密画现处于公测阶段，订单成交后，请联系客服，提交自己的手机号码、钱包地址、和订单号申请提现。公测结束后会上线自动提现功能，饭团密画感谢您的支持。" cancel:@"取消" cancelHandler:^{
                            
                        } confirm:@"联系客服" confirmHandler:^{
                            JLCustomerServiceViewController *customerServiceVC = [[JLCustomerServiceViewController alloc] init];
                            [weakSelf.navigationController pushViewController:customerServiceVC animated:YES];
                        }];
                        [weakSelf presentViewController:alertVC animated:YES completion:nil];
                    };
                    [weakSelf.navigationController pushViewController:sellWithSplitVC animated:YES];
                }
            } else {
                if ([weakSelf.artDetailData.aasm_state isEqualToString:@"bidding"]) {
                    // 跳转到 下架
                    if (weakSelf.currentSellingList.count > 0) {
                        Model_arts_id_orders_Data *orderData = [weakSelf.currentSellingList firstObject];
                        [[JLViewControllerTool appDelegate].walletTool authorizeWithAnimated:YES cancellable:YES with:^(BOOL success) {
                            if (success) {
                                [weakSelf artOffFromSellingList:orderData.sn];
                            }
                        }];
                    }
                } else {
                    // 出售
                    // 不可拆分
                    JLSellWithoutSplitViewController *sellWithoutSplitVC = [[JLSellWithoutSplitViewController alloc] init];
                    sellWithoutSplitVC.artDetailData = self.artDetailData;
                    sellWithoutSplitVC.sellBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
                        // 刷新艺术品详情
                        weakSelf.artDetailData = artDetailData;
                        if ([weakSelf.artDetailData.aasm_state isEqualToString:@"bidding"]) {
                            [weakSelf.immediatelyBuyBtn setTitle:@"下架" forState:UIControlStateNormal];
                        } else {
                            [weakSelf.immediatelyBuyBtn setTitle:@"出售" forState:UIControlStateNormal];
                        }
                        
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
            }
        } else {
            // 判断是否可以拆分 不可以拆分
            if (self.artDetailData.collection_mode != 3) {
                if (self.currentSellingList.count > 0) {
                    JLOrderSubmitViewController *orderSubmitVC = [[JLOrderSubmitViewController alloc] init];
                    orderSubmitVC.artDetailData = self.artDetailData;
                    orderSubmitVC.sellingOrderData = [self.currentSellingList firstObject];
                    __block JLOrderSubmitViewController *weakOrderSubmitVC = orderSubmitVC;
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
                    __block JLOrderSubmitViewController *weakOrderSubmitVC = orderSubmitVC;
                    orderSubmitVC.buySuccessBlock = ^(JLOrderPayType payType, NSString * _Nonnull payUrl) {
                        [weakOrderSubmitVC.navigationController popViewControllerAnimated:NO];
                        if (payType == JLOrderPayTypeWeChat) {
                            // 打开支付页面
                            JLWechatPayWebViewController *payWebVC = [[JLWechatPayWebViewController alloc] init];
                            payWebVC.payUrl = payUrl;
                            [weakSelf.navigationController pushViewController:payWebVC animated:YES];
                        } else {
                            JLAlipayWebViewController *payWebVC = [[JLAlipayWebViewController alloc] init];
                            payWebVC.payUrl = payUrl;
                            [weakSelf.navigationController pushViewController:payWebVC animated:YES];
                        }
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
            [weakSelf refreshImmediatelyBuyBtnStatus];
            // 请求出售列表
            [weakSelf requestSellingList];
        }
    }];
}

- (UIView *)certificateView {
    if (!_certificateView) {
        _certificateView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenWidth / 375.0f * 296.0f)];
        
        UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cer-bg"]];
        [_certificateView addSubview:backImageView];
        
        UIView *centerView = [[UIView alloc] init];
        centerView.backgroundColor = JL_color_white_ffffff;
        [_certificateView addSubview:centerView];
        
        UILabel *nameLabel = [JLUIFactory labelInitText:[NSString stringWithFormat:@"Name: %@", self.artDetailData.name] font:kFontPingFangSCRegular(10.0f) textColor:JL_color_black_010034 textAlignment:NSTextAlignmentLeft];
        [centerView addSubview:nameLabel];
        
        UILabel *painterLabel = [JLUIFactory labelInitText:[NSString stringWithFormat:@"Painter: %@", [NSString stringIsEmpty:self.artDetailData.author.display_name] ? @"" : self.artDetailData.author.display_name] font:kFontPingFangSCRegular(10.0f) textColor:JL_color_black_010034 textAlignment:NSTextAlignmentLeft];
        [centerView addSubview:painterLabel];
        
//        UILabel *textureLabel = [JLUIFactory labelInitText:[NSString stringWithFormat:@"Texture: %@", [[AppSingleton sharedAppSingleton] getMaterialByID:@(self.artDetailData.material_id).stringValue]] font:kFontPingFangSCRegular(10.0f) textColor:JL_color_black_010034 textAlignment:NSTextAlignmentLeft];
//        [centerView addSubview:textureLabel];
        
        NSString *sizeDesc = [NSString stringWithFormat:@"Size: %@cmx%@cm", self.artDetailData.size_width, self.artDetailData.size_length];
        UILabel *sizeLabel = [JLUIFactory labelInitText:sizeDesc font:kFontPingFangSCRegular(10.0f) textColor:JL_color_black_010034 textAlignment:NSTextAlignmentLeft];
        [centerView addSubview:sizeLabel];
        
        NSString *signTimeStr = @"";
        if (![NSString stringIsEmpty:self.artDetailData.last_sign_at]) {
            NSDate *signDate = [NSDate dateWithTimeIntervalSince1970:self.artDetailData.last_sign_at.doubleValue];
            signTimeStr = [signDate dateWithCustomFormat:@"yyyy-MM-dd"];
        }
        
        UILabel *signTimeLabel = [JLUIFactory labelInitText:[NSString stringWithFormat:@"Signing time: %@", signTimeStr] font:kFontPingFangSCRegular(10.0f) textColor:JL_color_black_010034 textAlignment:NSTextAlignmentCenter];
        [centerView addSubview:signTimeLabel];
        
        UIImageView *signTimeLeftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cert_left"]];
        [centerView addSubview:signTimeLeftImageView];
        
        UIImageView *signTimeRightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cert_right"]];
        [centerView addSubview:signTimeRightImageView];
        
        UILabel *certificateAddressTitleLabel = [JLUIFactory labelInitText:@"证书地址: " font:kFontPingFangSCRegular(10.0f) textColor:JL_color_black_010034 textAlignment:NSTextAlignmentLeft];
        [centerView addSubview:certificateAddressTitleLabel];
        
        UILabel *certificateAddressLabel = [JLUIFactory labelInitText:self.artDetailData.item_hash font:kFontPingFangSCRegular(10.0f) textColor:JL_color_black_010034 textAlignment:NSTextAlignmentLeft];
        certificateAddressLabel.numberOfLines = 1;
        certificateAddressLabel.adjustsFontSizeToFitWidth = YES;
        [centerView addSubview:certificateAddressLabel];
        
        [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_certificateView);
        }];
        [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(110.0f);
            make.bottom.mas_equalTo(-70.0f);
            make.left.mas_equalTo(65.0f);
            make.right.mas_equalTo(-45.0f);
        }];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(centerView);
            make.height.mas_offset(26.0f);
        }];
        [painterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel.mas_right);
            make.top.equalTo(centerView);
            make.right.equalTo(centerView);
            make.height.equalTo(nameLabel.mas_height);
            make.width.equalTo(nameLabel.mas_width);
        }];
//        [textureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(nameLabel.mas_bottom);
//            make.left.equalTo(centerView);
//            make.height.equalTo(nameLabel.mas_height);
//        }];
        [sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(textureLabel.mas_right);
//            make.top.equalTo(painterLabel.mas_bottom);
//            make.right.equalTo(centerView);
//            make.height.equalTo(textureLabel.mas_height);
//            make.width.equalTo(textureLabel.mas_width);
            make.left.equalTo(centerView);
            make.top.equalTo(painterLabel.mas_bottom);
            make.right.equalTo(centerView);
            make.height.equalTo(nameLabel.mas_height);
        }];
        [signTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sizeLabel.mas_bottom);
            make.height.mas_equalTo(26.0f);
            make.centerX.equalTo(centerView.mas_centerX);
        }];
        [signTimeLeftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(signTimeLabel.mas_left).offset(-8.0f);
            make.width.mas_equalTo(42.0f);
            make.height.mas_equalTo(1.0f);
            make.centerY.equalTo(signTimeLabel.mas_centerY);
        }];
        [signTimeRightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(signTimeLabel.mas_right).offset(8.0f);
            make.width.mas_equalTo(42.0f);
            make.height.mas_equalTo(1.0f);
            make.centerY.equalTo(signTimeLabel.mas_centerY);
        }];
        [certificateAddressTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(centerView).offset(-20.0f);
            make.top.equalTo(signTimeLabel.mas_bottom);
        }];
        [certificateAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(certificateAddressTitleLabel.mas_right);
            make.top.equalTo(signTimeLabel.mas_bottom);
            make.right.mas_lessThanOrEqualTo(20.0f);
        }];
    }
    return _certificateView;
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
            // 查看Live2D
            [self showLive2D];
        } else {
            [[JLLoading sharedLoading] showProgressWithView:nil message:@"正在下载Live2D文件" progress:0.0f];
            self.live2DDownloadTask = [[JLLive2DCacheManager shareManager] downLive2DWithPath:live2d_ipfs_url fileID:self.artDetailData.ID fileKey:[NSString stringWithFormat:@"%@.zip", live2d_file] progressBlock:^(CGFloat progress) {
                [[JLLoading sharedLoading] showProgressWithView:nil message:@"正在下载Live2D文件" progress:progress];
            } success:^(NSURL *URL) {
                [[JLLoading sharedLoading] hideLoading];
                [weakSelf showLive2D];
            } fail:^(NSString *message) {
                [[JLLoading sharedLoading] hideLoading];
                [[JLLoading sharedLoading] showMBFailedTipMessage:message hideTime:KToastDismissDelayTimeInterval];
            }];
        }
    }
}

- (void)showLive2D {
    NSString *live2d_file = self.artDetailData.live2d_file;
    NSString *live2d_ipfs_url = self.artDetailData.live2d_ipfs_zip_url;
    NSString *cacheFolder = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"Live2DFiles"];
    NSString *path = [cacheFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/%@.model3.json", self.artDetailData.ID, live2d_file, live2d_file]];
    AppDelegate* delegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    [self presentViewController:delegate.lAppViewController animated:YES completion:nil];
    [delegate initializeCubism];
    NSString *modelPath = [cacheFolder stringByAppendingString:[NSString stringWithFormat:@"/%@/%@/", self.artDetailData.ID, live2d_file]];
    NSString *modelJsonName = [NSString stringWithFormat:@"%@.model3.json", live2d_file];
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

- (JLArtDetailNamePriceView *)artDetailNamePriceView {
    if (!_artDetailNamePriceView) {
        _artDetailNamePriceView = [[JLArtDetailNamePriceView alloc] initWithFrame:CGRectMake(0.0f, self.pageFlowView.frameBottom, kScreenWidth, 90.0f)];
        _artDetailNamePriceView.artDetailData = self.artDetailData;
    }
    return _artDetailNamePriceView;
}

- (JLArtDetailSellingView *)artSellingView {
    if (!_artSellingView) {
        WS(weakSelf)
        _artSellingView = [[JLArtDetailSellingView alloc] initWithFrame:CGRectMake(0.0f, self.artDetailNamePriceView.frameBottom, kScreenWidth, 55.0f + 35.0f)];
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
            __block JLOrderSubmitViewController *weakOrderSubmitVC = orderSubmitVC;
            orderSubmitVC.buySuccessBlock = ^(JLOrderPayType payType, NSString * _Nonnull payUrl) {
                [weakOrderSubmitVC.navigationController popViewControllerAnimated:NO];
                if (payType == JLOrderPayTypeWeChat) {
                    // 打开支付页面
                    JLWechatPayWebViewController *payWebVC = [[JLWechatPayWebViewController alloc] init];
                    payWebVC.payUrl = payUrl;
                    [weakSelf.navigationController pushViewController:payWebVC animated:YES];
                } else {
                    JLAlipayWebViewController *payWebVC = [[JLAlipayWebViewController alloc] init];
                    payWebVC.payUrl = payUrl;
                    [weakSelf.navigationController pushViewController:payWebVC animated:YES];
                }
                [weakSelf requestSellingList];
            };
            [weakSelf.navigationController pushViewController:orderSubmitVC animated:YES];
        };
        _artSellingView.openCloseListBlock = ^(BOOL isOpen) {
            if (isOpen) {
                weakSelf.artSellingView.frame = CGRectMake(0.0f, weakSelf.artDetailNamePriceView.frameBottom, kScreenWidth, 55.0f + 35.0f + 38.0f * (weakSelf.currentSellingList.count) + 48.0f);
                weakSelf.artChainTradeView.frame = CGRectMake(0.0f, weakSelf.artSellingView.frameBottom + 10.0f, kScreenWidth, 210.0f);
                weakSelf.artAuthorDetailView.frame = CGRectMake(0.0f, weakSelf.artChainTradeView.frameBottom + 10.0f, kScreenWidth, 204.0f);
                weakSelf.artEvaluateView.frame = CGRectMake(0.0f, weakSelf.artAuthorDetailView.frameBottom, kScreenWidth, weakSelf.artEvaluateView.frameHeight);
                weakSelf.scrollView.contentSize = CGSizeMake(kScreenWidth, weakSelf.artEvaluateView.frameBottom);
            } else {
                weakSelf.artSellingView.frame = CGRectMake(0.0f, weakSelf.artDetailNamePriceView.frameBottom, kScreenWidth, 55.0f + 35.0f + 38.0f * (weakSelf.currentSellingList.count > 4 ? 4 : weakSelf.currentSellingList.count) + (weakSelf.currentSellingList.count > 4 ? 48.0f : 0.0f));
                weakSelf.artChainTradeView.frame = CGRectMake(0.0f, weakSelf.artSellingView.frameBottom + 10.0f, kScreenWidth, 210.0f);
                weakSelf.artAuthorDetailView.frame = CGRectMake(0.0f, weakSelf.artChainTradeView.frameBottom + 10.0f, kScreenWidth, 204.0f);
                weakSelf.artEvaluateView.frame = CGRectMake(0.0f, weakSelf.artAuthorDetailView.frameBottom, kScreenWidth, weakSelf.artEvaluateView.frameHeight);
                weakSelf.scrollView.contentSize = CGSizeMake(kScreenWidth, weakSelf.artEvaluateView.frameBottom);
            }
        };
    }
    return _artSellingView;
}

- (JLArtChainTradeView *)artChainTradeView {
    if (!_artChainTradeView) {
        _artChainTradeView = [[JLArtChainTradeView alloc] initWithFrame:CGRectMake(0.0f, self.artDetailData.collection_mode == 3 ? self.artSellingView.frameBottom + 10.0f : self.artDetailNamePriceView.frameBottom, kScreenWidth, 210.0f)];
        _artChainTradeView.artDetailData = self.artDetailData;
    }
    return _artChainTradeView;
}

- (JLArtAuthorDetailView *)artAuthorDetailView {
    if (!_artAuthorDetailView) {
        WS(weakSelf)
        _artAuthorDetailView = [[JLArtAuthorDetailView alloc] initWithFrame:CGRectMake(0.0f, self.artChainTradeView.frameBottom + 10.0f, kScreenWidth, 204.0f)];
        _artAuthorDetailView.artDetailData = self.artDetailData;
        _artAuthorDetailView.introduceBlock = ^{
            // 判断是否是自己
            if ([weakSelf.artDetailData.author.ID isEqualToString: [AppSingleton sharedAppSingleton].userBody.ID]) {
                JLHomePageViewController *homePageVC = [[JLHomePageViewController alloc] init];
                [weakSelf.navigationController pushViewController:homePageVC animated:YES];
            } else {
                JLCreatorPageViewController *creatorPageVC = [[JLCreatorPageViewController alloc] init];
                creatorPageVC.authorData = weakSelf.artDetailData.author;
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
        _artEvaluateView = [[JLArtEvaluateView alloc] initWithFrame:CGRectMake(0.0f, self.artAuthorDetailView.frameBottom, kScreenWidth, 0.0f) artDetailData:self.artDetailData];
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
    request.ID = self.artDetailData.ID;
    request.page = 1;
    request.per_page = 9999;
    Model_arts_id_orders_Rsp *response = [[Model_arts_id_orders_Rsp alloc] init];
    response.request = request;
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            weakSelf.artSellingView.sellingArray = response.body;
            weakSelf.currentSellingList = response.body;
            if (response.body.count == 4) {
                weakSelf.artSellingViewOpen = NO;
            }
            // 更新视图
            if (weakSelf.artDetailData.collection_mode == 3) {
                if (weakSelf.artSellingViewOpen) {
                    weakSelf.artSellingView.frame = CGRectMake(0.0f, weakSelf.artDetailNamePriceView.frameBottom, kScreenWidth, 55.0f + 35.0f + 38.0f * (weakSelf.currentSellingList.count) + 48.0f);
                    weakSelf.artChainTradeView.frame = CGRectMake(0.0f, weakSelf.artSellingView.frameBottom + 10.0f, kScreenWidth, 210.0f);
                    weakSelf.artAuthorDetailView.frame = CGRectMake(0.0f, weakSelf.artChainTradeView.frameBottom + 10.0f, kScreenWidth, 204.0f);
                    weakSelf.artEvaluateView.frame = CGRectMake(0.0f, weakSelf.artAuthorDetailView.frameBottom, kScreenWidth, weakSelf.artEvaluateView.frameHeight);
                    weakSelf.scrollView.contentSize = CGSizeMake(kScreenWidth, weakSelf.artEvaluateView.frameBottom);
                } else {
                    weakSelf.artSellingView.frame = CGRectMake(0.0f, weakSelf.artDetailNamePriceView.frameBottom, kScreenWidth, 55.0f + 35.0f + 38.0f * (weakSelf.currentSellingList.count > 4 ? 4 : weakSelf.currentSellingList.count) + (weakSelf.currentSellingList.count > 4 ? 48.0f : 0.0f));
                    weakSelf.artChainTradeView.frame = CGRectMake(0.0f, weakSelf.artSellingView.frameBottom + 10.0f, kScreenWidth, 210.0f);
                    weakSelf.artAuthorDetailView.frame = CGRectMake(0.0f, weakSelf.artChainTradeView.frameBottom + 10.0f, kScreenWidth, 204.0f);
                    weakSelf.artEvaluateView.frame = CGRectMake(0.0f, weakSelf.artAuthorDetailView.frameBottom, kScreenWidth, weakSelf.artEvaluateView.frameHeight);
                    weakSelf.scrollView.contentSize = CGSizeMake(kScreenWidth, weakSelf.artEvaluateView.frameBottom);
                }
            }
        }
        [weakSelf updateArtDetailData];
    }];
}

// 更新艺术品信息
- (void)updateArtDetailData {
    WS(weakSelf)
    Model_arts_detail_Req *reqeust = [[Model_arts_detail_Req alloc] init];
    reqeust.art_id = self.artDetailData.ID;
    Model_arts_detail_Rsp *response = [[Model_arts_detail_Rsp alloc] init];
    response.request = reqeust;
    
    [JLNetHelper netRequestGetParameters:reqeust respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            weakSelf.artDetailData = response.body;
        }
    }];
}
@end
