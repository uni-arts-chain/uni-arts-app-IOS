//
//  JLBoxOneCardView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/21.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLBoxOneCardView : JLBaseView
@property (nonatomic, strong) Model_blind_box_orders_open_Data *cardData;
@property (nonatomic, copy) void(^closeBlock)(void);
@property (nonatomic, copy) void(^homepageBlock)(void);
@end

NS_ASSUME_NONNULL_END
