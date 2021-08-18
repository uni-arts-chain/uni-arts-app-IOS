//
//  JLAuctionSubmitOrderContentBottomView.h
//  CloudArtChain
//
//  Created by jielian on 2021/8/17.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JLAuctionSubmitOrderContentBottomViewPayBlock)(NSString *payMoney);

@interface JLAuctionSubmitOrderContentBottomView : UIView

@property (nonatomic, copy) NSString *payMoney;

@property (nonatomic, copy) JLAuctionSubmitOrderContentBottomViewPayBlock payBlock;

@end

NS_ASSUME_NONNULL_END
