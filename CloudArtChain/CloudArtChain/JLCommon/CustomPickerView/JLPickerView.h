//
//  JLPickerView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,JLPickerViewType) {
    JLPickerViewTypeSingleText = 0,/** 单选标题 */
    JLPickerViewTypeLeadTime = 1,/** 提前时间 */
    JLPickerViewTypeDelayTime = 2,/** 延后时间 */
    
};

@interface JLPickerView : UIControl
/** 选中回调 */
@property (nonatomic, copy) void (^selectBlock)(NSInteger index,NSString *result);

/** 当前选中项 */
@property (nonatomic, assign) NSInteger selectIndex;

#pragma mark 当type为WYPickerViewTypeSingleText时才起作用
/** 数据源 */
@property (nonatomic, strong) NSArray *dataSource;
#pragma mark 当type不为WYPickerViewTypeSingleText时才起作用
@property (nonatomic, assign) NSInteger interval;

/// 实例方法
/// @param type 类型
- (instancetype)initWithType:(JLPickerViewType)type;

- (void)showWithAnimation:(void(^)(void))completed;

@end
