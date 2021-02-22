//
//  JLForgetPwdNewViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/16.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLForgetPwdNewViewController.h"
#import "JLLoginRegisterViewController.h"

#import "JLInputView.h"

@interface JLForgetPwdNewViewController ()
@property (nonatomic, strong) JLInputView *pwdInputView;
@property (nonatomic, strong) UIButton *confirmButton;
@end

@implementation JLForgetPwdNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.forgetPwdType == JLForgetPwdTypeForget) {
        self.navigationItem.title = @"忘记密码";
    } else {
        self.navigationItem.title = @"修改密码";
    }
    [self addBackItem];
    [self createView];
}

- (void)createView {
    [self.view addSubview:self.pwdInputView];
    [self.view addSubview:self.confirmButton];
    
    [self.pwdInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.view);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(67.0f);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.pwdInputView.mas_bottom).offset(37.0f);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(46.0f);
    }];
}

- (JLInputView *)pwdInputView {
    if (!_pwdInputView) {
        _pwdInputView = [[JLInputView alloc] initWithHeadImage:@"" placeholder:@"请输入6-18位数字与字母组合" trailType:JLInputTrailTypePwd];
    }
    return _pwdInputView;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = kFontPingFangSCRegular(17.0f);
        _confirmButton.backgroundColor = JL_color_blue_50C3FF;
        ViewBorderRadius(_confirmButton, 23.0f, 0.0f, JL_color_clear);
        [_confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (void)confirmButtonClick {
    UIViewController *targetVC;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[JLLoginRegisterViewController class]]) {
            targetVC = vc;
            break;
        }
    }
    if (targetVC) {
        [self.navigationController popToViewController:targetVC animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
