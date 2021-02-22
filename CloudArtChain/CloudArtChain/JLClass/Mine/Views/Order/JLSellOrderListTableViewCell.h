//
//  JLSellOrderListTableViewCell.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/20.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLSellOrderListTableViewCell : UITableViewCell
@property (nonatomic, assign) JLSellOrderState state;
@property (nonatomic, copy) void(^deliveringBlock)(void);
@property (nonatomic, copy) void(^logisticsBlock)(void);
@end

NS_ASSUME_NONNULL_END
