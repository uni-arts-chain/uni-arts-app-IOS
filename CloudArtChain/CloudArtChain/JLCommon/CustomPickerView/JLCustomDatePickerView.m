//
//  JLCustomDatePickerView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLCustomDatePickerView.h"

#import "NSDate+Extension.h"

@interface JLCustomDatePickerView()<UIPickerViewDelegate,UIPickerViewDataSource>

/* 默认选中的时间 */
@property (nullable, nonatomic, strong) NSDate *defaultDate;
/** 最小时间 */
@property (nullable, nonatomic, strong) NSDate *minDate;
/** 最大时间 */
@property (nullable, nonatomic, strong) NSDate *maxDate;

/** 弹框视图 */
@property (nonatomic, strong) UIView *alertView;
/** 日期选择 */
@property (nonatomic, strong) UIPickerView *datePickerView;
/** 小时选择 */
@property (nonatomic, strong) UIPickerView *hourPickerView;
/** 分钟选择 */
@property (nonatomic, strong) UIPickerView *minPickerView;


/** 当前选中的日期下标 */
@property (nonatomic, assign) NSInteger selectedDateIndex;
/** 当前选中的小时下标 */
@property (nonatomic, assign) NSInteger selectedHourIndex;
/** 当前选中的分钟下标 */
@property (nonatomic, assign) NSInteger selectedMinIndex;


@end

@implementation JLCustomDatePickerView

-(void)setDefaultDate:(NSDate *)selectDate {
    _defaultDate = selectDate;
    [self setupSelectDate];
}


- (instancetype)initWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate defaultDate:(NSDate *)defaultDate type:(JLCustomDateType)type {
    self = [super init];
    if (self) {
        _minDate = minDate;
        _maxDate = maxDate;
        _defaultDate = defaultDate ? defaultDate : [NSDate date];
        _type = type;
        [self setupView];
        [self setupSelectDate];
        
        [self addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [[UIColor colorWithHexString:@"1A1A1A"] colorWithAlphaComponent:0.7f];
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    //背景弹窗视图
    UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 252 + KTouch_Responder_Height)];
    self.alertView = alertView;
    alertView.backgroundColor = JL_color_white_ffffff;
    [alertView setCorners:UIRectCornerTopLeft|UIRectCornerTopRight radius:CGSizeMake(8, 8)];
    [self addSubview:alertView];
    
    //取消按钮
    UIButton *cancelBtn = [JLUIFactory buttonInitTitle:@"取消" titleColor:JL_color_gray_333333 backgroundColor:JL_color_white_ffffff font:kFontPingFangSCRegular(16) addTarget:self action:@selector(cancelAction)];
    cancelBtn.frame = CGRectMake(16, 19, 32, 22);
    [alertView addSubview:cancelBtn];
    //完成按钮
    UIButton *doneBtn = [JLUIFactory buttonInitTitle:@"确定" titleColor:JL_color_gray_333333 backgroundColor:JL_color_gray_101010 font:kFontPingFangSCRegular(14) addTarget:self action:@selector(doneAction)];
    doneBtn.frame = CGRectMake(alertView.frameWidth - 44 - 16, 16, 44.0f,28.0f);
    doneBtn.layer.cornerRadius = 6;
    doneBtn.layer.masksToBounds = YES;
    doneBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
    [alertView addSubview:doneBtn];
    //分割线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, doneBtn.frameBottom + 16, alertView.frameWidth, 1.0f)];
    lineView.backgroundColor = JL_color_gray_F3F3F3;
    [alertView addSubview:lineView];
    //时间选择背景视图
    UIView *pickBgView = [[UIView alloc]initWithFrame:CGRectMake(32, lineView.frameBottom, alertView.frameWidth - 32 * 2, alertView.frameHeight - 1 - 16 - 28 - 16 - KTouch_Responder_Height)];
    [alertView addSubview:pickBgView];
    //中间显示的分割线
    UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 69, pickBgView.frameWidth, 1)];
    topLineView.layer.zPosition = 99;
    topLineView.backgroundColor = JL_color_gray_F3F3F3;
    [pickBgView addSubview:topLineView];
    UIView *bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, pickBgView.frameHeight - 71, pickBgView.frameWidth, 1)];
    bottomLineView.backgroundColor = JL_color_gray_F3F3F3;
    bottomLineView.layer.zPosition = 99;
    [pickBgView addSubview:bottomLineView];
    
    //日期选择
    UIPickerView *datePickerView = [[UIPickerView alloc] init];
    datePickerView.dataSource = self;
    datePickerView.delegate = self;
    //时间选择
    UIPickerView *hourPickerView = [[UIPickerView alloc] init];
    hourPickerView.dataSource = self;
    hourPickerView.delegate = self;
    //时间选择
    UIPickerView *minPickerView = [[UIPickerView alloc] init];
    minPickerView.dataSource = self;
    minPickerView.delegate = self;
    
    if (self.type == JLCustomDateTypeCustomTime) {
        self.datePickerView = datePickerView;
        self.hourPickerView = hourPickerView;
        self.minPickerView = minPickerView;
        
        datePickerView.frame = CGRectMake(0 , 0, pickBgView.frameWidth / 2, pickBgView.frameHeight);
        hourPickerView.frame = CGRectMake(datePickerView.frameRight + 16, 0, 48, pickBgView.frameHeight);
        minPickerView.frame = CGRectMake(hourPickerView.frameRight + 16, 0, 48, pickBgView.frameHeight);

        [pickBgView addSubview:datePickerView];
        [pickBgView addSubview:hourPickerView];
        [pickBgView addSubview:minPickerView];
    } else if (self.type == JLCustomDateTypeHourAndMin) {
        self.hourPickerView = hourPickerView;
        self.minPickerView = minPickerView;
        
        hourPickerView.frame = CGRectMake(pickBgView.frameWidth / 2 - 48, 0, 48, pickBgView.frameHeight);
        minPickerView.frame = CGRectMake(hourPickerView.frameRight, 0, 48, pickBgView.frameHeight);

        [pickBgView addSubview:hourPickerView];
        [pickBgView addSubview:minPickerView];
    }
    
    
    
    [KMainWindow addSubview:self];
}


