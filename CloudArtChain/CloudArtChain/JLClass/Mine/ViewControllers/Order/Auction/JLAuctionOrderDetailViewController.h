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

/// 订单编号
@property (nonatomic, copy) NSString *orderNo;

@end

NS_ASSUME_NONNULL_END
