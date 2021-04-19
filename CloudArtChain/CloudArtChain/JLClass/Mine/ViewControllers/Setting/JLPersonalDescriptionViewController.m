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
    NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_blue_337FFF, NSFontAttributeName: kFontPingFangSCRegular(15.0f)};
    [rightBarButtonItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    [rightBarButtonItem setTitleTextAttributes:dic forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
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
        make.top.mas_equalTo(26.0f);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(138.0f);
    }];
}

- (JLDescriptionContentView *)descContentView {
    if (!_descContentView) {
        _descContentView = [[JLDescriptionContentView alloc] initWithMax:100 placeholder:@"描述一下自己在区块链行业的成就吧~" content:[AppSingleton sharedAppSingleton].userBody.desc];
    }
    return _descContentView;
}
@end
