
//
//  JLNewAuctionArtDetailContentView.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/19.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLNewAuctionArtDetailContentView.h"
#import "NewPagedFlowView.h"
#import "JLArtDetailVideoView.h"
#import "UIButton+TouchArea.h"
#import "JLActionTimeView.h"
#import "JLAuctionArtDetailArtPriceView.h"
#import "JLAuctionOfferRecordView.h"
#import "JLAuctionArtDetailAuctionInfoView.h"
#import "JLArtChainTradeView.h"
#import "JLArtDetailShowCertificateView.h"
#import "JLArtAuthorDetailView.h"
#import "JLArtEvaluateView.h"

@interface JLNewAuctionArtDetailContentView ()<JLNewAuctionArtDetailBottomViewDelegate, NewPagedFlowViewDataSource, NewPagedFlowViewDelegate>

@property (nonatomic, strong) JLNewAuctionArtDetailBottomView *bottomView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) NewPagedFlowView *pageFlowView;

@property (nonatomic, strong) UILabel *pageLabel;

@property (nonatomic, strong) UIButton *photoBrowserBtn;

@property (nonatomic, strong) JLArtDetailVideoView *videoView;

@property (nonatomic, strong) JLActionTimeView *timeView;

@property (nonatomic, strong) JLAuctionArtDetailArtPriceView *artPriceView;

@property (nonatomic, strong) JLAuctionOfferRecordView *offerRecordView;

@property (nonatomic, strong) JLAuctionArtDetailAuctionInfoView *auctionInfoView;

@property (nonatomic, strong) JLArtChainTradeView *chainTradeView;

@property (nonatomic, strong) JLArtAuthorDetailView *authorDetailView;

@property (nonatomic, strong) JLArtEvaluateView *evaluateView;

@property (nonatomic, strong) MASConstraint *timeViewTopConstraint;

@property (nonatomic, strong) MASConstraint *offerRecordViewHeightConstraint;

@property (nonatomic, strong) NSMutableArray *bannerImageArray;

@end

@implementation JLNewAuctionArtDetailContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    WS(weakSelf)
    _bottomView = [[JLNewAuctionArtDetailBottomView alloc] init];
    _bottomView.delegate = self;
    [self addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(@(KTouch_Responder_Height + 53));
    }];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = JL_color_gray_F6F6F6;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.mj_header = [JLRefreshHeader headerWithRefreshingBlock:^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(refreshData)]) {
            [weakSelf.delegate refreshData];
        }
    }];
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_top);
        make.left.top.right.equalTo(self);
    }];
    
    _bgView = [[UIView alloc] init];
    [_scrollView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView);
    }];
    
    // 视频
    _videoView = [[JLArtDetailVideoView alloc] init];
    _videoView.hidden = YES;
    _videoView.playOrStopBlock = ^(NSInteger status) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(playVideo:)]) {
            [weakSelf.delegate playVideo:weakSelf.artDetailData.img_main_file2[@"url"]];;
        }
    };
    [_bgView addSubview:_videoView];
    [_videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(@250.0f);
    }];
    
    // 主图
    _pageFlowView = [[NewPagedFlowView alloc] init];
    _pageFlowView.backgroundColor = JL_color_white_ffffff;
    _pageFlowView.autoTime = 5.0f;
    _pageFlowView.delegate = self;
    _pageFlowView.dataSource = self;
    _pageFlowView.minimumPageAlpha = 0.4f;
    _pageFlowView.isOpenAutoScroll = NO;
    [_bgView addSubview:_pageFlowView];
    [_pageFlowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(@250.0f);
    }];
    // 页码
    _pageLabel = [[UILabel alloc] init];
    _pageLabel.backgroundColor = [JL_color_black colorWithAlphaComponent:0.4f];
    _pageLabel.font = kFontPingFangSCRegular(12.0f);
    _pageLabel.textColor = JL_color_white_ffffff;
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    _pageLabel.text = @"1/1";
    ViewBorderRadius(_pageLabel, 8.5f, 0.0f, JL_color_clear);
    [_bgView addSubview:_pageLabel];
    [_pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.pageFlowView).offset(-9.0f);
        make.width.mas_equalTo(35.0f);
        make.height.mas_equalTo(17.0f);
        make.centerX.equalTo(self.pageFlowView.mas_centerX);
    }];
    // 查看主图
    _photoBrowserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_photoBrowserBtn setImage:[UIImage imageNamed:@"icon_home_artdetail_photo_browser"] forState:UIControlStateNormal];
    [_photoBrowserBtn edgeTouchAreaWithTop:20.0f right:20.0f bottom:20.0f left:20.0f];
    [_photoBrowserBtn addTarget:self action:@selector(photoBrowserBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_photoBrowserBtn];
    [_photoBrowserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kScreenWidth - 23.0f - 16.0f);
        make.bottom.equalTo(self.pageFlowView.mas_bottom).offset(-10.0f);
        make.size.mas_equalTo(16.0f);
    }];
    
    // 拍卖状态
    _timeView = [[JLActionTimeView alloc] init];
    _timeView.actionDescBlock = ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(auctionRule)]) {
            [weakSelf.delegate auctionRule];
        }
    };
    _timeView.countDownHandle = ^(NSString * _Nonnull second) {
        if ([second isEqualToString:@"0"] && weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(refreshData)]) {
            [weakSelf.delegate refreshData];
        }
    };
    [_bgView addSubview:_timeView];
    [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.timeViewTopConstraint = make.top.equalTo(self.pageFlowView.mas_bottom);
        make.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(@66);
    }];
    
    // 艺术品报价信息
    _artPriceView = [[JLAuctionArtDetailArtPriceView alloc] init];
    [_bgView addSubview:_artPriceView];
    [_artPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeView.mas_bottom);
        make.left.right.equalTo(self.bgView);
    }];
    
    // 出价列表
    _offerRecordView = [[JLAuctionOfferRecordView alloc] init];
    _offerRecordView.recordListBlock = ^(NSArray * _Nonnull bidList, NSDate * _Nonnull blockDate, UInt32 blockNumber) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(offerRecordList)]) {
            [weakSelf.delegate offerRecordList];
        }
    };
    [_bgView addSubview:_offerRecordView];
    [_offerRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.artPriceView.mas_bottom);
        make.left.right.equalTo(self.bgView);
        self.offerRecordViewHeightConstraint = make.height.mas_equalTo(@104);
    }];
    
    // 拍卖详情
    _auctionInfoView = [[JLAuctionArtDetailAuctionInfoView alloc] init];
    [_bgView addSubview:_auctionInfoView];
    [_auctionInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.offerRecordView.mas_bottom);
        make.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(@225);
    }];
    
    // 区块链信息
    _chainTradeView = [[JLArtChainTradeView alloc] init];
    _chainTradeView.showCertificateBlock = ^{
        [JLArtDetailShowCertificateView showWithArtDetailData:weakSelf.artDetailData];
    };
    [_bgView addSubview:_chainTradeView];
    [_chainTradeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.auctionInfoView.mas_bottom).offset(10);
        make.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(@210);
    }];
    
    // 作者信息
    _authorDetailView = [[JLArtAuthorDetailView alloc] init];
    _authorDetailView.introduceBlock = ^{
        // 判断是否是自己
        BOOL isSelf = NO;
        if ([weakSelf.artDetailData.author.ID isEqualToString: [AppSingleton sharedAppSingleton].userBody.ID]) {
            isSelf = YES;
        }
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(lookCreaterHomePage:isSelf:)]) {
            [weakSelf.delegate lookCreaterHomePage:weakSelf.artDetailData.author isSelf:isSelf];
        }
    };
    [_bgView addSubview:_authorDetailView];
    [_authorDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chainTradeView.mas_bottom).offset(10);
        make.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(@204);
    }];
    
    // 作品信息
    _evaluateView = [[JLArtEvaluateView alloc] init];
    _evaluateView.lookImageBlock = ^(NSInteger index, NSArray * _Nonnull imageArray) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(lookInfoImage:currentIndex:)]) {
            [weakSelf.delegate lookInfoImage:imageArray currentIndex:index];
        }
    };
    [_bgView addSubview:_evaluateView];
    [_evaluateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.authorDetailView.mas_bottom);
        make.left.right.equalTo(self.bgView);
        make.bottom.equalTo(self.bgView);
    }];
}

#pragma mark - JLNewAuctionArtDetailBottomViewDelegate
/// 喜欢
/// @param isLike 是否喜欢
/// @param artId 艺术品id
- (void)like: (BOOL)isLike artId: (NSString *)artId {
    if (_delegate && [_delegate respondsToSelector:@selector(like:artId:)]) {
        [_delegate like:isLike artId:artId];
    }
}

/// 踩
/// @param isTread 是否踩
/// @param artId 艺术品id
- (void)tread: (BOOL)isTread artId: (NSString *)artId {
    if (_delegate && [_delegate respondsToSelector:@selector(tread:artId:)]) {
        [_delegate tread:isTread artId:artId];
    }
}

/// 收藏
/// @param isCollect 是否收藏
/// @param artId 艺术品id
- (void)collected: (BOOL)isCollect artId: (NSString *)artId {
    if (_delegate && [_delegate respondsToSelector:@selector(collected:artId:)]) {
        [_delegate collected:isCollect artId:artId];
    }
}

