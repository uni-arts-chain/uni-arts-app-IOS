//
//  JLMultiChainWalletViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/18.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLMultiChainWalletViewController.h"
#import "JLMultiChainWalletContentView.h"

#import "JLMultiChainWalletInfoViewController.h"

@interface JLMultiChainWalletViewController ()<JLMultiChainWalletContentViewDelegate>

@property (nonatomic, strong) JLMultiChainWalletContentView *contentView;

@property (nonatomic, strong) NSMutableArray *walletInfoArray;

@end

@implementation JLMultiChainWalletViewController

#pragma mark - life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _symbol;
    [self addBackItem];
    
    [self.view addSubview:self.contentView];
    
    [self prepareSource];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareSource) name:LOCALNOTIFICATION_JL_IMPORTMULTIWALLETSUCCESS object:nil];
}

#pragma mark - JLMultiChainWalletContentViewDelegate
/// 查看钱包
/// @param index 列表索引
- (void)lookWalletWithIndex: (NSInteger)index {
    JLMultiWalletInfo *info = [[JLMultiWalletInfo alloc] init];
    info.userAvatar = [AppSingleton sharedAppSingleton].userBody.avatar[@"url"];
    if (_symbol == JLMultiChainWalletSymbolETH) {
        JLEthereumWalletInfo *walletInfo = self.walletInfoArray[index];
        // 包装信息
        info.symbol = _symbol;
        info.address = walletInfo.address;
        info.name = walletInfo.name;
    }
    JLMultiChainWalletInfoViewController *vc = [[JLMultiChainWalletInfoViewController alloc] init];
    vc.walletInfo = info;
    [self.navigationController pushViewController:vc animated:YES];
}
/// 导入钱包
- (void)importWallet {
    UIAlertController *alertVC = [UIAlertController alertShowWithTitle:@"提示" message:@"重新导入钱包后，当前钱包将被覆盖，请先备份好当前钱包助记词" cancel:@"取消" cancelHandler:^{

    } confirm:@"继续导入" confirmHandler:^{
        
    }];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - private methods
/// 准备数据
- (void)prepareSource {
    [self.walletInfoArray removeAllObjects];
    // 链类型
    if (_symbol == JLMultiChainWalletSymbolETH) {
        JLEthereumWalletInfo *walletInfo = [JLEthereumTool.shared currentWalletInfo];
        if (walletInfo) {
            NSArray *arr = [[NSUserDefaults standardUserDefaults] arrayForKey:USERDEFAULTS_JL_MULTI_WALLET_NAME];
            if (arr && arr.count) {
                for (NSDictionary *dict in arr) {
                    NSString *name = dict[walletInfo.storeKey];
                    walletInfo.name = name;
                    break;
                }
            }
            [self.walletInfoArray addObject:walletInfo];
        }
    }
    [self.contentView setMultiWalletSymbol:_symbol walletInfoArray:[self.walletInfoArray copy]];
}

#pragma mark - setters and getters
- (JLMultiChainWalletContentView *)contentView {
    if (!_contentView) {
        _contentView = [[JLMultiChainWalletContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height)];
        _contentView.delegate = self;
    }
    return _contentView;
}

- (NSMutableArray *)walletInfoArray {
    if (!_walletInfoArray) {
        _walletInfoArray = [NSMutableArray array];
    }
    return _walletInfoArray;
}

@end
