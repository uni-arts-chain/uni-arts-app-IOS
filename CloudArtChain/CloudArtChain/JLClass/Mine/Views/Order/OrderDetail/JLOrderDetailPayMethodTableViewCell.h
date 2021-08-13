//
//  JLOrderDetailPayMethodTableViewCell.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/15.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLOrderDetailPayMethodTableViewCell : UITableViewCell
/// 现金账户余额
@property (nonatomic, copy) NSString *cashAccountBalance;
/// 当前需要购买的总金额
@property (nonatomic, copy) NSString *buyTotalPrice;
/// 当前选择的支付方式
@property (nonatomic, assign) JLOrderPayTypeName payType;
@property (nonatomic, copy) void(^selectedMethodBlock)(JLOrderPayTypeName payType);
@end

NS_ASSUME_NONNULL_END
