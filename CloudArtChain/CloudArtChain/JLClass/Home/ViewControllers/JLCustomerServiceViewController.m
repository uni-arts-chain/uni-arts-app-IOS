//
//  JLCustomerServiceViewController.m
//  CloudArtChain
//
//  Created by 花田半亩 on 2020/9/6.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLCustomerServiceViewController.h"

#import "JLCustomerServiceSectionView.h"

@interface JLCustomerServiceViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) JLCustomerServiceSectionView *wechatView;
@property (nonatomic, strong) JLCustomerServiceSectionView *qqView;
@property (nonatomic, strong) JLCustomerServiceSectionView *emailView;
@end

@implementation JLCustomerServiceViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"客服";
    [self addBackItem];
    [self createSubViews];
}

- (void)createSubViews {
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.scrollView];
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.scrollView addSubview:self.titleLabel];
    [self.scrollView addSubview:self.wechatView];
    [self.scrollView addSubview:self.qqView];
    [self.scrollView addSubview:self.emailView];
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.emailView.frameBottom + 20.0f);
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [JLUIFactory imageViewInitImageName:@"icon_customer_service_back"];
//        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backImageView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = JL_color_clear;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"请通过以下方式联系我们：" font:kFontPingFangSCSCSemibold(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
        _titleLabel.frame = CGRectMake(90.0f, 103.0f, kScreenWidth - 90.0f, 15.0f);
    }
    return _titleLabel;
}

- (JLCustomerServiceSectionView *)wechatView {
    if (!_wechatView) {
        NSArray *itemsArray = @[@"YunHuaLian001", @"YunHuaLian001", @"YunHuaLian001"];
        _wechatView = [[JLCustomerServiceSectionView alloc] initWithFrame:CGRectMake(87.0f, self.titleLabel.frameBottom + 27.0f, kScreenWidth - 87.0f, 15.0f + itemsArray.count * (12.0f + 18.0f)) title:@"微信" items:itemsArray];
    }
    return _wechatView;
}

- (JLCustomerServiceSectionView *)qqView {
    if (!_qqView) {
        NSArray *itemsArray = @[@"3259654853", @"3259654853", @"3259654853"];
        _qqView = [[JLCustomerServiceSectionView alloc] initWithFrame:CGRectMake(87.0f, self.wechatView.frameBottom + 27.0f, kScreenWidth - 87.0f, 15.0f + itemsArray.count * (12.0f + 18.0f)) title:@"QQ" items:itemsArray];
    }
    return _qqView;
}

- (JLCustomerServiceSectionView *)emailView {
    if (!_emailView) {
        NSArray *itemsArray = @[@"yunhualian01@uart.com", @"yunhualian01@uart.com", @"yunhualian01@uart.com"];
        _emailView = [[JLCustomerServiceSectionView alloc] initWithFrame:CGRectMake(87.0f, self.qqView.frameBottom + 27.0f, kScreenWidth - 87.0f, 15.0f + itemsArray.count * (12.0f + 18.0f)) title:@"邮箱" items:itemsArray];
    }
    return _emailView;
}
@end
