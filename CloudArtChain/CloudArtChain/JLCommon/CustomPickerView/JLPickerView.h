//
//  JLPickerView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLPickerView : UIControl
/** 选中回调 */
@property (nonatomic, copy) void (^selectBlock)(NSInteger index, NSString *result);
/** 当前选中项 */
@property (nonatomic, assign) NSInteger selectIndex;
/** 数据源 */
@property (nonatomic, strong) NSArray *dataSource;

- (void)showWithAnimation:(void(^)(void))completed;
@end
