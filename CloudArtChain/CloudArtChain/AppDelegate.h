//
//  AppDelegate.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <UserNotifications/UserNotifications.h>
#import <CoreData/CoreData.h>
#import <SafariServices/SafariServices.h>
#import <SoraUI/SoraUI-Swift.h>
#import <CommonWallet/CommonWallet-Swift.h>
#import <萌易-Swift.h>

@class LAppViewController;
@class LAppView;
@class LAppTextureManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate, GeTuiSdkDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) JLWalletTool *walletTool;
- (void)setDeviceOrientationIsLandscapeRight:(BOOL)isLandscapeRight;

@property (strong, nonatomic) LAppViewController *lAppViewController;
@property (nonatomic, readonly, getter=getTextureManager) LAppTextureManager *textureManager; // 纹理管理器

/**
 * @brief   Cubism SDK の初期化
 */
- (void)initializeCubism;

/**
 * @brief   退出应用程序。
 */
- (void)finishApplication;

- (void)initializeCubismWithBack:(NSString *)backImagePath;

- (void)changeSence:(NSString *)modelPath jsonName:(NSString *)jsonName;

- (void)changeLive2DBack:(NSString *)backImagepath;

@end
