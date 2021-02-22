//
//  JLApplyCertNoDataCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/3.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLApplyCertNoDataCell.h"

@interface JLApplyCertNoDataCell ()
@property (nonatomic, strong) UILabel *noticeLabel;
@end

@implementation JLApplyCertNoDataCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.noticeLabel];
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (UILabel *)noticeLabel {
    if (!_noticeLabel) {
        _noticeLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_909090 textAlignment:NSTextAlignmentCenter];
    }
    return _noticeLabel;
}

- (void)setNoticeStr:(NSString *)noticeStr {
    if (![NSString stringIsEmpty:noticeStr]) {
        self.noticeLabel.text = noticeStr;
    }
}
@end
