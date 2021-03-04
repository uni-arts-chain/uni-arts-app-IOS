//
//  JLDatePicker.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/17.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLDatePicker.h"

#define MAXYEAR 2099
#define MINYEAR 1900
#define kPickerSize self.datePicker.frame.size

@interface JLDatePicker ()<UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate> {
    //日期存储数组
    NSMutableArray *_yearArray;
    NSMutableArray *_monthArray;
    NSMutableArray *_dayArray;
    NSMutableArray *_hourArray;
    NSMutableArray *_minuteArray;
    NSString *_dateFormatter;
    //记录位置
    NSInteger yearIndex;
    NSInteger monthIndex;
    NSInteger dayIndex;
    NSInteger hourIndex;
    NSInteger minuteIndex;
    
    NSInteger preRow;
    
    NSDate *_startDate;
}

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIButton *cancelButton;
@property (nonatomic,strong) UIButton *enterButton;
@property (nonatomic,strong) UILabel *endTime;
@property (nonatomic,strong) UIPickerView *datePicker;
@property (nonatomic,retain) NSDate *scrollToDate;//滚到指定日期
@property (nonatomic,assign) JLDateStyle datePickerStyle;
@property (nonatomic,strong) doneBlock doneBlock;
@end

@implementation JLDatePicker

- (void)setNewStyle:(BOOL)newStyle {
    _newStyle = newStyle;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setupUI];
    [self defaultConfig];
    if (self.scrollToDate) {
        [self getNowDate:self.scrollToDate animated:NO];
    }
}

/**
 默认滚动到当前时间
 */
- (instancetype)initWithDateStyle:(JLDateStyle)datePickerStyle CompleteBlock:(void(^)(NSDate *selectDate))completeBlock {
    self = [super init];
    if (self) {
        self.datePickerStyle = datePickerStyle;
        _dateFormatter = @"yyyy-MM-dd HH:mm";
        [self setupUI];
        [self defaultConfig];
        if (completeBlock) {
            self.doneBlock = ^(NSDate *selectDate) {
                completeBlock(selectDate);
            };
        }
    }
    return self;
}

- (instancetype)initWithDateStyle:(JLDateStyle)datePickerStyle scrollToDate:(NSDate *)scrollToDate CompleteBlock:(void(^)(NSDate *))completeBlock {
    self = [super init];
    if (self) {
        self.datePickerStyle = datePickerStyle;
        self.scrollToDate = scrollToDate;
        _dateFormatter = @"yyyy-MM-dd HH:mm";
        
        [self setupUI];
        [self defaultConfig];
        if (scrollToDate) {
            [self getNowDate:scrollToDate animated:NO];
        }
        if (completeBlock) {
            self.doneBlock = ^(NSDate *selectDate) {
                completeBlock(selectDate);
            };
        }
    }
    return self;
}


