//
//  JLWorkListListedCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/17.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLWorkListListedCell.h"

@interface JLWorkListListedCell ()
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIButton *removeItemButton;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *applyAddCertButton;
@end

@implementation JLWorkListListedCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.centerView];
    [self.centerView addSubview:self.removeItemButton];
    [self.centerView addSubview:self.applyAddCertButton];
    
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.0f);
        make.left.equalTo(self.addressLabel.mas_right);
        make.centerY.equalTo(self);
    }];
    [self.removeItemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.centerView);
    }];
    [self.applyAddCertButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.centerView);
        make.top.equalTo(self.removeItemButton.mas_bottom).offset(5.0f);
    }];
}

- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc] init];
    }
    return _centerView;
}

- (UIButton *)removeItemButton {
    if (!_removeItemButton) {
        _removeItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_removeItemButton setTitle:@"下架" forState:UIControlStateNormal];
        [_removeItemButton setTitleColor:JL_color_gray_414141 forState:UIControlStateNormal];
        _removeItemButton.titleLabel.font = kFontPingFangSCRegular(14.0f);
        [_removeItemButton addTarget:self action:@selector(removeItemButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removeItemButton;
}

- (void)removeItemButtonClick {
    
}

- (UIButton *)applyAddCertButton {
    if (!_applyAddCertButton) {
        _applyAddCertButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_applyAddCertButton setTitle:@"申请加签" forState:UIControlStateNormal];
        [_applyAddCertButton setTitleColor:JL_color_blue_38B2F1 forState:UIControlStateNormal];
        _applyAddCertButton.titleLabel.font = kFontPingFangSCRegular(14.0f);
        [_applyAddCertButton addTarget:self action:@selector(applyAddCertButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyAddCertButton;
}

- (void)applyAddCertButtonClick {
    
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_BBBBBB textAlignment:NSTextAlignmentRight];
    }
    return _statusLabel;
}
@end
