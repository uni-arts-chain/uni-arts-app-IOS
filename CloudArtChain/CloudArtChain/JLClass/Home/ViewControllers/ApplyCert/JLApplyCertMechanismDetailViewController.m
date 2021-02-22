//
//  JLApplyCertMechanismDetailViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/3.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLApplyCertMechanismDetailViewController.h"
#import "JLApplyCertMechanismCertViewController.h"

#import "JLMechanismDetailView.h"
#import "JLMechanismIntroductionView.h"

@interface JLApplyCertMechanismDetailViewController ()
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *mechanismImageView;
@property (nonatomic, strong) JLMechanismDetailView *mechanismDetailView;
@property (nonatomic, strong) JLMechanismIntroductionView *mechanismIntroductionView;
@end

@implementation JLApplyCertMechanismDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"机构详情";
    [self addBackItem];
    [self createSubView];
}

- (void)createSubView {
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.scrollView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(-KTouch_Responder_Height);
        make.height.mas_equalTo(92.0f);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.scrollView addSubview:self.mechanismImageView];
    [self.scrollView addSubview:self.mechanismDetailView];
    [self.scrollView addSubview:self.mechanismIntroductionView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.mechanismIntroductionView.frameBottom);
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        UIButton *applyCertBtn = [JLUIFactory buttonInitTitle:@"申请加签" titleColor:JL_color_white_ffffff backgroundColor:JL_color_blue_50C3FF font:kFontPingFangSCRegular(17.0f) addTarget:self action:@selector(applyCertBtnClick)];
        ViewBorderRadius(applyCertBtn, 23.0f, 0.0f, JL_color_clear);
        [_bottomView addSubview:applyCertBtn];
        [applyCertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15.0f);
            make.right.mas_equalTo(-15.0f);
            make.height.mas_equalTo(46.0f);
            make.centerY.equalTo(_bottomView.mas_centerY);
        }];
    }
    return _bottomView;
}

- (void)applyCertBtnClick {
    JLApplyCertMechanismCertViewController *mechanismCertVC = [[JLApplyCertMechanismCertViewController alloc] init];
    [self.navigationController pushViewController:mechanismCertVC animated:YES];
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

- (UIImageView *)mechanismImageView {
    if (!_mechanismImageView) {
        _mechanismImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, 12.0f, kScreenWidth - 15.0f * 2, 130.0f)];
        _mechanismImageView.backgroundColor = [UIColor randomColor];
        ViewBorderRadius(_mechanismImageView, 5.0f, 0.0f, JL_color_clear);
    }
    return _mechanismImageView;
}

- (JLMechanismDetailView *)mechanismDetailView {
    if (!_mechanismDetailView) {
        _mechanismDetailView = [[JLMechanismDetailView alloc] initWithFrame:CGRectMake(0.0f, self.mechanismImageView.frameBottom, kScreenWidth, 85.0f)];
    }
    return _mechanismDetailView;
}

- (JLMechanismIntroductionView *)mechanismIntroductionView {
    if (!_mechanismIntroductionView) {
        _mechanismIntroductionView = [[JLMechanismIntroductionView alloc] initWithFrame:CGRectMake(0.0f, self.mechanismDetailView.frameBottom, kScreenWidth, 0.0f)];
    }
    return _mechanismIntroductionView;
}
@end