- (void)setupUI {
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    UIView *clearBlackView = [[UIView alloc] initWithFrame:self.frame];
    clearBlackView.backgroundColor = JL_color_black;
    clearBlackView.alpha = 0.3f;
    [self addSubview:clearBlackView];
    //点击背景是否影藏
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame), kScreenWidth, 270 + KTouch_Responder_Height)];
    [self addSubview:self.contentView];
    self.contentView.backgroundColor = JL_color_gray_F5F5F5;
    

    if (self.newStyle) {
        self.contentView.backgroundColor = JL_color_white_ffffff;
        [self.contentView setCorners:UIRectCornerTopLeft|UIRectCornerTopRight radius:CGSizeMake(8, 8)];
        
        self.cancelButton = [JLUIFactory buttonInitTitle:@"取消" titleColor:JL_color_gray_333333 backgroundColor:JL_color_white_ffffff font:kFontPingFangSCRegular(16) addTarget:self action:@selector(dismiss)];
        self.cancelButton.frame = CGRectMake(16, 19, 32, 22);
        
        self.enterButton = [JLUIFactory buttonInitTitle:@"确定" titleColor:JL_color_white_ffffff backgroundColor:JL_color_blue_38B2F1 font:kFontPingFangSCRegular(14) addTarget:self action:@selector(enButtonClick:)];
        self.enterButton.contentEdgeInsets = UIEdgeInsetsZero;
        self.enterButton.frame = CGRectMake(self.contentView.frameWidth - 44 - 16, 16, 44.0f, 28.0f);
        self.enterButton.layer.cornerRadius = 6;
        self.enterButton.layer.masksToBounds = YES;
        [self.contentView addSubview:self.cancelButton];
        [self.contentView addSubview:self.enterButton];
        
        //分割线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.enterButton.frameBottom + 15, self.contentView.frameWidth, 1.0f)];
        lineView.backgroundColor = JL_color_gray_F3F3F3;
        [self.contentView addSubview:lineView];
        
        self.datePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(32, 60, kScreenWidth - 32 * 2, CGRectGetHeight(self.contentView.frame)-60-KTouch_Responder_Height)];
        self.datePicker.showsSelectionIndicator = YES;
        self.datePicker.delegate = self;
        self.datePicker.dataSource = self;
        self.datePicker.backgroundColor = JL_color_white_ffffff;
        [self.contentView addSubview:self.datePicker];
        
        //中间显示的分割线
        UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(self.datePicker.frameX, self.datePicker.frameHeight / 2 + 60 - 27, self.datePicker.frameWidth, 1)];
        topLineView.layer.zPosition = 99;
        topLineView.backgroundColor = JL_color_gray_F3F3F3;
        [self.contentView addSubview:topLineView];
        UIView *bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(self.datePicker.frameX, self.datePicker.frameHeight / 2 + 60 + 27, self.datePicker.frameWidth, 1)];
        bottomLineView.backgroundColor = JL_color_gray_F3F3F3;
        bottomLineView.layer.zPosition = 99;
        [self.contentView addSubview:bottomLineView];
    } else {
        self.cancelButton = [JLUIFactory buttonInitTitle:@"取消" titleColor:JL_color_black backgroundColor:JL_color_clear font:kFontPingFangSCRegular(17.0f) addTarget:self action:@selector(dismiss)];
        self.cancelButton.frame = CGRectMake(15, 5, 60, 40.0f);
        
        self.enterButton = [JLUIFactory buttonInitTitle:@"确定" titleColor:JL_color_blue_38B2F1 backgroundColor:JL_color_clear font:kFontPingFangSCRegular(17.0f) addTarget:self action:@selector(enButtonClick:)];
        self.enterButton.frame = CGRectMake(kScreenWidth-75, 5, 60, 40.0f);
        self.endTime = [JLUIFactory labelInitText:@"结束时间" font:kFontPingFangSCRegular(17.0f) textColor:JL_color_black textAlignment:NSTextAlignmentCenter];
        
        self.endTime.frame = CGRectMake(80, 5, kScreenWidth-160, 40);
        [self.contentView addSubview:self.cancelButton];
        [self.contentView addSubview:self.enterButton];
        [self.contentView addSubview:self.endTime];
        

        self.datePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, CGRectGetHeight(self.contentView.frame)-50-KTouch_Responder_Height)];
        self.datePicker.showsSelectionIndicator = YES;
        self.datePicker.delegate = self;
        self.datePicker.dataSource = self;
        self.datePicker.backgroundColor = JL_color_white_ffffff;
        [self.contentView addSubview:self.datePicker];
    }
}

- (void)defaultConfig {
    if (!_scrollToDate) {
        _scrollToDate = [NSDate date];
    }
    
    //循环滚动时需要用到
    preRow = (self.scrollToDate.year - MINYEAR) * 12 + self.scrollToDate.month - 1;
    
    //设置年月日时分数据
    _yearArray = [self setArray:_yearArray];
    _monthArray = [self setArray:_monthArray];
    _dayArray = [self setArray:_dayArray];
    _hourArray = [self setArray:_hourArray];
    _minuteArray = [self setArray:_minuteArray];
    
    for (int i = 0; i < 60; i++) {
        NSString *num = [NSString stringWithFormat:@"%02d",i];
        if (0 < i && i <= 12) {
            [_monthArray addObject:num];
        }
        if (i<24) {
            [_hourArray addObject:num];
        }
        [_minuteArray addObject:num];
    }
    for (NSInteger i = MINYEAR; i <= MAXYEAR; i++) {
        NSString *num = [NSString stringWithFormat:@"%ld",(long)i];
        [_yearArray addObject:num];
    }
    
    //最大最小限制
    if (!self.maxLimitDate) {
        self.maxLimitDate = [NSDate date:@"2050-12-31 23:59" format:@"yyyy-MM-dd HH:mm"];
    }
    //最小限制
    if (!self.minLimitDate) {
        self.minLimitDate = [NSDate date:@"2015-01-01 00:00" format:@"yyyy-MM-dd HH:mm"];
    }
}

