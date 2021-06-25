//
//  JLAlertTipView.h
//  CloudArtChain
//
//  Created by jielian on 2021/6/25.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JLAlertTipViewCancelBlock)(void);
typedef void(^JLAlertTipViewDoneBlock)(void);

@interface JLAlertTipView : UIView

+ (void)alertWithTitle: (NSString *)title message: (NSString *)message doneTitle: (NSString *)doneTitle done: (JLAlertTipViewDoneBlock)done;

+ (void)alertWithTitle: (NSString *)title message: (NSString *)message doneTitle: (NSString *)doneTitle cancelTitle: (NSString *)cancelTitle done: (JLAlertTipViewDoneBlock)done cancel: (JLAlertTipViewCancelBlock)cancel;

@end
