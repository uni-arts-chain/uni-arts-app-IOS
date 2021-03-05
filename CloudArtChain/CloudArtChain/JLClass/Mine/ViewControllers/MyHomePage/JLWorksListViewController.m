//
//  JLWorksListViewController.m
//  CloudArtChain
//
//  Created by 花田半亩 on 2020/9/6.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLWorksListViewController.h"

#import "JLWorkListBaseTableViewCell.h"
#import "JLWorkListListedCell.h"
#import "JLWorkListNotListCell.h"
#import "JLWorkListSelfBuyCell.h"
#import "JLNormalEmptyView.h"

@interface JLWorksListViewController ()<UITableViewDelegate,UITableViewDataSource,JLPagetableViewRequestDelegate>
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *artsArray;
@end

@implementation JLWorksListViewController

-  (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [self headRefresh];
}

- (void)viewDidAppear:(BOOL)animated {
    
}

//这里是必须存在的方法 传递tableView的偏移量
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.tableView.scrollViewDidScroll) {
        self.tableView.scrollViewDidScroll(self.tableView);
    }
}

- (void)JLPagetableView:(JLPagetableView *)JLPagetableView requestFailed:(NSError *)error {
    
}

- (void)JLPagetableView:(JLPagetableView *)JLPagetableView isPullDown:(BOOL)PullDown SuccessData:(id)SuccessData {
    //处理返回的SuccessData 数据之后刷新table
    [self.tableView reloadData];
}

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.artsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    if (self.workListType == JLWorkListTypeListed) {
        JLWorkListListedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLWorkListListedCell" forIndexPath:indexPath];
        cell.artDetailData = self.artsArray[indexPath.row];
        cell.offFromListBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
            [[JLViewControllerTool appDelegate].walletTool cancelSellOrderCallWithCollectionId:artDetailData.collection_id.intValue itemId:artDetailData.item_id.intValue block:^(BOOL success, NSString * _Nonnull message) {
                if (success) {
                    [[JLViewControllerTool appDelegate].walletTool authorizeWithAnimated:YES cancellable:YES with:^(BOOL success) {
                        if (success) {
                            [[JLViewControllerTool appDelegate].walletTool cancelSellOrderConfirmWithCallbackBlock:^(BOOL success, NSString * _Nullable message) {
                                if (success) {
                                    [weakSelf.artsArray removeObjectAtIndex:indexPath.row];
                                    [weakSelf.tableView reloadData];
                                    [[JLLoading sharedLoading] showMBSuccessTipMessage:@"下架成功" hideTime:KToastDismissDelayTimeInterval];
                                    if (weakSelf.offFromListBlock) {
                                        weakSelf.offFromListBlock(artDetailData);
                                    }
                                } else {
                                    [[JLLoading sharedLoading] showMBFailedTipMessage:message hideTime:KToastDismissDelayTimeInterval];
                                }
                            }];
                        }
                    }];
                } else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:message hideTime:KToastDismissDelayTimeInterval];
                }
            }];
        };
        cell.applyAddCertBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
            if (weakSelf.applyAddCertBlock) {
                weakSelf.applyAddCertBlock(artDetailData);
            }
        };
        return cell;
    } else if (self.workListType == JLWorkListTypeNotList) {
        JLWorkListNotListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLWorkListNotListCell" forIndexPath:indexPath];
        cell.artDetailData = self.artsArray[indexPath.row];
        [cell setArtDetail:self.artsArray[indexPath.row]];
        cell.addToListBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
            [[JLViewControllerTool appDelegate].walletTool sellOrderCallWithCollectionId:artDetailData.collection_id.intValue itemId:artDetailData.item_id.intValue price:artDetailData.price block:^(BOOL success, NSString * _Nonnull message) {
                if (success) {
                    [[JLViewControllerTool appDelegate].walletTool authorizeWithAnimated:YES cancellable:YES with:^(BOOL success) {
                        if (success) {
                            [[JLViewControllerTool appDelegate].walletTool sellOrderConfirmWithCallbackBlock:^(BOOL success, NSString * _Nullable message) {
                                if (success) {
                                    [weakSelf.artsArray removeObjectAtIndex:indexPath.row];
                                    [weakSelf.tableView reloadData];
                                    [[JLLoading sharedLoading] showMBSuccessTipMessage:@"上架成功" hideTime:KToastDismissDelayTimeInterval];
                                    if (weakSelf.addToListBlock) {
                                        weakSelf.addToListBlock(artDetailData);
                                    }
                                } else {
                                    [[JLLoading sharedLoading] showMBFailedTipMessage:message hideTime:KToastDismissDelayTimeInterval];
                                }
                            }];
                        }
                    }];
                } else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:message hideTime:KToastDismissDelayTimeInterval];
                }
            }];
        };
        return cell;
    }
    JLWorkListBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLWorkListBaseTableViewCell" forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.artDetailBlock) {
        self.artDetailBlock(self.artsArray[indexPath.row]);
    }
}

