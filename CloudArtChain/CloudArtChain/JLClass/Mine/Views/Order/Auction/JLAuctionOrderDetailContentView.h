//
//  JLAuctionOrderDetailContentView.h
//  CloudArtChain
//
//  Created by jielian on 2021/7/20.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JLAuctionOrderDetailContentViewDelegate <NSObject>

/// 支付
/// @param payMoney 待支付的价格
- (void)payOrder: (NSString *)payMoney;

/// 刷新数据
- (void)refreshData;

@end

@interface JLAuctionOrderDetailContentView : UIView

@property (nonatomic, weak) id<JLAuctionOrderDetailContentViewDelegate> delegate;

/// 订单类型
@property (nonatomic, assign) JLAuctionOrderType type;

@end

NS_ASSUME_NONNULL_END
