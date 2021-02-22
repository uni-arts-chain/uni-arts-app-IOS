//
//  JLViewControllerTool.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLViewControllerTool : NSObject
//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC;

+ (UIViewController *)topViewController;

+ (AppDelegate *)appDelegate;
@end

NS_ASSUME_NONNULL_END
