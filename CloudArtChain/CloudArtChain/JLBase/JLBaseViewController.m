//
//  JLBaseViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseViewController.h"

@interface JLBaseViewController ()

@end

@implementation JLBaseViewController
#pragma mark - Life Cycle
- (void)dealloc {
    printf("%s dealloc\n", NSStringFromClass([self class]).UTF8String);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = JL_color_white_ffffff;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    
    UITableView.appearance.estimatedRowHeight = 0.0f;
    UITableView.appearance.estimatedSectionFooterHeight = 0.0f;
    UITableView.appearance.estimatedSectionHeaderHeight = 0.0f;
}

- (void)addBackItem {
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] init];
    leftBarButtonItem.style = UIBarButtonItemStylePlain;
    leftBarButtonItem.image = [UIImage imageNamed:@"icon_back"];
    leftBarButtonItem.target = self;
    [leftBarButtonItem setAction:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem ;
}

- (void)addBackItemImage:(NSString *)imageStr {
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageStr] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
}

- (void)addRightItemImage:(NSString *)imageStr {
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageStr] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemClick {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.customUMLogPageName) {
        [MobClick beginLogPageView:self.customUMLogPageName];
    } else if (self.title && self.title.length != 0) {
        [MobClick beginLogPageView:self.title];
    } else {
        [MobClick beginLogPageView:NSStringFromClass([self class])];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    if (self.customUMLogPageName) {
        [MobClick endLogPageView:self.customUMLogPageName];
    } else if (self.title && self.title.length != 0) {
        [MobClick endLogPageView:self.title];
    } else {
        [MobClick endLogPageView:NSStringFromClass([self class])];
    }
}
@end
