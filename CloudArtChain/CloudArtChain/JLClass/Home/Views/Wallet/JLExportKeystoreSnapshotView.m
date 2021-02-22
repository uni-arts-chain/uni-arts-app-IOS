//
//  JLExportKeystoreSnapshotView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/4.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLExportKeystoreSnapshotView.h"

@interface JLExportKeystoreSnapshotView ()
@property (nonatomic, strong) UIImageView *maskImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *understoodBtn;
@end

@implementation JLExportKeystoreSnapshotView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.maskImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.understoodBtn];
    
    [self.maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(24.0f);
        make.size.mas_equalTo(34.0f);
        make.centerX.equalTo(self);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.maskImageView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(49.0f);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(36.0f);
        make.right.mas_equalTo(-36.0f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10.0f);
    }];
    [self.understoodBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25.0f);
        make.right.mas_equalTo(-25.0f);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(32.0f);
        make.height.mas_equalTo(40.0f);
    }];
}

- (UIImageView *)maskImageView {
    if (!_maskImageView) {
        _maskImageView = [JLUIFactory imageViewInitImageName:@"icon_common_snapshot_notice"];
    }
    return _maskImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"请勿截图" font:kFontPingFangSCMedium(17.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [JLUIFactory labelInitText:@"如果有人获取你的助记词将直接获取你的资产！请抄写下助记词并存放在安全的地方" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 2.0f;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_contentLabel.text];
        [attr addAttributes:@{NSParagraphStyleAttributeName: paragraph} range:NSMakeRange(0, _contentLabel.text.length)];
        _contentLabel.attributedText = attr;
    }
    return _contentLabel;
}

- (UIButton *)understoodBtn {
    if (!_understoodBtn) {
        _understoodBtn = [JLUIFactory buttonInitTitle:@"知道了" titleColor:JL_color_white_ffffff backgroundColor:JL_color_red_D70000 font:kFontPingFangSCRegular(16.0f) addTarget:self action:@selector(closeView)];
        ViewBorderRadius(_understoodBtn, 20.0f, 0.0f, JL_color_clear);
    }
    return _understoodBtn;
}

- (void)closeView {
    [LEEAlert closeWithCompletionBlock:nil];
}
@end
