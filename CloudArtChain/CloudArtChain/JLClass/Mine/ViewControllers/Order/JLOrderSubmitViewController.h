//
//  JLOrderSubmitViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/2.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLOrderSubmitViewController : JLBaseViewController
@property (nonatomic, strong) Model_art_Detail_Data *artDetailData;
@property (nonatomic, strong) Model_arts_id_orders_Data *sellingOrderData;
@property (nonatomic, copy) void(^buySuccessBlock)(JLOrderPayType payType, NSString *payUrl);
@end

NS_ASSUME_NONNULL_END
