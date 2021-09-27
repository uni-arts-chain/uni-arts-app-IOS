//
//  JLDappContentView.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/26.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappContentView.h"
#import "JLDappSearchHeaderView.h"
#import "JLDappTrackView.h"
#import "JLDappTitleView.h"
#import "JLDappChainView.h"

@interface JLDappContentView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) JLDappSearchHeaderView *searchHeaderView;
@property (nonatomic, strong) JLDappTrackView *trackView;
@property (nonatomic, strong) JLDappTitleView *chainTitleView;

@property (nonatomic, strong) JLDappTitleView *chainRecommendTitleView;
@property (nonatomic, strong) JLDappChainView *chainRecommendView;
@property (nonatomic, strong) JLDappTitleView *chainTransactionTitleView;
@property (nonatomic, strong) JLDappChainView *chainTransactionView;

@property (nonatomic, strong) MASConstraint *chainRecommendViewHeightConstraint;
@property (nonatomic, strong) MASConstraint *chainTransactionViewHeightConstraint;

@property (nonatomic, assign) JLDappContentViewTrackType selectTrackType;
@property (nonatomic, assign) JLMultiChainSymbol selectChainSymbol;

@end

@implementation JLDappContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectTrackType = JLDappContentViewTrackTypeCollect;
        _selectChainSymbol = JLMultiChainSymbolETH;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    WS(weakSelf)
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.mj_header = [JLRefreshHeader headerWithRefreshingBlock:^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(refreshDataWithTrackType:chainSymbol:)]) {
            [weakSelf.delegate refreshDataWithTrackType:weakSelf.selectTrackType chainSymbol:weakSelf.selectChainSymbol];
        }
    }];
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    _bgView = [[UIView alloc] init];
    [_scrollView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    // 搜索视图
    _searchHeaderView = [[JLDappSearchHeaderView alloc] init];
    _searchHeaderView.searchBlock = ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(search)]) {
            [weakSelf.delegate search];
        }
    };
    _searchHeaderView.scanBlock = ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(scanCode)]) {
            [weakSelf.delegate scanCode];
        }
    };
    [_bgView addSubview:_searchHeaderView];
    [_searchHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(10);
        make.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(@35);
    }];
    
    // 收藏或最近视图
    _trackView = [[JLDappTrackView alloc] init];
    _trackView.didSelectTitleBlock = ^(NSInteger index) {
        weakSelf.selectTrackType = index;
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(lookTrackWithType:)]) {
            [weakSelf.delegate lookTrackWithType:weakSelf.selectTrackType];
        }
    };
    _trackView.moreBlock = ^(NSInteger index) {
        JLDappContentViewLookMoreType type = JLDappContentViewLookMoreTypeCollect;
        if (index == 1) {
            type = JLDappContentViewLookMoreTypeRecently;
        }
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(lookMoreWithType:)]) {
            [weakSelf.delegate lookMoreWithType:type];
        }
    };
    _trackView.lookDappBlock = ^(NSString * _Nonnull dappUrl) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(lookDappWithUrl:)]) {
            [weakSelf.delegate lookDappWithUrl:dappUrl];
        }
    };
    [_bgView addSubview:_trackView];
    [_trackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchHeaderView.mas_bottom).offset(10);
        make.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(@130);
    }];
    
    // 链标题视图
    _chainTitleView = [[JLDappTitleView alloc] init];
    _chainTitleView.didSelectBlock = ^(NSInteger index) {
        weakSelf.selectChainSymbol = weakSelf.chainSymbolArray[index];
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(refreshChainInfoDatasWithSymbol:)]) {
            [weakSelf.delegate refreshChainInfoDatasWithSymbol:weakSelf.selectChainSymbol];
        }
    };
    [_bgView addSubview:_chainTitleView];
    [_chainTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.trackView.mas_bottom).offset(12);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(@30);
    }];
    
    // 推荐标题视图
    _chainRecommendTitleView = [[JLDappTitleView alloc] init];
    _chainRecommendTitleView.moreBlock = ^(NSInteger index) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(lookMoreWithType:)]) {
            [weakSelf.delegate lookMoreWithType:JLDappContentViewLookMoreTypeRecommend];
        }
    };
    [_chainRecommendTitleView setTitleArray:@[@"推荐"] selectIndex:0 style:JLDappTitleViewStyleNoScroll];
    [_bgView addSubview:_chainRecommendTitleView];
    [_chainRecommendTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chainTitleView.mas_bottom).offset(14);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(@30);
    }];
    // 推荐内容视图
    _chainRecommendView = [[JLDappChainView alloc] init];
    _chainRecommendView.lookDappBlock = ^(NSString * _Nonnull url) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(lookDappWithUrl:)]) {
            [weakSelf.delegate lookDappWithUrl:url];
        }
    };
    [_bgView addSubview:_chainRecommendView];
    [_chainRecommendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chainRecommendTitleView.mas_bottom).offset(12);
        make.left.right.equalTo(self);
        self.chainRecommendViewHeightConstraint = make.height.mas_equalTo(@192);
    }];
    
    // 交易标题视图
    _chainTransactionTitleView= [[JLDappTitleView alloc] init];
    _chainTransactionTitleView.moreBlock = ^(NSInteger index) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(lookMoreWithType:)]) {
            [weakSelf.delegate lookMoreWithType:JLDappContentViewLookMoreTypeTransaction];
        }
    };
    [_chainTransactionTitleView setTitleArray:@[@"交易"] selectIndex:0 style:JLDappTitleViewStyleNoScroll];
    [_bgView addSubview:_chainTransactionTitleView];
    [_chainTransactionTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chainRecommendView.mas_bottom).offset(12);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(@30);
    }];
    // 交易内容视图
    _chainTransactionView = [[JLDappChainView alloc] init];
    _chainRecommendView.lookDappBlock = ^(NSString * _Nonnull url) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(lookDappWithUrl:)]) {
            [weakSelf.delegate lookDappWithUrl:url];
        }
    };
    [_bgView addSubview:_chainTransactionView];
    [_chainTransactionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chainTransactionTitleView.mas_bottom).offset(12);
        make.left.right.equalTo(self);
        self.chainTransactionViewHeightConstraint = make.height.mas_equalTo(@192);
        make.bottom.equalTo(self.bgView).offset(-(50 + KTabBar_Height));
    }];
}

