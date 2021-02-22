//
//  JLAlertSheetControl.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLAlertSheetControl.h"

@interface JLAlertSheetControl()
/** 类型 删除的选项为红色 */
@property (nonatomic, assign) AlertSheetControlType type;
/** 标题 */
@property (nonatomic, strong) NSString *title;
/** 选项 */
@property (nonatomic, strong) NSArray *options;
/** 当前选中的标题 */
@property (nonatomic, assign) NSInteger curSelectedIndex;
/** 底部按钮数组 */
@property (nonatomic, strong) NSArray *bottomBtns;
/** 选项卡点击回调 */
@property (nonatomic, copy) void(^selectedIndexBlock)(NSInteger selectedIndex);
/** 底部按钮点击回调 */
@property (nonatomic, copy) void(^bottomClickBlock)(NSInteger selectedIndex);
/** 弹框视图 */
@property (nonatomic, strong) UIView *alertView;
@end

@implementation JLAlertSheetControl
+ (JLAlertSheetControl *)alertSheetWithType:(AlertSheetControlType)type
                                      title:(NSString *)title
                                    options:(NSArray *)options
                                 bottomBtns:(NSArray *)bottomBtns
                           curSelectedIndex:(NSInteger)curSelectedIndex
                         selectedIndexBlock:(void(^)(NSInteger selectedIndex))selectedIndexBlock
                           bottomClickBlock:(void(^)(NSInteger selectedIndex))bottomClickBlock {
    JLAlertSheetControl *sheet = [[JLAlertSheetControl alloc]initWithType:type title:title options:options bottomBtns:bottomBtns curSelectedIndex:curSelectedIndex selectedIndexBlock:selectedIndexBlock bottomClickBlock:bottomClickBlock];
    return sheet;
}

- (instancetype)initWithType:(AlertSheetControlType)type
                       title:(NSString *)title options:(NSArray *)options
                  bottomBtns:(NSArray *)bottomBtns
            curSelectedIndex:(NSInteger)curSelectedIndex
          selectedIndexBlock:(void(^)(NSInteger selectedIndex))selectedIndexBlock
            bottomClickBlock:(void(^)(NSInteger selectedIndex))bottomClickBlock {
    self = [super init];
    if (self) {
        _type = type;
        _title = title;
        _options = options;
        _bottomBtns = bottomBtns;
        _curSelectedIndex = curSelectedIndex;
        _selectedIndexBlock = selectedIndexBlock;
        _bottomClickBlock = bottomClickBlock;
        [self setupView];
        [self addTarget:self action:@selector(hideAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [[UIColor colorWithHexString:@"1A1A1A"] colorWithAlphaComponent:0.7f];
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    //背景弹窗视图
    UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    alertView.backgroundColor = JL_color_white_ffffff;
    self.alertView = alertView;
    [self addSubview:alertView];
    //控件边距
    CGFloat margin = 16;
    //左边距
    CGFloat x = 16.0f;
    //宽度
    CGFloat width = kScreenWidth - x * 2;
    //上边距 16
    CGFloat y = 0;
    //线条默认高度
    CGFloat lineHeight = 1.0f;
    if (![NSString stringIsEmpty:self.title]) {
        y += margin;
        UILabel *titleLabel = [JLUIFactory labelInitText:self.title font:kFontPingFangSCRegular(14) textColor:JL_color_gray_666666 textAlignment:NSTextAlignmentCenter];
        [alertView addSubview:titleLabel];
        //左右间距 16
        CGFloat titleHeight = [JLTool getAdaptionSizeWithText:self.title labelWidth:width font:kFontPingFangSCRegular(14)].height;
        titleLabel.frame = CGRectMake(x, y, width, titleHeight);
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.frameBottom + margin, alertView.frameWidth, lineHeight)];
        lineView.backgroundColor = JL_color_gray_F3F3F3;
        [alertView addSubview:lineView];
        y = lineView.frameBottom;
    }
    
    for (int i = 0; i < self.options.count; i++) {
        NSString *optionStr = self.options[i];
        
        UIButton *optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [optionBtn setTitle:optionStr forState:UIControlStateNormal];
        [optionBtn setTitleColor:self.type == AlertSheetControlTypeDeleteNotice ? JL_color_red_D70000 : JL_color_gray_333333 forState:UIControlStateNormal];
        optionBtn.titleLabel.font = kFontPingFangSCRegular(16);
        [optionBtn addTarget:self action:@selector(optionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        optionBtn.tag = i;
        [alertView addSubview:optionBtn];
        //左右间距 16
        CGFloat optionHeight = [JLTool getAdaptionSizeWithText:optionStr labelWidth:width font:kFontPingFangSCRegular(16)].height;
        optionBtn.frame = CGRectMake(x, y, width, optionHeight + margin * 2);
        
        //当前选中的一项
        if (self.curSelectedIndex == i && self.type == AlertSheetControlTypeOptionChoice) {
            [optionBtn setTitleColor:JL_color_gray_101010 forState:UIControlStateNormal];
        }
        
        if (i != self.options.count - 1) {
            //最后一个没有分割线
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, optionBtn.frameBottom, alertView.frameWidth, lineHeight)];
            lineView.backgroundColor = JL_color_gray_F3F3F3;
            [alertView addSubview:lineView];
            y = lineView.frameBottom;
        } else {
            y = optionBtn.frameBottom;
        }
    }
    UIView *marginView = [[UIView alloc]initWithFrame:CGRectMake(0, y, kScreenWidth, margin / 2)];
    marginView.backgroundColor = JL_color_gray_F3F3F3;
    [alertView addSubview:marginView];
    y = marginView.frameBottom;
    
    for (int i = 0; i < self.bottomBtns.count; i++) {
        NSString *btnStr = self.bottomBtns[i];
        UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [bottomBtn setTitle:btnStr forState:UIControlStateNormal];
        [bottomBtn setTitleColor:JL_color_gray_333333 forState:UIControlStateNormal];
        bottomBtn.titleLabel.font = kFontPingFangSCRegular(16);
        [bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        bottomBtn.tag = i;
        [alertView addSubview:bottomBtn];
        //左右间距 16
        CGFloat optionHeight = [JLTool getAdaptionSizeWithText:btnStr labelWidth:width font:kFontPingFangSCRegular(16)].height;
        bottomBtn.frame = CGRectMake(x, y, width, optionHeight + margin * 2);
        
        if (i != self.bottomBtns.count - 1) {
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, bottomBtn.frameBottom, alertView.frameWidth, lineHeight)];
            lineView.backgroundColor = JL_color_gray_F3F3F3;
            [alertView addSubview:lineView];
            y = lineView.frameBottom;
        } else {
            y = bottomBtn.frameBottom;
        }
    }
    
    alertView.frame = CGRectMake(0, self.frameHeight, kScreenWidth, y + KTouch_Responder_Height);
    [alertView setCorners:UIRectCornerTopLeft|UIRectCornerTopRight radius:CGSizeMake(8, 8)];
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

- (void)hideAction {
    [self hideWithAnimation:nil];
}

/**
 选项按钮点击事件

 @param sender 按钮
 */
- (void)optionBtnClick:(UIButton *)sender {
    [self hideWithAnimation:nil];
    NSInteger tag = sender.tag;
    if (self.selectedIndexBlock) {
        self.selectedIndexBlock(tag);
    }
}

/**
 底部按钮点击事件

 @param sender 按钮
 */
- (void)bottomBtnClick:(UIButton *)sender {
    NSInteger tag = sender.tag;
    if (self.bottomClickBlock) {
        self.bottomClickBlock(tag);
    }
    [self hideWithAnimation:nil];
}
@end
