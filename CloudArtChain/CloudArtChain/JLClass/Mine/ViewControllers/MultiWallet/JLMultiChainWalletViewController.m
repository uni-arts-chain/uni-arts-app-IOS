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
#import "JLMultiChainWalletImportViewController.h"

@interface JLMultiChainWalletViewController ()<JLMultiChainWalletContentViewDelegate>

@property (nonatomic, strong) JLMultiChainWalletContentView *contentView;

@property (nonatomic, strong) NSMutableArray *walletInfoArray;
@property (nonatomic, assign) NSInteger currentLookWallet;

@end

@implementation JLMultiChainWalletViewController

#pragma mark - life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _chainSymbol;
    [self addBackItem];
    
    [self.view addSubview:self.contentView];
    
    [self prepareSource];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(importWalletSuccess:) name:LOCALNOTIFICATION_JL_IMPORTMULTIWALLETSUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMultiWalletName:) name:LOCALNOTIFICATION_JL_CHANGEMULTIWALLETNAMESUCCESS object:nil];
}

#pragma mark - JLMultiChainWalletContentViewDelegate
/// 查看钱包
/// @param index 列表索引
- (void)lookWalletWithIndex: (NSInteger)index {
    _currentLookWallet = index;
    
    JLMultiWalletInfo *info = [[JLMultiWalletInfo alloc] init];
    info.userAvatar = [AppSingleton sharedAppSingleton].userBody.avatar[@"url"];
    if (_chainSymbol == JLMultiChainSymbolETH) {
        JLEthereumWalletInfo *walletInfo = self.walletInfoArray[index];
        // 包装信息
        info.chainSymbol = _chainSymbol;
        info.chainName = _chainName;
        info.chainImageNamed = _imageNamed;
        info.address = walletInfo.address;
        info.walletName = walletInfo.name;
        info.storeKey = walletInfo.storeKey;
    }
    JLMultiChainWalletInfoViewController *vc = [[JLMultiChainWalletInfoViewController alloc] init];
    vc.walletInfo = info;
    JLNavigationViewController *navVC = [[JLNavigationViewController alloc] initWithRootViewController:vc];
    navVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navVC animated:YES completion:nil];
}
/// 导入钱包
- (void)importWallet {
    WS(weakSelf)
    UIAlertController *alertVC = [UIAlertController alertShowWithTitle:@"提示" message:@"重新导入钱包后，当前钱包将被覆盖，请先备份好当前钱包助记词" cancel:@"取消" cancelHandler:^{

    } confirm:@"继续导入" confirmHandler:^{
        JLMultiChainWalletImportViewController *vc = [[JLMultiChainWalletImportViewController alloc] init];
        vc.chainSymbol = weakSelf.chainSymbol;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - Notification
- (void)changeMultiWalletName: (NSNotification *)noti {
    NSDictionary *dict = noti.userInfo;
    JLEthereumWalletInfo *walletInfo = self.walletInfoArray[_currentLookWallet];
    NSString *walletName = dict[walletInfo.storeKey];
    if (![NSString stringIsEmpty:walletName]) {
        walletInfo.name = walletName;
        
        [self.contentView setMultiWalletSymbol:_chainSymbol walletInfoArray:[self.walletInfoArray copy]];
    }
}

- (void)importWalletSuccess: (NSNotification *)noti {
    NSDictionary *dict = noti.userInfo;
    [self saveWalletName:dict[@"walletName"]];
    
    [self prepareSource];
}

#pragma mark - private methods
/// 准备数据
- (void)prepareSource {
    [self.walletInfoArray removeAllObjects];
    // 链类型
    if (_chainSymbol == JLMultiChainSymbolETH) {
        JLEthereumWalletInfo *walletInfo = [JLEthereumTool.shared currentWalletInfo];
        if (walletInfo) {
            NSArray *arr = [[NSUserDefaults standardUserDefaults] arrayForKey:USERDEFAULTS_JL_MULTI_WALLET_NAME];
            if (arr && arr.count) {
                for (NSDictionary *dict in arr) {
                    if ([dict.allKeys.firstObject isEqualToString:walletInfo.storeKey]) {
                        walletInfo.name = dict[walletInfo.storeKey];
                        break;
                    }
                }
            }
            [self.walletInfoArray addObject:walletInfo];
        }
    }
    [self.contentView setMultiWalletSymbol:_chainSymbol walletInfoArray:[self.walletInfoArray copy]];
}

- (void)saveWalletName: (NSString *)walletName {
    JLEthereumWalletInfo *walletInfo = [JLEthereumTool.shared currentWalletInfo];
    NSArray *arr = [[NSUserDefaults standardUserDefaults] arrayForKey:USERDEFAULTS_JL_MULTI_WALLET_NAME];
    NSMutableArray *resultArr = [NSMutableArray arrayWithArray:arr];
    NSDictionary *resultDict = @{ walletInfo.storeKey : walletName };
    
    BOOL isFind = NO;
    for (int i = 0; i < resultArr.count; i++) {
        NSDictionary *dict = resultArr[i];
        NSString *name = dict[walletInfo.storeKey];
        if (![NSString stringIsEmpty:name]) {
            isFind = YES;
            [resultArr replaceObjectAtIndex:i withObject:resultDict];
            break;
        }
    }
    
    if (!isFind) {
        [resultArr addObject:resultDict];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[resultArr copy] forKey:USERDEFAULTS_JL_MULTI_WALLET_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
