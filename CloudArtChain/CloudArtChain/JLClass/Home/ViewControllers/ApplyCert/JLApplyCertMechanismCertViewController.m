//
//  JLApplyCertMechanismCertViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/3.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLApplyCertMechanismCertViewController.h"
#import "JLBaseTextField.h"
#import "JLSelectWorksViewController.h"
#import "JLCreatorPageViewController.h"
#import "JLWalletPwdViewController.h"

@interface JLApplyCertMechanismCertViewController ()
@property (nonatomic, strong) UIView *selectWorkView;
@property (nonatomic, strong) JLBaseTextField *workTF;
@property (nonatomic, strong) UIView *mechanismView;
@property (nonatomic, strong) UILabel *mechanismLabel;
@property (nonatomic, strong) UIButton *applyBtn;
@end

@implementation JLApplyCertMechanismCertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申请加签";
    [self addBackItem];
    [self createSubViews];
}

- (void)createSubViews {
    [self.view addSubview:self.selectWorkView];
    [self.view addSubview:self.mechanismView];
    [self.view addSubview:self.applyBtn];
    
    [self.selectWorkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(20.0f);
        make.height.mas_equalTo(40.0f);
    }];
    [self.mechanismView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(self.selectWorkView.mas_bottom).offset(15.0f);
        make.height.mas_equalTo(40.0f);
    }];
    [self.applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(self.mechanismView.mas_bottom).offset(33.0f);
        make.height.mas_equalTo(46.0f);
    }];
}

- (UIView *)selectWorkView {
    if (!_selectWorkView) {
        _selectWorkView = [[UIView alloc] init];
        UIImageView *arrowImageView = [JLUIFactory imageViewInitImageName:@"icon_applycert_arrowright"];
        [_selectWorkView addSubview:arrowImageView];
        [_selectWorkView addSubview:self.workTF];
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = JL_color_gray_DDDDDD;
        [_selectWorkView addSubview:lineView];
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_selectWorkView addSubview:selectBtn];
        
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_selectWorkView);
            make.width.mas_equalTo(8.0f);
            make.height.mas_equalTo(15.0f);
            make.centerY.equalTo(_selectWorkView.mas_centerY);
        }];
        [self.workTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(_selectWorkView);
            make.right.equalTo(arrowImageView.mas_left).offset(-10.0f);
        }];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(_selectWorkView);
            make.height.mas_equalTo(1.0f);
        }];
        [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_selectWorkView);
        }];
    }
    return _selectWorkView;
}

- (void)selectBtnClick {
    JLSelectWorksViewController *selectWorksVC = [[JLSelectWorksViewController alloc] init];
    selectWorksVC.selectType = JLSelectWorksTypeMechanismAddSign;
    [self.navigationController pushViewController:selectWorksVC animated:YES];
}

- (JLBaseTextField *)workTF {
    if (!_workTF) {
        _workTF = [[JLBaseTextField alloc]init];
        _workTF.font = kFontPingFangSCRegular(16.0f);
        _workTF.textColor = JL_color_gray_212121;
        _workTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_BBBBBB, NSFontAttributeName: kFontPingFangSCRegular(16.0f)};
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"请选择需要签名的作品" attributes:dic];
        _workTF.attributedPlaceholder = attr;
    }
    return _workTF;
}

- (UIView *)mechanismView {
    if (!_mechanismView) {
        _mechanismView = [[UIView alloc] init];
        [_mechanismView addSubview:self.mechanismLabel];
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = JL_color_gray_DDDDDD;
        [_mechanismView addSubview:lineView];
        
        [self.mechanismLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_mechanismView);
        }];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(_mechanismView);
            make.height.mas_equalTo(1.0f);
        }];
    }
    return _mechanismView;
}

- (UILabel *)mechanismLabel {
    if (!_mechanismLabel) {
        _mechanismLabel = [JLUIFactory labelInitText:@"南京艺术品鉴定机构" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _mechanismLabel;
}

- (UIButton *)applyBtn {
    if (!_applyBtn) {
        _applyBtn = [JLUIFactory buttonInitTitle:@"申请证书" titleColor:JL_color_white_ffffff backgroundColor:JL_color_blue_50C3FF font:kFontPingFangSCRegular(17.0f) addTarget:self action:@selector(applyBtnClick)];
        ViewBorderRadius(_applyBtn, 23.0f, 0.0f, JL_color_clear);
    }
    return _applyBtn;
}

- (void)applyBtnClick {
    WS(weakSelf)
    JLWalletPwdViewController *walletPwdVC = [[JLWalletPwdViewController alloc] init];
    self.navigationController.definesPresentationContext = YES;
    walletPwdVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    walletPwdVC.endEditBlock = ^(NSString * _Nonnull pwd) {
        [JLAlert jlalertDefaultView:@"提示" message:@"已提交申请，请等待审核\r\n可在“我的主页中”查看审核进度" cancel:@"取消" cancelBlock:^{

        } confirm:@"去查看" confirmBlock:^{
            JLCreatorPageViewController *creatorPageVC = [[JLCreatorPageViewController alloc] init];
            [weakSelf.navigationController pushViewController:creatorPageVC animated:YES];
        }];
    };
    [self.navigationController presentViewController:walletPwdVC animated:NO completion:nil];
}
@end
