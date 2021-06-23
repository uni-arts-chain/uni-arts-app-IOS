//
//  JLSearchViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/25.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLSearchViewController.h"
#import <YYCache/YYCache.h>
#import "XPCollectionViewWaterfallFlowLayout.h"
#import "JLArtDetailViewController.h"
#import "JLAuctionArtDetailViewController.h"

#import "JLSearchBarView.h"
#import "JLSearchHIstoryTableViewCell.h"
#import "JLNormalEmptyView.h"
#import "JLNFTGoodCollectionCell.h"

#import "UIButton+TouchArea.h"

NSString *const JLSearchHistoryName = @"SearchHistoryName";
NSString *const JLSearchHistory = @"SearchHistory";

@interface JLSearchViewController ()<XPCollectionViewWaterfallFlowLayoutDataSource, JLSearchBarViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) JLSearchBarView *searchBarView;
@property (nonatomic, strong) UIView *historyView;
@property (nonatomic, strong) UIScrollView *historyScrollView;
@property (nonatomic, strong) UIView *historyContentView;
@property (nonatomic, strong) UICollectionView *resultCollectionView;
//搜索历史数组
@property (nonatomic, strong) NSMutableArray *searchHistoryArray;
// 搜索结果数组
@property (nonatomic, strong) NSMutableArray *searchResultArray;

@property (nonatomic, strong) JLNormalEmptyView *emptyView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSString *searchContent;
@end

@implementation JLSearchViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.titleView = self.searchBarView;
    [self createViews];
}

#pragma mark - setup UI
- (void)createViews {
    [self.view addSubview:self.historyView];
    [self.historyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view addSubview:self.resultCollectionView];
    [self.resultCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)updateHistoryContentViews {
    
    [self.historyView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag >= 1000) {
            [obj removeFromSuperview];
        }
    }];
    
    [self.historyContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    UIView *bgView = [[UIView alloc] init];
    [self.historyContentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.historyContentView);
        make.left.equalTo(self.historyContentView).offset(12);
        make.right.equalTo(self.historyContentView).offset(-12);
    }];
        
    CGFloat oriW = self.view.frameWidth - 24;
    CGFloat spaceW = 23;
    CGFloat spaceH = 12;
    CGFloat tagHeight = 36;
    CGFloat tagWidth = (self.view.frameWidth - 24 - spaceW * 2) / 3 > 102 ? 102 : (self.view.frameWidth - 24 - spaceW * 2) / 3;
    CGFloat currentAllW = 0;
    NSInteger line = 0;

    for (int i = 0; i < self.searchHistoryArray.count; i++) {
        
        CGFloat textW = [JLTool getAdaptionSizeWithText:self.searchHistoryArray[i] labelHeight:tagHeight font:kFontPingFangSCRegular(15)].width + 20;
        textW = textW > tagWidth ? textW : tagWidth;
        
        CGFloat leftConstraint = 0;
        CGFloat topConstraint = 0;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.tag = 100 + i;
        titleLabel.backgroundColor = JL_color_white_ffffff;
        titleLabel.text = self.searchHistoryArray[i];
        titleLabel.textColor = JL_color_black_101220;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = kFontPingFangSCRegular(15);
        titleLabel.layer.cornerRadius = 4;
        titleLabel.layer.masksToBounds = YES;
        titleLabel.layer.borderWidth = 0.5;
        titleLabel.layer.borderColor = JL_color_gray_E1E1E1.CGColor;
        titleLabel.userInteractionEnabled = YES;
        [titleLabel addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTap:)]];
        [bgView addSubview:titleLabel];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.tag = 1000 + i;
        [deleteBtn setImage:[UIImage imageNamed:@"search_icon_clear_red"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.historyView addSubview:deleteBtn];
        
        // 是否换行显示
        if (currentAllW + textW > oriW) {
            line += 1;
            currentAllW = 0;
            leftConstraint = 0;
        }
        leftConstraint = currentAllW;
        topConstraint = line ? (tagHeight + spaceH) * line : 0;
        
        if (i == self.searchHistoryArray.count - 1) {
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bgView).offset(topConstraint);
                make.left.equalTo(bgView).offset(leftConstraint);
                make.size.mas_equalTo(CGSizeMake(textW, tagHeight));
                make.bottom.equalTo(bgView);
            }];
        }else {
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bgView).offset(topConstraint);
                make.left.equalTo(bgView).offset(leftConstraint);
                make.size.mas_equalTo(CGSizeMake(textW, tagHeight));
            }];
        }
        
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel).offset(-13);
            make.right.equalTo(titleLabel).offset(13);
            make.width.height.mas_equalTo(@30);
        }];
        
        currentAllW = currentAllW + textW + spaceW;
    }
}

#pragma mark - XPCollectionViewWaterfallFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout *)layout numberOfColumnInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout *)layout itemWidth:(CGFloat)width heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    Model_art_Detail_Data *artDetailData = self.searchResultArray[indexPath.item];
    
    CGFloat textH = [JLTool getAdaptionSizeWithText:artDetailData.name labelWidth:width - 25 font:kFontPingFangSCMedium(13.0f)].height;
    if (textH > 36.4) {
        textH = 36.4;
    }
    return 45 + textH + artDetailData.imgHeight;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout *)layout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 12, 12, 12);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout*)layout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 12;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout*)layout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 12;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout *)layout referenceHeightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout *)layout referenceHeightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.searchResultArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JLNFTGoodCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JLNFTGoodCollectionCell" forIndexPath:indexPath];
    cell.artDetailData = self.searchResultArray[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Model_art_Detail_Data *artDetailData = self.searchResultArray[indexPath.row];
    if ([artDetailData.aasm_state isEqualToString:@"auctioning"]) {
        // 拍卖中
        JLAuctionArtDetailViewController *auctionDetailVC = [[JLAuctionArtDetailViewController alloc] init];
        auctionDetailVC.artDetailType = artDetailData.is_owner ? JLAuctionArtDetailTypeSelf : JLAuctionArtDetailTypeDetail;
        Model_auction_meetings_arts_Data *meetingsArtsData = [[Model_auction_meetings_arts_Data alloc] init];
        meetingsArtsData.art = artDetailData;
        auctionDetailVC.artsData = meetingsArtsData;
        [self.navigationController pushViewController:auctionDetailVC animated:YES];
    } else {
        JLArtDetailViewController *artDetailVC = [[JLArtDetailViewController alloc] init];
        artDetailVC.artDetailType = artDetailData.is_owner ? JLArtDetailTypeSelfOrOffShelf : JLArtDetailTypeDetail;
        artDetailVC.artDetailData = artDetailData;
        [self.navigationController pushViewController:artDetailVC animated:YES];
    }
}

#pragma mark JLSearchBarViewDelegate
- (void)textEditChange:(NSString *)text {
    
}

- (void)textEndEditChange:(NSString *)text {
    if (![NSString stringIsEmpty:text]) {
        [self cacheSearchContent:text];

        self.historyView.hidden = YES;
        self.resultCollectionView.hidden = NO;
        self.searchContent = text;
        [self headRefresh];
    }
}

#pragma mark - event reponse
- (void)didRightItemJumpPage {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)itemTap: (UITapGestureRecognizer *)ges {
    NSString *content = self.searchHistoryArray[ges.view.tag - 100];
    [self.searchHistoryArray removeObjectAtIndex:ges.view.tag - 100];
    [self cacheSearchContent:content];
    [self.searchBarView setSearchText:content];

    self.historyView.hidden = YES;
    self.resultCollectionView.hidden = NO;
    self.searchContent = content;
    [self headRefresh];
}

- (void)deleteBtnClick: (UIButton *)sender {
    
    NSInteger index = sender.tag - 1000;

    [self deleteHistory:index];
}

- (void)clearBtnClick {
    [self.searchHistoryArray removeAllObjects];
    [self setCacheUserInfo:self.searchHistoryArray];
    
    [self updateHistoryContentViews];
}

#pragma mark - loadDatas
- (void)requestSearchList {
    WS(weakSelf)
    Model_arts_search_Req *request = [[Model_arts_search_Req alloc] init];
    request.q = self.searchContent;
    request.page = self.currentPage;
    request.per_page = kPageSize;
    Model_arts_search_Rsp *response = [[Model_arts_search_Rsp alloc] init];
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            if (weakSelf.currentPage == 1) {
                [weakSelf.searchResultArray removeAllObjects];
            }
            [weakSelf.searchResultArray addObjectsFromArray:response.body];
            
            [weakSelf endRefresh:response.body];
            [self setNoDataShow];
            [self.resultCollectionView reloadData];
        } else {
            NSLog(@"%@", errorStr);
        }
    }];
}

#pragma mark - private methods
- (void)headRefresh {
    self.currentPage = 1;
    [self requestSearchList];
}

- (void)footRefresh {
    self.currentPage++;
    [self requestSearchList];
}

- (void)endRefresh:(NSArray*)collectionArray {
    if (collectionArray.count < kPageSize) {
        [(JLRefreshFooter *)self.resultCollectionView.mj_footer endWithNoMoreDataNotice];
    } else {
        [self.resultCollectionView.mj_footer endRefreshing];
    }
}

- (void)setNoDataShow {
    if (self.searchResultArray.count == 0) {
        [self.resultCollectionView addSubview:self.emptyView];
    } else {
        if (_emptyView) {
            [self.emptyView removeFromSuperview];
            self.emptyView = nil;
        }
    }
}

