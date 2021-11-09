//
//  JLExchangeNFTViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/5/8.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLExchangeNFTViewController.h"
#import "JLBaseTextField.h"
#import "UIAlertController+Alert.h"

@interface JLExchangeNFTViewController ()
@property (nonatomic, strong) UIView *inputBackView;
@property (nonatomic, strong) JLBaseTextField *codeInputTextField;
@end

@implementation JLExchangeNFTViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"兑换NFT";
    [self addBackItem];
    [self addRightBarButton];
    [self createSubViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.codeInputTextField becomeFirstResponder];
}

- (void)addRightBarButton {
    NSString *title = @"兑换";
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(exchangeBtnClick)];
    NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_212121, NSFontAttributeName: kFontPingFangSCRegular(15.0f)};
    [rightBarButtonItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    [rightBarButtonItem setTitleTextAttributes:dic forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)exchangeBtnClick {
    WS(weakSelf)
    [self.view endEditing:YES];
    if ([NSString stringIsEmpty:self.codeInputTextField.text]) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请输入兑换码" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    
    Model_lotteries_get_reward_Req *request = [[Model_lotteries_get_reward_Req alloc] init];
    request.sn = self.codeInputTextField.text;
    Model_lotteries_get_reward_Rsp *response = [[Model_lotteries_get_reward_Rsp alloc] init];
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            UIAlertController *alert = [UIAlertController alertShowWithTitle:@"兑换成功" message:@"藏品卡片将在5分钟内划转完成，可在\"我的主页\"查看!" confirm:@"确定" confirmHandler:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)createSubViews {
    WS(weakSelf)
    [self.view addSubview:self.inputBackView];
    [self.inputBackView addSubview:self.codeInputTextField];
    
    [self.inputBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(25.0f);
        make.height.mas_equalTo(40.0f);
    }];
    
    [self.codeInputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.inputBackView).insets(UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f));
    }];
    
    [self.codeInputTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [weakSelf.codeInputTextField markedTextRange];
            UITextPosition *position = [weakSelf.codeInputTextField positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                NSString *result = [JLUtils trimSpace:x];
                weakSelf.codeInputTextField.text = result;
            }
        } else {
            NSString *result = [JLUtils trimSpace:x];
            weakSelf.codeInputTextField.text = result;
        }
    }];
}

- (UIView *)inputBackView {
    if (!_inputBackView) {
        _inputBackView = [[UIView alloc] init];
        ViewBorderRadius(_inputBackView, 5.0f, 1.0f, JL_color_gray_101010);
    }
    return _inputBackView;
}

- (JLBaseTextField *)codeInputTextField {
    if (!_codeInputTextField) {
        _codeInputTextField = [[JLBaseTextField alloc] init];
        _codeInputTextField.font = kFontPingFangSCRegular(16.0f);
        _codeInputTextField.textColor = JL_color_gray_101010;
        _codeInputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _codeInputTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _codeInputTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _codeInputTextField.spellCheckingType = UITextSpellCheckingTypeNo;
        _codeInputTextField.textAlignment = NSTextAlignmentCenter;
        NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_BBBBBB, NSFontAttributeName: kFontPingFangSCRegular(16.0f)};
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"请输入兑换码" attributes:dic];
        _codeInputTextField.attributedPlaceholder = attr;
    }
    return _codeInputTextField;
}
@end
