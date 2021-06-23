//
//  JLModifyNickNameViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/16.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLModifyNickNameViewController.h"

#import "JLCalcInputView.h"

@interface JLModifyNickNameViewController ()
@property (nonatomic, strong) JLCalcInputView *calcInputView;
@property (nonatomic, strong) UIButton *doneBtn;
@end

@implementation JLModifyNickNameViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改昵称";
    [self addBackItem];
    
    [self createView];
}

- (void)saveBtnClick {
    [self.view endEditing:YES];
    if (self.saveBlock) {
        self.saveBlock(self.calcInputView.inputContent);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createView {
    [self.view addSubview:self.calcInputView];
    [self.calcInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(@87.0f);
    }];
    
    [self.view addSubview:self.doneBtn];
}

- (JLCalcInputView *)calcInputView {
    if (!_calcInputView) {
        _calcInputView = [[JLCalcInputView alloc] initWithMaxInput:8 placeholder:@"请输入昵称" content:[AppSingleton sharedAppSingleton].userBody.display_name];
    }
    return _calcInputView;
}
- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [JLUIFactory buttonInitTitle:@"保存" titleColor:JL_color_white_ffffff backgroundColor:JL_color_mainColor font:kFontPingFangSCMedium(16.0f) addTarget:self action:@selector(saveBtnClick)];
        _doneBtn.frame = CGRectMake(0.0f, kScreenHeight - KStatusBar_Navigation_Height - KTouch_Responder_Height - 44.0f, kScreenWidth, 44.0f + KTouch_Responder_Height);
    }
    return _doneBtn;
}
@end
