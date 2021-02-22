//
//  UIAlertController+Alert.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLCustomPickerView.h"
#import "IQActionSheetPickerView.h"
#import "JLAlertSheetControl.h"
#import "JLCustomDatePickerView.h"

@interface UIAlertController (Alert)

/** 点击选项按钮回调 */
@property (nonatomic, copy) void(^selectedIndexBlock)(NSInteger selectedIndex);
/** 点击底部按钮回调 */
@property (nonatomic, copy) void(^bottomClickBlock)(NSInteger selectedIndex);

/**
 定制化AlertView
 
 @param title 标题
 @param message 信息
 @param confirmTitle 确定按钮
 @return UIAlertController
 */
+ (UIAlertController *)alertShowWithTitle:(NSString *)title message:(NSString *)message confirm:(NSString *)confirmTitle;

/**
 定制化AlertView
 
 @param title 标题
 @param message 信息
 @param confirmTitle 确定按钮
 @param handler 确定回调
 @return UIAlertController
 */
+ (UIAlertController *)alertShowWithTitle:(NSString *)title message:(NSString *)message confirm:(NSString *)confirmTitle confirmHandler:(void (^)(void))handler;

/**
 定制化AlertView
 
 @param title 标题
 @param message 信息
 @param cancelTitle 取消按钮
 @param cancelHandler 取消回调
 @param confirmTitle 确定按钮
 @param handler 确定回调
 @return UIAlertController
 */
+ (UIAlertController *)alertShowWithTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancelTitle cancelHandler:(void (^)(void))cancelHandler confirm:(NSString *)confirmTitle confirmHandler:(void (^)(void))handler;


/**
 定制化AlertView 按钮位置调换，确定在左取消在右
 
 @param title 标题
 @param message 信息
 @param confirmTitle 确定按钮
 @param handler 确定回调
 @return UIAlertController
 */
+ (UIAlertController *)alertShowReverseButtonTitle:(NSString *)title message:(NSString *)message confirm:(NSString *)confirmTitle confirmHandler:(void (^)(void))handler;


/**
 定制化AlertView 按钮位置调换，确定在左取消在右

 @param title 标题
 @param message 信息
 @param confirmTitle 确定按钮
 @param handler 确定回调
 @param cancelTitle 取消按钮
 @param cancelHandler 取消回调
 @return UIAlertController
 */
+ (UIAlertController *)alertShowReverseButtonTitle:(NSString *)title message:(NSString *)message confirm:(NSString *)confirmTitle confirmHandler:(void (^)(void))handler cancel:(NSString *)cancelTitle cancelHandler:(void (^)(void))cancelHandler;


/**
 定制化AlertView
 
 @param title 标题
 @param message 信息
 @param cancelTitle 取消按钮
 @param cancelHandler 取消回调
 @param isDestructive 是否具有该样式
 @param confirmTitle 确定按钮
 @param handler 确定回调
 @return UIAlertController
 */
+ (UIAlertController *)alertShowWithTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancelTitle cancelHandler:(void (^)(void))cancelHandler isDestructive:(BOOL)isDestructive confirm:(NSString *)confirmTitle confirmHandler:(void (^)(void))handler;



/**
 定制化actionSheet（不带标题）
 
 @param buttonTitleArray 选择框数组
 @param handler 回调事件
 @return UIAlertController
 */
+ (UIAlertController *)actionSheetWithButtonTitleArray:(NSArray *)buttonTitleArray handler:(void (^)(NSInteger index))handler;//不带标题


/**
 定制化actionSheet
 
 @param title 标题
 @param buttonTitleArray 选择框数组
 @param handler 回调事件
 @return UIAlertController
 */
+ (UIAlertController *)actionSheetWithTitle:(NSString *)title buttonTitleArray:(NSArray *)buttonTitleArray handler:(void (^)(NSInteger index))handler;

/**
 定制化actionSheet

 @param title 标题
 @param buttonTitleArray 选择框数组
 @param handler 回调事件
 @param cancelHandler 取消回调事件
 @return UIAlertController
 */
+ (UIAlertController *)actionSheetWithTitle:(NSString *)title buttonTitleArray:(NSArray *)buttonTitleArray handler:(void (^)(NSInteger index))handler cancelHandler:(void (^)(void))cancelHandler;



/**
 自定义文字选择控件
 
 @param title 标题
 @param comonents 每行显示的数据
 @param selectTitles 选中的数据
 @param defaultTitles 界面上选中的值（可以为空）
 @param changedBlock 改变中的回调
 @param selectedBlock 选择完成回调
 */
