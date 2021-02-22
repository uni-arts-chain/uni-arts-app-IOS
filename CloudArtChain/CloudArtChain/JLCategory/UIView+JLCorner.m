//
//  UIView+JLCorner.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "UIView+JLCorner.h"

@implementation UIView (JLCorner)
- (void)setCorners:(UIRectCorner)corners radius:(CGSize)cornerRadius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadius];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (UIImage *)snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

+ (UIImage *)snapshotImageFromView:(UIView *)view atFrame:(CGRect)frame
{
    if (!view || CGRectEqualToRect(CGRectZero, view.bounds)) {
        return nil;
    }
    // 1、先根据 view，生成 整个 view 的截图
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);  //NO，YES 控制是否透明
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    } else {
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *wholeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 如果 frame 和 bounds 一样，只要返回 wholeImage 就好。
    if (CGRectEqualToRect(frame, view.bounds)) {
        return wholeImage;
    }
    
    // 2、根据 view 的图片。生成指定位置大小的图片。
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGRect imageToExtractFrame = CGRectApplyAffineTransform(frame, CGAffineTransformMakeScale(screenScale, screenScale));
    CGImageRef imageRef = CGImageCreateWithImageInRect([wholeImage CGImage], imageToExtractFrame);
    
    wholeImage = nil;
    
    UIImage *image = [UIImage imageWithCGImage:imageRef
                                         scale:screenScale
                                   orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    return image;
}

@end
