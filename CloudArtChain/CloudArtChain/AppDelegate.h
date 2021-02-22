//
//  AppDelegate.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "云画链-Swift.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) JLWalletTool *walletTool;
- (void)setDeviceOrientationIsLandscapeRight:(BOOL)isLandscapeRight;
@end

