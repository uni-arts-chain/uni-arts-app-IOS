//
//  JLAuctionOrderDetailBottomView.h
//  CloudArtChain
//
//  Created by jielian on 2021/7/20.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JLAuctionOrderDetailBottomViewPayBlock)(NSString *payMoney);

@interface JLAuctionOrderDetailBottomView : UIView

@property (nonatomic, copy) NSString *payMoney;

@property (nonatomic, copy) JLAuctionOrderDetailBottomViewPayBlock payBlock;

@end

NS_ASSUME_NONNULL_END
