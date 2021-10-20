//
//  JLTabbarController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLTabbarController.h"
#import "JLHomeViewController.h"
#import "JLMarketViewController.h"
//#import "JLCategoryViewController.h"
#import "JLCreatorViewController.h"
#import "JLDappViewController.h"
#import "JLShoppingCartViewController.h"
#import "JLMineViewController.h"

@interface JLTabbarController ()<UITabBarControllerDelegate>

@end

@implementation JLTabbarController
- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建viewControllers
    JLNavigationViewController *navHomeVC = [[JLNavigationViewController alloc] initWithRootViewController:[[JLHomeViewController alloc] init]];
    JLNavigationViewController *navCategoryVC = [[JLNavigationViewController alloc] initWithRootViewController:[[JLMarketViewController alloc] init]];
//    JLNavigationViewController *navShoppingCartVC = [[JLNavigationViewController alloc] initWithRootViewController:[[JLShoppingCartViewController alloc] init]];
    JLNavigationViewController *naviCreatorVC = [[JLNavigationViewController alloc] initWithRootViewController:[[JLCreatorViewController alloc] init]];
    JLNavigationViewController *navDappVC = [[JLNavigationViewController alloc] initWithRootViewController:[[JLDappViewController alloc] init]];
    JLNavigationViewController *navMineVC = [[JLNavigationViewController alloc] initWithRootViewController:[[JLMineViewController alloc] init]];
    
    self.viewControllers = @[navHomeVC, navCategoryVC, naviCreatorVC, navDappVC, navMineVC];
    
    // 使tabbar显示出来
    self.tabBar.translucent = NO;
    
    self.delegate = self;

    // 设置tabbarItem.title两种状态颜色
    NSDictionary *normalDic = @{NSForegroundColorAttributeName: JL_color_gray_606060, NSFontAttributeName: kFontPingFangSCRegular(11.0f)};
    NSDictionary *selectedDic = @{NSForegroundColorAttributeName: JL_color_gray_101010, NSFontAttributeName: kFontPingFangSCRegular(11.0f)};
    
    NSArray *titleArray = @[@"首页",
                            @"市场",
                            @"创作者",
                            @"发现",
                            @"我的"];
    NSArray *normalImageNameArray = @[@"icon_tab_nomal_home",
                                      @"icon_tab_normal_market",
                                      @"icon_tab_nomal_creator",
                                      @"icon_tab_normal_find",
                                      @"icon_tab_nomal_mine"];
    
    NSArray *selectedImageNameArray = @[@"icon_tab_selected_home",
                                        @"icon_tab_selected_market",
                                        @"icon_tab_selected_creator",
                                        @"icon_tab_selected_find",
                                        @"icon_tab_selected_mine"];
    // 设置  tabBarItem.title  tabBarItem.image  tabBarItem.selectedImage
    for (int i = 0; i < titleArray.count; i++)  {
        UITabBarItem *tabBarItem = self.tabBar.items[i];
        tabBarItem.title = titleArray[i];
        tabBarItem.image = [[UIImage imageNamed:normalImageNameArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageNameArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [tabBarItem setTitleTextAttributes:normalDic forState:UIControlStateNormal];
        [tabBarItem setTitleTextAttributes:selectedDic forState:UIControlStateSelected];
     }
    
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *tabBarAppearance = [[UITabBarAppearance alloc] init];
        tabBarAppearance.backgroundColor = JL_color_white_ffffff;
        tabBarAppearance.shadowColor = [UIColor clearColor];
        tabBarAppearance.shadowImage = [UIImage new];
        tabBarAppearance.backgroundImage = [UIImage new];
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = normalDic;
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedDic;
        if (@available(iOS 15.0, *)) {
            self.tabBar.scrollEdgeAppearance = tabBarAppearance;
        }
        self.tabBar.standardAppearance = tabBarAppearance;
    }else {
        // 去掉tabbar顶部灰线
        self.tabBar.shadowImage = [UIImage new];
        self.tabBar.backgroundImage = [UIImage new];
        self.tabBar.barTintColor = JL_color_white_ffffff;
    }
    
    [self.tabBar addShadow:[UIColor colorWithHexString:@"#404040"] cornerRadius:5.0f offsetX:0.0f];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]){
        UIViewController *topVC = [(UINavigationController *)viewController topViewController];
        if ([topVC isKindOfClass:[JLMineViewController class]]) {
            if ([JLLoginUtil haveSelectedAccount]) {
                return YES;
            } else {
                [JLLoginUtil presentCreateWallet];
                return NO;
            }
        } else if ([topVC isKindOfClass:[JLDappViewController class]]) {
            if ([JLLoginUtil haveSelectedAccount]) {
                return YES;
            } else {
                [JLLoginUtil presentCreateWallet];
                return NO;
            }
        }
    }
    return YES;
}

//- (void)presentLoginViewController:(UIViewController *)topVC{
//    __block NSUInteger index;
//    __weak typeof (self) weakSelf = self;
//    JLLoginSuccessBlock success = ^{
//        if ([topVC isKindOfClass:[JLAssetViewController class]]) {
//            index = 3;
//        } else if ([topVC isKindOfClass:[JLMinerViewController class]]) {
//            index = 2;
//        } else if ([topVC isKindOfClass:[JLMineViewController class]]) {
//            index = 4;
//        }
//        weakSelf.selectedIndex = index;
//    };
//    [LoginUtil presentLoginViewControllerWithSuccess:success failure:nil];
//}

@end
