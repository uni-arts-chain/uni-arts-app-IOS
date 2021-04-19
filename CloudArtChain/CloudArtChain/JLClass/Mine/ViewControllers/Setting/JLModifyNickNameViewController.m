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
@end

@implementation JLModifyNickNameViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改昵称";
    [self addBackItem];
    [self addRightNavigationItem];
    [self createView];
}

- (void)addRightNavigationItem {
    NSString *title = @"保存";
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];
    NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_blue_337FFF, NSFontAttributeName: kFontPingFangSCRegular(15.0f)};
    [rightBarButtonItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    [rightBarButtonItem setTitleTextAttributes:dic forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
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
        make.top.mas_equalTo(8.0f);
        make.left.right.equalTo(self.view);
    }];
}

- (JLCalcInputView *)calcInputView {
    if (!_calcInputView) {
        _calcInputView = [[JLCalcInputView alloc] initWithMaxInput:8 placeholder:@"请输入昵称" content:[AppSingleton sharedAppSingleton].userBody.display_name];
    }
    return _calcInputView;
}
@end
