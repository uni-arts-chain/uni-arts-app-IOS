//
//  UIAlertController+Alert.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "UIAlertController+Alert.h"

@implementation UIAlertController (Alert)

+ (UIAlertController *)alertShowWithTitle:(NSString *)title message:(NSString *)message confirm:(NSString *)confirmTitle {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleCancel handler:nil];
    [okAction setValue:JL_color_gray_101010 forKey:@"_titleTextColor"];
    [alert addAction:okAction];
    return alert;
}

+ (UIAlertController *)alertShowWithTitle:(NSString *)title message:(NSString *)message confirm:(NSString *)confirmTitle confirmHandler:(void (^)(void))handler {
    return [self alertShowWithTitle:title message:message cancel:@"取消" cancelHandler:nil confirm:confirmTitle confirmHandler:handler];
}

+ (UIAlertController *)alertShowWithTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancelTitle cancelHandler:(void (^)(void))cancelHandler confirm:(NSString *)confirmTitle confirmHandler:(void (^)(void))handler {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (cancelHandler){
                cancelHandler();
            }
        }];
        
        [cancelAction setValue:JL_color_gray_101010 forKey:@"_titleTextColor"];
        [alertVC addAction:cancelAction];
    }
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler();
        }
    }];
    [okAction setValue:JL_color_gray_101010 forKey:@"_titleTextColor"];
    [alertVC addAction:okAction];
    
    return alertVC;
}

+ (UIAlertController *)alertShowReverseButtonTitle:(NSString *)title message:(NSString *)message confirm:(NSString *)confirmTitle confirmHandler:(void (^)(void))handler {
    return [self alertShowReverseButtonTitle:title message:message confirm:confirmTitle confirmHandler:handler cancel:@"取消" cancelHandler:nil];
}

//按钮位置调换，确定在左取消在右
+ (UIAlertController *)alertShowReverseButtonTitle:(NSString *)title message:(NSString *)message confirm:(NSString *)confirmTitle confirmHandler:(void (^)(void))handler cancel:(NSString *)cancelTitle cancelHandler:(void (^)(void))cancelHandler {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler();
        }
    }];
    [okAction setValue:JL_color_gray_101010 forKey:@"_titleTextColor"];
    [alertVC addAction:okAction];
    //UIAlertActionStyleCancel样式总是显示在左侧，与添加按钮的顺序无关
    
    if (cancelTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (cancelHandler){
                cancelHandler();
            }
        }];
        [cancelAction setValue:JL_color_gray_101010 forKey:@"_titleTextColor"];
        [alertVC addAction:cancelAction];
    }
    return alertVC;
}

+ (UIAlertController *)alertShowWithTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancelTitle cancelHandler:(void (^)(void))cancelHandler isDestructive:(BOOL)isDestructive confirm:(NSString *)confirmTitle confirmHandler:(void (^)(void))handler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (cancelTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelHandler){
                cancelHandler();
            }
        }];
        [cancelAction setValue:JL_color_gray_101010 forKey:@"_titleTextColor"];
        [alert addAction:cancelAction];
    }
    UIAlertAction *otherAction;
    if (isDestructive) {
        otherAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (handler) {
                handler();
            }
        }];
    }else{
        otherAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (handler) {
                handler();
            }
            
        }];
        [otherAction setValue:JL_color_gray_101010 forKey:@"_titleTextColor"];
    }
    [alert addAction:otherAction];
    return alert;
}

#pragma mark UIAlertControllerStyleActionSheet
+ (UIAlertController *)actionSheetWithButtonTitleArray:(NSArray *)buttonTitleArray handler:(void (^)(NSInteger index))handler {
    return [self actionSheetWithTitle:nil buttonTitleArray:buttonTitleArray handler:handler];
}

+ (UIAlertController *)actionSheetWithTitle:(NSString *)title buttonTitleArray:(NSArray *)buttonTitleArray handler:(void (^)(NSInteger index))handler {
    return [self actionSheetWithTitle:title buttonTitleArray:buttonTitleArray handler:handler cancelHandler:nil];
}

