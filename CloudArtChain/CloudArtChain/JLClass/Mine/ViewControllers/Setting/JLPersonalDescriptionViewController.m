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
@property (nonatomic, strong) JLDescriptionContentView *descContentView;
@property (nonatomic, strong) UIButton *doneBtn;
@end

@implementation JLPersonalDescriptionViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"描述";
    [self addBackItem];
    
    [self createView];
}

- (void)saveBtnClick {
    [self.view endEditing:YES];
    if (self.saveBlock) {
        self.saveBlock(self.descContentView.inputContent);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createView {
    [self.view addSubview:self.descContentView];
    [self.descContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(249.0f);
    }];
    
    [self.view addSubview:self.doneBtn];
}

- (JLDescriptionContentView *)descContentView {
    if (!_descContentView) {
        _descContentView = [[JLDescriptionContentView alloc] initWithMax:100 placeholder:@"请简单介绍一下自己吧" content:[AppSingleton sharedAppSingleton].userBody.desc];
    }
    return _descContentView;
}

- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [JLUIFactory buttonInitTitle:@"保存" titleColor:JL_color_white_ffffff backgroundColor:JL_color_mainColor font:kFontPingFangSCMedium(16.0f) addTarget:self action:@selector(saveBtnClick)];
        _doneBtn.frame = CGRectMake(0.0f, kScreenHeight - KStatusBar_Navigation_Height - KTouch_Responder_Height - 44.0f, kScreenWidth, 44.0f + KTouch_Responder_Height);
    }
    return _doneBtn;
}
@end
