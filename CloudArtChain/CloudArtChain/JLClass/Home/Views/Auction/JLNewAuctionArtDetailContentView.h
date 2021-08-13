//
//  JLNewAuctionArtDetailContentView.h
//  CloudArtChain
//
//  Created by jielian on 2021/7/19.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLBaseView.h"
#import "JLNewAuctionArtDetailBottomView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JLNewAuctionArtDetailContentViewDelegate <NSObject>

/// 刷新数据
- (void)refreshData;

/// 喜欢
/// @param isLike 是否喜欢
/// @param artId 艺术品id
- (void)like: (BOOL)isLike artId: (NSString *)artId;

/// 踩
/// @param isTread 是否踩
/// @param artId 艺术品id
- (void)tread: (BOOL)isTread artId: (NSString *)artId;

/// 收藏
/// @param isCollect 是否收藏
/// @param artId 艺术品id
- (void)collected: (BOOL)isCollect artId: (NSString *)artId;

/// 右侧按钮点击事件
/// @param status 取消拍卖/缴纳保证金/出价/中标支付
- (void)doneStatus: (JLNewAuctionArtDetailBottomViewStatus)status;

/// 播放视频
/// @param videoUrl 视频url
- (void)playVideo: (NSString *)videoUrl;

/// 查看图片或live2d
/// @param artDetailData 艺术品信息
/// @param currentIndex 当前图片索引
- (void)lookPageFlow: (Model_art_Detail_Data *)artDetailData currentIndex: (NSInteger)currentIndex;

/// 竞拍须知
- (void)auctionRule;

/// 查看更多出价列表
- (void)offerRecordList: (NSArray *)bidHistoryArray;

/// 查看作者信息
/// @param authorData 作者信息
/// @param isSelf 是否是自己
- (void)lookCreaterHomePage: (Model_art_author_Data *)authorData isSelf: (BOOL)isSelf;

/// 查看作品信息图片
/// @param imageArray 图片数组
/// @param currentIndex 当前图片索引
- (void)lookInfoImage: (NSArray *)imageArray currentIndex: (NSInteger)currentIndex;

@end

@interface JLNewAuctionArtDetailContentView : UIView

@property (nonatomic, weak) id<JLNewAuctionArtDetailContentViewDelegate> delegate;

@property (nonatomic, strong) Model_auctions_Data *auctionsData;

@property (nonatomic, copy) NSArray *bidHistoryArray;

@end

NS_ASSUME_NONNULL_END
