//
//  JLSuccessToast.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLSuccessToast : UIControl
/**
 初始化

 @param msg 需要提示的文字
 @param duration 停留的时间
 @param hidedBlock 隐藏回调
 @return 实例
 */
+ (JLSuccessToast *)successToastWithMessage:(NSString *)msg duration:(NSTimeInterval)duration hidedBlock:(void(^)(void))hidedBlock;

/**
 展示动画
 */
- (void)showWithAnimation;

@end

NS_ASSUME_NONNULL_END
