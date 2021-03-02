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

#import "NewPagedFlowView.h"
#import "JLArtDetailView.h"
#import "JLArtAuthorDetailView.h"
#import "JLArtInfoView.h"
#import "JLArtEvaluateView.h"
#import "JLArtDetailDescriptionView.h"
#import "JLChainQRCodeView.h"

@interface JLArtDetailViewController ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>
@property (nonatomic, strong) UITabBar *bottomBar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NewPagedFlowView *pageFlowView;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UIButton *photoBrowserBtn;
@property (nonatomic, strong) JLArtDetailView *artDetailView;
@property (nonatomic, strong) JLArtAuthorDetailView *artAuthorDetailView;
@property (nonatomic, strong) JLArtInfoView *artInfoView;
@property (nonatomic, strong) JLArtEvaluateView *artEvaluateView;
@property (nonatomic, strong) JLArtDetailDescriptionView *artDetailDescView;

@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *dislikeButton;
// 测试数据
@property (nonatomic, strong) NSArray *tempImageArray;
@end

@implementation JLArtDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    [self addBackItem];
    [self createSubView];
}

- (void)backClick {
    if (!self.artDetailData.favorite_by_me && self.cancelFavorateBlock) {
        self.cancelFavorateBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.artDetailDescView.frameBottom);
}

- (void)createSubView {
    if (self.artDetailType == JLArtDetailTypeDetail) {
        [self initBottomUI];
    }
    [self.view addSubview:self.scrollView];
    if (self.artDetailType == JLArtDetailTypeDetail) {
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottomBar.mas_top);
            make.left.top.right.equalTo(self.view);
        }];
    } else {
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-KTouch_Responder_Height);
            make.left.top.right.equalTo(self.view);
        }];
    }
    
    [self.scrollView addSubview:self.pageFlowView];
    [self.pageFlowView addSubview:self.pageLabel];
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
    [self.scrollView addSubview:self.artDetailView];
    [self.scrollView addSubview:self.artAuthorDetailView];
    [self.scrollView addSubview:self.artInfoView];
    [self.scrollView addSubview:self.artEvaluateView];
    [self.scrollView addSubview:self.artDetailDescView];
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
        [[JLViewControllerTool appDelegate].walletTool sellOrderCallWithCollectionId:1 itemId:34 price:@"1" block:^(BOOL success, NSString * _Nonnull message) {
            if (success) {
                JLOrderSubmitViewController *orderSubmitVC = [[JLOrderSubmitViewController alloc] init];
                [weakSelf.navigationController pushViewController:orderSubmitVC animated:YES];
            }
        }];
    }
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
    }
    return _photoBrowserBtn;
}

- (void)photoBrowserBtnClick {
    //图片查看
    WMPhotoBrowser *browser = [WMPhotoBrowser new];
    //数据源
    browser.dataSource = [self.tempImageArray mutableCopy];
    browser.downLoadNeeded = YES;
    browser.currentPhotoIndex = self.pageFlowView.currentPageIndex;
    browser.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [[JLTool currentViewController] presentViewController:browser animated:YES completion:nil];
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
    }
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", pageNumber + 1, (long)[self numberOfPagesInFlowView:self.pageFlowView]];
}

- (JLArtDetailView *)artDetailView {
    if (!_artDetailView) {
        WS(weakSelf)
        _artDetailView = [[JLArtDetailView alloc] initWithFrame:CGRectMake(0.0f, self.pageFlowView.frameBottom, kScreenWidth, 197.0f)];
        _artDetailView.artDetailData = self.artDetailData;
        _artDetailView.chainQRCodeBlock = ^(NSString * _Nonnull qrcode) {
            JLChainQRCodeView *chainQRCodeView = [[JLChainQRCodeView alloc] initWithFrame:CGRectMake(0, 0, 225.0f, 225.0f) qrcodeString:qrcode];
            chainQRCodeView.center = weakSelf.view.center;
            LewPopupViewAnimationSpring *animation = [[LewPopupViewAnimationSpring alloc] init];
            [weakSelf lew_presentPopupView:chainQRCodeView animation:animation dismissed:^{
               NSLog(@"动画结束");
            }];
        };
    }
    return _artDetailView;
}

- (JLArtAuthorDetailView *)artAuthorDetailView {
    if (!_artAuthorDetailView) {
        WS(weakSelf)
        _artAuthorDetailView = [[JLArtAuthorDetailView alloc] initWithFrame:CGRectMake(0.0f, self.artDetailView.frameBottom + 10.0f, kScreenWidth, 204.0f)];
        _artAuthorDetailView.artDetailData = self.artDetailData;
        _artAuthorDetailView.introduceBlock = ^{
            JLCreatorPageViewController *creatorPageVC = [[JLCreatorPageViewController alloc] init];
            creatorPageVC.authorData = weakSelf.artDetailData.author;
            [weakSelf.navigationController pushViewController:creatorPageVC animated:YES];
        };
    }
    return _artAuthorDetailView;
}

- (JLArtInfoView *)artInfoView {
    if (!_artInfoView) {
        _artInfoView = [[JLArtInfoView alloc] initWithFrame:CGRectMake(0.0f, self.artAuthorDetailView.frameBottom, kScreenWidth, 250.0f)];
        _artInfoView.artDetailData = self.artDetailData;
    }
    return _artInfoView;
}

- (JLArtEvaluateView *)artEvaluateView {
    if (!_artEvaluateView) {
        _artEvaluateView = [[JLArtEvaluateView alloc] initWithFrame:CGRectMake(0.0f, self.artInfoView.frameBottom, kScreenWidth, 0.0f) artDetailData:self.artDetailData];
    }
    return _artEvaluateView;
}

- (JLArtDetailDescriptionView *)artDetailDescView {
    if (!_artDetailDescView) {
        _artDetailDescView = [[JLArtDetailDescriptionView alloc] initWithFrame:CGRectMake(0.0f, [self.artEvaluateView getFrameBottom], kScreenWidth, 0.0f) artDetailData:self.artDetailData];
    }
    return _artDetailDescView;
}

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

@end

