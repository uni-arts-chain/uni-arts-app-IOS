//
//  JLChooseChainWalletViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/18.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLChooseChainWalletViewController.h"
#import "JLChooseChainWalletContentView.h"

#import "JLMultiChainWalletViewController.h"

@interface JLChooseChainWalletViewController ()<JLChooseChainWalletContentViewDelegate>

@property (nonatomic, strong) JLChooseChainWalletContentView *contentView;

@end

@implementation JLChooseChainWalletViewController

#pragma mark - life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择链类型";
    [self addBackItem];
    
    [self.view addSubview:self.contentView];
}

#pragma mark - JLChooseChainWalletContentViewDelegate
- (void)chooseChainSymbol: (JLMultiChainSymbol)symbol chainName: (JLMultiChainName)chainName imageNamed: (NSString *)imageNamed {
    if (symbol == JLMultiChainSymbolUART) {
        NSString *userAvatar = [NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.avatar[@"url"]] ? nil : [AppSingleton sharedAppSingleton].userBody.avatar[@"url"];
        [[JLViewControllerTool appDelegate].walletTool presenterLoadOnLaunchWithNavigationController:[AppSingleton sharedAppSingleton].globalNavController userAvatar:userAvatar];
    }else {
        JLMultiChainWalletViewController *vc = [[JLMultiChainWalletViewController alloc] init];
        vc.chainSymbol = symbol;
        vc.chainName = chainName;
        vc.imageNamed = imageNamed;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - setters and getters
- (JLChooseChainWalletContentView *)contentView {
    if (!_contentView) {
        _contentView = [[JLChooseChainWalletContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height)];
        _contentView.delegate = self;
    }
    return _contentView;
}

@end
