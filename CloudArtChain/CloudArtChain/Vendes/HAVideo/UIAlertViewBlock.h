//
//  UIAlertViewBlock.h
//  CS090Agent
//
//  Created by cs090_jzb on 15/9/14.
//  Copyright (c) 2015年 cs090. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AlertBlock)(UIAlertView *alertView);

@interface UIAlertViewBlock : UIAlertView<UIAlertViewDelegate>

@property (nonatomic, copy)AlertBlock doneBlock;
@property (nonatomic, copy)AlertBlock cancelBlock;

- (void)addDoneBlock:(AlertBlock)doneBlock;
- (void)addCancelBlock:(AlertBlock)cancelBlock;

@end