#pragma mark - setters and getters
- (void)setTrackArray:(NSArray *)trackArray {
    _trackArray = trackArray;
    
    if ([_scrollView.mj_header isRefreshing]) {
        [_scrollView.mj_header endRefreshing];
    }
    
    _trackView.dataArray = _trackArray;
}

- (void)setRecommendArray:(NSArray *)recommendArray {
    _recommendArray = recommendArray;
    
    if ([_scrollView.mj_header isRefreshing]) {
        [_scrollView.mj_header endRefreshing];
    }
    
    if (_recommendArray.count < 3) {
        CGFloat height = MAX(64, 64 *_recommendArray.count);
        [_chainRecommendViewHeightConstraint uninstall];
        [_chainRecommendView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.chainRecommendViewHeightConstraint = make.height.mas_equalTo(@(height));
        }];
    }else {
        [_chainRecommendViewHeightConstraint uninstall];
        [_chainRecommendView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.chainRecommendViewHeightConstraint = make.height.mas_equalTo(@192);
        }];
    }
    
    _chainRecommendView.dataArray = _recommendArray;
}

- (void)setTransactionArray:(NSArray *)transactionArray {
    _transactionArray = transactionArray;
    
    if ([_scrollView.mj_header isRefreshing]) {
        [_scrollView.mj_header endRefreshing];
    }
    
    if (_transactionArray.count < 3) {
        CGFloat height = MAX(64, 64 *_transactionArray.count);
        [_chainTransactionViewHeightConstraint uninstall];
        [_chainTransactionView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.chainTransactionViewHeightConstraint = make.height.mas_equalTo(@(height));
        }];
    }else {
        [_chainTransactionViewHeightConstraint uninstall];
        [_chainTransactionView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.chainTransactionViewHeightConstraint = make.height.mas_equalTo(@192);
        }];
    }
    
    _chainTransactionView.dataArray = _transactionArray;
}

- (void)setChainSymbolArray:(NSArray *)chainSymbolArray {
    _chainSymbolArray = chainSymbolArray;
    
    NSInteger defaultIndex = 0;
    for (int i = 0; i < _chainSymbolArray.count; i++) {
        if (_selectChainSymbol == _chainSymbolArray[i]) {
            defaultIndex = i;
            break;
        }
    }
    
    [_chainTitleView setTitleArray:_chainSymbolArray selectIndex:defaultIndex style:JLDappTitleViewStyleScrollNoMore];
}

@end