/// 右侧按钮点击事件
/// @param status 取消拍卖/缴纳保证金/出价/中标支付
- (void)doneStatus: (JLNewAuctionArtDetailBottomViewStatus)status {
    if (_delegate && [_delegate respondsToSelector:@selector(doneStatus:)]) {
        [_delegate doneStatus:status];
    }
}

#pragma mark NewPagedFlowViewDatasource
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView{
    return CGSizeMake(kScreenWidth, 250.0f);
}

- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return self.bannerImageArray.count;
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] init];
    }
    ///在这里下载网络图片
    NSString *bannerModel = nil;
    if (index < self.bannerImageArray.count) {
        bannerModel = self.bannerImageArray[index];
    }
    if (![NSString stringIsEmpty:bannerModel]) {
        [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:bannerModel] placeholderImage:nil];
        bannerView.mainImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return bannerView;
}

#pragma mark - NewPagedFlowViewDelegate
- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", pageNumber + 1, (long)[self numberOfPagesInFlowView:_pageFlowView]];
}

#pragma mark - event response
- (void)photoBrowserBtnClick: (UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(lookPageFlow:currentIndex:)]) {
        [_delegate lookPageFlow:_artDetailData currentIndex:_pageFlowView.currentPageIndex];
    }
}

#pragma mark - setters and getters
- (void)setArtDetailData:(Model_art_Detail_Data *)artDetailData {
    _artDetailData = artDetailData;
    
    if (_scrollView.mj_header.isRefreshing) {
        [_scrollView.mj_header endRefreshing];
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    if (![NSString stringIsEmpty:_artDetailData.img_detail_file1[@"url"]]) {
        [arr addObject:_artDetailData.img_detail_file1[@"url"]];
    }
    if (![NSString stringIsEmpty:_artDetailData.img_detail_file2[@"url"]]) {
        [arr addObject:_artDetailData.img_detail_file2[@"url"]];
    }
    if (![NSString stringIsEmpty:_artDetailData.img_detail_file3[@"url"]]) {
        [arr addObject:_artDetailData.img_detail_file3[@"url"]];
    }
    _artDetailData.detail_imgs = [arr copy];
    
    // 视频
    if (_artDetailData.resource_type == 4) {
        _videoView.hidden = NO;
        _pageFlowView.hidden = YES;
        _pageLabel.hidden = YES;
        _photoBrowserBtn.hidden = YES;
        _videoView.artDetailData = _artDetailData;
        [_bgView bringSubviewToFront:_videoView];
        
        [_timeViewTopConstraint uninstall];
        [_timeView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.timeViewTopConstraint = make.top.equalTo(self.videoView.mas_bottom);
        }];
    }else {
        _videoView.hidden = YES;
        _pageFlowView.hidden = NO;
        _pageLabel.hidden = NO;
        _photoBrowserBtn.hidden = NO;
        
        [self.bannerImageArray removeAllObjects];
        NSString *fileImage1 = _artDetailData.img_main_file1[@"url"];
        NSString *fileImage2 = _artDetailData.img_main_file2[@"url"];
        NSString *fileImage3 = _artDetailData.img_main_file3[@"url"];
        if (![NSString stringIsEmpty:fileImage1]) {
            [self.bannerImageArray addObject:fileImage1];
        }
        if (![NSString stringIsEmpty:fileImage2]) {
            [self.bannerImageArray addObject:fileImage2];
        }
        if (![NSString stringIsEmpty:fileImage3]) {
            [self.bannerImageArray addObject:fileImage3];
        }
        [_pageFlowView reloadData];
        
        _pageLabel.text = [NSString stringWithFormat:@"1/%ld", (long)[self numberOfPagesInFlowView:_pageFlowView]];
        
        [_timeViewTopConstraint uninstall];
        [_timeView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.timeViewTopConstraint = make.top.equalTo(self.pageFlowView.mas_bottom);
        }];
    }
    
    [_timeView setTimeType:JLActionTimeTypeRuning countDownInterval:20000];
    
    _artPriceView.artDetailData = _artDetailData;
    
    _auctionInfoView.artDetailData = _artDetailData;
    
    _chainTradeView.artDetailData = _artDetailData;
    
    _authorDetailView.artDetailData = _artDetailData;
    
    _evaluateView.artDetailData = _artDetailData;
    
    _bottomView.artDetailData = _artDetailData;
}

- (NSMutableArray *)bannerImageArray {
    if (!_bannerImageArray) {
        _bannerImageArray = [NSMutableArray array];
    }
    return _bannerImageArray;
}

@end
