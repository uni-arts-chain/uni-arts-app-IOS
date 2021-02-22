//
//  JLPrivateKeyExportView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/4.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLPrivateKeyExportView.h"
#import "UIButton+TouchArea.h"

@interface JLPrivateKeyExportView ()
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *privateKeyView;
@property (nonatomic, strong) UILabel *privateKeyLabel;
@property (nonatomic, strong) UILabel *noticeLabel;
@property (nonatomic, strong) UIButton *keyCopyBtn;
@end

@implementation JLPrivateKeyExportView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    WS(weakSelf)
    [self addSubview:self.titleLabel];
    [self addSubview:self.closeBtn];
    [self addSubview:self.privateKeyView];
    [self.privateKeyView addSubview:self.privateKeyLabel];
    [self addSubview:self.noticeLabel];
    [self addSubview:self.keyCopyBtn];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(67.0f);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12.0f);
        make.right.mas_equalTo(-15.0f);
        make.size.mas_equalTo(13.0f);
    }];
    [self.privateKeyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25.0f);
        make.right.mas_equalTo(-25.0f);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo(69.0f);
    }];
    [self.privateKeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.0f);
        make.right.mas_equalTo(-12.0f);
        make.centerY.equalTo(self.privateKeyView.mas_centerY);
    }];
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.privateKeyView);
        make.right.equalTo(self.privateKeyView);
        make.top.equalTo(self.privateKeyView.mas_bottom).offset(15.0f);
    }];
    [self.keyCopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.privateKeyView);
        make.right.equalTo(self.privateKeyView);
        make.top.equalTo(self.noticeLabel.mas_bottom).offset(20.0f);
        make.height.mas_equalTo(40.0f);
    }];
    
    [[JLViewControllerTool appDelegate].walletTool fetchExportDataForAddressWithAddress:[[JLViewControllerTool appDelegate].walletTool getCurrentAccount].address seedBlock:^(NSString *seed) {
        weakSelf.privateKeyLabel.text = seed;
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"导出私钥" font:kFontPingFangSCMedium(17.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (UIView *)privateKeyView {
    if (!_privateKeyView) {
        _privateKeyView = [[UIView alloc] init];
        ViewBorderRadius(_privateKeyView, 5.0f, 1.0f, JL_color_gray_A4A4A4);
    }
    return _privateKeyView;
}

- (UILabel *)privateKeyLabel {
    if (!_privateKeyLabel) {
        _privateKeyLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(12.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 10.0f;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_privateKeyLabel.text];
        [attr addAttributes:@{NSParagraphStyleAttributeName: paragraph} range:NSMakeRange(0, _privateKeyLabel.text.length)];
        _privateKeyLabel.attributedText = attr;
    }
    return _privateKeyLabel;
}

- (UILabel *)noticeLabel {
    if (!_noticeLabel) {
        _noticeLabel = [JLUIFactory labelInitText:@"安全警告：私钥未经加密，导出存在风险，建议使用助记词和Keystore进行备份。" font:kFontPingFangSCRegular(12.0f) textColor:JL_color_red_D70000 textAlignment:NSTextAlignmentLeft];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 2.0f;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_noticeLabel.text];
        [attr addAttributes:@{NSParagraphStyleAttributeName: paragraph} range:NSMakeRange(0, _noticeLabel.text.length)];
        _noticeLabel.attributedText = attr;
    }
    return _noticeLabel;
}

- (UIButton *)keyCopyBtn {
    if (!_keyCopyBtn) {
        _keyCopyBtn = [JLUIFactory buttonInitTitle:@"复制" titleColor:JL_color_white_ffffff backgroundColor:JL_color_blue_50C3FF font:kFontPingFangSCRegular(16.0f) addTarget:self action:@selector(keyCopyBtnClick)];
        ViewBorderRadius(_keyCopyBtn, 20.0f, 0.0f, JL_color_clear);
        [_keyCopyBtn addTarget:self action:@selector(keyCopyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _keyCopyBtn;
}

- (void)keyCopyBtnClick {
    [UIPasteboard generalPasteboard].string = self.privateKeyLabel.text;
    [[JLLoading sharedLoading] showMBFailedTipMessage:@"复制成功" hideTime:KToastDismissDelayTimeInterval];
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"icon_common_close"] forState:UIControlStateNormal];
        [_closeBtn edgeTouchAreaWithTop:10.0f right:10.0f bottom:10.0f left:10.0f];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (void)closeBtnClick {
    [LEEAlert closeWithCompletionBlock:nil];
}
@end
