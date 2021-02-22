//
//  HVideoViewController.h
//  Join
//
//  Created by 黄克瑾 on 2017/1/11.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TakeOperationSureBlock)(id item);

@interface HVideoViewController : UIViewController

@property (copy, nonatomic) TakeOperationSureBlock takeBlock;

@property (assign, nonatomic) NSInteger HSeconds;

@property (nonatomic, assign) BOOL customDismiss;

/// 是否允许拍摄视频
@property (nonatomic, assign) BOOL allowTakeVideo;

@end
