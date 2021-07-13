//
//  JLArtDetailSellingTableViewCell.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/23.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLArtDetailSellingTableViewCell : UITableViewCell
@property (nonatomic, strong) Model_arts_id_orders_Data *sellingOrderData;
@property (nonatomic, copy) void(^lookUserInfoBlock)(Model_arts_id_orders_Data *sellingOrderData);
@property (nonatomic, copy) void(^operationBlock)(Model_arts_id_orders_Data *sellingOrderData);
@end

NS_ASSUME_NONNULL_END
