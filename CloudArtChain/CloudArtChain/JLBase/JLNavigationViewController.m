//
//  JLNavigationViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLNavigationViewController.h"

@interface JLNavigationViewController ()

@end

@implementation JLNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航条不透明
    self.navigationBar.translucent = NO;
    // 设置导航条背景色
    self.navigationBar.barTintColor = JL_color_white_ffffff;
    // tintColor(这里主要调整返回箭头颜色)
    self.navigationBar.tintColor = JL_color_fontdeep;
    // 设置导航条title颜色及字体
    NSDictionary *attrDict = @{NSFontAttributeName: kFontPingFangSCRegular(18)};
    self.navigationBar.titleTextAttributes = attrDict;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: JL_color_gray_333333};
    // 去掉navigationBar底部灰线
    self.navigationBar.shadowImage = [UIImage new];
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        //第二级则隐藏底部Tab
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
@end
