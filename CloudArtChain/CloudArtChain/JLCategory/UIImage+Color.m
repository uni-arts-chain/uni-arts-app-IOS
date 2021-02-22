//
//  UIImage+Color.m
//  Rfinex
//
//  Created by superman on 2018/3/15.
//  Copyright © 2018年 HuaXinBlockChain(Shenyang)Tech. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIImage*)getCricleWithColor:(UIColor *)color size:(CGSize)size {
    
    if (size.width <= 1) {
        size.width = 30;
        size.height = 30;
    }
    
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    //获取当前图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //添加一个椭圆，第一个参数是在那个上下文上面添加，，，第二个参数是设定一个矩形框，这个椭圆会”填充“这个矩形框，如果这个矩形框是正方形，那么就是圆
    CGRect rect =CGRectMake(0, 0, size.width, size.height);
    CGContextAddEllipseInRect(context,rect);
    CGContextClip(context);
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    // 裁剪
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

@end
