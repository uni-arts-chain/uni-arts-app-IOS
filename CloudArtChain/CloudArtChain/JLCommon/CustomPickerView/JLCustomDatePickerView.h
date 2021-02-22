//
//  JLCustomDatePickerView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,JLCustomDateType) {
    JLCustomDateTypeCustomTime = 0,/** MM月dd日 周几 HH:mm */
    JLCustomDateTypeHourAndMin = 1,/** HH mm */
};

@interface JLCustomDatePickerView : UIControl

/** 选择完成时间回调 */
@property (nonatomic, copy) void (^ _Nonnull selectDateBlock)(NSDate * _Nullable date);



/** 类型 */
@property (nonatomic, assign) JLCustomDateType type;


/// 初始化方法
/// @param minDate 最小时间
/// @param maxDate 最大时间
/// @param defaultDate 默认时间
/// @param type 类型
- (instancetype _Nonnull)initWithMinDate:(NSDate *_Nonnull)minDate maxDate:(NSDate *_Nonnull)maxDate defaultDate:(NSDate *_Nonnull)defaultDate type:(JLCustomDateType)type;

/**
 展示动画

 @param completed 动画结束回调
 */
- (void)showWithAnimation:(void(^_Nullable)(void))completed;

/**
 隐藏动画
 
 @param completed 动画结束回调
 */
- (void)hideWithAnimation:(void(^_Nonnull)(void))completed;
@end
