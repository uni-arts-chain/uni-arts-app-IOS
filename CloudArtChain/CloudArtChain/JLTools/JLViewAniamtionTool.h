//
//  JLViewAniamtionTool.h
//  CloudArtChain
//
//  Created by jielian on 2021/6/11.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLViewAniamtionTool : NSObject

/// 视图进场动画
/// @param easingFunction 效果
/// @param fromValue 开始值
/// @param toValue 结束值
+ (CAAnimation *)enterAnimationWithEasingFunction: (QGYEasingFunction)easingFunction fromValue: (NSValue *)fromValue toValue: (NSValue *)toValue;

@end

NS_ASSUME_NONNULL_END
