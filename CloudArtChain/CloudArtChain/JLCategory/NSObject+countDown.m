//
//  UIView+countDown.m
//  Rfinex
//
//  Created by 曾进宗 on 2018/12/14.
//  Copyright © 2018 HuaXinBlockChain(Shenyang)Tech. All rights reserved.
//

#import "NSObject+countDown.h"
#import <objc/runtime.h>

@interface NSObject ()

@property (nonatomic, assign) NSTimeInterval leaveTime;
@property (nonatomic, strong) dispatch_source_t timer;

@end

static NSString * const ktimer = @"timer";
static NSString * const kleaveTime = @"leaveTime";
static NSString * const kOtc_timeStoppedCallback = @"otc_timeStoppedCallback";

@implementation NSObject (countDown)

- (void)setTimer:(dispatch_source_t)timer {
    [self willChangeValueForKey:ktimer];
    objc_setAssociatedObject(self, &ktimer,
                             timer,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:ktimer];
}

- (dispatch_source_t)timer {
    return objc_getAssociatedObject(self, &ktimer);
}

- (void)setLeaveTime:(NSTimeInterval)leaveTime {
    [self willChangeValueForKey:kleaveTime];
    objc_setAssociatedObject(self, &kleaveTime,
                             @(leaveTime),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kleaveTime];
}

- (NSTimeInterval)leaveTime {
    return [objc_getAssociatedObject(self, &kleaveTime) doubleValue];
}

- (void)setOtc_timeStoppedCallback:(void (^)(void))otc_timeStoppedCallback
{
    [self willChangeValueForKey:kOtc_timeStoppedCallback];
    objc_setAssociatedObject(self, &kOtc_timeStoppedCallback,
                             otc_timeStoppedCallback,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kOtc_timeStoppedCallback];
    
}

- (void (^)(void))otc_timeStoppedCallback {
    return objc_getAssociatedObject(self, &kOtc_timeStoppedCallback);
}

#pragma mark - 设置函数
- (void)otc_countDownWithTimeInterval:(NSTimeInterval)duration{
    [self otc_closeTime];
    if (duration<0) {
        return;
    }
    __block NSInteger timeOut = duration; //倒计时时间
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(self.timer,DISPATCH_TIME_NOW,1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(self.timer, ^{
        if (timeOut <= 0) { // 倒计时结束，关闭
            [weakSelf otc_cancelTimer];
        } else {
            timeOut--;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf countDownTime:timeOut];
            });
        }
    });
    dispatch_resume(self.timer);
}

- (void)otc_cancelTimer {
    dispatch_source_cancel(self.timer);
    self.timer = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        // 设置界面的按钮显示 根据自己需求设置
        if (self.otc_timeStoppedCallback) { self.otc_timeStoppedCallback(); }
    });
}

- (void)otc_closeTime
{
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

- (void)countDownTime:(NSInteger)duration
{
    
}

/// 获取顶层的窗口
- (UIWindow *)getTopLevelWindow {
    UIWindow *topView = [UIApplication sharedApplication].keyWindow;
    for (UIWindow *win in [[UIApplication sharedApplication].windows  reverseObjectEnumerator]) {
        if ([win isEqual: topView]) {
            continue;
        }
        if (win.windowLevel > topView.windowLevel && win.hidden != YES ) {
            topView =win;
        }
    }
    return topView;
}
@end