- (void)setupSelectDate {
    if (self.defaultDate) {
        NSInteger totalHours = [self.minDate hoursBeforeDate:self.defaultDate];
        NSInteger days = totalHours / 24.0;
        self.selectedDateIndex = days;
        self.selectedHourIndex = self.defaultDate.hour;
        self.selectedMinIndex = self.defaultDate.minute;
        
        //默认时间为选中时间的明天的这个时候
        [self.datePickerView selectRow:self.selectedDateIndex inComponent:0 animated:YES];
        [self.hourPickerView selectRow:self.selectedHourIndex inComponent:0 animated:YES];
        [self.minPickerView selectRow:self.selectedMinIndex inComponent:0 animated:YES];
        [self.datePickerView reloadAllComponents];
        [self.hourPickerView reloadAllComponents];
        [self.minPickerView reloadAllComponents];
    }
    
}



- (void)cancelAction {
    [self hideWithAnimation:nil];
}

- (void)doneAction {
    if (self.selectDateBlock) {
        NSDate *seletedDate;
        if (self.type == JLCustomDateTypeCustomTime) {
            NSDate *todayDate = [NSDate date];
            seletedDate = [todayDate dateByAddingDays:self.selectedDateIndex];
        } else {
            seletedDate = [NSDate date];
        }
        NSInteger hour = self.selectedHourIndex % 24;
        NSInteger min = self.selectedMinIndex % 60;
        NSString *curDateStr = [NSString stringWithFormat:@"%@ %02ld:%02ld",[seletedDate stringWithFormat:@"yyyy-MM-dd"],hour,min];
        seletedDate = [NSDate date:curDateStr format:@"yyyy-MM-dd HH:mm"];
        self.selectDateBlock(seletedDate);
    }
    [self hideWithAnimation:nil];
    
}

- (void)showWithAnimation:(void(^)(void))completed {
    [UIView animateWithDuration:0.4 animations:^{
        self.alertView.frameY -= self.alertView.frameHeight;
    } completion:^(BOOL finished) {
        if (completed) {
            completed();
        }
    }];
}

- (void)hideWithAnimation:(void(^)(void))completed {
    [UIView animateWithDuration:0.4 animations:^{
        self.alertView.frameY = kScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completed) {
            completed();
        }
    }];
}


#pragma mark 选择器的代理

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.datePickerView) {
        //日期
        if (self.maxDate) {
            return [self.maxDate daysAfterDate:self.minDate];
        } else {
            return 99999;
        }
    } else if (pickerView == self.hourPickerView) {
        //小时
        return 24 * 20;
    } else {
        //分钟
        return 60 * 20;
    }
}


