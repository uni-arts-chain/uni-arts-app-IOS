//
//  JLDappWalletConnectViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/10/15.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappWalletConnectViewController.h"
#import "JLScanViewController.h"

typedef NS_ENUM(NSUInteger, JLDappWalletConnectState) {
    JLDappWalletConnectStateConnected,
    JLDappWalletConnectStateDisconnected
};

@interface JLDappWalletConnectViewController ()

@property (nonatomic, strong) UIButton *connectBtn;

@property (nonatomic, assign) JLDappWalletConnectState walletState;

@end

@implementation JLDappWalletConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"链接钱包";
    [self addBackItem];
    _walletState = JLDappWalletConnectStateDisconnected;
    JLLog(@"wc: %@", _wcMessage);
    
    [self.view addSubview:self.connectBtn];
    [self.connectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(100);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
}

#pragma mark - event response
- (void)backClick {
    WS(weakSelf)
    if (_walletState == JLDappWalletConnectStateConnected) {
        UIAlertController *alertVC = [UIAlertController alertShowWithTitle:@"提示" message:@"确定要断开连接?" cancel:@"取消" cancelHandler:^{

        } confirm:@"确定" confirmHandler:^{
            [weakSelf disconnect:^(BOOL isSuccess) {
                if (isSuccess) {
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)connectBtnClick: (UIButton *)sender {
    WS(weakSelf)
    if (_walletState == JLDappWalletConnectStateDisconnected) {
        if (![NSString stringIsEmpty:_wcMessage] && [_wcMessage hasPrefix:@"wc:"]) {
            [self refreshConnectingUI];
            [self connect];
        }else {
            JLScanViewController *scanVC = [[JLScanViewController alloc] init];
            scanVC.scanType = JLScanTypeOther;
            scanVC.qrCode = true;
            scanVC.resultBlock = ^(NSString * _Nonnull scanResult) {
                if (![NSString stringIsEmpty:scanResult] && [scanResult hasPrefix:@"wc:"]) {
                    weakSelf.wcMessage = scanResult;
                    [weakSelf refreshConnectingUI];
                    [weakSelf connect];
                }else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:@"此二维码不支持连接钱包" hideTime:KToastDismissDelayTimeInterval];
                }
            };
            scanVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [weakSelf presentViewController:scanVC animated:YES completion:nil];
        }
    }else {
        UIAlertController *alertVC = [UIAlertController alertShowWithTitle:@"提示" message:@"确定要断开连接?" cancel:@"取消" cancelHandler:^{

        } confirm:@"确定" confirmHandler:^{
            [JLEthereumTool.shared disconnected:^(BOOL isSuccess) {
                [weakSelf refreshDisconnectedUI];
            }];
        }];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

#pragma mark - private methods
- (void)connect {
    WS(weakSelf)
    [JLEthereumTool.shared connectWith:_wcMessage viewController:weakSelf completion:^(BOOL isConnect) {
        if (isConnect) {
            [weakSelf refreshConnectedUI];
            weakSelf.walletState = JLDappWalletConnectStateConnected;
        }else {
            [weakSelf refreshDisconnectedUI];
        }
    }];
}

- (void)disconnect: (nullable void(^)(BOOL isSuccess))completion {
    WS(weakSelf)
    [JLEthereumTool.shared disconnected:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf refreshDisconnectedUI];
            
            completion(YES);
        }
    }];
}

- (void)refreshConnectingUI {
    [self.connectBtn setTitle:@"钱包连接中..." forState:UIControlStateNormal];
    self.connectBtn.enabled = NO;
    self.connectBtn.backgroundColor = [JL_color_gray_101010 colorWithAlphaComponent:0.5];
}

- (void)refreshConnectedUI {
    [self.connectBtn setTitle:@"钱包已连接" forState:UIControlStateNormal];
    self.connectBtn.enabled = YES;
    self.connectBtn.backgroundColor = JL_color_gray_101010;
}

- (void)refreshDisconnectedUI {
    [self.connectBtn setTitle:@"连接钱包" forState:UIControlStateNormal];
    self.connectBtn.enabled = YES;
    self.connectBtn.backgroundColor = JL_color_gray_101010;
    self.walletState = JLDappWalletConnectStateDisconnected;
    self.wcMessage = @"";
}

#pragma mark - setters and getters
- (UIButton *)connectBtn {
    if (!_connectBtn) {
        _connectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _connectBtn.backgroundColor = JL_color_gray_101010;
        _connectBtn.layer.cornerRadius = 5;
        [_connectBtn setTitle:@"连接钱包" forState:UIControlStateNormal];
        [_connectBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _connectBtn.titleLabel.font = kFontPingFangSCMedium(15);
        [_connectBtn addTarget:self action:@selector(connectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _connectBtn;
}

@end
