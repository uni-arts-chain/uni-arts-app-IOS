//
//  JLLoading.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//
//  loading 、tip管理类

#import <Foundation/Foundation.h>

@interface JLLoading : NSObject

/**
 单例对象

 @return 单例对象
 */
+ (JLLoading *)sharedLoading;


/**
 显示loading

 @param message 消息
 @param view loading显示在的视图
 */
- (void)showLoadingWithMessage:(NSString *)message onView:(UIView *)view;

/**
 显示视频图片下载loading
 
 @param view loading显示在其上面的view
 */
- (void)showDownloadLoadingOnView:(UIView *)view;

/// 显示刷新loading
/// @param view loading显示在其上面的view
- (void)showRefreshLoadingOnView:(UIView *)view;

/**
 隐藏loading
 */
- (void)hideLoading;


/**
 显示MBProgressHud样式成功提示

 @param msg 提示内容
 @param delaySecond 提示消失时间
 */
- (void)showMBSuccessTipMessage:(NSString *)msg hideTime:(NSTimeInterval)delaySecond;

/**
 显示MBProgressHud样式成功提示-带有隐藏回调

 @param msg 提示内容
 @param delaySecond 提示消失时间
 @param hidedblock 提示隐藏回调
 */
- (void)showMBSuccessTipMessage:(NSString *)msg hideTime:(NSTimeInterval)delaySecond hidedBlock:(void (^)(void))hidedblock;


/**
 显示MBProgressHud样式失败提示

 @param msg 提示内容
 @param delaySecond 提示消失时间
 */
- (void)showMBFailedTipMessage:(NSString *)msg hideTime:(NSTimeInterval)delaySecond;


/**
 显示MBProgressHud样式失败提示 - 带有隐藏回调

 @param msg 提示内容
 @param delaySecond 提示消失时间
 @param hidedblock 提示隐藏回调
 */
- (void)showMBFailedTipMessage:(NSString *)msg hideTime:(NSTimeInterval)delaySecond hidedBlock:(void (^)(void))hidedblock;


/**
 显示自定义成功提示 目前只支持一行文字的提示内容

 @param msg 提示内容
 @param view 显示在其上的视图
 @param hideTime 提示消失时间
 */
- (void)showJLSuccessTipMessage:(NSString *)msg onView:(UIView *)view hideTime:(NSTimeInterval)hideTime;

/**
 显示自定义成功提示带有隐藏后回调 目前只支持一行文字的提示内容

 @param msg 提示内容
 @param view 显示在其上的视图
 @param hideTime 提示消失时间
 @param hidedBlock 提示消失后回调
 */
- (void)showJLSuccessTipMessage:(NSString *)msg onView:(UIView *)view hideTime:(NSTimeInterval)hideTime hidedBlock:(void(^)(void))hidedBlock;


/**
 显示自定义失败提示 目前只支持一行文字的提示内容

 @param msg 提示内容
 @param view 显示在其上的视图
 @param hideTime 提示消失时间
 */
- (void)showJLFailedTipMessage:(NSString *)msg onView:(UIView *)view hideTime:(NSTimeInterval)hideTime;

/**
  显示自定义失败提示带有隐藏后回调 目前只支持一行文字的提示内容

 @param msg 提示内容
 @param view 显示在其上的视图
 @param hideTime 提示消失时间
 @param hidedBlock 提示消失后回调
 */
- (void)showJLFailedTipMessage:(NSString *)msg onView:(UIView *)view hideTime:(NSTimeInterval)hideTime hidedBlock:(void(^)(void))hidedBlock;


/**
 显示成功 icon + 文字提示
 
 @param msg 需要提示的文字
 @param duration 停留的时间
 */
- (void)showIconSuccessToastWithMessage:(NSString *)msg duration:(NSTimeInterval)duration;
/**
 显示成功 icon + 文字提示
 
 @param msg 需要提示的文字
 @param duration 停留的时间
 @param hidedBlock 隐藏回调
 */
- (void)showIconSuccessToastWithMessage:(NSString *)msg duration:(NSTimeInterval)duration hidedBlock:(void(^)(void))hidedBlock;


/// 进度显示
/// @param view 需要展示的视图（为nil 则默认是在window上）
/// @param msg 需要展示的消息
/// @param progress 进度
- (void)showProgressWithView:(UIView *)view message:(NSString *)msg progress:(CGFloat)progress;

@end
