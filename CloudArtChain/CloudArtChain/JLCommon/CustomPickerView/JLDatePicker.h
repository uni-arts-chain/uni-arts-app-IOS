//
//  JLDatePicker.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/17.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "NSDate+Extension.h"

/**
 *  弹出日期类型
 */
typedef enum{
    DateStyleShowYearMonthDayHourMinute  = 0,//年月日时分
    DateStyleShowMonthDayHourMinute,//月日时分
    DateStyleShowYearMonthDay,//年月日
    DateStyleShowYearMonth,//年月
    DateStyleShowMonthDay,//月日
    DateStyleShowHourMinute,//时分
    DateStyleShowYear,//年
    DateStyleShowMonth,//月
    DateStyleShowDayHourMinute,//日时分
}JLDateStyle;
typedef void(^doneBlock)(NSDate *);

@interface JLDatePicker : JLBaseView
/**
 *  限制最大时间（默认2099）datePicker大于最大日期则滚动回最大限制日期
 */
@property (nonatomic, retain) NSDate *maxLimitDate;
/**
 *  限制最小时间（默认0） datePicker小于最小日期则滚动回最小限制日期
 */
@property (nonatomic, retain) NSDate *minLimitDate;

/** 是否是新的ui样式 */
@property (nonatomic, assign) BOOL newStyle;


/**
 默认滚动到当前时间
 */
-(instancetype)initWithDateStyle:(JLDateStyle)datePickerStyle CompleteBlock:(void(^)(NSDate *))completeBlock;

/**
 滚动到指定的的日期
 */
-(instancetype)initWithDateStyle:(JLDateStyle)datePickerStyle scrollToDate:(NSDate *)scrollToDate CompleteBlock:(void(^)(NSDate *))completeBlock;

-(void)show;
@end


