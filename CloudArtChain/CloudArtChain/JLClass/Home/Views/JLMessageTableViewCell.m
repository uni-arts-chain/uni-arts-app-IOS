//
//  JLMessageTableViewCell.m
//  CloudArtChain
//
//  Created by 花田半亩 on 2020/9/6.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLMessageTableViewCell.h"
#import "NSDate+Extension.h"

@interface JLMessageTableViewCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *pointView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIView *unreadMaskView;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation JLMessageTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = JL_color_clear;
        self.contentView.backgroundColor = JL_color_clear;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.bgView];
    
    [self.bgView addSubview:self.pointView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.timeLabel];
    [self.bgView addSubview:self.unreadMaskView];
    [self.bgView addSubview:self.lineView];
    [self.bgView addSubview:self.descLabel];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.bottom.equalTo(self.contentView).offset(-12);
    }];
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(16);
        make.left.equalTo(self.bgView).offset(12);
        make.width.height.mas_equalTo(@12);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pointView);
        make.left.equalTo(self.pointView.mas_right).offset(13);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-12.0f);
        make.centerY.equalTo(self.pointView);
    }];
    [self.unreadMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-3.0f);
        make.centerY.equalTo(self.pointView);
        make.size.mas_equalTo(6.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(44);
        make.left.equalTo(self.bgView).offset(12);
        make.right.equalTo(self.bgView).offset(-12);
        make.height.mas_equalTo(@1);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(12);
        make.right.equalTo(self.bgView).offset(-12);
        make.top.equalTo(self.lineView.mas_bottom).offset(13);
        make.bottom.equalTo(self.bgView).offset(-13);
    }];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = JL_color_white_ffffff;
        _bgView.layer.cornerRadius = 8;
    }
    return _bgView;
}

- (UIView *)pointView {
    if (!_pointView) {
        _pointView = [[UIView alloc] init];
        _pointView.backgroundColor = JL_color_mainColor;
        _pointView.layer.cornerRadius = 6;
    }
    return _pointView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"消息" font:kFontPingFangSCSCSemibold(15.0f) textColor:JL_color_black_101220 textAlignment:NSTextAlignmentLeft];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_87888F textAlignment:NSTextAlignmentRight];
    }
    return _timeLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_black_40414D textAlignment:NSTextAlignmentLeft];
    }
    return _descLabel;
}

- (UIView *)unreadMaskView {
    if (!_unreadMaskView) {
        _unreadMaskView = [[UIView alloc] init];
        _unreadMaskView.backgroundColor = JL_color_red_D70000;
        ViewBorderRadius(_unreadMaskView, 3.0f, 0.0f, JL_color_clear);
    }
    return _unreadMaskView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = JL_color_gray_EDEDEC;
    }
    return _lineView;
}

- (void)setRow:(NSInteger)row {
    _row = row;
    
    if (_row % 4 == 0) {
        self.pointView.backgroundColor = JL_color_mainColor;
    }else if (_row % 4 == 1) {
        self.pointView.backgroundColor = JL_color_blue_00B7EE;
    }else if (_row % 4 == 2) {
        self.pointView.backgroundColor = JL_color_orange_F39800;
    }else if (_row % 4 == 3) {
        self.pointView.backgroundColor = JL_color_purple_8170FF;
    }
}

- (void)setMessageData:(Model_messages_Data *)messageData {
    self.descLabel.text = messageData.title;
    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:messageData.created_at.doubleValue];
    self.timeLabel.text = [messageDate dateWithCustomFormat:@"yyyy/MM/dd HH:mm:ss"];
    self.unreadMaskView.hidden = messageData.read;
}
@end
