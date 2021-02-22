//
//  UIButton+TouchArea.h
//  Rfinex
//
//  Created by 曾进宗 on 2019/9/9.
//  Copyright © 2019 HuaXinBlockChain(Shenyang)Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (TouchArea)

/* 改变UIButton的响应区域 扩大点击域 */
- (void)edgeTouchAreaWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end

NS_ASSUME_NONNULL_END
