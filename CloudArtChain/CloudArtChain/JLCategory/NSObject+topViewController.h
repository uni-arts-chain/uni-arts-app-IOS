
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (topViewController)

- (UIViewController *)topViewController;

- (UIViewController *)topViewControllerWithRootViewController: (UIViewController *)viewController;

- (UIWindow *)getCurrentWindow;

@end

NS_ASSUME_NONNULL_END
