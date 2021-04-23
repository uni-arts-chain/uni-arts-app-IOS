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
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *unreadMaskView;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation JLMessageTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.unreadMaskView];
    [self.contentView addSubview:self.lineView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20.0f);
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12.0f);
        make.left.equalTo(self.titleLabel);
        make.bottom.mas_equalTo(-15.0f);
    }];
    [self.unreadMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-27.0f);
        make.size.mas_equalTo(6.0f);
        make.centerY.equalTo(self.contentView);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.bottom.equalTo(self.contentView);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(1.0f);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_909090 textAlignment:NSTextAlignmentLeft];
    }
    return _timeLabel;
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
        _lineView.backgroundColor = JL_color_gray_DDDDDD;
    }
    return _lineView;
}

- (void)setMessageData:(Model_messages_Data *)messageData {
    self.titleLabel.text = messageData.body;
    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:messageData.created_at.doubleValue];
    self.timeLabel.text = [messageDate dateWithCustomFormat:@"yyyy/MM/dd HH:mm:ss"];
    self.unreadMaskView.hidden = messageData.read;
}
@end
