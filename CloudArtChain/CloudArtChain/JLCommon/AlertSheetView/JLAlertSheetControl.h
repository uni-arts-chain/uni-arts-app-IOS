//
//  WYAlertSheetControl.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//
// 模态基础视图

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,AlertSheetControlType) {
    AlertSheetControlTypeDeleteNotice = 1,/** 删除（选项都为红色） */
    AlertSheetControlTypeOptionChoice = 2,/** 多选项 */
    
};

@interface JLAlertSheetControl : UIControl
/**
 初始化

 @param type 类型 删除的选项为红色
 @param title 标题
 @param options 选项
 @param bottomBtns 底部按钮数组
 @param curSelectedIndex 当前选中的标题(超过数组长度默认不选中)
 @param selectedIndexBlock 选项卡点击回调
 @param bottomClickBlock 底部按钮点击回调
 @return 实例
 */
+ (JLAlertSheetControl *)alertSheetWithType:(AlertSheetControlType)type
                                      title:(NSString *)title
                                    options:(NSArray *)options
                                 bottomBtns:(NSArray *)bottomBtns
                           curSelectedIndex:(NSInteger)curSelectedIndex
                         selectedIndexBlock:(void(^)(NSInteger selectedIndex))selectedIndexBlock
                           bottomClickBlock:(void(^)(NSInteger selectedIndex))bottomClickBlock;


/**
 动画展示

 @param completed 展示完成
 */
- (void)showWithAnimation:(void(^)(void))completed;

/**
 动画隐藏

 @param completed 隐藏完成
 */
- (void)hideWithAnimation:(void(^)(void))completed;

@end
