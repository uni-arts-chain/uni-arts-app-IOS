//
//  JLDownloadLoading.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLDownloadLoading : UIView

/**
 初始化
 
 @param view 需要展示的视图父视图
 @return 实例
 */
+ (JLDownloadLoading *)showLoadingWithView:(UIView *)view;

/**
 初始化

 @param view 需要展示的视图父视图
 @return 实例
 */
+ (JLDownloadLoading *)showLoadingWithView:(UIView *)view frame:(CGRect)frame;

/**
 隐藏loading视图
 */
- (void)hideLoading;

/**
 隐藏loading视图 并 移除视图
 */
- (void)hideLoadingWithRemove;

/**
 开始loading动画
 */
- (void)startLoading;

@end

NS_ASSUME_NONNULL_END
