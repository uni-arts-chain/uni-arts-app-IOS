//
//  JLDappWalletConnectViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/10/15.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappWalletConnectViewController.h"
#import "JLScanViewController.h"

typedef NS_ENUM(NSUInteger, JLDappChainConnectState) {
    JLDappChainConnectStateConnected,
    JLDappChainConnectStateDisconnected
};
typedef NS_ENUM(NSUInteger, JLDappWalletConnectState) {
    JLDappWalletConnectStateApprove,
    JLDappWalletConnectStateReject
};

@interface JLDappWalletConnectViewController ()

@property (nonatomic, strong) UIButton *connectBtn;
@property (nonatomic, strong) UIButton *approveBtn;

@property (nonatomic, assign) JLDappChainConnectState chainState;
@property (nonatomic, assign) JLDappWalletConnectState walletState;

@property (nonatomic, strong) NSTimer *backgroundTimer;
@property (nonatomic, assign) BOOL notificationGranted;

@end

@implementation JLDappWalletConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"链接钱包";
    [self addBackItem];
    _chainState = JLDappChainConnectStateDisconnected;
    _walletState = JLDappWalletConnectStateReject;
    JLLog(@"wc: %@", _wcMessage);
    
    [self.view addSubview:self.connectBtn];
    [self.view addSubview:self.approveBtn];
    
    [self.connectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(100);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    [self.approveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.connectBtn.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
    WS(weakSelf)
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionAlert|UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
        JLLog(@"notification permission: %d", granted);
        weakSelf.notificationGranted = granted;
    }];
}

#pragma mark - event response
- (void)backClick {
    WS(weakSelf)
    UIAlertController *alertVC = [UIAlertController alertShowWithTitle:@"提示" message:@"确定要断开连接?" cancel:@"取消" cancelHandler:^{

    } confirm:@"确定" confirmHandler:^{
        [weakSelf disconnect:^(BOOL isSuccess) {
            if (isSuccess) {
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)connectBtnClick: (UIButton *)sender {
    WS(weakSelf)
    if (_chainState == JLDappChainConnectStateConnected) {
        UIAlertController *alertVC = [UIAlertController alertShowWithTitle:@"提示" message:@"确定要断开连接?" cancel:@"取消" cancelHandler:^{

        } confirm:@"确定" confirmHandler:^{
            [weakSelf disconnect:nil];
        }];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else {
        [self.connectBtn setTitle:@"链连接中..." forState:UIControlStateNormal];
        [self connect];
    }
}

- (void)approveBtnClick: (UIButton *)sender {
    WS(weakSelf)
    if (_walletState == JLDappWalletConnectStateApprove) {
        [JLEthereumTool.shared rejectSession:^(BOOL isSuccess) {
            [weakSelf.approveBtn setTitle:@"钱包未连接" forState:UIControlStateNormal];
            weakSelf.walletState = JLDappWalletConnectStateReject;
            weakSelf.wcMessage = @"";
        }];
    }else {
        if (![NSString stringIsEmpty:_wcMessage] && [_wcMessage hasPrefix:@"wc:"]) {
            [weakSelf.approveBtn setTitle:@"钱包连接中..." forState:UIControlStateNormal];
            [JLEthereumTool.shared approveSession:^(BOOL isSuccess, NSString * _Nullable errorMsg) {
                if (isSuccess) {
                    [weakSelf.approveBtn setTitle:@"钱包已连接" forState:UIControlStateNormal];
                    weakSelf.walletState = JLDappWalletConnectStateApprove;
                }
            }];
        }else {
            JLScanViewController *scanVC = [[JLScanViewController alloc] init];
            scanVC.scanType = JLScanTypeOther;
            scanVC.qrCode = true;
            scanVC.resultBlock = ^(NSString * _Nonnull scanResult) {
                if (![NSString stringIsEmpty:scanResult] && [scanResult hasPrefix:@"wc:"]) {
                    weakSelf.wcMessage = scanResult;
                    [weakSelf.approveBtn setTitle:@"钱包连接中..." forState:UIControlStateNormal];
                    [JLEthereumTool.shared approveSession:^(BOOL isSuccess, NSString * _Nullable errorMsg) {
                        if (isSuccess) {
                            [weakSelf.approveBtn setTitle:@"钱包已连接" forState:UIControlStateNormal];
                            weakSelf.walletState = JLDappWalletConnectStateApprove;
                        }
                    }];
                }else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:@"此二维码不支持连接钱包" hideTime:KToastDismissDelayTimeInterval];
                }
            };
            scanVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [weakSelf presentViewController:scanVC animated:YES completion:nil];
        }
    }
}

#pragma mark - private methods
- (void)connect {
    WS(weakSelf)
    [JLEthereumTool.shared connectWith:_wcMessage viewController:self socket:^(BOOL isConnect) {
        if (isConnect) {
            [weakSelf.connectBtn setTitle:@"链已连接" forState:UIControlStateNormal];
            weakSelf.chainState = JLDappChainConnectStateConnected;
            [weakSelf.approveBtn setTitle:@"钱包连接中..." forState:UIControlStateNormal];
        }else {
            [weakSelf.connectBtn setTitle:@"链已断开" forState:UIControlStateNormal];
            weakSelf.chainState = JLDappChainConnectStateDisconnected;
        }
    } wallet:^(BOOL isApprove) {
        if (isApprove) {
            [weakSelf.approveBtn setTitle:@"钱包已连接" forState:UIControlStateNormal];
            weakSelf.walletState = JLDappWalletConnectStateApprove;
        }else {
            [weakSelf.approveBtn setTitle:@"钱包未连接" forState:UIControlStateNormal];
            weakSelf.walletState = JLDappWalletConnectStateReject;
            weakSelf.wcMessage = @"";
        }
    }];
}

- (void)disconnect: (nullable void(^)(BOOL isSuccess))completion {
    WS(weakSelf)
    [JLEthereumTool.shared disconnected:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.connectBtn setTitle:@"链已断开" forState:UIControlStateNormal];
            weakSelf.chainState = JLDappChainConnectStateDisconnected;
            [weakSelf.approveBtn setTitle:@"钱包未连接" forState:UIControlStateNormal];
            weakSelf.walletState = JLDappWalletConnectStateReject;
            weakSelf.wcMessage = @"";
            
            completion(YES);
        }
    }];
}

#pragma mark - setters and getters
- (UIButton *)connectBtn {
    if (!_connectBtn) {
        _connectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _connectBtn.backgroundColor = JL_color_gray_101010;
        _connectBtn.layer.cornerRadius = 5;
        [_connectBtn setTitle:@"连接链" forState:UIControlStateNormal];
        [_connectBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _connectBtn.titleLabel.font = kFontPingFangSCMedium(15);
        [_connectBtn addTarget:self action:@selector(connectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _connectBtn;
}

- (UIButton *)approveBtn {
    if (!_approveBtn) {
        _approveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _approveBtn.backgroundColor = JL_color_gray_101010;
        _approveBtn.layer.cornerRadius = 5;
        [_approveBtn setTitle:@"连接钱包" forState:UIControlStateNormal];
        [_approveBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _approveBtn.titleLabel.font = kFontPingFangSCMedium(15);
        [_approveBtn addTarget:self action:@selector(approveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _approveBtn;
}

@end
