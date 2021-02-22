//
//  JLWalletPwdViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/3.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLWalletPwdViewController.h"

@interface JLWalletPwdViewController ()
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *pwdView;
@property (nonatomic, strong) UITextField *pwdTF;
@property (nonatomic, strong) UIButton *forgetPwdBtn;
@end

@implementation JLWalletPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [JL_color_black colorWithAlphaComponent:0.3];
    [self createView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.pwdTF becomeFirstResponder];
}

- (void)createView {
    [self.view addSubview:self.baseView];
    [self.baseView addSubview:self.titleLabel];
    [self.baseView addSubview:self.pwdView];
    [self.pwdView addSubview:self.pwdTF];
    [self.baseView addSubview:self.forgetPwdBtn];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.equalTo(self.baseView);
        make.height.mas_equalTo(56.0f);
    }];
    [self.pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(6.0f);
        make.left.mas_equalTo(28.0f);
        make.right.mas_equalTo(-28.0f);
        make.height.mas_equalTo(44.0f);
    }];
    [self.pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.bottom.equalTo(self.pwdView);
    }];
    [self.forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pwdView.mas_left);
        make.top.equalTo(self.pwdView.mas_bottom);
        make.height.mas_equalTo(48.0f);
    }];
}

- (UIView*)baseView {
    if (!_baseView) {
        CGRect rect = CGRectMake(0, kScreenHeight - 162.0f - KTouch_Responder_Height , kScreenWidth, 162.0f + KTouch_Responder_Height);
        _baseView = [[UIView alloc]initWithFrame:rect];
        _baseView.backgroundColor = JL_color_white_ffffff;
    }
    return _baseView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = JL_color_black;
        _titleLabel.font = kFontPingFangSCRegular(16.0f);
        _titleLabel.text = @"需支付：99积分";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)pwdView {
    if (!_pwdView) {
        _pwdView = [UIView new];
        ViewBorderRadius(_pwdView, 5.0f, 1.0f, JL_color_other_D2D4DC);
    }
    return _pwdView;
}

#pragma mark - 懒加载
-(UITextField *)pwdTF{
    if (!_pwdTF) {
        _pwdTF =[[UITextField alloc]init];
        _pwdTF.font = kFontPingFangSCRegular(16.0f);
        _pwdTF.textColor = JL_color_gray_101010;
        _pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pwdTF.returnKeyType = UIReturnKeyDone;
        _pwdTF.secureTextEntry = YES;
        NSDictionary *dic = @{NSForegroundColorAttributeName:JL_color_gray_BBBBBB,NSFontAttributeName:kFontPingFangSCRegular(16.0f)};
        NSAttributedString *attr = [[NSAttributedString alloc]initWithString:@"请输入钱包密码" attributes:dic];
        _pwdTF.attributedPlaceholder = attr;
        [_pwdTF addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventEditingDidEndOnExit];
    }
    return _pwdTF;
}

- (UIButton *)forgetPwdBtn {
    if (!_forgetPwdBtn) {
        _forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetPwdBtn setTitleColor:JL_color_blue_38B2F1 forState:UIControlStateNormal];
        _forgetPwdBtn.titleLabel.font = kFontPingFangSCRegular(14.0f);
        [_forgetPwdBtn addTarget:self action:@selector(forgetPwdBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPwdBtn;
}

- (void)forgetPwdBtnClick {
    
}

- (void)popBottomView {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.backgroundColor = JL_color_clear;
        self.baseView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 162.0f + KTouch_Responder_Height);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void)saveButtonAction {
    [self popBottomView];
    if (![NSString stringIsEmpty:self.pwdTF.text]) {
        if (self.endEditBlock) {
            self.endEditBlock(self.pwdTF.text);
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self popBottomView];
}

@end
