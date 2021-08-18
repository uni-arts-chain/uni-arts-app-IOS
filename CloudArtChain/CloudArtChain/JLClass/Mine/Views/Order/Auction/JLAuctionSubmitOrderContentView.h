//
//  JLAuctionSubmitOrderContentView.h
//  CloudArtChain
//
//  Created by jielian on 2021/8/17.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JLAuctionSubmitOrderContentViewDelegate <NSObject>
/// 刷新数据
- (void)refreshData;
/// 超时未支付
- (void)overduePayment;
/// 支付订单
/// @param payType 支付方式
/// @param money 付款金额
- (void)payOrder: (JLOrderPayTypeName)payType money:(NSString *)money;

@end

@interface JLAuctionSubmitOrderContentView : UIView

@property (nonatomic, weak) id<JLAuctionSubmitOrderContentViewDelegate> delegate;

- (void)setAuctionsData:(Model_auctions_Data *)auctionsData cashAccountBalance: (NSString *)cashAccountBalance;

@end

NS_ASSUME_NONNULL_END