+ (UIAlertController *)actionSheetWithTitle:(NSString *)title
                           buttonTitleArray:(NSArray *)buttonTitleArray
                                    handler:(void (^)(NSInteger index))handler
                              cancelHandler:(void (^)(void))cancelHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if (title.length > 0) {
        alert.title = title;
    }
    for (NSInteger i = 0; i < buttonTitleArray.count; i++) {
        NSString *buttonTitle = buttonTitleArray[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            handler(i);
        }];
        [action setValue:JL_color_mainColor forKey:@"_titleTextColor"];
        [alert addAction:action];
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (cancelHandler) {
            cancelHandler();
        }
    }];
    [cancel setValue:JL_color_mainColor forKey:@"_titleTextColor"];
    [alert addAction:cancel];
    
    //UILabel *appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
    //[appearanceLabel setAppearanceFont:[UIFont systemFontOfSize:16]];
    return alert;
}

#pragma mark 自定义选择控件
+ (void)pickTextViewWithWithTitle:(NSString *)title
                  titlesForComponents:(NSArray *)components
                         selectTitles:(NSArray *)selectTitles
                        defaultTitles:(NSArray *)defaultTitles
                         changedBlock:(void(^)(IQActionSheetPickerView *pickerView,NSInteger row,NSInteger component))changedBlock
                        selectedBlock:(void(^)(IQActionSheetPickerView *pickerView,NSArray<NSString *> *titles))selectedBlock {
    
    JLCustomPickerView *pickerView = [[JLCustomPickerView alloc] initWithTitle:title customPickerViewStyle:JLCustomPickerViewStyleTextPicker titlesForComponents:components selectTitles:selectTitles changedBlock:changedBlock selectedBlock:^(IQActionSheetPickerView *pickView, NSArray<NSString *> *titles) {
        //若修改的话，才进行回调
        if (![defaultTitles isEqual:titles]) {
            if (selectedBlock) {
                selectedBlock(pickView,titles);
            }
        }
    } selectedDateBlock:nil];
    [pickerView showPickerView];
}

#pragma mark 自定义时间选择控件
+ (void)pickDateViewWithWithTitle:(NSString *)title
                customPickerViewStyle:(JLCustomPickerViewStyle)pickerViewStyle
                           selectDate:(NSDate *)selectDate
                          defaultDate:(NSDate *)defaultDate
                          maximumDate:(NSDate *)maximumDate
                          minimumDate:(NSDate *)minimumDate
                    selectedDateBlock:(void(^)(IQActionSheetPickerView *pickerView,NSDate *date))selectedDateBlock {
    
    JLCustomPickerView *pickerView = [[JLCustomPickerView alloc] initWithTitle:title customPickerViewStyle:pickerViewStyle titlesForComponents:@[] selectTitles:@[] changedBlock:nil selectedBlock:nil selectedDateBlock:^(IQActionSheetPickerView *pickView, NSDate *date) {
        if (![defaultDate isEqualToDate:date]) {
            if (selectedDateBlock) {
                selectedDateBlock(pickView,date);
            }
        }
    }];
    
    if (selectDate) {
        pickerView.selectDate = selectDate;
    }
    if (maximumDate) {
        pickerView.maximumDate = maximumDate;
    }
    if (minimumDate) {
        pickerView.minimumDate = minimumDate;
    }
    [pickerView showPickerView];
}

#pragma mark 展示日期选择器

+ (void)customDatePickerWithDefaultDate:(NSDate *)defaultDate
                                minDate:(NSDate *)minDate
                                maxDate:(NSDate *)maxDate
                                   type:(JLCustomDateType)type
                      selectedDateBlock:(void(^)(NSDate *date))selectedDateBlock {
    JLCustomDatePickerView *pickView = [[JLCustomDatePickerView alloc] initWithMinDate:minDate maxDate:maxDate defaultDate:defaultDate type:type];
    pickView.selectDateBlock = selectedDateBlock;
    [KMainWindow addSubview:pickView];
    [pickView showWithAnimation:nil];
}

