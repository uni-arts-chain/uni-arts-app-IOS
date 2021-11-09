//
//  JLAboutUsViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/5/6.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLAboutUsViewController.h"

@interface JLAboutUsViewController ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *productLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *registerLabel;
@end

@implementation JLAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关于我们";
    [self addBackItem];
    
    [self createSubViews];
}

- (void)createSubViews {
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.productLabel];
    [self.view addSubview:self.infoLabel];
    [self.view addSubview:self.registerLabel];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(60.0f);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(94.0f);
        make.height.mas_equalTo(99.0f);
    }];
    [self.productLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(55.0f);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(self.productLabel.mas_bottom).offset(20.0f);
    }];
    [self.registerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.bottom.mas_equalTo(-KTouch_Responder_Height - 60.0f);
    }];
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [JLUIFactory imageViewInitImageName:@"icon_about_us_icon"];
    }
    return _iconImageView;
}

- (UILabel *)productLabel {
    if (!_productLabel) {
        _productLabel = [JLUIFactory labelInitText:@"IP / 画师 / cos / 潮玩 /" font:kFontPingFangSCSCSemibold(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentCenter];
    }
    return _productLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [JLUIFactory labelInitText:@"ACG二次元艺术创作衍生品交流平台" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_030303 textAlignment:NSTextAlignmentCenter];
    }
    return _infoLabel;
}

- (UILabel *)registerLabel {
    if (!_registerLabel) {
        _registerLabel = [JLUIFactory labelInitText:@"Copyright©2020-2021\r\n加码射线APP版权所有\r\n上海黑皇文化创意有限公司" font:kFontPingFangSCRegular(12.0f) textColor:JL_color_gray_999999 textAlignment:NSTextAlignmentCenter];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_registerLabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 8.0f;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attr addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle} range:NSMakeRange(0, _registerLabel.text.length)];
        _registerLabel.attributedText = attr;
    }
    return _registerLabel;
}

@end
