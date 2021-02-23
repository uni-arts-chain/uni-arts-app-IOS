//
//  JLReceiveAddressSelectTableViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/28.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLReceiveAddressSelectTableViewCell.h"
#import "JLBaseTextField.h"

@interface JLReceiveAddressSelectTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) JLBaseTextField *inputTF;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIButton *selectButton;
@end

@implementation JLReceiveAddressSelectTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.inputTF];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.selectButton];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.width.mas_equalTo(90.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-27.0f);
        make.width.mas_equalTo(6.0f);
        make.height.mas_equalTo(12.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right);
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.arrowImageView.mas_left).offset(-8.0f);
    }];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputTF);
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCMedium(16.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (JLBaseTextField *)inputTF {
    if (!_inputTF) {
        _inputTF = [[JLBaseTextField alloc] init];
        _inputTF.font = kFontPingFangSCRegular(15.0f);
        _inputTF.textColor = JL_color_gray_666666;
        _inputTF.clearButtonMode = UITextFieldViewModeNever;
        _inputTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    return _inputTF;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [JLUIFactory imageViewInitImageName:@"icon_mine_address_select"];
    }
    return _arrowImageView;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton addTarget:self action:@selector(selectButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

- (void)selectButtonClick {
    if (self.selectedBlock) {
        self.selectedBlock();
    }
}

- (void)setTitle:(NSString *)title placeholder:(NSString *)placeholder {
    self.titleLabel.text = title;
    NSDictionary *dic = @{NSForegroundColorAttributeName:JL_color_gray_999999, NSFontAttributeName:kFontPingFangSCRegular(15.0f)};
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:placeholder attributes:dic];
    self.inputTF.attributedPlaceholder = attr;
}

- (void)setSelectedContent:(NSString *)content {
    self.inputTF.text = content;
    self.inputContent = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
}
@end