#pragma mark 设置设备的开关机时间
+ (void)setTimePickeWithTitle:(NSString *)title
                       resetTitle:(NSString *)resetTitle
                     selectTitles:(NSArray *)selectTitles
                    defaultTitles:(NSArray *)defaultTitles
                selectedDateBlock:(void(^)(IQActionSheetPickerView *pickerView,NSArray<NSString *> *titles))selectedDateBlock {
    NSMutableArray *hoursArray = [[NSMutableArray alloc] init];
    [hoursArray addObject:resetTitle];
    for (NSInteger i = 0; i < 24; i++) {
        [hoursArray addObject:[NSString stringWithFormat:@"%02ld",(long)i]];
    }
    NSMutableArray *minutesArray = [[NSMutableArray alloc] init];
    [minutesArray addObject:resetTitle];
    for (NSInteger j = 0; j < 60; j++) {
        [minutesArray addObject:[NSString stringWithFormat:@"%02ld",(long)j]];
    }
    
    [self pickTextViewWithWithTitle:title titlesForComponents:@[hoursArray,minutesArray] selectTitles:selectTitles defaultTitles:defaultTitles changedBlock:^(IQActionSheetPickerView *pickerView, NSInteger row, NSInteger component) {
        if (row == 0) {
            pickerView.selectedTitles = @[resetTitle, resetTitle];
        } else if ([pickerView.selectedTitles containsObject:resetTitle]) {
            if (component == 0) {
                pickerView.selectedTitles = @[pickerView.selectedTitles[0], pickerView.titlesForComponents[1][1]];
            } else {
                pickerView.selectedTitles = @[pickerView.titlesForComponents[0][1], pickerView.selectedTitles[1]];
            }
        }
    } selectedBlock:selectedDateBlock];
}


#pragma mark 模态视图

+ (void)actionSheetNoticeWithTitle:(NSString *)title
                       optionTitle:(NSString *)optionTitle
                       optionBlock:(void(^)(void))optionBlock
                       cancelTitle:(NSString *)cancelTitle
                       cancelBlock:(void(^)(void))cancelBlock; {
    JLAlertSheetControl *sheetControl = [JLAlertSheetControl alertSheetWithType:AlertSheetControlTypeOptionChoice title:title options:@[optionTitle] bottomBtns:@[cancelTitle] curSelectedIndex:1 selectedIndexBlock:^(NSInteger selectedIndex) {
        if (optionBlock) {
            optionBlock();
        }
    } bottomClickBlock:^(NSInteger selectedIndex) {
        if (cancelBlock) {
            cancelBlock();
        }
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:sheetControl];
    [sheetControl showWithAnimation:nil];
}

+ (void)actionSheetDeleteWithDeleteBlock:(void(^)(void))deleteBlock {
    [self actionSheetWithType:AlertSheetControlTypeDeleteNotice title:@"确认删除？" options:@[@"确定"] curSelectedIndex:2 selectedIndexBlock:^(NSInteger selectedIndex) {
        if (deleteBlock) {
            deleteBlock();
        }
    } bottomClickBlock:nil];
}

+ (void)actionSheetWithOptions:(NSArray *)options
          selectedIndexBlock:(void(^)(NSInteger selectedIndex))selectedIndexBlock {
    [self actionSheetWithType:AlertSheetControlTypeOptionChoice title:nil options:options curSelectedIndex:options.count + 1 selectedIndexBlock:selectedIndexBlock bottomClickBlock:nil];
}

+ (JLAlertSheetControl *)actionSheetWithType:(AlertSheetControlType)type
                                       title:(NSString *)title
                                     options:(NSArray *)options
                          selectedIndexBlock:(void(^)(NSInteger selectedIndex))selectedIndexBlock
                            bottomClickBlock:(void(^)(void))bottomClickBlock {
    return [UIAlertController actionSheetWithType:type title:title options:options curSelectedIndex:options.count selectedIndexBlock:selectedIndexBlock bottomClickBlock:bottomClickBlock];
}

+ (JLAlertSheetControl *)actionSheetWithType:(AlertSheetControlType)type
                    title:(NSString *)title
                  options:(NSArray *)options
         curSelectedIndex:(NSInteger)curSelectedIndex
       selectedIndexBlock:(void(^)(NSInteger selectedIndex))selectedIndexBlock
         bottomClickBlock:(void(^)(void))bottomClickBlock {
    JLAlertSheetControl *sheetControl = [JLAlertSheetControl alertSheetWithType:type title:title options:options bottomBtns:@[@"取消"] curSelectedIndex:curSelectedIndex selectedIndexBlock:selectedIndexBlock bottomClickBlock:^(NSInteger selectedIndex) {
        if (bottomClickBlock) {
            bottomClickBlock();
        }
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:sheetControl];
    [sheetControl showWithAnimation:nil];
    return sheetControl;
}
@end