- (void)addLabelWithName:(NSArray *)nameArr {
    for (id subView in self.contentView.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            [subView removeFromSuperview];
        }
    }
    
    for (int i = 0; i < nameArr.count; i++) {
        CGFloat labelX = kPickerSize.width / (nameArr.count * 2) + 18 + kPickerSize.width / nameArr.count * i;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, CGRectGetHeight(self.datePicker.frame) / 2 + 50 - 10, 20, 20)];
        label.textColor = JL_color_gray_333333;
        label.text = nameArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.backgroundColor = JL_color_clear;
        [self.contentView addSubview:label];
        
        if (self.newStyle) {
            label.textColor = JL_color_gray_101010;
            label.font = kFontPingFangSCRegular(16);
            label.frame = CGRectMake(labelX + self.datePicker.frameX, self.datePicker.frameY + self.datePicker.frameHeight / 2 - 10, 20, 20);
        }
    }
}

- (NSMutableArray *)setArray:(id)mutableArray {
    if (mutableArray) {
        [mutableArray removeAllObjects];
    } else {
        mutableArray = [NSMutableArray array];
    }
    return mutableArray;
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    switch (self.datePickerStyle) {
        case DateStyleShowYearMonthDayHourMinute:
           [self addLabelWithName:@[@"年",@"月",@"日",@"时",@"分"]];
            return 5;
            
        case DateStyleShowMonthDayHourMinute:
            [self addLabelWithName:@[@"月",@"日",@"时",@"分"]];
            return 4;
            
        case DateStyleShowYearMonthDay:
            [self addLabelWithName:@[@"年",@"月",@"日"]];
            return 3;
            
        case DateStyleShowYearMonth:
            [self addLabelWithName:@[@"年",@"月"]];
            return 2;
            
        case DateStyleShowMonthDay:
            [self addLabelWithName:@[@"月",@"日"]];
            return 2;
            
        case DateStyleShowHourMinute:
           [self addLabelWithName:@[@"时",@"分"]];
            return 2;
            
        case DateStyleShowYear:
           [self addLabelWithName:@[@"年"]];
            return 1;
            
        case DateStyleShowMonth:
            [self addLabelWithName:@[@"月"]];
            return 1;
            
        case DateStyleShowDayHourMinute:
            [self addLabelWithName:@[@"日",@"时",@"分"]];
            return 3;
            
        default:
            return 0;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *numberArr = [self getNumberOfRowsInComponent];
    return [numberArr[component] integerValue];
}

- (NSArray *)getNumberOfRowsInComponent {
    NSInteger yearNum = _yearArray.count;
    NSInteger monthNum = _monthArray.count;
    NSInteger dayNum = [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
    
    NSInteger dayNum2 = [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:1];//确保可以选到31日
    
    NSInteger hourNum = _hourArray.count;
    NSInteger minuteNUm = _minuteArray.count;
    
    NSInteger timeInterval = MAXYEAR - MINYEAR;
    
    switch (self.datePickerStyle) {
        case DateStyleShowYearMonthDayHourMinute:
            return @[@(yearNum),@(monthNum),@(dayNum),@(hourNum),@(minuteNUm)];
            break;
            
        case DateStyleShowMonthDayHourMinute:
            return @[@(monthNum*timeInterval),@(dayNum),@(hourNum),@(minuteNUm)];
            break;
            
        case DateStyleShowYearMonthDay:
            return @[@(yearNum),@(monthNum),@(dayNum)];
            break;
            
        case DateStyleShowYearMonth:
            return @[@(yearNum),@(monthNum)];
            break;
            
        case DateStyleShowMonthDay:
            return @[@(monthNum*timeInterval),@(dayNum),@(hourNum)];
            break;
            
        case DateStyleShowHourMinute:
            return @[@(hourNum),@(minuteNUm)];
            break;
            
        case DateStyleShowYear:
            return @[@(yearNum)];
            break;
            
        case DateStyleShowMonth:
            return @[@(monthNum)];
            break;
            
        case DateStyleShowDayHourMinute:
            return @[@(dayNum2),@(hourNum),@(minuteNUm)];
            break;
            
        default:
            return @[];
            break;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    if (self.newStyle) {
        return 54.0f;
    }
    return 40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if (self.newStyle) {
        //隐藏原生黑线
         ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = JL_color_clear;
//         ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = JL_color_clear;
    }
    UILabel *customLabel = (UILabel *)view;
    if (!customLabel) {
        customLabel = [[UILabel alloc] init];
        customLabel.textAlignment = NSTextAlignmentCenter;
        if (self.newStyle) {
            customLabel.font = kFontPingFangSCRegular(16);
            customLabel.textColor = JL_color_gray_666666;
        } else {
            customLabel.textColor = JL_color_gray_333333;
            [customLabel setFont:[UIFont systemFontOfSize:17]];
        }
    }
    NSString *title;
    
    switch (self.datePickerStyle) {
        case DateStyleShowYearMonthDayHourMinute:
            if (component==0) {
                title = _yearArray[row];
                if (row == yearIndex && self.newStyle) {
                    customLabel.textColor = JL_color_gray_101010;
                } else {
                    customLabel.textColor = JL_color_gray_333333;
                }
            }
            if (component==1) {
                title = _monthArray[row];
                if (row == monthIndex && self.newStyle) {
                    customLabel.textColor = JL_color_gray_101010;
                } else {
                    customLabel.textColor = JL_color_gray_333333;
                }
            }
            if (component==2) {
                title = _dayArray[row];
                if (row == dayIndex && self.newStyle) {
                    customLabel.textColor = JL_color_gray_101010;
                } else {
                    customLabel.textColor = JL_color_gray_333333;
                }
            }
            if (component==3) {
                title = _hourArray[row];
                if (row == hourIndex && self.newStyle) {
                    customLabel.textColor = JL_color_gray_101010;
                } else {
                    customLabel.textColor = JL_color_gray_333333;
                }
            }
            if (component==4) {
                title = _minuteArray[row];
                if (row == minuteIndex && self.newStyle) {
                    customLabel.textColor = JL_color_gray_101010;
                } else {
                    customLabel.textColor = JL_color_gray_333333;
                }
            }
            break;
            
        case DateStyleShowYearMonthDay:
            if (component==0) {
                title = _yearArray[row];
                if (row == yearIndex && self.newStyle) {
                    customLabel.textColor = JL_color_gray_101010;
                } else {
                    customLabel.textColor = JL_color_gray_333333;
                }
            }
            if (component==1) {
                title = _monthArray[row];
                if (row == monthIndex && self.newStyle) {
                    customLabel.textColor = JL_color_gray_101010;
                } else {
                    customLabel.textColor = JL_color_gray_333333;
                }
            }
            if (component==2) {
                title = _dayArray[row];
                if (row == dayIndex && self.newStyle) {
                    customLabel.textColor = JL_color_gray_101010;
                } else {
                    customLabel.textColor = JL_color_gray_333333;
                }
            }
            break;
            
        case DateStyleShowYearMonth:
            if (component==0) {
                title = _yearArray[row];
                if (row == yearIndex && self.newStyle) {
                    customLabel.textColor = JL_color_gray_101010;
                } else {
                    customLabel.textColor = JL_color_gray_333333;
                }
            }
            if (component==1) {
                title = _monthArray[row];
                if (row == monthIndex && self.newStyle) {
                    customLabel.textColor = JL_color_gray_101010;
                } else {
                    customLabel.textColor = JL_color_gray_333333;
                }
            }
            break;
            
        case DateStyleShowMonthDayHourMinute:
            if (component==0) {
                title = _monthArray[row%12];
                if (row == monthIndex && self.newStyle) {
                    customLabel.textColor = JL_color_gray_101010;
                } else {
                    customLabel.textColor = JL_color_gray_333333;
                }
            }
            if (component==1) {
                title = _dayArray[row];
                if (row == dayIndex && self.newStyle) {
                    customLabel.textColor = JL_color_gray_101010;
                } else {
                    customLabel.textColor = JL_color_gray_333333;
                }
            }
            if (component==2) {
                title = _hourArray[row];
                if (row == hourIndex && self.newStyle) {
                    customLabel.textColor = JL_color_gray_101010;
                } else {
                    customLabel.textColor = JL_color_gray_333333;
                }
            }
            if (component==3) {
                title = _minuteArray[row];
                if (row == minuteIndex && self.newStyle) {
                    customLabel.textColor = JL_color_gray_101010;
                } else {
                    customLabel.textColor = JL_color_gray_333333;
                }
            }
            break;
            
        case DateStyleShowMonthDay:
            if (component==0) {
                title = _monthArray[row%12];
                if (row == monthIndex && self.newStyle) {
                    customLabel.textColor = JL_color_gray_101010;
                } else {
                    customLabel.textColor = JL_color_gray_333333;
                }
            }
            if (component==1) {
                title = _dayArray[row];
                if (row == dayIndex && self.newStyle) {
                    customLabel.textColor = JL_color_gray_101010;
                } else {
                    customLabel.textColor = JL_color_gray_333333;
                }
            }
            break;
            
        case DateStyleShowHourMinute:
            if (component==0) {
                title = _hourArray[row];
                if (row == hourIndex && self.newStyle) {
                    customLabel.textColor = JL_color_gray_101010;
                } else {
                    customLabel.textColor = JL_color_gray_333333;
                }
            }
            if (component==1) {
                title = _minuteArray[row];
                if (row == minuteIndex && self.newStyle) {
                    customLabel.textColor = JL_color_gray_101010;
                } else {
                    customLabel.textColor = JL_color_gray_333333;
                }
            }
            break;
            
        case DateStyleShowYear:
            if (component==0) {
                title = _yearArray[row];
                if (row == yearIndex && self.newStyle) {
                    customLabel.textColor = JL_color_gray_101010;
                } else {
                    customLabel.textColor = JL_color_gray_333333;
                }
            }
            break;
            
        case DateStyleShowMonth:
            if (component==0) {
                title = _monthArray[row];
                if (row == monthIndex && self.newStyle) {
                    customLabel.textColor = JL_color_gray_101010;
                } else {
                    customLabel.textColor = JL_color_gray_333333;
                }
            }
            break;
            
        case DateStyleShowDayHourMinute:
            if (component==0) {
                title = _dayArray[row];
                if (row == dayIndex && self.newStyle) {
                    customLabel.textColor = JL_color_gray_101010;
                } else {
                    customLabel.textColor = JL_color_gray_333333;
                }
            }
            if (component==1) {
                title = _hourArray[row];
                if (row == hourIndex && self.newStyle) {
                    customLabel.textColor = JL_color_gray_101010;
                } else {
                    customLabel.textColor = JL_color_gray_333333;
                }
            }
            if (component==2) {
                title = _minuteArray[row];
                if (row == minuteIndex && self.newStyle) {
                    customLabel.textColor = JL_color_gray_101010;
                } else {
                    customLabel.textColor = JL_color_gray_333333;
                }
            }
            break;
            
        default:
            title = @"";
            break;
    }
    
    customLabel.text = title;
    return customLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (self.datePickerStyle) {
        case DateStyleShowYearMonthDayHourMinute:{
            if (component == 0) {
                yearIndex = row;
            }
            if (component == 1) {
                monthIndex = row;
            }
            if (component == 2) {
                dayIndex = row;
            }
            if (component == 3) {
                hourIndex = row;
            }
            if (component == 4) {
                minuteIndex = row;
            }
            if (component == 0 || component == 1){
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
            }
        }
            break;
            
        case DateStyleShowYearMonthDay:{
            if (component == 0) {
                yearIndex = row;
            }
            if (component == 1) {
                monthIndex = row;
            }
            if (component == 2) {
                dayIndex = row;
            }
            if (component == 0 || component == 1){
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
            }
        }
            break;
            
        case DateStyleShowYearMonth:{
            if (component == 0) {
                yearIndex = row;
            }
            if (component == 1) {
                monthIndex = row;
            }
        }
            break;
            
        case DateStyleShowMonthDayHourMinute:{
            if (component == 1) {
                dayIndex = row;
            }
            if (component == 2) {
                hourIndex = row;
            }
            if (component == 3) {
                minuteIndex = row;
            }
            if (component == 0) {
                [self yearChange:row];
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
            }
            [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
            
        }
            break;
            
        case DateStyleShowMonthDay:{
            if (component == 1) {
                dayIndex = row;
            }
            if (component == 0) {
                [self yearChange:row];
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
            }
            [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
        }
            break;
            
        case DateStyleShowHourMinute:{
            if (component == 0) {
                hourIndex = row;
            }
            if (component == 1) {
                minuteIndex = row;
            }
        }
            break;
            
        case DateStyleShowYear:{
            if (component == 0) {
                yearIndex = row;
            }
        }
            break;
            
        case DateStyleShowMonth:{
            if (component == 0) {
                monthIndex = row;
            }
        }
            break;
            
        case DateStyleShowDayHourMinute:{
            if (component == 0) {
                dayIndex = row;
            }
            if (component == 1) {
                hourIndex = row;
            }
            if (component == 2) {
                minuteIndex = row;
            }
        }
            break;
            
        default:
            break;
    }
    
    [pickerView reloadAllComponents];
    
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",_yearArray[yearIndex],_monthArray[monthIndex],_dayArray[dayIndex],_hourArray[hourIndex],_minuteArray[minuteIndex]];

    self.scrollToDate = [[NSDate date:dateStr format:_dateFormatter] dateWithFormatter:_dateFormatter] ;
      
    if ([self.scrollToDate compare:self.minLimitDate] == NSOrderedAscending) {
        self.scrollToDate = self.minLimitDate;
        [self getNowDate:self.minLimitDate animated:YES];
    } else if ([self.scrollToDate compare:self.maxLimitDate] == NSOrderedDescending){
        self.scrollToDate = self.maxLimitDate;
        [self getNowDate:self.maxLimitDate animated:YES];
    }
    _startDate = self.scrollToDate;
}

- (void)yearChange:(NSInteger)row {
    monthIndex = row % 12;
    //年份状态变化
    if (row - preRow < 12 && row - preRow > 0 && [_monthArray[monthIndex] integerValue] < [_monthArray[preRow % 12] integerValue]) {
        yearIndex ++;
    } else if(preRow-row <12 && preRow-row > 0 && [_monthArray[monthIndex] integerValue] > [_monthArray[preRow%12] integerValue]) {
        yearIndex --;
    } else {
        NSInteger interval = (row-preRow)/12;
        yearIndex += interval;
    }
    preRow = row;
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if( [touch.view isDescendantOfView:self.contentView]) {
        return NO;
    }
    return YES;
}

#pragma mark - Action
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.3 animations:^{
        self.contentView.frame =CGRectMake(0, CGRectGetMaxY(self.frame)-270 - KTouch_Responder_Height, kScreenWidth,270 + KTouch_Responder_Height);
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:.3 animations:^{
        self.contentView.frame = CGRectMake(0, CGRectGetMaxY(self.frame), kScreenWidth,270 + KTouch_Responder_Height);
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

- (void)enButtonClick:(UIButton *)enter {
    _startDate = [self.scrollToDate dateWithFormatter:_dateFormatter];
    self.doneBlock(_startDate);
    [self dismiss];
}

#pragma mark - tools
//通过年月求每月天数
- (NSInteger)DaysfromYear:(NSInteger)year andMonth:(NSInteger)month {
    NSInteger num_year = year;
    NSInteger num_month = month;
    
    BOOL isrunNian = num_year % 4 == 0 ? (num_year % 100 == 0 ? (num_year % 400 == 0 ? YES : NO) : YES) : NO;
    switch (num_month) {
        case 1:case 3:case 5:case 7:case 8:case 10:case 12:
        {
            [self setdayArray:31];
            return 31;
        }
            
        case 4:case 6:case 9:case 11:
        {
            [self setdayArray:30];
            return 30;
        }
            
        case 2:
        {
            if (isrunNian) {
                [self setdayArray:29];
                return 29;
            } else {
                [self setdayArray:28];
                return 28;
            }
        }
            
        default:
            break;
    }
    return 0;
}

//设置每月的天数数组
- (void)setdayArray:(NSInteger)num {
    [_dayArray removeAllObjects];
    for (int i = 1; i <= num; i++) {
        [_dayArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
}

//滚动到指定的时间位置
- (void)getNowDate:(NSDate *)date animated:(BOOL)animated {
    if (!date) {
        date = [NSDate date];
    }
    [self DaysfromYear:date.year andMonth:date.month];
    
    yearIndex = date.year - MINYEAR;
    monthIndex = date.month - 1;
    dayIndex = date.day - 1;
    hourIndex = date.hour;
    minuteIndex = date.minute;
    
    //循环滚动时需要用到
    preRow = (self.scrollToDate.year - MINYEAR) * 12 + self.scrollToDate.month - 1;
    
    NSArray *indexArray;
    
    if (self.datePickerStyle == DateStyleShowYearMonthDayHourMinute) {
        indexArray = @[@(yearIndex),@(monthIndex),@(dayIndex),@(hourIndex),@(minuteIndex)];
    }
    if (self.datePickerStyle == DateStyleShowYearMonthDay) {
        indexArray = @[@(yearIndex),@(monthIndex),@(dayIndex)];
    }
    if (self.datePickerStyle == DateStyleShowYearMonth) {
        indexArray = @[@(yearIndex),@(monthIndex)];
    }
    if (self.datePickerStyle == DateStyleShowMonthDayHourMinute) {
        indexArray = @[@(monthIndex),@(dayIndex),@(hourIndex),@(minuteIndex)];
    }
    if (self.datePickerStyle == DateStyleShowMonthDay) {
        indexArray = @[@(monthIndex),@(dayIndex)];
    }
    if (self.datePickerStyle == DateStyleShowHourMinute) {
        indexArray = @[@(hourIndex),@(minuteIndex)];
    }
    if (self.datePickerStyle == DateStyleShowYear) {
        indexArray = @[@(yearIndex)];
    }
    if (self.datePickerStyle == DateStyleShowMonth) {
        indexArray = @[@(monthIndex)];
    }
    if (self.datePickerStyle == DateStyleShowDayHourMinute) {
        indexArray = @[@(dayIndex),@(hourIndex),@(minuteIndex)];
    }
    [self.datePicker reloadAllComponents];
    
    for (int i = 0; i < indexArray.count; i++) {
        if ((self.datePickerStyle == DateStyleShowMonthDayHourMinute || self.datePickerStyle == DateStyleShowMonthDay) && i==0) {
            NSInteger mIndex = [indexArray[i] integerValue] + (12 * (self.scrollToDate.year - MINYEAR));
            [self.datePicker selectRow:mIndex inComponent:i animated:animated];
        } else {
            [self.datePicker selectRow:[indexArray[i] integerValue] inComponent:i animated:animated];
        }
    }
}

- (void)setMinLimitDate:(NSDate *)minLimitDate {
    _minLimitDate = minLimitDate;
    if ([_scrollToDate compare:self.minLimitDate] == NSOrderedAscending) {
        _scrollToDate = self.minLimitDate;
    }
    [self getNowDate:self.scrollToDate animated:YES];
}

- (void)setMaxLimitDate:(NSDate *)maxLimitDate {
    _maxLimitDate = maxLimitDate;
}
@end
