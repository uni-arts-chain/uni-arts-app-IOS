//
//  JLAuctionOrderDetailViewController.h
//  CloudArtChain
//
//  Created by jielian on 2021/7/20.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLAuctionOrderDetailViewController : JLBaseViewController

/// 订单类型
@property (nonatomic, assign) JLAuctionOrderType type;

@property (nonatomic, strong) Model_arts_sold_Data *orderData;

@end

NS_ASSUME_NONNULL_END
