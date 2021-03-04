//
//  JLPersonalDescriptionViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/16.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLPersonalDescriptionViewController.h"

#import "JLDescriptionContentView.h"
#import "JLBorderInputView.h"

@interface JLPersonalDescriptionViewController ()
@property (nonatomic, strong) UILabel *residentialAddressTitleLabel;
@property (nonatomic, strong) JLBorderInputView *residentialAddressInputView;
@property (nonatomic, strong) UILabel *collegeTitleLabel;
@property (nonatomic, strong) JLBorderInputView *collegeInputView;
@property (nonatomic, strong) UILabel *descTitleLabel;
@property (nonatomic, strong) JLDescriptionContentView *descContentView;
@end

@implementation JLPersonalDescriptionViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"描述";
    [self addBackItem];
    [self addRightNavigationItem];
    [self createView];
}

- (void)addRightNavigationItem {
    NSString *title = @"保存";
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];
    NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_blue_38B2F1, NSFontAttributeName: kFontPingFangSCRegular(15.0f)};
    [rightBarButtonItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    [rightBarButtonItem setTitleTextAttributes:dic forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)saveBtnClick {
    [self.view endEditing:YES];
    if (self.saveBlock) {
        self.saveBlock(self.residentialAddressInputView.inputContent, self.collegeInputView.inputContent, self.descContentView.inputContent);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createView {
    [self.view addSubview:self.residentialAddressTitleLabel];
    [self.view addSubview:self.residentialAddressInputView];
    [self.view addSubview:self.collegeTitleLabel];
    [self.view addSubview:self.collegeInputView];
    [self.view addSubview:self.descTitleLabel];
    [self.view addSubview:self.descContentView];
    
    [self.residentialAddressTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17.0f);
        make.top.equalTo(self.view);
        make.right.mas_equalTo(-17.0f);
        make.height.mas_equalTo(54.0f);
    }];
    [self.residentialAddressInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.residentialAddressTitleLabel.mas_bottom);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(47.0f);
    }];
    [self.collegeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.residentialAddressTitleLabel.mas_left);
        make.right.equalTo(self.residentialAddressTitleLabel.mas_right);
        make.top.equalTo(self.residentialAddressInputView.mas_bottom).offset(3.0f);
        make.height.equalTo(self.residentialAddressTitleLabel.mas_height);
    }];
    [self.collegeInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.residentialAddressInputView.mas_left);
        make.right.equalTo(self.residentialAddressInputView.mas_right);
        make.top.equalTo(self.collegeTitleLabel.mas_bottom);
        make.height.equalTo(self.residentialAddressInputView.mas_height);
    }];
    [self.descTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.residentialAddressTitleLabel.mas_left);
        make.right.equalTo(self.residentialAddressTitleLabel.mas_right);
        make.top.equalTo(self.collegeInputView.mas_bottom).offset(3.0f);
        make.height.equalTo(self.residentialAddressTitleLabel.mas_height);
    }];
    [self.descContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descTitleLabel.mas_bottom);
        make.left.equalTo(self.residentialAddressInputView.mas_left);
        make.right.equalTo(self.residentialAddressInputView.mas_right);
        make.height.mas_equalTo(138.0f);
    }];
}

- (UILabel *)residentialAddressTitleLabel {
    if (!_residentialAddressTitleLabel) {
        _residentialAddressTitleLabel = [JLUIFactory labelInitText:@"居住地" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _residentialAddressTitleLabel;
}

- (JLBorderInputView *)residentialAddressInputView {
    if (!_residentialAddressInputView) {
        _residentialAddressInputView = [[JLBorderInputView alloc] initWithPlaceholder:@"请输入所在城市" content:[AppSingleton sharedAppSingleton].userBody.residential_address];
    }
    return _residentialAddressInputView;
}

- (UILabel *)collegeTitleLabel {
    if (!_collegeTitleLabel) {
        _collegeTitleLabel = [JLUIFactory labelInitText:@"院校情况" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _collegeTitleLabel;
}

- (JLBorderInputView *)collegeInputView {
    if (!_collegeInputView) {
        _collegeInputView = [[JLBorderInputView alloc] initWithPlaceholder:@"请输入XX大学在读/XX大学毕业" content:[AppSingleton sharedAppSingleton].userBody.college];
    }
    return _collegeInputView;
}

- (UILabel *)descTitleLabel {
    if (!_descTitleLabel) {
        _descTitleLabel = [JLUIFactory labelInitText:@"自我简介" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _descTitleLabel;
}

- (JLDescriptionContentView *)descContentView {
    if (!_descContentView) {
        _descContentView = [[JLDescriptionContentView alloc] initWithMax:100 placeholder:@"介绍一下优秀的自己吧～" content:[AppSingleton sharedAppSingleton].userBody.desc];
    }
    return _descContentView;
}
@end
