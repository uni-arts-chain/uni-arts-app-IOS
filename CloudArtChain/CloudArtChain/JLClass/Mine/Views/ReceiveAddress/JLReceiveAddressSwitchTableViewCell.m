//
//  JLReceiveAddressSwitchTableViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/28.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLReceiveAddressSwitchTableViewCell.h"

@interface JLReceiveAddressSwitchTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISwitch *switchView;
@end

@implementation JLReceiveAddressSwitchTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.switchView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UISwitch *)switchView {
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
        [_switchView addTarget:self action:@selector(switchViewTogle:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

- (void)switchViewTogle:(UISwitch *)sender {
    if (self.switchBlock) {
        self.switchBlock(sender.isOn);
    }
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

@end
