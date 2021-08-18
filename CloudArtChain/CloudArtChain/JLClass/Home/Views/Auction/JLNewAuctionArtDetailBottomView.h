//
//  JLNewAuctionArtDetailBottomView.h
//  CloudArtChain
//
//  Created by jielian on 2021/7/19.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JLNewAuctionArtDetailBottomViewStatus) {
    /// 未开始
    JLNewAuctionArtDetailBottomViewStatusNotStarted,
    /// 取消拍卖
    JLNewAuctionArtDetailBottomViewStatusCancelAuction,
    /// 缴纳保证金
    JLNewAuctionArtDetailBottomViewStatusPayEarnestMoney,
    /// 出价
    JLNewAuctionArtDetailBottomViewStatusOffer,
    /// 中标支付
    JLNewAuctionArtDetailBottomViewStatusWinBidding,
    /// 已结束
    JLNewAuctionArtDetailBottomViewStatusFinished
};

@protocol JLNewAuctionArtDetailBottomViewDelegate <NSObject>

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

@end

@interface JLNewAuctionArtDetailBottomView : UIView

@property (nonatomic, weak) id<JLNewAuctionArtDetailBottomViewDelegate> delegate;

@property (nonatomic, strong) Model_auctions_Data *auctionsData;

@end

NS_ASSUME_NONNULL_END
