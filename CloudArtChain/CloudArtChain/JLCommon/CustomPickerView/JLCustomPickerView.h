//
//  JLCustomPickerView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//
#import <UIKit/UIKit.h>
@class IQActionSheetPickerView;

typedef NS_ENUM(NSUInteger, JLCustomPickerViewStyle) {
    
    JLCustomPickerViewStyleTextPicker,/** 自定义文字选择器 */

    JLCustomPickerViewStyleDatePicker, /** 自定义日期选择器(yyyy-MM-dd) */
    
    JLCustomPickerViewStyleDateTimePicker, /** 自定义日期和时间选择器 (MM月dd日 周几 HH:mm)*/
    
    JLCustomPickerViewStyleTimePicker, /** 自定义时间选择器(HH:mm) */
};


/**
 改变中回调

 @param pickView 选择视图
 @param row 某一列
 @param component 某一行
 */
typedef void (^ChangedBlock)(IQActionSheetPickerView *pickView,NSInteger row,NSInteger component);


/**
 完成回调

 @param pickView 选择视图
 @param titles 选中的数据
 */
typedef void (^SelectedTitlesBlock)(IQActionSheetPickerView *pickView,NSArray<NSString *> *titles);


/**
 完成回调
 
 @param pickView 选择视图
 @param date 选中的时间
 */
typedef void (^SelectedDateBlock)(IQActionSheetPickerView *pickView,NSDate *date);

@interface JLCustomPickerView : UIControl

/**
 初始化方法

 @param title 标题
 @param pickerViewStyle 选择器类型
 @param comonents 每一列显示的数据
 @param selectTitles 选中的数据
 @param changedBlock 改变中的回调
 @param selectedBlock 选择完成的回调
 @return 视图
 */
- (instancetype)initWithTitle:(NSString *)title
        customPickerViewStyle:(JLCustomPickerViewStyle)pickerViewStyle
          titlesForComponents:(NSArray *)comonents
                 selectTitles:(NSArray *)selectTitles
                 changedBlock:(ChangedBlock)changedBlock
                selectedBlock:(SelectedTitlesBlock)selectedBlock
            selectedDateBlock:(SelectedDateBlock)selectedDateBlock;


/*!
 选中的时间 (not animated).
 */
@property(nullable, nonatomic, assign) NSDate *selectDate; //get/set date.


/*!
 设置的最小时间 Default is nil.
 */
@property (nullable, nonatomic, retain) NSDate *minimumDate;

/*!
 设置的最大时间. Default is nil.
 */
@property (nullable, nonatomic, retain) NSDate *maximumDate;


/**
 动画展示pickView
 */
- (void)showPickerView;

@end


