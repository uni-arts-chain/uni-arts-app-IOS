//
//  UIView+JLCorner.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (JLCorner)
- (void)setCorners:(UIRectCorner)corners radius:(CGSize)cornerRadii;
//视图截图
- (UIImage *)snapshotImage;

//获取视图某个范围截图
+ (UIImage *)snapshotImageFromView:(UIView *)view atFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
