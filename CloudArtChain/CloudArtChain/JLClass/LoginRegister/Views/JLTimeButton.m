//
//  JLTimeButton.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLTimeButton.h"
#import "NSObject+countDown.h"

@implementation JLTimeButton

#pragma mark 发送验证码倒计时
- (void)startCountDown {
    WS(weakSelf)
    self.enabled = NO;
    [self otc_countDownWithTimeInterval:60];
    self.otc_timeStoppedCallback = ^{
        weakSelf.enabled = YES;
        [weakSelf setTitle:@"获取验证码" forState:UIControlStateNormal];
    };
}

#pragma mark 重写倒计时
- (void)countDownTime:(NSInteger)duration {
    [self setTitle:[NSString stringWithFormat:@"%lds", (long)duration] forState:UIControlStateDisabled];
}
@end
