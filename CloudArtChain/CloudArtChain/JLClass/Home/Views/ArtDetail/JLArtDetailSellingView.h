//
//  JLArtDetailSellingView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/23.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLArtDetailSellingView : JLBaseView
@property (nonatomic, strong) NSArray *sellingArray;
@property (nonatomic, copy) void(^offFromListBlock)(void);
@property (nonatomic, copy) void(^buyBlock)(Model_arts_id_orders_Data *sellOrderData);
@end

NS_ASSUME_NONNULL_END
