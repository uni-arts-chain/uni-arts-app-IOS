//
//  JLOrderDetailViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/28.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBaseViewController.h"

typedef NS_ENUM(NSUInteger, JLOrderDetailType) {
    JLOrderDetailTypeBuy, /** 买入订单 */
    JLOrderDetailTypeSell, /** 卖出订单 */
};

NS_ASSUME_NONNULL_BEGIN

@interface JLOrderDetailViewController : JLBaseViewController
@property (nonatomic, assign) JLOrderDetailType orderDetailType;
@property (nonatomic, strong) Model_arts_sold_Data *orderData;
@end

NS_ASSUME_NONNULL_END
