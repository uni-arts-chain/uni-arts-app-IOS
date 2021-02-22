//
//  JLCustomTipControl.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TipControlPosition) {
    TipControlPositionCenter, /**< 提示显示在视图中间位置 */
    TipControlPositionBottom, /**< 提示显示在视图底部位置，距离视图底部138pt */
};

@interface JLCustomTipControl : UIControl
/**
 初始化提示control

 @param frame frame
 @param icon 提示图片
 @param tipMessage 提示文字
 @param hideTime 隐藏时间
 @param position 位置
 @param hidedBlock 提示隐藏回调
 @return control
 */
- (instancetype)initWithFrame:(CGRect)frame tipIcon:(NSString *)icon tipMessage:(NSString *)tipMessage hideTime:(NSTimeInterval)hideTime position:(TipControlPosition)position hidedBlock:(void(^)(void))hidedBlock;
@end

NS_ASSUME_NONNULL_END
