//
//  AppDelegate.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "AppDelegate.h"
#import "JLGuidePageView.h"
#import <UMCommon/UMCommon.h>
#import <UMCommonLog/UMCommonLogHeaders.h>


@interface AppDelegate ()
@property (assign, nonatomic) BOOL isLandscapeRight; //是否允许转向
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self clearCache];
    if (@available(iOS 11.0, *)) {//避免滚动视图顶部出现20的空白以及push或者pop的时候页面有一个上移或者下移的异常动画的问题
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    // 系统信息
//    [AppSingleton systemInfo];
    // 检测持久化登录token有效期
//    [AppSingleton loginInfon];
//    [JLVersionManager checkVersion];
    [self createIQKeyboardManager];
    [self initUM];
    [self showMainViewController];
    [JLGuidePageView showGuidePage];
    [self setupAppearance];
    [self rpcTest];
    return YES;
}

- (void)rpcTest {
//    [NetworkRPCRequest testAccountInfoUniArtsAndReturnError:nil];
    [NetworkRPCRequest testAccountInfoUniArtsAndReturnError:nil block:^(BOOL success) {
        NSLog(@"test : %d", success)
    }];
}

#pragma mark 清除网络缓存
- (void)clearCache {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void) createIQKeyboardManager{
    // 全局键盘管理器
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    // 点击背景退键盘
    manager.shouldResignOnTouchOutside = YES;
    // 键盘和TextField之间距离
    manager.keyboardDistanceFromTextField = 0;
    manager.toolbarTintColor = JL_color_gray_101010;
}

- (void) initUM{
    [UMConfigure setEncryptEnabled:YES];//打开加密传输
    //开发者需要显式的调用此函数，日志系统才能工作
    [UMCommonLogManager setUpUMCommonLogManager];
//    [UMConfigure setLogEnabled:YES];//设置打开日志
    [UMConfigure initWithAppkey:@"5f6959dea4ae0a7f7d09cd7d" channel:@"myex.io"];
}

- (void)showMainViewController{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    JLNavigationViewController * navigationController = [[JLNavigationViewController alloc] initWithRootViewController:[JLTabbarController new]];
    [AppSingleton sharedAppSingleton].globalNavController = navigationController;
    [AppSingleton sharedAppSingleton].loginUtil = [[JLLoginUtil alloc] init];
    self.window.rootViewController = navigationController;
    self.walletTool = [[JLWalletTool alloc] initWithWindow:self.window];
    [self.window makeKeyAndVisible];
}

- (void)setupAppearance {
    [[UITextView appearance] setTintColor:JL_color_gray_101010];
    [[UITextField appearance] setTintColor:JL_color_gray_101010];
    
    // 设置导航条背景色
    [[UINavigationBar appearance] setBarTintColor:JL_color_white_ffffff];
    
    // tintColor(这里主要调整返回箭头颜色)
    [[UINavigationBar appearance] setTintColor:JL_color_gray_212121];
    
    // 设置导航条title颜色及字体
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: kFontPingFangSCRegular(18),NSForegroundColorAttributeName: JL_color_gray_212121}];
    
    [[UITabBar appearance] setTranslucent:NO];
}

- (void)setDeviceOrientationIsLandscapeRight:(BOOL)isLandscapeRight {
    self.isLandscapeRight = isLandscapeRight;
    if (isLandscapeRight) {
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    } else {
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }
}

@end
