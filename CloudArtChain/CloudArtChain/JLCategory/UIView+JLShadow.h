//
//  UIView+JLShadow.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (JLShadow)
/**
 添加默认圆角阴影
 */
- (void)addDefaultShadow;

/**
 添加阴影和圆角
 
 @param shaowColor 阴影颜色
 @param radius 圆角大小
 */
- (void)addShadow:(UIColor*)shaowColor cornerRadius:(CGFloat)radius  offsetX:(CGFloat)x;
@end

NS_ASSUME_NONNULL_END
