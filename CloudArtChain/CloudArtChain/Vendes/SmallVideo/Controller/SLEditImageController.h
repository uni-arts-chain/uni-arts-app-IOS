//
//  SLEditImageController.h
//  DarkMode
//
//  Created by wsl on 2019/10/31.
//  Copyright © 2019 wsl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLEditImageController : UIViewController
@property (nonatomic, strong) UIImage *image; //当前拍摄的照片
// 是否保存图片到本地
@property (nonatomic, assign) BOOL saveToAlbum;
@property (nonatomic,   copy) void(^imageEditBlock)(UIImage *image);
@property (nonatomic,   copy) void(^againShotBlock)(void);
@end

NS_ASSUME_NONNULL_END