+ (void)pickTextViewWithWithTitle:(NSString *)title
                  titlesForComponents:(NSArray *)components
                         selectTitles:(NSArray *)selectTitles
                        defaultTitles:(NSArray *)defaultTitles
                         changedBlock:(void(^)(IQActionSheetPickerView *pickerView,NSInteger row,NSInteger component))changedBlock
                        selectedBlock:(void(^)(IQActionSheetPickerView *pickerView,NSArray<NSString *> *titles))selectedBlock;



/**
 自定义时间选择控件
 
 @param title 标题
 @param pickerViewStyle 选择器类型   非WYCustomPickerViewStyleTextPicker类型
 @param selectDate 选中的时间
 @param defaultDate 界面上默认时间
 @param maximumDate 最大时间
 @param minimumDate 最小时间
 @param selectedDateBlock 选择完时间回调
 */
+ (void)pickDateViewWithWithTitle:(NSString *)title
                customPickerViewStyle:(JLCustomPickerViewStyle)pickerViewStyle
                           selectDate:(NSDate *)selectDate
                          defaultDate:(NSDate *)defaultDate
                          maximumDate:(NSDate *)maximumDate
                          minimumDate:(NSDate *)minimumDate
                    selectedDateBlock:(void(^)(IQActionSheetPickerView *pickerView,NSDate *date))selectedDateBlock;


/// 自定义时间选择控件
/// @param defaultDate 默认时间
/// @param minDate 最小时间
/// @param maxDate 最大时间
/// @param type 类型
/// @param selectedDateBlock 选择完时间回调
+ (void)customDatePickerWithDefaultDate:(NSDate *)defaultDate
                                minDate:(NSDate *)minDate
                                maxDate:(NSDate *)maxDate
                                   type:(JLCustomDateType)type
                      selectedDateBlock:(void(^)(NSDate *date))selectedDateBlock;


/**
 设置设备的开关机时间
 
 @param title 标题
 @param resetTitle 当选中该标题时，需要重置相同的标题
 @param selectTitles 选中的数据
 @param defaultTitles 界面上选中的值（可以为空）
 @param selectedDateBlock 选择完成回调
 */
+ (void)setTimePickeWithTitle:(NSString *)title
                       resetTitle:(NSString *)resetTitle
                     selectTitles:(NSArray *)selectTitles
                    defaultTitles:(NSArray *)defaultTitles
                selectedDateBlock:(void(^)(IQActionSheetPickerView *pickerView,NSArray<NSString *> *titles))selectedDateBlock;




/// 提示视图
/// @param title 标题
/// @param optionTitle 选择标题
/// @param optionBlock 点击选择
/// @param cancelTitle 取消标题
/// @param cancelBlock 点击取消
+ (void)actionSheetNoticeWithTitle:(NSString *)title
                       optionTitle:(NSString *)optionTitle
                       optionBlock:(void(^)(void))optionBlock
                       cancelTitle:(NSString *)cancelTitle
                       cancelBlock:(void(^)(void))cancelBlock;

/**
 删除的模态视图
 
 @param deleteBlock 删除回调
 */
+ (void)actionSheetDeleteWithDeleteBlock:(void(^)(void))deleteBlock;

/**
 没有选中项的多选模态视图
 
 @param options 选项
 @param selectedIndexBlock 选项卡点击回调
 */
+ (void)actionSheetWithOptions:(NSArray *)options
          selectedIndexBlock:(void(^)(NSInteger selectedIndex))selectedIndexBlock;

/**
模态视图

@param type 类型 删除的选项为红色
@param title 标题
@param options 选项
@param selectedIndexBlock 选项卡点击回调
@param bottomClickBlock 底部按钮点击回调
*/
+ (JLAlertSheetControl *)actionSheetWithType:(AlertSheetControlType)type
                                       title:(NSString *)title
                                     options:(NSArray *)options
                          selectedIndexBlock:(void(^)(NSInteger selectedIndex))selectedIndexBlock
                            bottomClickBlock:(void(^)(void))bottomClickBlock;

/**
 模态视图
 
 @param type 类型 删除的选项为红色
 @param title 标题
 @param options 选项
 @param curSelectedIndex 当前选中的标题(超过数组长度默认不选中)
 @param selectedIndexBlock 选项卡点击回调
 @param bottomClickBlock 底部按钮点击回调
 */
+ (JLAlertSheetControl *)actionSheetWithType:(AlertSheetControlType)type
                    title:(NSString *)title
                  options:(NSArray *)options
         curSelectedIndex:(NSInteger)curSelectedIndex
       selectedIndexBlock:(void(^)(NSInteger selectedIndex))selectedIndexBlock
         bottomClickBlock:(void(^)(void))bottomClickBlock;

@end
