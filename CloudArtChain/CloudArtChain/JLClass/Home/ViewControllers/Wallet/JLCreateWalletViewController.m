//
//  JLCreateWalletViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/3.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLCreateWalletViewController.h"
#import "JLBaseTextField.h"
#import "UIButton+TouchArea.h"
#import "JLWalletViewController.h"

@interface JLCreateWalletViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *noticeView;
@property (nonatomic, strong) JLBaseTextField *nameTF;
@property (nonatomic, strong) UIView *protocolView;
@property (nonatomic, strong) UIButton *severButton;
@property (nonatomic, strong) UIButton *protocolButton;
@property (nonatomic, strong) UIButton *applyCertBtn;
@end

@implementation JLCreateWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"创建钱包";
    [self addBackItem];
    [self createSubViews];
}

- (void)createSubViews {
    WS(weakSelf)
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.scrollView addSubview:self.noticeView];
    [self.noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.mas_equalTo(8.0f);
        make.width.mas_equalTo(kScreenWidth);
    }];
    
    [self.scrollView addSubview:self.nameTF];
    UIView *nameLine = [self createLineView];
    [self.scrollView addSubview:nameLine];
    [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.noticeView.mas_bottom).offset(15.0f);
        make.height.mas_equalTo(40.0f);
        make.width.mas_equalTo(kScreenWidth - 15.0f * 2);
    }];
    [nameLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameTF);
        make.top.equalTo(self.nameTF.mas_bottom);
        make.height.mas_equalTo(1.0f);
        make.width.equalTo(self.nameTF);
    }];
    
    [self.scrollView addSubview:self.protocolView];
    [self.protocolView addSubview:self.severButton];
    [self.protocolView addSubview:self.protocolButton];
    [self.protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(nameLine.mas_bottom).offset(3.0f);
        make.height.mas_equalTo(52.0f);
        make.width.equalTo(self.nameTF);
    }];
    [self.severButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.protocolView);
        make.centerY.equalTo(self.protocolView.mas_centerY);
        make.height.mas_equalTo(20.0f);
        make.width.mas_equalTo(170.0f);
    }];
    [self.protocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.severButton.mas_right);
        make.centerY.equalTo(self.protocolView.mas_centerY);
        make.height.mas_equalTo(20.0f);
    }];
    
    [self.scrollView addSubview:self.applyCertBtn];
    [self.applyCertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.protocolView.mas_bottom);
        make.height.mas_equalTo(46.0f);
        make.width.equalTo(self.nameTF);
    }];
    
    [self.nameTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [weakSelf.nameTF markedTextRange];
            UITextPosition *position = [weakSelf.nameTF positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                NSString *result = [JLUtils trimSpace:x];
                if (result.length > 20) {
                    result = [result substringToIndex:20];
                }
                weakSelf.nameTF.text = result;
            }
        } else {
            NSString *result = [JLUtils trimSpace:x];
            if (result.length > 20) {
                result = [result substringToIndex:20];
            }
            weakSelf.nameTF.text = result;
        }
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.applyCertBtn.frameBottom);
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = JL_color_white_ffffff;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)createLineView {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = JL_color_gray_DDDDDD;
    return lineView;
}

- (UIView *)noticeView {
    if (!_noticeView) {
        _noticeView = [[UIView alloc] init];
        _noticeView.backgroundColor = JL_color_blue_C7ECFF;
        
        UILabel *noticeLabel = [JLUIFactory labelInitText:@"· 密码用于保护私钥和交易授权，强度非常重要。\r\n· 云画链不存储密码，也无法帮您找回，请务必牢记。" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_blue_165B7F textAlignment:NSTextAlignmentLeft];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 10.0f;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:noticeLabel.text];
        [attr addAttributes:@{NSParagraphStyleAttributeName: paragraph} range:NSMakeRange(0, noticeLabel.text.length)];
        noticeLabel.attributedText = attr;
        [_noticeView addSubview:noticeLabel];
        
        [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(29.0f);
            make.top.mas_equalTo(15.0f);
            make.right.mas_equalTo(-29.0f);
            make.bottom.mas_equalTo(-15.0f);
        }];
    }
    return _noticeView;
}

- (JLBaseTextField *)nameTF {
    if (!_nameTF) {
        _nameTF = [[JLBaseTextField alloc] init];
        _nameTF.font = kFontPingFangSCRegular(16.0f);
        _nameTF.textColor = JL_color_gray_212121;
        _nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_BBBBBB, NSFontAttributeName: kFontPingFangSCRegular(16.0f)};
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"钱包名称" attributes:dic];
        _nameTF.attributedPlaceholder = attr;
    }
    return _nameTF;
}

- (UIView *)protocolView {
    if (!_protocolView) {
        _protocolView = [[UIView alloc] init];
    }
    return _protocolView;
}

- (UIButton *)applyCertBtn {
    if (!_applyCertBtn) {
        _applyCertBtn = [JLUIFactory buttonInitTitle:@"申请证书" titleColor:JL_color_white_ffffff backgroundColor:JL_color_blue_50C3FF font:kFontPingFangSCRegular(17.0f) addTarget:self action:@selector(applyCertBtnClick)];
        ViewBorderRadius(_applyCertBtn, 23.0f, 0.0f, JL_color_clear);
    }
    return _applyCertBtn;
}

- (void)applyCertBtnClick {
    [self.view endEditing:YES];
    if ([NSString stringIsEmpty:self.nameTF.text]) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请填写钱包名称" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    if (!self.severButton.selected) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请先同意服务及隐私条款" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    [[JLViewControllerTool appDelegate].walletTool showBackupNoticeWithNavigationController:self.navigationController username:[self.nameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
}

- (UIButton *)severButton {
    if (!_severButton) {
        _severButton = [[UIButton alloc] init];
        [_severButton setTitle:@"我已经仔细阅读并同意 " forState:UIControlStateNormal];
        _severButton.titleLabel.font = kFontPingFangSCRegular(14.0f);
        _severButton.axcUI_buttonContentLayoutType = AxcButtonContentLayoutStyleLeftImageLeft;
        _severButton.axcUI_padding = 5.0f;
        [_severButton setTitleColor:JL_color_gray_909090 forState:UIControlStateNormal];
        [_severButton setImage:[UIImage imageNamed:@"icon_agree_normal"] forState:UIControlStateNormal];
        [_severButton setImage:[UIImage imageNamed:@"icon_agree_selected"] forState:UIControlStateSelected];
        _severButton.selected = YES;
        [_severButton edgeTouchAreaWithTop:5.0f right:0.0f bottom:10.0f left:10.0f];
        [_severButton addTarget:self action:@selector(severButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _severButton;
}

- (void)severButtonAction:(UIButton*)button {
    button.selected = !button.selected;
}

- (UIButton*)protocolButton {
    if (!_protocolButton) {
        _protocolButton = [[UIButton alloc]init];
        [_protocolButton setTitle:@"服务及隐私条款" forState:UIControlStateNormal];
        _protocolButton.titleLabel.font = kFontPingFangSCRegular(14.0f);
        [_protocolButton setTitleColor:JL_color_blue_38B2F1 forState:UIControlStateNormal];
        _protocolButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_protocolButton edgeTouchAreaWithTop:5.0f right:10.0f bottom:10.0f left:0.0f];
        [_protocolButton addTarget:self action:@selector(termsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _protocolButton;
}

- (void)termsBtnClick{
//    JLServiceAgreementViewController *agreement = [[JLServiceAgreementViewController alloc] init];
//    [self.navigationController pushViewController:agreement animated:YES];
}
@end
