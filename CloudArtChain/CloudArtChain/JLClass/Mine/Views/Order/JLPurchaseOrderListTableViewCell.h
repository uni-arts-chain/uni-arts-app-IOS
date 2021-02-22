//
//  JLPurchaseOrderListTableViewCell.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/20.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLPurchaseOrderListTableViewCell : UITableViewCell
@property (nonatomic, assign) JLPurchaseOrderState state;
@property (nonatomic, copy) void(^cancelOrderBlock)(void);
@property (nonatomic, copy) void(^orderPayBlock)(void);
@property (nonatomic, copy) void(^logisticsBlock)(void);
@property (nonatomic, copy) void(^receiveBlock)(void);
@end

NS_ASSUME_NONNULL_END
