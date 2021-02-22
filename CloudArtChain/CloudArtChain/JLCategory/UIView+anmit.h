//
//  UIView+anmit.h
//  Rfinex
//
//  Created by 曾进宗 on 2018/8/17.
//  Copyright © 2018年 HuaXinBlockChain(Shenyang)Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (anmit)

- (void)showWithAlert:(UIView*)alert;

- (void)dismissAlert;

- (void)otc_dismiss:(void(^)(void))complete;

@end
