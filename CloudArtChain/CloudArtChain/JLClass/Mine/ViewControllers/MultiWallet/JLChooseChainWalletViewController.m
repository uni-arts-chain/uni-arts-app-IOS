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
        // 显示主钱包
        JLAccountItem *accountItem = [[JLViewControllerTool appDelegate].walletTool getCurrentAccount];
        JLMultiWalletInfo *info = [[JLMultiWalletInfo alloc] init];
        info.userAvatar = [AppSingleton sharedAppSingleton].userBody.avatar[@"url"];
        info.chainSymbol = symbol;
        info.chainName = chainName;
        info.chainImageNamed = imageNamed;
        info.address = accountItem.address;
        info.walletName = accountItem.username;
        JLMultiChainWalletInfoViewController *vc = [[JLMultiChainWalletInfoViewController alloc] init];
        vc.walletInfo = info;
        JLNavigationViewController *navVC = [[JLNavigationViewController alloc] initWithRootViewController:vc];
        navVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:navVC animated:YES completion:nil];
    }else {
        // 选择其他链钱包
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
