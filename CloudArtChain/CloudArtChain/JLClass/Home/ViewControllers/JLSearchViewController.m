//
//  JLSearchViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/25.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLSearchViewController.h"
#import <YYCache/YYCache.h>
#import "UICollectionWaterLayout.h"
#import "JLArtDetailViewController.h"

#import "JLSearchBarView.h"
#import "JLSearchHIstoryTableViewCell.h"
#import "JLNormalEmptyView.h"
#import "JLCategoryWorkCollectionViewCell.h"

#import "UIButton+TouchArea.h"

NSString *const JLSearchHistoryName = @"SearchHistoryName";
NSString *const JLSearchHistory = @"SearchHistory";

@interface JLSearchViewController ()<UITableViewDelegate, UITableViewDataSource, JLSearchBarViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) JLSearchBarView *searchBarView;
@property (nonatomic, strong) UIView *historyView;
@property (nonatomic, strong) UITableView *historyTableView;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.titleView = self.searchBarView;
    [self createViews];
}

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

- (JLSearchBarView *)searchBarView {
    if (!_searchBarView) {
        _searchBarView = [[JLSearchBarView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth - 30.0f, 30.0f)];
        _searchBarView.delegate = self;
        [_searchBarView setSearchPlaceholder:@""];
        [_searchBarView becomeResponder];
    }
    return _searchBarView;
}

- (void)cacheSearchContent:(NSString *)content {
    if (self.searchHistoryArray.count == 10) {
        [self.searchHistoryArray removeLastObject];
    }
    [self.searchHistoryArray insertObject:content atIndex:0];
    YYCache *cache = [[YYCache alloc] initWithName:JLSearchHistoryName];
    [cache setObject:self.searchHistoryArray forKey:JLSearchHistory];
}

- (NSArray *)getCacheUserInfo {
    YYCache *cache = [[YYCache alloc] initWithName:JLSearchHistoryName];
    return (NSArray *)[cache objectForKey:JLSearchHistory];
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

- (void)deleteHistory:(NSIndexPath *)indexPath {
    [self.searchHistoryArray removeObjectAtIndex:indexPath.row];
    [self.historyTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark JLSearchBarViewDelegate
- (void)textEditChange:(NSString *)text {
    
}

- (void)textEndEditChange:(NSString *)text {
    if (![NSString stringIsEmpty:text]) {
        [self cacheSearchContent:text];

        self.historyTableView.hidden = YES;
        self.resultCollectionView.hidden = NO;
        self.searchContent = text;
        [self headRefresh];
    }
}

- (void)didRightItemJumpPage {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)historyView {
    if (!_historyView) {
        _historyView = [[UIView alloc] init];
        UIView *titleView = [self historyTitleView];
        [_historyView addSubview:titleView];
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(_historyView);
            make.height.mas_equalTo(35.0f);
        }];
        [_historyView addSubview:self.historyTableView];
        [self.historyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(_historyView);
            make.top.equalTo(titleView.mas_bottom);
        }];
    }
    return _historyView;
}

- (UIView *)historyTitleView {
    UIView *titleView = [[UIView alloc] init];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"搜索历史";
    titleLabel.font = kFontPingFangSCRegular(15.0f);
    titleLabel.textColor = JL_color_gray_101010;
    [titleView addSubview:titleLabel];
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearBtn setTitle:@"清除" forState:UIControlStateNormal];
    [clearBtn setTitleColor:JL_color_gray_606060 forState:UIControlStateNormal];
    clearBtn.titleLabel.font = kFontPingFangSCRegular(13.0f);
    [clearBtn edgeTouchAreaWithTop:10.0f right:10.0f bottom:10.0f left:10.0f];
    [clearBtn addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
    ViewBorderRadius(clearBtn, 10.0f, 1.0f, JL_color_gray_CBCBCB);
    [titleView addSubview:clearBtn];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17.0f);
        make.top.mas_equalTo(17.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20.0f);
        make.bottom.equalTo(titleLabel);
        make.width.mas_equalTo(37.0f);
        make.height.mas_equalTo(20.0f);
    }];
    
    return titleView;
}