- (JLPagetableView *)tableView {
    if (!_tableView) {
        WS(weakSelf)
        _tableView = [[JLPagetableView alloc]initWithFrame:CGRectZero];
        _tableView.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height - 40.0f - KStatusBar_Navigation_Height - 47.0f - KTouch_Responder_Height);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0.0f;
        _tableView.estimatedSectionHeaderHeight = 0.0f;
        _tableView.estimatedSectionFooterHeight = 0.0f;
        _tableView.RequestDelegate = self;
        //table是否有刷新
        _tableView.isHasHeaderRefresh = NO;
        _tableView.emptyView.hintText = @"暂无数据";
        _tableView.emptyView.hintTextFont = kFontPingFangSCRegular(15.0f);
        _tableView.emptyView.hintTextColor = JL_color_gray_BBBBBB;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[JLWorkListBaseTableViewCell class] forCellReuseIdentifier:@"JLWorkListBaseTableViewCell"];
        [_tableView registerClass:[JLWorkListListedCell class] forCellReuseIdentifier:@"JLWorkListListedCell"];
        [_tableView registerClass:[JLWorkListNotListCell class] forCellReuseIdentifier:@"JLWorkListNotListCell"];
        [_tableView registerClass:[JLWorkListSelfBuyCell class] forCellReuseIdentifier:@"JLWorkListSelfBuyCell"];
        _tableView.mj_footer = [JLRefreshFooter footerWithRefreshingBlock:^{
            [weakSelf footRefresh];
        }];
    }
    return _tableView;
}

- (void)requestMineArtList {
    WS(weakSelf)
    Model_arts_mine_Req *request = [[Model_arts_mine_Req alloc] init];
    request.page = self.currentPage;
    request.per_page = kPageSize;
    request.aasm_state = self.workListType == JLWorkListTypeListed ? @"bidding,auctioning" : @"prepare,online";
    Model_arts_mine_Rsp *response = [[Model_arts_mine_Rsp alloc] init];
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            if (weakSelf.currentPage == 1) {
                [weakSelf.artsArray removeAllObjects];
            }
            [weakSelf.artsArray addObjectsFromArray:response.body];

            [weakSelf endRefresh:response.body];
            [self.tableView reloadData];
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)headRefresh {
    self.currentPage = 1;
    self.tableView.mj_footer.hidden = YES;
    [self requestMineArtList];
}

- (void)footRefresh {
    self.currentPage++;
    [self requestMineArtList];
}

- (void)endRefresh:(NSArray*)artsArray {
    if (artsArray.count < kPageSize) {
        self.tableView.mj_footer.hidden = NO;
        [(JLRefreshFooter *)self.tableView.mj_footer endWithNoMoreDataNotice];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (NSMutableArray *)artsArray {
    if (!_artsArray) {
        _artsArray = [NSMutableArray array];
    }
    return _artsArray;
}

- (void)addToBiddingList:(Model_art_Detail_Data *)artDetailData {
    [self.artsArray insertObject:artDetailData atIndex:0];
    [self.tableView reloadData];
}

- (void)offFromBiddingList:(Model_art_Detail_Data *)artDetailData {
    [self.artsArray insertObject:artDetailData atIndex:0];
    [self.tableView reloadData];
}
@end
