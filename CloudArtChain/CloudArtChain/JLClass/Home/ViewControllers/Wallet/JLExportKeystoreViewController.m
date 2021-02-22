//
//  JLExportKeystoreViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/4.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLExportKeystoreViewController.h"

#import "JLPageMenuView.h"
#import "JLExportKeystoreFileView.h"
#import "JLExportKeystoreQRCodeView.h"
#import "JLExportKeystoreSnapshotView.h"

@interface JLExportKeystoreViewController ()
@property (nonatomic, strong) JLPageMenuView *pageMenuView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *fileScrollView;
@property (nonatomic, strong) JLExportKeystoreFileView *fileView;
@property (nonatomic, strong) UIScrollView *qrcodeScrollView;
@property (nonatomic, strong) JLExportKeystoreQRCodeView *qrCodeView;
@property (nonatomic, strong) JLExportKeystoreSnapshotView *snapshotView;
@end

@implementation JLExportKeystoreViewController

- (void)viewDidLoad {
    WS(weakSelf)
    [super viewDidLoad];
    self.navigationItem.title = @"导出Keystore";
    [self addBackItem];
    [self createSubViews];
    
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationUserDidTakeScreenshotNotification
        object:nil
         queue:mainQueue
    usingBlock:^(NSNotification *note) {
        //截屏已经发生,可进行相关提示处理
        [JLAlert alertCustomView:weakSelf.snapshotView maxWidth:kScreenWidth - 40.0f * 2];
    }];
    
    [[JLViewControllerTool appDelegate].walletTool fetchExportRestoreDataForAddressWithAddress:[[JLViewControllerTool appDelegate].walletTool getCurrentAccount].address password:self.keystorePwd restoreBlock:^(NSString *restoreData) {
        weakSelf.fileView.restoreData = restoreData;
        weakSelf.qrCodeView.restoreData = restoreData;
    }];
}

- (void)backClick {
    UIViewController *editWalletVC;
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:[JLEditWalletViewController class]]) {
            editWalletVC = tempVC;
            break;
        }
    }
    if (editWalletVC != nil) {
        [self.navigationController popToViewController:editWalletVC animated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight - KStatusBar_Navigation_Height - 65.0f - KTouch_Responder_Height);
    self.fileScrollView.contentSize = CGSizeMake(kScreenWidth, self.fileView.frameBottom + 20.0f);
    self.qrcodeScrollView.contentSize = CGSizeMake(kScreenWidth, self.qrCodeView.frameBottom + 20.0f);
}

- (void)createSubViews {
    [self.view addSubview:self.pageMenuView];
    [self.pageMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(65.0f);
    }];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pageMenuView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(-KTouch_Responder_Height);
    }];
    [self.scrollView addSubview:self.fileScrollView];
    [self.fileScrollView addSubview:self.fileView];
    [self.scrollView addSubview:self.qrcodeScrollView];
    [self.qrcodeScrollView addSubview:self.qrCodeView];
}

- (JLPageMenuView *)pageMenuView {
    if (!_pageMenuView) {
        WS(weakSelf)
        _pageMenuView = [[JLPageMenuView alloc] initWithMenus:@[@"Keystore文件", @"二维码"] itemMargin:90.0f];
        _pageMenuView.indexChangedBlock = ^(NSInteger index) {
            [weakSelf.scrollView setContentOffset:CGPointMake(index * kScreenWidth, 0.0f) animated:YES];
        };
    }
    return _pageMenuView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = JL_color_white_ffffff;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = NO;
    }
    return _scrollView;
}

- (UIScrollView *)fileScrollView {
    if (!_fileScrollView) {
        _fileScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height - 65.0f - KTouch_Responder_Height)];
        _fileScrollView.backgroundColor = JL_color_white_ffffff;
        _fileScrollView.showsVerticalScrollIndicator = NO;
        _fileScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _fileScrollView;
}

- (JLExportKeystoreFileView *)fileView {
    if (!_fileView) {
        _fileView = [[JLExportKeystoreFileView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, 0.0f)];
    }
    return _fileView;
}

- (UIScrollView *)qrcodeScrollView {
    if (!_qrcodeScrollView) {
        _qrcodeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kScreenWidth, 0.0f, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height - 65.0f - KTouch_Responder_Height)];
        _qrcodeScrollView.backgroundColor = JL_color_white_ffffff;
        _qrcodeScrollView.showsVerticalScrollIndicator = NO;
        _qrcodeScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _qrcodeScrollView;
}

- (JLExportKeystoreQRCodeView *)qrCodeView {
    if (!_qrCodeView) {
        _qrCodeView = [[JLExportKeystoreQRCodeView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, 0.0f)];
    }
    return _qrCodeView;
}

- (JLExportKeystoreSnapshotView *)snapshotView {
    if (!_snapshotView) {
        _snapshotView = [[JLExportKeystoreSnapshotView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth - 40.0f * 2, 280.0f)];
        ViewBorderRadius(_snapshotView, 5.0f, 0.0f, JL_color_clear);
    }
    return _snapshotView;
}
@end
