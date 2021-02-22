//
//  WMPhotoBrowserCell.h
//  WMPhotoBrowser
//
//  Created by zhengwenming on 2018/1/2.
//  Copyright © 2018年 zhengwenming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+WMFrame.h"
#import "JLLoading.h"

@interface WMPhotoBrowserCell : UICollectionViewCell
@property (nonatomic,   copy) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) UIImageView *imageView;
/** 图片加载视图 */
@property (nonatomic, strong) JLLoading *downloadLoading;

@property (nonatomic, retain) id model;
@property (nonatomic,   copy) void (^longPressGestureBlock)(NSIndexPath *pressIndexPath);
@end
