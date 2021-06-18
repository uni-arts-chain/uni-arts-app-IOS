//
//  JLTabbarController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLTabbarController.h"
#import "JLHomeViewController.h"
#import "JLCategoryViewController.h"
#import "JLCreatorViewController.h"
#import "JLBoxViewController.h"
#import "JLShoppingCartViewController.h"
#import "JLMineViewController.h"

@interface JLTabbarController ()<UITabBarControllerDelegate>

@end

@implementation JLTabbarController
- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建viewControllers
    JLHomeViewController *homeVC = [[JLHomeViewController alloc] init];
    JLCategoryViewController *newVC = [[JLCategoryViewController alloc] init];
    newVC.type = JLCategoryViewControllerTypeNew;
    JLCategoryViewController *oldVC = [[JLCategoryViewController alloc] init];
    oldVC.type = JLCategoryViewControllerTypeOld;
    JLMineViewController *mineVC = [[JLMineViewController alloc] init];
    
    JLNavigationViewController *homeNav = [[JLNavigationViewController alloc] initWithRootViewController:homeVC];
    JLNavigationViewController *newNav = [[JLNavigationViewController alloc] initWithRootViewController:newVC];
    JLNavigationViewController *oldNav = [[JLNavigationViewController alloc] initWithRootViewController:oldVC];
    JLNavigationViewController *mineNav = [[JLNavigationViewController alloc] initWithRootViewController:mineVC];
    
    self.viewControllers = @[homeNav, newNav, oldNav, mineNav];
    
    // 使tabbar显示出来
    self.tabBar.translucent = NO;
    
    // 去掉tabbar顶部灰线
    self.tabBar.shadowImage = [UIImage new];
    self.tabBar.backgroundImage = [UIImage new];
    self.delegate = self;
    self.tabBar.barTintColor = JL_color_white_ffffff;
    
    // 设置tabbarItem.title两种状态颜色
    NSDictionary *normalDic = @{NSForegroundColorAttributeName: JL_color_white_ffffff, NSFontAttributeName: kFontPingFangSCRegular(11.0f)};
    NSDictionary *selectedDic = @{NSForegroundColorAttributeName: JL_color_white_ffffff, NSFontAttributeName: kFontPingFangSCRegular(11.0f)};
    
    NSArray *titleArray = @[@"首页",
                            @"新品",
                            @"二手",
                            @"我的"];
    NSArray *normalImageNameArray = @[@"icon_tab_nomal_home",
                                      @"icon_tab_normal_new",
                                      @"icon_tab_normal_old",
                                      @"icon_tab_nomal_mine"];
    
    NSArray *selectedImageNameArray = @[@"icon_tab_selected_home",
                                        @"icon_tab_selected_new",
                                        @"icon_tab_selected_old",
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
        } else if ([topVC isKindOfClass:[JLBoxViewController class]]) {
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
