//
//  JLApplyCertWorksMechanismSignCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/3.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLApplyCertWorksMechanismSignCell.h"

@interface JLApplyCertWorksMechanismSignCell ()
@property (nonatomic, strong) UIImageView *worksImageView;
@property (nonatomic, strong) UIImageView *maskImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation JLApplyCertWorksMechanismSignCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.worksImageView];
    [self.contentView addSubview:self.maskImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.selectedImageView];
    [self.contentView addSubview:self.lineView];
    
    [self.worksImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.width.mas_equalTo(77.0f);
        make.height.mas_equalTo(57.0f);
        make.centerY.equalTo(self.contentView);
    }];
    [self.maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.worksImageView.mas_top).offset(2.0f);
        make.left.equalTo(self.worksImageView.mas_right).offset(15.0f);
        make.size.mas_equalTo(14.0f);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maskImageView.mas_right).offset(8.0f);
        make.height.mas_equalTo(15.0f);
        make.centerY.equalTo(self.maskImageView.mas_centerY);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maskImageView.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(12.0f);
        make.height.mas_equalTo(12.0f);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maskImageView.mas_left);
        make.top.equalTo(self.infoLabel.mas_bottom).offset(8.0f);
        make.height.mas_equalTo(12.0f);
    }];
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-27.0f);
        make.size.mas_equalTo(16.0f);
        make.centerY.equalTo(self.contentView);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.bottom.equalTo(self.contentView);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(1.0f);
    }];
}

- (UIImageView *)worksImageView {
    if (!_worksImageView) {
        _worksImageView = [[UIImageView alloc] init];
        ViewBorderRadius(_worksImageView, 5.0f, 0.0f, JL_color_clear);
    }
    return _worksImageView;
}

- (UIImageView *)maskImageView {
    if (!_maskImageView) {
        _maskImageView = [JLUIFactory imageViewInitImageName:@"icon_applycert_works"];
    }
    return _maskImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCMedium(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(12.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _infoLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [JLUIFactory labelInitText:@"证书地址：" font:kFontPingFangSCRegular(12.0f) textColor:JL_color_gray_909090 textAlignment:NSTextAlignmentLeft];
    }
    return _addressLabel;
}

- (UIImageView *)selectedImageView {
    if (!_selectedImageView) {
        _selectedImageView = [JLUIFactory imageViewInitImageName:@"icon_applycert_works_select_normal"];
    }
    return _selectedImageView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = JL_color_gray_DDDDDD;
    }
    return _lineView;
}

- (void)worksSelected:(BOOL)selected {
    self.selectedImageView.image = selected ? [UIImage imageNamed:@"icon_applycert_works_select_selected"] : [UIImage imageNamed:@"icon_applycert_works_select_normal"];
}

- (void)setArtDetailData:(Model_art_Detail_Data *)artDetailData {
    if (![NSString stringIsEmpty:artDetailData.img_main_file1[@"url"]]) {
        [self.worksImageView sd_setImageWithURL:[NSURL URLWithString:artDetailData.img_main_file1[@"url"]]];
    }
    self.nameLabel.text = [NSString stringIsEmpty:artDetailData.name] ? @"" : artDetailData.name;
//    self.infoLabel.text = [NSString stringWithFormat:@"%@，%@x%@cm", [[AppSingleton sharedAppSingleton] getMaterialByID:@(artDetailData.material_id).stringValue], artDetailData.size_width, artDetailData.size_length];
    self.addressLabel.text = [NSString stringWithFormat:@"证书地址：%@", [NSString stringIsEmpty:artDetailData.item_hash] ? @"" : artDetailData.item_hash];
}

@end
