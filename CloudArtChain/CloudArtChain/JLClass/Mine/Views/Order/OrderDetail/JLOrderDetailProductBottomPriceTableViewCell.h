//
//  JLOrderDetailProductBottomPriceTableViewCell.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/4.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLOrderDetailProductBottomPriceTableViewCell : UITableViewCell
@property (nonatomic, copy) void(^totalPriceChangeBlock)(NSString *totalPrice, NSString *amount);

- (void)setArtDetailData:(Model_art_Detail_Data *)artDetailData sellingOrderData:(Model_arts_id_orders_Data *)sellingOrderData;
@end

NS_ASSUME_NONNULL_END
