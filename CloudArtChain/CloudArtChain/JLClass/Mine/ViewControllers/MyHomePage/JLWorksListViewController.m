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

@property (nonatomic, strong) NSTimer *timer;
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
    if (self.workListType == JLWorkListTypeAuction) {
        [cell setAuctionsData:self.artsArray[indexPath.row]];
    }else {
        [cell setArtDetailData:self.artsArray[indexPath.row] type:self.workListType];
    }
    
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
        if (weakSelf.offFromListBlock) {
            weakSelf.offFromListBlock(artDetailData, weakSelf.workListType);
        }
//        if ([artDetailData.aasm_state isEqualToString:@"auctioning"]) {
//            [[JLViewControllerTool appDelegate].walletTool cancelAuctionCallWithCollectionId:artDetailData.collection_id.intValue itemId:artDetailData.item_id.intValue block:^(BOOL success, NSString * _Nonnull message) {
//                if (success) {
//                    [[JLViewControllerTool appDelegate].walletTool authorizeWithAnimated:YES cancellable:YES with:^(BOOL success) {
//                        if (success) {
//                            [[JLViewControllerTool appDelegate].walletTool cancelAuctionCallConfirmWithCallbackBlock:^(BOOL success, NSString * _Nullable message) {
//                                if (success) {
//                                    [weakSelf.artsArray removeObjectAtIndex:indexPath.row];
//                                    [weakSelf.collectionView reloadData];
//                                    [[JLLoading sharedLoading] showMBSuccessTipMessage:@"取消拍卖成功" hideTime:KToastDismissDelayTimeInterval];
//                                    artDetailData.aasm_state = @"online";
//                                    if (weakSelf.offFromListBlock) {
//                                        weakSelf.offFromListBlock(artDetailData);
//                                    }
//                                } else {
//                                    [[JLLoading sharedLoading] showMBFailedTipMessage:message hideTime:KToastDismissDelayTimeInterval];
//                                }
//                            }];
//                        }
//                    }];
//                } else {
//                    [[JLLoading sharedLoading] showMBFailedTipMessage:message hideTime:KToastDismissDelayTimeInterval];
//                }
//            }];
//        } else {
//            [[JLViewControllerTool appDelegate].walletTool cancelSellOrderCallWithCollectionId:artDetailData.collection_id.intValue itemId:artDetailData.item_id.intValue block:^(BOOL success, NSString * _Nonnull message) {
//                if (success) {
//                    [[JLViewControllerTool appDelegate].walletTool authorizeWithAnimated:YES cancellable:YES with:^(BOOL success) {
//                        if (success) {
//                            [[JLViewControllerTool appDelegate].walletTool cancelSellOrderConfirmWithCallbackBlock:^(BOOL success, NSString * _Nullable message) {
//                                if (success) {
//                                    [weakSelf.artsArray removeObjectAtIndex:indexPath.row];
//                                    [weakSelf.collectionView reloadData];
//                                    [[JLLoading sharedLoading] showMBSuccessTipMessage:@"下架成功" hideTime:KToastDismissDelayTimeInterval];
//                                    if (weakSelf.offFromListBlock) {
//                                        weakSelf.offFromListBlock(artDetailData);
//                                    }
//                                } else {
//                                    [[JLLoading sharedLoading] showMBFailedTipMessage:message hideTime:KToastDismissDelayTimeInterval];
//                                }
//                            }];
//                        }
//                    }];
//                } else {
//                    [[JLLoading sharedLoading] showMBFailedTipMessage:message hideTime:KToastDismissDelayTimeInterval];
//                }
//            }];
//        }
    };
    cell.transferBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
        if (weakSelf.transferBlock) {
            weakSelf.transferBlock(artDetailData);
        }
    };
    cell.auctionBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
        if (weakSelf.auctionBlock) {
            weakSelf.auctionBlock(artDetailData);
        }
    };
    cell.cancelAuctionBlock = ^(Model_auctions_Data * _Nonnull auctionsData) {
        [JLAlertView alertWithTitle:@"提示" message:@"是否确认取消拍卖？" doneTitle:@"确认" cancelTitle:@"取消" done:^{
            [weakSelf cancelAuction:auctionsData];
        } cancel:nil];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [cell layoutSubviews];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.workListType == JLWorkListTypeAuction) {
        if (self.lookAuctionDetailBlock) {
            self.lookAuctionDetailBlock(self.artsArray[indexPath.row]);
        }
    }else {
        if (self.artDetailBlock) {
            self.artDetailBlock(self.artsArray[indexPath.row], self.workListType);
        }
    }
}

