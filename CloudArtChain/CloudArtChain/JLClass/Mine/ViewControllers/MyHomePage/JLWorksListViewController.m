//
//  JLWorksListViewController.m
//  CloudArtChain
//
//  Created by 花田半亩 on 2020/9/6.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLWorksListViewController.h"

//#import "JLWorkListBaseTableViewCell.h"
//#import "JLWorkListListedCell.h"
//#import "JLWorkListNotListCell.h"
//#import "JLWorkListSelfBuyCell.h"
#import "JLHomePageCollectionViewCell.h"
#import "JLNormalEmptyView.h"

#import "JLHomePageCollectionWaterLayout.h"

@interface JLWorksListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, JLPagetableCollectionViewRequestDelegate>
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *artsArray;
@property (nonatomic, strong) JLNormalEmptyView *emptyView;
@end

@implementation JLWorksListViewController

-  (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    
    [self headRefresh];
}

- (void)viewDidAppear:(BOOL)animated {
    
}

//这里是必须存在的方法 传递tableView的偏移量
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.collectionView.scrollViewDidScroll) {
        self.collectionView.scrollViewDidScroll(self.collectionView);
    }
}

- (void)JLPagetableCollectionView:(JLPagetableCollectionView *)JLPagetableView requestFailed:(NSError *)error {
    
}

