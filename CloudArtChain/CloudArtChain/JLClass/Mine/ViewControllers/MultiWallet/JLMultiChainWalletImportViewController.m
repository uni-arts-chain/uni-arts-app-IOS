//
//  JLMultiChainWalletImportViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/23.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLMultiChainWalletImportViewController.h"
#import "JLMultiChainWalletImportContentView.h"
#import "JLMultiChainWalletImportChooseTypeView.h"

#import "JLScanViewController.h"

@interface JLMultiChainWalletImportViewController ()<JLMultiChainWalletImportContentViewDelegate>

@property (nonatomic, strong) JLMultiChainWalletImportContentView *contentView;

@property (nonatomic, assign) JLMultiChainImportType importType;
@property (nonatomic, copy) NSArray *sourceArray;

@end

@implementation JLMultiChainWalletImportViewController

#pragma mark - life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"导入钱包";
    [self addBackItem];
    
    _importType = JLMultiChainImportTypeMnemonic;
    
    [self.view addSubview:self.contentView];
}

- (void)rightItemClick {
    WS(weakSelf)
    JLScanViewController *scanVC = [[JLScanViewController alloc] init];
    scanVC.scanType = JLScanTypeImportWallet;
    scanVC.qrCode = true;
    scanVC.resultBlock = ^(NSString * _Nonnull scanResult) {
        weakSelf.contentView.keystore = scanResult;
    };
    scanVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:scanVC animated:YES completion:nil];
}

#pragma mark - JLMultiChainWalletImportContentViewDelegate
- (void)chooseImportType {
    WS(weakSelf)
    [JLMultiChainWalletImportChooseTypeView showWithTitle:@"导入类型" sourceArray:self.sourceArray defaultImportType:_importType completion:^(JLMultiChainImportType  _Nonnull selectType) {
        weakSelf.importType = selectType;
        weakSelf.contentView.importType = selectType;
        if (selectType == JLMultiChainImportTypeKeystore) {
            [weakSelf addRightItemImage:@"icon_navi_scan"];
        }else {
            weakSelf.navigationItem.rightBarButtonItem = nil;
        }
    }];
}

- (void)paste {
    WS(weakSelf)
    UIAlertController *alertController = [UIAlertController actionSheetWithTitle:@"JSON文件" buttonTitleArray:@[@"粘贴或输入JSON"] handler:^(NSInteger index) {
        weakSelf.contentView.keystore = [UIPasteboard generalPasteboard].string;
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)nextWithWalletName: (NSString *)walletName
               mnonicArray: (NSArray * _Nullable)mnonicArray
                privateKey: (NSString * _Nullable)privateKey
                  keystore: (NSString * _Nullable)keystore
          keystorePassword: (NSString * _Nullable)keystorePassword {
    WS(weakSelf)
    [[JLLoading sharedLoading] showLoadingWithMessage:@"导入中..." onView:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.importType == JLMultiChainImportTypeMnemonic) {
            [JLEthereumTool.shared importWalletWithMnemonics:mnonicArray completion:^(NSString * _Nullable address, NSString * _Nullable errorMsg) {
                [[JLLoading sharedLoading] hideLoading];
                if (![NSString stringIsEmpty:address]) {
                    [weakSelf importCompletionWithWalletName:walletName];
                }else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:@"导入失败，请检查助记词是否正确" hideTime:KToastDismissDelayTimeInterval];
                }
            }];
        }else if (weakSelf.importType == JLMultiChainImportTypePrivateKey) {
            [JLEthereumTool.shared importWalletWithPrivateKey:privateKey completion:^(NSString * _Nullable address, NSString * _Nullable errorMsg) {
                [[JLLoading sharedLoading] hideLoading];
                if (![NSString stringIsEmpty:address]) {
                    [weakSelf importCompletionWithWalletName:walletName];
                }else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:@"导入失败，请检查私钥是否正确" hideTime:KToastDismissDelayTimeInterval];
                }
            }];
        }else if (weakSelf.importType == JLMultiChainImportTypeKeystore) {
            [JLEthereumTool.shared importWalletWithKeystoreJson:keystore password:keystorePassword completion:^(NSString * _Nullable address, NSString * _Nullable errorMsg) {
                [[JLLoading sharedLoading] hideLoading];
                if (![NSString stringIsEmpty:address]) {
                    [weakSelf importCompletionWithWalletName:walletName];
                }else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:@"导入失败，请检查密码或JSON文件是否正确" hideTime:KToastDismissDelayTimeInterval];
                }
            }];
        }
    });
}

#pragma mark - private methods
- (void)importCompletionWithWalletName: (NSString *)walletName {
    [[JLLoading sharedLoading] showMBSuccessTipMessage:@"导入成功" hideTime:KToastDismissDelayTimeInterval];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LOCALNOTIFICATION_JL_IMPORTMULTIWALLETSUCCESS object:nil userInfo:@{ @"walletName": walletName }];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - setters and getters
- (JLMultiChainWalletImportContentView *)contentView {
    if (!_contentView) {
        _contentView = [[JLMultiChainWalletImportContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height)];
        _contentView.delegate = self;
        _contentView.importType = _importType;
    }
    return _contentView;
}

- (NSArray *)sourceArray {
    if (!_sourceArray) {
        _sourceArray = @[JLMultiChainImportTypeMnemonic,
                         JLMultiChainImportTypePrivateKey,
                         JLMultiChainImportTypeKeystore];
    }
    return _sourceArray;
}

@end
