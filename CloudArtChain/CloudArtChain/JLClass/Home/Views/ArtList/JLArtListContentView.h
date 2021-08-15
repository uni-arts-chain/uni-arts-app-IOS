//
//  JLArtListContentView.h
//  CloudArtChain
//
//  Created by jielian on 2021/8/13.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JLArtListContentViewDelegate <NSObject>

/// 下拉刷新数据
- (void)refreshDatas;
/// 上拉加载更多数据
- (void)loadMoreDatas;

/// 查看艺术品详情
/// @param artDetailData 艺术品信息
- (void)lookArtDetail: (Model_art_Detail_Data *)artDetailData;

/// 查看拍卖详情
/// @param auctionId 拍卖id
- (void)lookAuctionDetail: (NSString *)auctionId;

- (void)scrollViewDidScrollContentOffset: (CGPoint)contentOffset;

@end

@interface JLArtListContentView : UIView

@property (nonatomic, weak) id<JLArtListContentViewDelegate> delegate;
/// 类型
@property (nonatomic, assign) JLArtListType type;
/// 是否需要上下拉刷新
@property (nonatomic, assign) BOOL isNeedRefresh;
/// 滑动视图距离上边距
@property (nonatomic, assign) CGFloat topInset;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, copy) NSArray *dataArray;

@property (nonatomic, assign) CGFloat contentOffsetY;

@end

NS_ASSUME_NONNULL_END
