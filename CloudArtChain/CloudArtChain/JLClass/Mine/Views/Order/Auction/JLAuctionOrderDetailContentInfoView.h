//
//  JLAuctionOrderDetailContentInfoView.h
//  CloudArtChain
//
//  Created by jielian on 2021/8/18.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLAuctionOrderDetailContentInfoView : UIView

/// 订单类型
@property (nonatomic, assign) JLAuctionOrderType type;

@property (nonatomic, strong) Model_auctions_Data *auctionsData;

@end

NS_ASSUME_NONNULL_END
