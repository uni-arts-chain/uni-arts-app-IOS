//
//  JLAuctionSubmitOrderContentPayTypeView.h
//  CloudArtChain
//
//  Created by jielian on 2021/8/17.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JLAuctionSubmitOrderContentPayTypeViewSelectedMethodBlock)(JLOrderPayTypeName payType);

@interface JLAuctionSubmitOrderContentPayTypeView : UIView

@property (nonatomic, copy) JLAuctionSubmitOrderContentPayTypeViewSelectedMethodBlock selectedMethodBlock;

- (void)setCashAccountBalance: (NSString *)cashAccountBalance payMoney: (NSString *)payMoney payType:(JLOrderPayTypeName)payType;

@end

NS_ASSUME_NONNULL_END
