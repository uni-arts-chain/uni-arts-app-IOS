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
    [AppSingleton systemInfo];
    // 检测持久化登录token有效期
    [AppSingleton loginInfon];
//    [JLVersionManager checkVersion];
    [self createIQKeyboardManager];
    [self initUM];
    [self showMainViewController];
    [JLGuidePageView showGuidePage];
    [self setupAppearance];
    [self rpcTest];
    // 个推
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    [self registerRemoteNotification];
    return YES;
}

- (void)rpcTest {
//    [NetworkRPCRequest testAccountInfoUniArtsAndReturnError:nil];
    [NetworkRPCRequest testAccountInfoUniArtsAndReturnError:nil block:^(BOOL success) {
        NSLog(@"test : %d", success)
    }];
}

#pragma mark - 用户通知(推送) _ 自定义方法

/**
 * [ 参考代码，开发者注意根据实际需求自行修改 ] 注册远程通知
 *
 * 警告：Xcode8及以上版本需要手动开启“TARGETS -> Capabilities -> Push Notifications”
 * 警告：该方法需要开发者自定义，以下代码根据APP支持的iOS系统不同，代码可以对应修改。以下为参考代码
 * 注意根据实际需要修改，注意测试支持的iOS系统都能获取到DeviceToken
 *
 */
- (void)registerRemoteNotification {
    float iOSVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (iOSVersion >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error && granted) {
                NSLog(@"注册通知成功");
            } else {
                NSLog(@"注册通知失败");
            }
        }];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        return;
    }
    
    if (iOSVersion >= 8.0) {
//        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionAlert | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error && granted) {
                NSLog(@"注册通知成功");
            } else {
                NSLog(@"注册通知失败");
            }
        }];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
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


#pragma mark - 远程通知(推送)回调

/// [ 系统回调 ] 远程通知注册成功回调，获取DeviceToken成功，同步给个推服务器
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // [ GTSDK ]：（新版）向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceTokenData:deviceToken];
    
    NSString *token = [JLTool getHexStringForData:deviceToken];
    NSLog(@"[ CloudArtChain ] [ DeviceToken(NSString) ]: %@\n\n", token);
}

/// [ 系统回调:可选 ] 远程通知注册失败回调，获取DeviceToken失败，打印错误信息
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *errorMsg = [NSString stringWithFormat:@"%@: %@", NSStringFromSelector(_cmd), error.localizedDescription];
    NSLog(@"[ CloudArtChain ] %@", errorMsg);
}


// MARK: - iOS 10+中收到推送消息

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
/// [ 系统回调 ] iOS 10及以上  APNs通知将要显示时触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSLog(@"[ CloudArtChain ] [APNs] %@：%@", NSStringFromSelector(_cmd), notification.request.content.userInfo);
    // [ 参考代码，开发者注意根据实际需求自行修改 ] 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    //completionHandler(UNNotificationPresentationOptionNone); 若不显示通知，则无法点击通知
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

/// [ 系统回调 ] iOS 10及以上 收到APNs推送并点击时触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSLog(@"[ CloudArtChain ] [APNs] %@ \nTime:%@ \n%@",
          NSStringFromSelector(_cmd),
          response.notification.date,
          response.notification.request.content.userInfo);
    
    // [ GTSDK ]：将收到的APNs信息同步给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    completionHandler();
}

#endif

#pragma mark - APP运行中接收到通知(推送)处理 - iOS 10以下版本收到推送
/// [ 系统回调 ] 收到静默通知。iOS 10以下收到APNs推送并点击时触发、APP在前台时收到APNs推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    NSLog(@"[ CloudArtChain ] [APNs] %@：%@", NSStringFromSelector(_cmd), userInfo);
    // [ GTSDK ]：将收到的APNs信息同步给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    
    // [ 参考代码，开发者注意根据实际需求自行修改 ] 根据APP需要自行修改参数值
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - GeTuiSdkDelegate

/// [ GTSDK回调 ] SDK启动成功返回cid
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    NSLog(@"[ CloudArtChain ] [GTSdk RegisterClient]:%@", clientId);
}

/// [ GTSDK回调 ] SDK收到透传消息回调
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    // [ GTSDK ]：汇报个推自定义事件(反馈透传消息)
    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
    NSString *payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    NSString *msg = [NSString stringWithFormat:@"Receive Payload: %@, taskId: %@, messageId: %@ %@", payloadMsg, taskId, msgId, offLine ? @"<离线消息>" : @""];
    NSLog(@"[ CloudArtChain ] [GTSdk ReceivePayload]:%@", msg);
}

/// [ GTSDK回调 ] SDK收到sendMessage消息回调
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    NSString *msg = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
    NSLog(@"[ CloudArtChain ] [GeTuiSdk DidSendMessage]:%@\n\n",msg);
}

/// [ GTSDK回调 ] SDK运行状态通知
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    [[NSNotificationCenter defaultCenter] postNotificationName:GTSdkStateNotification object:self];
}

/// [ GTSDK回调 ] SDK设置推送模式回调
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
        NSLog(@"%@", [NSString stringWithFormat:@">>>[SetModeOff error]: %@", [error localizedDescription]]);
    }
    NSLog(@"%@", [NSString stringWithFormat:@">>>[GexinSdkSetModeOff]: %@", isModeOff ? @"开启" : @"关闭"]);
}

- (void)GeTuiSdkDidOccurError:(NSError *)error {
    NSLog(@"[ CloudArtChain ] [GeTuiSdk GeTuiSdkDidOccurError]:%@\n\n",error.localizedDescription);
}

- (void)GeTuiSdkDidAliasAction:(NSString *)action result:(BOOL)isSuccess sequenceNum:(NSString *)aSn error:(NSError *)aError {
    /*
     参数说明
     isSuccess: YES: 操作成功 NO: 操作失败
     aError.code:
     30001：绑定别名失败，频率过快，两次调用的间隔需大于 5s
     30002：绑定别名失败，参数错误
     30003：绑定别名请求被过滤
     30004：绑定别名失败，未知异常
     30005：绑定别名时，cid 未获取到
     30006：绑定别名时，发生网络错误
     30007：别名无效
     30008：sn 无效 */
    if([action isEqual:kGtResponseBindType]) {
        NSLog(@"[ CloudArtChain ] bind alias result sn = %@, code = %@", aSn, @(aError.code));
    }
    if([action isEqual:kGtResponseUnBindType]) {
        NSLog(@"[ CloudArtChain ] unbind alias result sn = %@, code = %@", aSn, @(aError.code));
    }
}

- (void)GeTuiSdkDidSetTagsAction:(NSString *)sequenceNum result:(BOOL)isSuccess error:(NSError *)aError {
    /*
     参数说明
     sequenceNum: 请求的序列码
     isSuccess: 操作成功 YES, 操作失败 NO
     aError.code:
     20001：tag 数量过大（单次设置的 tag 数量不超过 100)
     20002：调用次数超限（默认一天只能成功设置一次）
     20003：标签重复
     20004：服务初始化失败
     20005：setTag 异常
     20006：tag 为空
     20007：sn 为空
     20008：离线，还未登陆成功
     20009：该 appid 已经在黑名单列表（请联系技术支持处理）
     20010：已存 tag 数目超限
     20011：tag 内容格式不正确
     */
    NSLog(@"[ CloudArtChain ] GeTuiSdkDidSetTagAction sequenceNum:%@ isSuccess:%@ error: %@", sequenceNum, @(isSuccess), aError);
}

@end
