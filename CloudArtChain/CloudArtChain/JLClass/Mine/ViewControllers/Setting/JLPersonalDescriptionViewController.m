//
//  JLPersonalDescriptionViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/16.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLPersonalDescriptionViewController.h"

#import "JLDescriptionContentView.h"

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
    NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_blue_38B2F1, NSFontAttributeName: kFontPingFangSCRegular(15.0f)};
    [rightBarButtonItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    [rightBarButtonItem setTitleTextAttributes:dic forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)saveBtnClick {
    [self.view endEditing:YES];
    if ([NSString stringIsEmpty:self.descContentView.inputContent]) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请输入描述内容" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    if (self.saveBlock) {
        self.saveBlock(self.descContentView.inputContent);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createView {
    [self.view addSubview:self.descContentView];
    [self.descContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8.0f);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(230.0f);
    }];
}

- (JLDescriptionContentView *)descContentView {
    if (!_descContentView) {
        _descContentView = [[JLDescriptionContentView alloc] initWithMax:100 placeholder:@"示例：\r\n出生于 xx\r\n现就读/毕业于 xxx大学\r\n师承xxx、xxx\r\n获得xxx奖项\r\n（每项换行输入）"];
    }
    return _descContentView;
}
@end
