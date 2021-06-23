//
//  JLOrderDetailContentView.h
//  CloudArtChain
//
//  Created by jielian on 2021/6/21.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLOrderDetailViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLOrderDetailContentView : UIView

@property (nonatomic, assign) JLOrderDetailType orderDetailType;

@property (nonatomic, strong) Model_arts_sold_Data *orderData;

@end

NS_ASSUME_NONNULL_END