-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 54.0f;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    //隐藏原生黑线
     ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = JL_color_clear;
     ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = JL_color_clear;
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:view.bounds];
    contentLabel.backgroundColor = JL_color_clear;
    contentLabel.frameHeight = 54.0f;
    if (pickerView == self.datePickerView) {
        //日期
        contentLabel.textAlignment = NSTextAlignmentRight;
        if (row == self.selectedDateIndex) {
            contentLabel.textColor = JL_color_gray_101010;
        } else {
            contentLabel.textColor = JL_color_gray_666666;
        }
    } else if (pickerView == self.hourPickerView) {
        //小时
        contentLabel.textAlignment = NSTextAlignmentCenter;
        if (row == self.selectedHourIndex) {
            contentLabel.textColor = JL_color_gray_101010;
        } else {
            contentLabel.textColor = JL_color_gray_666666;
        }
    } else {
        //分钟
        contentLabel.textAlignment = NSTextAlignmentCenter;
        if (row == self.selectedMinIndex) {
            contentLabel.textColor = JL_color_gray_101010;
        } else {
            contentLabel.textColor = JL_color_gray_666666;
        }
    }
    contentLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    return contentLabel;
}



-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *showStr;
    if (pickerView == self.datePickerView) {
        //日期
        NSDate *minDate = self.minDate ? self.minDate : [NSDate date];
        NSDate *curDate = [minDate dateByAddingDays:row];
        showStr = [NSString stringWithFormat:@"%@ %@",[curDate stringWithFormat:@"MM月dd日"],[NSString weekdayStringWithDate:curDate simple:YES]];
    } else if (pickerView == self.hourPickerView) {
        //小时
        NSInteger hour = row % 24;
        showStr = [NSString stringWithFormat:@"%02ld",hour];
    } else {
        //分钟
        NSInteger min = row % 60;
        showStr = [NSString stringWithFormat:@"%02ld",min];
    }
    return showStr;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (pickerView == self.datePickerView) {
        //日期
        self.selectedDateIndex = row;
        [self.datePickerView reloadAllComponents];
    } else if (pickerView == self.hourPickerView) {
        //小时
        self.selectedHourIndex = row;
        [self.hourPickerView reloadAllComponents];
    } else {
        //分钟
        self.selectedMinIndex = row;
        [self.minPickerView reloadAllComponents];
    }
    //判断是否选择了小于于最小日期的时间
    [self judgeDateIsBeforeMinDate];
    //判断是否选择了大于于最大日期的时间
    [self judgeDateIsAfterMaxDate];
}

- (void)judgeDateIsAfterMaxDate {
    if (self.maxDate) {
        NSDate *minDate = self.minDate ? self.minDate : [NSDate date];
        NSDate *seletedDate = self.type == JLCustomDateTypeHourAndMin ? minDate : [minDate dateByAddingDays:self.selectedDateIndex];
        NSInteger hour = self.selectedHourIndex % 24;
        NSInteger min = self.selectedMinIndex % 60;
        NSString *curDateStr = [NSString stringWithFormat:@"%@ %02ld:%02ld",[seletedDate stringWithFormat:@"yyyy-MM-dd"],(long)hour,(long)min];
        seletedDate = [NSDate date:curDateStr format:@"yyyy-MM-dd HH:mm"];
        if ([self.maxDate isEarlierThanDate:seletedDate]) {
            self.defaultDate = self.maxDate;
        }
    }
}

- (void)judgeDateIsBeforeMinDate {
    if (self.minDate) {
        NSDate *seletedDate = self.type == JLCustomDateTypeHourAndMin ? self.minDate : [self.minDate dateByAddingDays:self.selectedDateIndex];
        NSInteger hour = self.selectedHourIndex % 24;
        NSInteger min = self.selectedMinIndex % 60;
        NSString *curDateStr = [NSString stringWithFormat:@"%@ %02ld:%02ld",[seletedDate stringWithFormat:@"yyyy-MM-dd"],(long)hour,(long)min];
        seletedDate = [NSDate date:curDateStr format:@"yyyy-MM-dd HH:mm"];
        if ([seletedDate isEarlierThanDate:self.minDate]) {
            self.defaultDate = self.minDate;
        }
    }
    
}

@end
