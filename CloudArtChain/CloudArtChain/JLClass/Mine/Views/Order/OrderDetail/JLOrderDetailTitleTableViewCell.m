//
//  JLOrderDetailTitleTableViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/28.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLOrderDetailTitleTableViewCell.h"

@interface JLOrderDetailTitleTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation JLOrderDetailTitleTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(15.0f);
        make.right.bottom.equalTo(self.contentView);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCMedium(21.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}
@end
