//
//  JLWorkListNotListCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/17.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLWorkListNotListCell.h"

@interface JLWorkListNotListCell ()
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIButton *addToListBtn;
@property (nonatomic, strong) UIButton *applyAddCertBtn;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *applyCertBtn;
@property (nonatomic, strong) UIButton *reapplyCertBtn;
@end

@implementation JLWorkListNotListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.centerView];
    [self.centerView addSubview:self.addToListBtn];
    [self.centerView addSubview:self.applyAddCertBtn];
    
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.0f);
        make.left.equalTo(self.addressLabel.mas_right);
        make.centerY.equalTo(self);
    }];
    [self.addToListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.centerView);
    }];
    [self.applyAddCertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.centerView);
        make.top.equalTo(self.addToListBtn.mas_bottom).offset(5.0f);
    }];
}

- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc] init];
    }
    return _centerView;
}

- (UIButton *)addToListBtn {
    if (!_addToListBtn) {
        _addToListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addToListBtn setTitle:@"上架" forState:UIControlStateNormal];
        [_addToListBtn setTitleColor:JL_color_green_48B422 forState:UIControlStateNormal];
        _addToListBtn.titleLabel.font = kFontPingFangSCRegular(14.0f);
        [_addToListBtn addTarget:self action:@selector(addToListBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addToListBtn;
}

- (void)addToListBtnClick {
    
}

- (UIButton *)applyAddCertBtn {
    if (!_applyAddCertBtn) {
        _applyAddCertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_applyAddCertBtn setTitle:@"申请加签" forState:UIControlStateNormal];
        [_applyAddCertBtn setTitleColor:JL_color_blue_38B2F1 forState:UIControlStateNormal];
        _applyAddCertBtn.titleLabel.font = kFontPingFangSCRegular(14.0f);
        [_applyAddCertBtn addTarget:self action:@selector(applyAddCertBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyAddCertBtn;
}

- (void)applyAddCertBtnClick {
    
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_BBBBBB textAlignment:NSTextAlignmentRight];
    }
    return _statusLabel;
}

- (UIButton *)applyCertBtn {
    if (!_applyCertBtn) {
        _applyCertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_applyCertBtn setTitle:@"申请证书" forState:UIControlStateNormal];
        [_applyCertBtn setTitleColor:JL_color_blue_38B2F1 forState:UIControlStateNormal];
        _applyCertBtn.titleLabel.font = kFontPingFangSCRegular(14.0f);
        [_applyCertBtn addTarget:self action:@selector(applyCertBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyCertBtn;
}

- (void)applyCertBtnClick {
    
}

- (UIButton *)reapplyCertBtn {
    if (!_reapplyCertBtn) {
        _reapplyCertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reapplyCertBtn setTitle:@"重新申请" forState:UIControlStateNormal];
        [_reapplyCertBtn setTitleColor:JL_color_blue_38B2F1 forState:UIControlStateNormal];
        _reapplyCertBtn.titleLabel.font = kFontPingFangSCRegular(14.0f);
        [_reapplyCertBtn addTarget:self action:@selector(reapplyCertBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reapplyCertBtn;
}

- (void)reapplyCertBtnClick {
    
}
@end
