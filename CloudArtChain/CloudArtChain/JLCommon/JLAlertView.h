//
//  JLAlertView.h
//  CloudArtChain
//
//  Created by jielian on 2021/7/21.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JLAlertViewDoneBlock)(void);
typedef void(^JLAlertViewCancelBlock)(void);

@interface JLAlertView : UIView

+ (void)alertWithTitle: (NSString *)title message: (NSString *)message doneTitle: (NSString *)doneTitle done: (JLAlertViewDoneBlock)done;

+ (void)alertWithTitle: (NSString *)title message: (NSString *)message doneTitle: (NSString *)doneTitle cancelTitle: (NSString *)cancelTitle done: (JLAlertViewDoneBlock)done cancel: (JLAlertViewCancelBlock)cancel;

@end