- (void)deleteHistory:(NSInteger)index {
    [self.searchHistoryArray removeObjectAtIndex:index];
    [self setCacheUserInfo:self.searchHistoryArray];
    
    [self updateHistoryContentViews];
}

- (void)cacheSearchContent:(NSString *)content {
    if (self.searchHistoryArray.count == 10) {
        [self.searchHistoryArray removeLastObject];
    }
    if ([self.searchHistoryArray containsObject:content]) {
        [self.searchHistoryArray removeObject:content];
    }
    [self.searchHistoryArray insertObject:content atIndex:0];
    
    [self setCacheUserInfo:self.searchHistoryArray];
}

- (NSArray *)getCacheUserInfo {
    YYCache *cache = [[YYCache alloc] initWithName:JLSearchHistoryName];
    return (NSArray *)[cache objectForKey:JLSearchHistory];
}

- (void)setCacheUserInfo: (NSArray *)array {
    YYCache *cache = [[YYCache alloc] initWithName:JLSearchHistoryName];
    [cache setObject:array forKey:JLSearchHistory];
}

#pragma mark - setters and getters
- (JLSearchBarView *)searchBarView {
    if (!_searchBarView) {
        _searchBarView = [[JLSearchBarView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth - 24.0f, 34.0f)];
        _searchBarView.delegate = self;
        [_searchBarView setSearchPlaceholder:@"请输入关键词搜索作品"];
        [_searchBarView becomeResponder];
    }
    return _searchBarView;
}

- (UIView *)historyView {
    if (!_historyView) {
        _historyView = [[UIView alloc] init];
        UIView *titleView = [self historyTitleView];
        [_historyView addSubview:titleView];
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(_historyView);
            make.height.mas_equalTo(52.0f);
        }];
        
        [_historyView addSubview:self.historyScrollView];
        [self.historyScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleView.mas_bottom);
            make.left.right.bottom.equalTo(self.historyView);
        }];
        
        [self.historyScrollView addSubview:self.historyContentView];
        [self.historyContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.historyScrollView);
            make.width.equalTo(self.historyScrollView);
        }];
        
        [self updateHistoryContentViews];
    }
    return _historyView;
}

- (UIView *)historyTitleView {
    UIView *titleView = [[UIView alloc] init];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"历史搜索";
    titleLabel.font = kFontPingFangSCRegular(13);
    titleLabel.textColor = JL_color_black_101220;
    [titleView addSubview:titleLabel];
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearBtn setImage:[UIImage imageNamed:@"search_history_clear_icon"] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:clearBtn];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.0f);
        make.top.mas_equalTo(26.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-4.0f);
        make.centerY.equalTo(titleLabel);
        make.width.mas_equalTo(32.0f);
        make.height.mas_equalTo(32.0f);
    }];
    
    return titleView;
}

- (UIScrollView *)historyScrollView {
    if (!_historyScrollView) {
        _historyScrollView = [[UIScrollView alloc] init];
    }
    return _historyScrollView;
}

- (UIView *)historyContentView {
    if (!_historyContentView) {
        _historyContentView = [[UIView alloc] init];
    }
    return _historyContentView;
}

- (UICollectionView *)resultCollectionView {
    if (!_resultCollectionView) {
        WS(weakSelf)
        XPCollectionViewWaterfallFlowLayout *layout = [[XPCollectionViewWaterfallFlowLayout alloc] init];
        layout.dataSource = self;
        
        _resultCollectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
        _resultCollectionView.backgroundColor = JL_color_vcBgColor;
        _resultCollectionView.contentInset = UIEdgeInsetsMake(18, 0, 0, 0);
        _resultCollectionView.delegate = self;
        _resultCollectionView.dataSource = self;
        [_resultCollectionView registerClass:[JLNFTGoodCollectionCell class] forCellWithReuseIdentifier:@"JLNFTGoodCollectionCell"];
        _resultCollectionView.hidden = YES;
        _resultCollectionView.mj_footer = [JLRefreshFooter footerWithRefreshingBlock:^{
            [weakSelf footRefresh];
        }];
    }
    return _resultCollectionView;
}

- (JLNormalEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[JLNormalEmptyView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height - KTouch_Responder_Height)];
    }
    return _emptyView;
}

- (NSMutableArray *)searchHistoryArray {
    if (!_searchHistoryArray) {
        _searchHistoryArray = [[NSMutableArray alloc] initWithArray:[self getCacheUserInfo]];
    }
    return _searchHistoryArray;
}

- (NSMutableArray *)searchResultArray {
    if (!_searchResultArray) {
        _searchResultArray = [NSMutableArray array];
    }
    return _searchResultArray;
}

@end
