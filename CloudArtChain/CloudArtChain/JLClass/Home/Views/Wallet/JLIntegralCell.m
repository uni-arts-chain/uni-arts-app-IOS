//
//  JLIntegralCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/4.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLIntegralCell.h"

@interface JLIntegralCell ()
@property (nonatomic, strong) UILabel *fromLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *pointLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation JLIntegralCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.fromLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.pointLabel];
    [self.contentView addSubview:self.lineView];
    
    [self.fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(20.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fromLabel);
        make.top.equalTo(self.fromLabel.mas_bottom).offset(14.0f);
        make.height.mas_equalTo(14.0f);
    }];
    [self.pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-25.0f);
        make.top.mas_equalTo(26.0f);
        make.size.mas_equalTo(31.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.bottom.equalTo(self.contentView);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(1.0f);
    }];
}

- (UILabel *)fromLabel {
    if (!_fromLabel) {
        _fromLabel = [JLUIFactory labelInitText:@"购买艺术品" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _fromLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [JLUIFactory labelInitText:@"2020/08/25 12:35:25" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_909090 textAlignment:NSTextAlignmentLeft];
    }
    return _timeLabel;
}

- (UILabel *)pointLabel {
    if (!_pointLabel) {
        _pointLabel = [JLUIFactory labelInitText:@"+2" font:kFontPingFangSCMedium(15.0f) textColor:JL_color_blue_38B2F1 textAlignment:NSTextAlignmentCenter];
        _pointLabel.backgroundColor = JL_color_blue_E1F5FF;
        ViewBorderRadius(_pointLabel, 31.0f * 0.5f, 0.0f, JL_color_clear);
    }
    return _pointLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = JL_color_gray_DDDDDD;
    }
    return _lineView;
}
@end
