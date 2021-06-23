//
//  UIImage+JLTool.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIImage (JLTool)

/// 图片剪裁
/// @param bounds 位置 大小
- (UIImage *)croppedImage:(CGRect)bounds;

/// 图片压缩
/// @param newSize 尺寸
/// @param quality 质量
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;

/// 图片压缩
/// @param contentMode 视图模式
/// @param bounds 位置 大小
/// @param quality 质量
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;

- (CGAffineTransform)transformForOrientation:(CGSize)newSize;

/// 自动校正图片方向
- (UIImage *)fixOrientation;

/// 图片旋转
/// @param degrees 旋转角度
- (UIImage *)rotatedByDegrees:(CGFloat)degrees;

/**
 地图路线图

 @param color 颜色
 @return 地图路线图
 */
+ (UIImage *)getRouteArrowImageWithColor:(UIColor *)color;

/// 根据颜色生成指定大小的图片
/// @param imageColor 图片颜色
/// @param width 宽度
/// @param height 高度
+ (UIImage *)getImageWithColor:(UIColor *)imageColor width:(CGFloat)width height:(CGFloat)height;

/// 图片浏览默认图片
+ (UIImage *)imageBrowserDefaultImage;

/** 图片压缩 */
+ (NSData*)compressOriginalImage:(UIImage *)image;

/// 根据url获取视频第几帧
+ (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

/// 修改指定图片颜色生成新的图片
/// @param image 原图片
/// @param color 图片颜色
+ (UIImage *)jl_changeImage:(UIImage *)image color:(UIColor *)color;

@end
