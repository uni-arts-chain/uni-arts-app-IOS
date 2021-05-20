//
//  JLOrderDetailProductTableViewCell.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/29.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLOrderDetailViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLOrderDetailProductTableViewCell : UITableViewCell
- (void)setOrderData:(Model_arts_sold_Data *)orderData orderDetailType:(JLOrderDetailType)orderDetailType;
@end

NS_ASSUME_NONNULL_END
