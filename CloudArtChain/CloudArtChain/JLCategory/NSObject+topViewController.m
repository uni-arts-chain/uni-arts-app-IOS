
#import "NSObject+topViewController.h"

@implementation NSObject (topViewController)

- (UIViewController *)topViewController {

    return [self topViewControllerWithRootViewController:[self getCurrentWindow].rootViewController];
}

- (UIViewController *)topViewControllerWithRootViewController: (UIViewController *)viewController {

    if (viewController == nil) {
        return nil;
    }
    if (viewController.presentedViewController != nil) {
        return [self topViewControllerWithRootViewController:viewController.presentedViewController];
    }else if ([viewController isKindOfClass:UITabBarController.class]) {
        return [self topViewControllerWithRootViewController:((UITabBarController *)viewController).selectedViewController];
    }else if ([viewController isKindOfClass:UINavigationController.class]) {
        return [self topViewControllerWithRootViewController:((UINavigationController *)viewController).visibleViewController];
    }else {
        return viewController;
    }
}

- (UIWindow *)getCurrentWindow {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (window.windowLevel != UIWindowLevelNormal) {
        for (UIWindow *tempWindow in [UIApplication sharedApplication].windows) {
            if (tempWindow.windowLevel == UIWindowLevelNormal) {
                window = tempWindow;
                break;
            }
        }
    }
    return window;
}

@end
