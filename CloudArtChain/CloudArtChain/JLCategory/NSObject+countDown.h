//
//  UIView+countDown.h
//  Rfinex
//
//  Created by 曾进宗 on 2018/12/14.
//  Copyright © 2018 HuaXinBlockChain(Shenyang)Tech. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (countDown)

//重写倒计时
- (void)countDownTime:(NSInteger)duration;

/**
 * 倒计时结束的回调
 */
@property (nonatomic, copy) void(^otc_timeStoppedCallback)(void);

/**
 设置倒计时的间隔和倒计时文案
 @param duration 倒计时时间
 */
- (void)otc_countDownWithTimeInterval:(NSTimeInterval)duration;

/**
 * invalidate timer
 */
- (void)otc_cancelTimer;

//关闭定时器
- (void)otc_closeTime;

@end