- (void)JLPagetableCollectionView:(JLPagetableCollectionView *)JLPagetableView isPullDown:(BOOL)PullDown SuccessData:(id)SuccessData {
    //处理返回的SuccessData 数据之后刷新table
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.artsArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    JLHomePageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JLHomePageCollectionViewCell" forIndexPath:indexPath];
    [cell setArtDetailData:self.artsArray[0] type:self.workListType];
    
    cell.addToListBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
        if (weakSelf.sellBlock) {
            weakSelf.sellBlock(artDetailData);
        }
//        [[JLViewControllerTool appDelegate].walletTool sellOrderCallWithCollectionId:artDetailData.collection_id.intValue itemId:artDetailData.item_id.intValue price:artDetailData.price block:^(BOOL success, NSString * _Nonnull message) {
//            if (success) {
//                [[JLViewControllerTool appDelegate].walletTool authorizeWithAnimated:YES cancellable:YES with:^(BOOL success) {
//                    if (success) {
//                        [[JLViewControllerTool appDelegate].walletTool sellOrderConfirmWithCallbackBlock:^(BOOL success, NSString * _Nullable message) {
//                            if (success) {
//                                [weakSelf.artsArray removeObjectAtIndex:indexPath.row];
//                                [weakSelf.collectionView reloadData];
//                                [[JLLoading sharedLoading] showMBSuccessTipMessage:@"上架成功" hideTime:KToastDismissDelayTimeInterval];
//                                if (weakSelf.addToListBlock) {
//                                    weakSelf.addToListBlock(artDetailData);
//                                }
//                            } else {
//                                [[JLLoading sharedLoading] showMBFailedTipMessage:message hideTime:KToastDismissDelayTimeInterval];
//                            }
//                        }];
//                    }
//                }];
//            } else {
//                [[JLLoading sharedLoading] showMBFailedTipMessage:message hideTime:KToastDismissDelayTimeInterval];
//            }
//        }];
    };
    
    cell.offFromListBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
        if ([artDetailData.aasm_state isEqualToString:@"auctioning"]) {
            [[JLViewControllerTool appDelegate].walletTool cancelAuctionCallWithCollectionId:artDetailData.collection_id.intValue itemId:artDetailData.item_id.intValue block:^(BOOL success, NSString * _Nonnull message) {
                if (success) {
                    [[JLViewControllerTool appDelegate].walletTool authorizeWithAnimated:YES cancellable:YES with:^(BOOL success) {
                        if (success) {
                            [[JLViewControllerTool appDelegate].walletTool cancelAuctionCallConfirmWithCallbackBlock:^(BOOL success, NSString * _Nullable message) {
                                if (success) {
                                    [weakSelf.artsArray removeObjectAtIndex:indexPath.row];
                                    [weakSelf.collectionView reloadData];
                                    [[JLLoading sharedLoading] showMBSuccessTipMessage:@"取消拍卖成功" hideTime:KToastDismissDelayTimeInterval];
                                    artDetailData.aasm_state = @"online";
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
        } else {
            [[JLViewControllerTool appDelegate].walletTool cancelSellOrderCallWithCollectionId:artDetailData.collection_id.intValue itemId:artDetailData.item_id.intValue block:^(BOOL success, NSString * _Nonnull message) {
                if (success) {
                    [[JLViewControllerTool appDelegate].walletTool authorizeWithAnimated:YES cancellable:YES with:^(BOOL success) {
                        if (success) {
                            [[JLViewControllerTool appDelegate].walletTool cancelSellOrderConfirmWithCallbackBlock:^(BOOL success, NSString * _Nullable message) {
                                if (success) {
                                    [weakSelf.artsArray removeObjectAtIndex:indexPath.row];
                                    [weakSelf.collectionView reloadData];
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
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [cell layoutSubviews];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.artDetailBlock) {
        self.artDetailBlock(self.artsArray[indexPath.row]);
    }
}

- (JLPagetableCollectionView *)collectionView {
    if (!_collectionView) {
        WS(weakSelf)
        JLHomePageCollectionWaterLayout *layout = [JLHomePageCollectionWaterLayout layoutWithColoumn:2 data:self.artsArray verticleMin:14.0f horizonMin:14.0f leftMargin:15.0f rightMargin:15.0f];

        _collectionView = [[JLPagetableCollectionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight - KTouch_Responder_Height - KStatusBar_Navigation_Height - 47.0f - 40.0f) collectionViewLayout:layout];
        _collectionView.backgroundColor = JL_color_white_ffffff;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.isHasHeaderRefresh = NO;
        [_collectionView registerClass:[JLHomePageCollectionViewCell class] forCellWithReuseIdentifier:@"JLHomePageCollectionViewCell"];
        _collectionView.mj_footer = [JLRefreshFooter footerWithRefreshingBlock:^{
            [weakSelf footRefresh];
        }];
    }
    return _collectionView;
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
            [self.collectionView reloadData];
            [self setNoDataShow];
        } else {
            [weakSelf.collectionView.mj_footer endRefreshing];
        }
    }];
}

- (void)headRefresh {
    self.currentPage = 1;
    self.collectionView.mj_footer.hidden = YES;
    [self requestMineArtList];
}

- (void)footRefresh {
    self.currentPage++;
    [self requestMineArtList];
}

- (void)endRefresh:(NSArray*)artsArray {
    if (artsArray.count < kPageSize) {
        self.collectionView.mj_footer.hidden = NO;
        [(JLRefreshFooter *)self.collectionView.mj_footer endWithNoMoreDataNotice];
    } else {
        [self.collectionView.mj_footer endRefreshing];
    }
}

- (JLNormalEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[JLNormalEmptyView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height - KTouch_Responder_Height)];
    }
    return _emptyView;
}

- (void)setNoDataShow {
    if (self.artsArray.count == 0) {
        [self.collectionView addSubview:self.emptyView];
    } else {
        if (_emptyView) {
            [self.emptyView removeFromSuperview];
            self.emptyView = nil;
        }
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
    [self.collectionView reloadData];
}

- (void)offFromBiddingList:(Model_art_Detail_Data *)artDetailData {
    [self.artsArray insertObject:artDetailData atIndex:0];
    [self.collectionView reloadData];
}

- (void)launchAuctionFromNotList:(NSIndexPath *)indexPath {
    [self.artsArray removeObjectAtIndex:indexPath.row];
    [self.collectionView reloadData];
}
@end
