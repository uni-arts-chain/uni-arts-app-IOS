//
//  JLPickerView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLPickerView.h"
#import "NSDate+Extension.h"

@interface JLPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>

/** 弹框视图 */
@property (nonatomic, strong) UIView *alertView;
/** 选择器 */
@property (nonatomic, strong) UIPickerView *pickerView;
/** 类型 */
@property (nonatomic, assign) JLPickerViewType type;



@end

@implementation JLPickerView

-(void)setSelectIndex:(NSInteger)selectIndex {
    if (selectIndex > self.dataSource.count - 1 || selectIndex < 0) {
        selectIndex = 0;
    }
    _selectIndex = selectIndex;
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:selectIndex inComponent:0 animated:NO];
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.pickerView reloadAllComponents];
}

-(void)setInterval:(NSInteger)interval {
    _interval = interval;
    [self.pickerView reloadAllComponents];
}

- (instancetype)initWithType:(JLPickerViewType)type
{
    self = [super init];
    if (self) {
        _type = type;
        
        [self setupView];
        [self addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setupView {
    [KMainWindow addSubview:self];
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
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    self.pickerView = pickerView;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [pickBgView addSubview:pickerView];
    
    if (self.type == JLPickerViewTypeLeadTime || self.type == JLPickerViewTypeDelayTime) {
        UILabel *titleLabel = [JLUIFactory labelInitText:self.type == JLPickerViewTypeLeadTime ? @"提前" : @"延后" font:kFontPingFangSCRegular(16) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentCenter];
        titleLabel.frame = CGRectMake(pickBgView.frameWidth / 2 - 32 - 16, (pickBgView.frameHeight - 22) / 2, 32, 22);
        [pickBgView addSubview:titleLabel];
        
        pickerView.frame = CGRectMake(titleLabel.frameRight + 16, 0, 100, pickBgView.frameHeight);
    } else if (self.type == JLPickerViewTypeSingleText) {
        pickerView.frame = CGRectMake(0, 0, pickBgView.frameWidth, pickBgView.frameHeight);
    }
    
}


- (void)cancelAction {
    [self hideWithAnimation:nil];
}

- (void)doneAction {
    if (self.selectBlock) {
        if (self.type == JLPickerViewTypeLeadTime || self.type == JLPickerViewTypeDelayTime) {
            self.selectBlock(self.selectIndex, @((self.selectIndex + 1) * 10).stringValue);
        } else if (self.type == JLPickerViewTypeSingleText) {
            self.selectBlock(self.selectIndex, self.dataSource[self.selectIndex]);
        }
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
    if (self.type == JLPickerViewTypeLeadTime || self.type == JLPickerViewTypeDelayTime) {
        return self.interval / 10;
    } else if (self.type == JLPickerViewTypeSingleText) {
        return self.dataSource.count;
    }
    return 0;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 54.0f;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if (self.selectIndex > [self pickerView:pickerView numberOfRowsInComponent:component] - 1 || self.selectIndex < 0) {
        self.selectIndex = 0;
    }
    //隐藏原生黑线
     ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = JL_color_clear;
     ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = JL_color_clear;
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:view.bounds];
    contentLabel.backgroundColor = JL_color_clear;
    contentLabel.frameHeight = 54.0f;
    contentLabel.font = kFontPingFangSCRegular(16);
    if (row == self.selectIndex) {
        contentLabel.textColor = JL_color_gray_101010;
    } else {
        contentLabel.textColor = JL_color_gray_666666;
    }
    if (self.type == JLPickerViewTypeLeadTime || self.type == JLPickerViewTypeDelayTime) {
        contentLabel.textAlignment = NSTextAlignmentLeft;
    } else if (self.type == JLPickerViewTypeSingleText) {
        contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    contentLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    return contentLabel;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *showStr;
    if (self.type == JLPickerViewTypeLeadTime || self.type == JLPickerViewTypeDelayTime) {
        showStr = [NSString stringWithFormat:@"%ld 分钟",(row + 1) * 10];
    } else if (self.type == JLPickerViewTypeSingleText) {
        showStr = self.dataSource[row];
    }
    return showStr;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.selectIndex = row;
}

@end


