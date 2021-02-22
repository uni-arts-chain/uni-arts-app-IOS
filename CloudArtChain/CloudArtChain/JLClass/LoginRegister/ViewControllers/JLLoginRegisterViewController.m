//
//  JLLoginRegisterViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/16.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLLoginRegisterViewController.h"
#import "JLForgetPwdViewController.h"

#import "JLLoginView.h"
#import "JLRegisterView.h"

typedef NS_ENUM(NSUInteger, JLLoginRegisterType) {
    JLLoginRegisterTypeLogin, /** 登录 */
    JLLoginRegisterTypeRegister, /** 注册 */
};

@interface JLLoginRegisterViewController ()
@property (nonatomic, assign) JLLoginRegisterType loginRegisterType;
@property (nonatomic, strong) JLLoginView *loginView;
@property (nonatomic, strong) JLRegisterView *registerView;
@end

@implementation JLLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.loginRegisterType = JLLoginRegisterTypeLogin;
    [self createView];
}

- (void)createView {
    [self.view addSubview:self.loginView];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view addSubview:self.registerView];
    [self.registerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self showLoginOrRegisterView];
}

- (void)showLoginOrRegisterView {
    if (self.loginRegisterType == JLLoginRegisterTypeLogin) {
        self.loginView.hidden = NO;
        self.registerView.hidden = YES;
    } else {
        self.loginView.hidden = YES;
        self.registerView.hidden = NO;
    }
}

- (JLLoginView *)loginView {
    if (!_loginView) {
        WS(weakSelf)
        _loginView = [[JLLoginView alloc] init];
        _loginView.backBlock = ^{
            [weakSelf backClick];
        };
        _loginView.registerBlock = ^{
            weakSelf.loginRegisterType = JLLoginRegisterTypeRegister;
            [weakSelf showLoginOrRegisterView];
        };
        _loginView.forgetPwdBlock = ^{
            JLForgetPwdViewController *forgetPwdVC = [[JLForgetPwdViewController alloc] init];
            forgetPwdVC.forgetPwdType = JLForgetPwdTypeForget;
            [weakSelf.navigationController pushViewController:forgetPwdVC animated:YES];
        };
    }
    return _loginView;
}

- (JLRegisterView *)registerView {
    if (!_registerView) {
        WS(weakSelf)
        _registerView = [[JLRegisterView alloc] init];
        _registerView.backBlock = ^{
            [weakSelf backClick];
        };
        _registerView.loginBlock = ^{
            weakSelf.loginRegisterType = JLLoginRegisterTypeLogin;
            [weakSelf showLoginOrRegisterView];
        };
    }
    return _registerView;
}

- (void)backClick {
    if (self.backClickBlock) {
        self.backClickBlock();
    } else {
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
@end
