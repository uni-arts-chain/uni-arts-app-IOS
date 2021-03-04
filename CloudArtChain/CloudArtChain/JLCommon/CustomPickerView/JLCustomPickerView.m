//
//  JLCustomPickerView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLCustomPickerView.h"
#import "IQActionSheetPickerView.h"

@interface JLCustomPickerView()<IQActionSheetPickerViewDelegate>

/** 改变中回调 */
@property (nonatomic, copy)ChangedBlock changedBlock;
/** 选择完数据后回调 */
@property (nonatomic, copy)SelectedTitlesBlock selectedBlock;
/** 选择完时间后回调 */
@property (nonatomic, copy)SelectedDateBlock selectedDateBlock;
/** 选择器实例 */
@property (nonatomic, strong)IQActionSheetPickerView *pickView;

@end

@implementation JLCustomPickerView

- (instancetype)initWithTitle:(NSString *)title
        customPickerViewStyle:(JLCustomPickerViewStyle)pickerViewStyle
          titlesForComponents:(NSArray *)comonents
                 selectTitles:(NSArray *)selectTitles
                 changedBlock:(ChangedBlock)changedBlock
                selectedBlock:(SelectedTitlesBlock)selectedBlock
            selectedDateBlock:(SelectedDateBlock)selectedDateBlock
{
    self = [super init];
    if (self) {
        self.changedBlock = changedBlock;
        self.selectedBlock = selectedBlock;
        self.selectedDateBlock = selectedDateBlock;
        [self setupUIWithTitle:title customPickerViewStyle:pickerViewStyle titlesForComponents:comonents selectTitles:selectTitles];
    }
    return self;
}



/**
 初始化视图

 @param title 标题
 @param pickerViewStyle 选择器类型
 @param comonents 每行的显示内容
 @param selectTitles 每行选中的内容
 */
- (void)setupUIWithTitle:(NSString *)title
   customPickerViewStyle:(JLCustomPickerViewStyle)pickerViewStyle
     titlesForComponents:(NSArray *)comonents
            selectTitles:(NSArray *)selectTitles {
    //初始化选择控制器
    if (pickerViewStyle == JLCustomPickerViewStyleTextPicker) {
        IQActionSheetPickerView *pickView = [[IQActionSheetPickerView alloc] initWithTitle:title delegate:self];
        self.pickView = pickView;
        pickView.actionSheetPickerStyle = IQActionSheetPickerStyleTextPicker;
        pickView.titlesForComponents = comonents;
        pickView.actionToolbar.tintColor = JL_color_gray_101010;//按钮文字颜色
        pickView.actionToolbar.titleButton.titleColor = [UIColor blackColor];//title字体颜色
        pickView.actionToolbar.titleButton.titleFont = kFontPingFangSCRegular(17);//title字体大小
        pickView.actionToolbar.barTintColor = JL_color_white_ffffff;//背景色
        pickView.actionToolbar.backgroundColor = JL_color_white_ffffff;
        pickView.selectedTitles = selectTitles;//选中的数组
        [self addSubview:pickView];

    }else{
        
        IQActionSheetPickerView *pickView = [[IQActionSheetPickerView alloc] initWithTitle:title delegate:self];
        self.pickView = pickView;
        if (pickerViewStyle == JLCustomPickerViewStyleDatePicker) {
            pickView.actionSheetPickerStyle = IQActionSheetPickerStyleDatePicker;

        }else if (pickerViewStyle == JLCustomPickerViewStyleDateTimePicker){
            pickView.actionSheetPickerStyle = IQActionSheetPickerStyleDateTimePicker;

        }else{
            pickView.actionSheetPickerStyle = IQActionSheetPickerStyleTimePicker;
        }
        
        pickView.actionToolbar.tintColor = JL_color_gray_101010;//按钮文字颜色
        pickView.actionToolbar.titleButton.titleColor = [UIColor blackColor];//title字体颜色
        pickView.actionToolbar.titleButton.titleFont = kFontPingFangSCRegular(17);//title字体大小
        pickView.actionToolbar.barTintColor = JL_color_white_ffffff;//背景色
        pickView.actionToolbar.backgroundColor = JL_color_white_ffffff;
        [self addSubview:pickView];
    }
    
}


- (void)setSelectDate:(NSDate *)selectDate{
    self.pickView.date = selectDate;
}

- (void)setMinimumDate:(NSDate *)minimumDate{
    self.pickView.minimumDate = minimumDate;
}

- (void)setMaximumDate:(NSDate *)maximumDate{
    self.pickView.maximumDate = maximumDate;
}


/**
 动画展示pickView
 */
- (void)showPickerView {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.pickView show];
}

#pragma mark IQActionSheetPickerViewDelegate
- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray<NSString *> *)titles {
    //选择完成的回调
    if (self.selectedBlock) {
        self.selectedBlock(pickerView, titles);
    }
}

- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didChangeRow:(NSInteger)row inComponent:(NSInteger)component {
    //改变中的回调
    if (self.changedBlock) {
        self.changedBlock(pickerView, row, component);
    }
}

- (void)actionSheetPickerViewDidCancel:(IQActionSheetPickerView *)pickerView{
    [self removeFromSuperview];
}

- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate *)date{
    if (self.selectedDateBlock) {
        self.selectedDateBlock(pickerView, date);
    }
}


@end