- (JLPagetableCollectionView *)collectionView {
    if (!_collectionView) {
        WS(weakSelf)
        BOOL isAuction = NO;
        if (self.workListType == JLWorkListTypeAuction) {
            isAuction = YES;
        }
        JLHomePageCollectionWaterLayout *layout = [JLHomePageCollectionWaterLayout layoutWithColoumn:2 data:self.artsArray verticleMin:14.0f horizonMin:14.0f leftMargin:15.0f rightMargin:15.0f isAuction:isAuction];
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
        _collectionView.scrollViewDidScroll = ^(UIScrollView *scrollView) {
            
        };
    }
    return _collectionView;
}

- (void)createTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    WS(weakSelf)
    self.timer = [NSTimer jl_scheduledTimerWithTimeInterval:1.0 block:^{
        [weakSelf handleTimer];
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

- (void)handleTimer {
    for (int i = 0; i < self.artsArray.count; i++) {
        Model_auctions_Data *model = self.artsArray[i];
        model.server_timestamp = @(model.server_timestamp.integerValue + 1).stringValue;
    }
    [self.collectionView reloadData];
}

- (void)requestMineArtList {
    WS(weakSelf)
    Model_arts_mine_Req *request = [[Model_arts_mine_Req alloc] init];
    request.page = self.currentPage;
    request.per_page = kPageSize;
    request.aasm_state = self.workListType == JLWorkListTypeListed ? @"bidding" : @"online";
    Model_arts_mine_Rsp *response = [[Model_arts_mine_Rsp alloc] init];
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            if (weakSelf.currentPage == 1) {
                [weakSelf.artsArray removeAllObjects];
            }
            [weakSelf.artsArray addObjectsFromArray:response.body];
            [weakSelf endRefresh:response.body];
            [weakSelf.collectionView reloadData];
            [weakSelf setNoDataShow];
        } else {
            if (weakSelf.endRefreshBlock) {
                weakSelf.endRefreshBlock();
            }
            [weakSelf.collectionView.mj_footer endRefreshing];
        }
    }];
}

- (void)requestAuctionMineArtList {
    WS(weakSelf)
    Model_auctions_mine_Req *request = [[Model_auctions_mine_Req alloc] init];
    request.page = self.currentPage;
    request.per_page = kPageSize;
    Model_auctions_mine_Rsp *response = [[Model_auctions_mine_Rsp alloc] init];
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            if (weakSelf.currentPage == 1) {
                [weakSelf.artsArray removeAllObjects];
            }
            [weakSelf.artsArray addObjectsFromArray:response.body];
            [weakSelf endRefresh:response.body];
            [weakSelf.collectionView reloadData];
            [weakSelf setNoDataShow];
            
            [weakSelf createTimer];
        } else {
            if (weakSelf.endRefreshBlock) {
                weakSelf.endRefreshBlock();
            }
            [weakSelf.collectionView.mj_footer endRefreshing];
        }
    }];
}

// 取消拍卖
- (void)cancelAuction: (Model_auctions_Data *)auctionsData {
    Model_auctions_id_cancel_Req *request = [[Model_auctions_id_cancel_Req alloc] init];
    request.ID = auctionsData.ID;
    Model_auctions_id_cancel_Rsp *response = [[Model_auctions_id_cancel_Rsp alloc] init];
    response.request = request;
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            [[JLLoading sharedLoading] showMBSuccessTipMessage:@"已取消" hideTime:KToastDismissDelayTimeInterval];
            [[NSNotificationCenter defaultCenter] postNotificationName:LOCALNOTIFICATION_JL_CANCEL_AUCTION object:nil];
        }else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
        }
    }];
}

- (void)headRefresh {
    self.currentPage = 1;
    if (self.workListType == JLWorkListTypeAuction) {
        [self requestAuctionMineArtList];
    }else {
        [self requestMineArtList];
    }
}

- (void)footRefresh {
    self.currentPage++;
    if (self.workListType == JLWorkListTypeAuction) {
        [self requestAuctionMineArtList];
    }else {
        [self requestMineArtList];
    }
}

- (void)endRefresh:(NSArray*)artsArray {
    if (self.endRefreshBlock) {
        self.endRefreshBlock();
    }
    if (artsArray.count < kPageSize) {
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

- (void)dealloc
{
    NSLog(@"释放了: %@", self.class);
}
@end
