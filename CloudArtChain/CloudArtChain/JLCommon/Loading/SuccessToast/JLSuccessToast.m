//
//  JLSuccessToast.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLSuccessToast.h"

@interface JLSuccessToast()
/** 弹窗视图 */
@property (nonatomic, strong) UIView *alertView;
/** 提示文字 */
@property (nonatomic, strong) NSString *message;
/** 停留时间 */
@property (nonatomic, assign) NSTimeInterval duration;
/** 隐藏回调 */
@property (nonatomic, copy) void (^hidedBlock)(void);
@end

@implementation JLSuccessToast
+ (JLSuccessToast *)successToastWithMessage:(NSString *)msg duration:(NSTimeInterval)duration hidedBlock:(void(^)(void))hidedBlock {
    JLSuccessToast *toast = [[JLSuccessToast alloc] initWithMessage:msg duration:duration hidedBlock:hidedBlock];
    return toast;
}

- (instancetype)initWithMessage:(NSString *)msg duration:(NSTimeInterval)duration hidedBlock:(void(^)(void))hidedBlock {
    self = [super init];
    if (self) {
        _message = msg;
        _duration = duration;
        _hidedBlock = hidedBlock;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    CGFloat messageWidth = [JLTool getAdaptionSizeWithText:self.message labelHeight:22 font:kFontPingFangSCRegular(16)].width;
    
    if (messageWidth > kScreenWidth / 2 - 32) {
        messageWidth = kScreenWidth / 2 - 32;
    }
    if (messageWidth < 128 - 32) {
        messageWidth = 128 - 32;
    }
    
    self.frame = CGRectMake((kScreenWidth - messageWidth - 32) / 2, (kScreenHeight - messageWidth - 32) / 2, messageWidth + 32, messageWidth + 32);
    
    UIView *alertView = [[UIView alloc] initWithFrame:self.bounds];
    alertView.alpha = 0;
    self.alertView = alertView;
    alertView.backgroundColor = [JL_color_gray_333333 colorWithAlphaComponent:0.9];
    alertView.layer.cornerRadius = 8;
    alertView.layer.masksToBounds = YES;
    [self addSubview:alertView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((alertView.frameWidth - 36) / 2, 28 * messageWidth / 128, 36, 36)];
    iconImageView.image = [UIImage imageNamed:@"ic_sucess"];
    [alertView addSubview:iconImageView];
    
    
    CGFloat messageHeight = [JLTool getAdaptionSizeWithText:self.message labelWidth:messageWidth  font:kFontPingFangSCRegular(16)].height;
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = self.message;
    messageLabel.font = kFontPingFangSCRegular(16);
    messageLabel.textColor = JL_color_white_ffffff;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.frame = CGRectMake(16, iconImageView.frameBottom + 12 * messageWidth / 128, messageWidth, messageHeight);
    [alertView addSubview:messageLabel];
}

- (void)showWithAnimation {
    [UIView animateWithDuration:0.4 animations:^{
        self.alertView.alpha = 1;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hideWithAnimation) withObject:nil
                   afterDelay:self.duration];
    }];
}

- (void)hideWithAnimation {
    [UIView animateWithDuration:0.4 animations:^{
        self.alertView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.hidedBlock) {
            self.hidedBlock();
        }
    }];
}
@end