- (void)clearBtnClick {
    [self.searchHistoryArray removeAllObjects];
    YYCache *cache = [[YYCache alloc] initWithName:JLSearchHistoryName];
    [cache setObject:self.searchHistoryArray forKey:JLSearchHistory];
    [self.historyTableView reloadData];
}

- (UITableView *)historyTableView {
    if (!_historyTableView) {
        _historyTableView = [[UITableView alloc] initWithFrame:self.historyView.frame style:UITableViewStylePlain];
        _historyTableView.dataSource = self;
        _historyTableView.delegate = self;
        _historyTableView.backgroundColor = JL_color_white_ffffff;
        _historyTableView.tableFooterView = [UIView new];
        _historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_historyTableView registerClass:[JLSearchHIstoryTableViewCell class] forCellReuseIdentifier:@"JLSearchHIstoryTableViewCell"];
    }
    return _historyTableView;
}

- (UICollectionView *)resultCollectionView {
    if (!_resultCollectionView) {
        WS(weakSelf)
        UICollectionWaterLayout *layout = [UICollectionWaterLayout layoutWithColoumn:2 data:self.searchResultArray verticleMin:0.0f horizonMin:26.0f leftMargin:15.0f rightMargin:15.0f];
        
        _resultCollectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
        _resultCollectionView.backgroundColor = JL_color_white_ffffff;
        _resultCollectionView.delegate = self;
        _resultCollectionView.dataSource = self;
        [_resultCollectionView registerClass:[JLCategoryWorkCollectionViewCell class] forCellWithReuseIdentifier:@"JLCategoryWorkCollectionViewCell"];
        _resultCollectionView.hidden = YES;
        _resultCollectionView.mj_footer = [JLRefreshFooter footerWithRefreshingBlock:^{
            [weakSelf footRefresh];
        }];
    }
    return _resultCollectionView;
}


#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchHistoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    JLSearchHIstoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLSearchHIstoryTableViewCell" forIndexPath:indexPath];
    cell.historyContent = self.searchHistoryArray[indexPath.row];
    cell.deleteBlock = ^{
        [weakSelf deleteHistory:indexPath];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *content = self.searchHistoryArray[indexPath.row];
    [self.searchHistoryArray removeObjectAtIndex:indexPath.row];
    [self cacheSearchContent:content];
    [self.searchBarView setSearchText:content];

    self.historyTableView.hidden = YES;
    self.resultCollectionView.hidden = NO;
    self.searchContent = content;
    [self headRefresh];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.searchResultArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JLCategoryWorkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JLCategoryWorkCollectionViewCell" forIndexPath:indexPath];
    cell.artDetailData = self.searchResultArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Model_art_Detail_Data *artDetailData = self.searchResultArray[indexPath.row];
    JLArtDetailViewController *artDetailVC = [[JLArtDetailViewController alloc] init];
    artDetailVC.artDetailType = [artDetailData.author.ID isEqualToString:[AppSingleton sharedAppSingleton].userBody.ID] ? JLArtDetailTypeSelfOrOffShelf : JLArtDetailTypeDetail;
    artDetailVC.artDetailData = artDetailData;
    [self.navigationController pushViewController:artDetailVC animated:YES];
}

- (JLNormalEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[JLNormalEmptyView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height - KTouch_Responder_Height)];
    }
    return _emptyView;
}

- (void)headRefresh {
    self.currentPage = 1;
    self.resultCollectionView.mj_footer.hidden = YES;
    [self requestSearchList];
}

- (void)footRefresh {
    self.currentPage++;
    [self requestSearchList];
}

- (void)endRefresh:(NSArray*)collectionArray {
    if (collectionArray.count < kPageSize) {
        self.resultCollectionView.mj_footer.hidden = NO;
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

#pragma mark 请求搜索数据
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

@end
