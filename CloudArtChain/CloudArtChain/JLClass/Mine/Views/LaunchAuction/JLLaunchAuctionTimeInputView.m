//
//  JLLaunchAuctionTimeInputView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/7.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLLaunchAuctionTimeInputView.h"
#import "NSDate+Extension.h"

@interface JLLaunchAuctionTimeInputView ()
@property (nonatomic, strong) NSString *titleDesc;
@property (nonatomic, strong) NSString *defaultContent;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *selectBtn;
@end

@implementation JLLaunchAuctionTimeInputView
- (instancetype)initWithTitle:(NSString *)title defaultContent:(NSString *)defaultContent {
    if (self = [super init]) {
        self.titleDesc = title;
        self.defaultContent = defaultContent;
        self.inputContent = defaultContent;
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.arrowImageView];
    [self addSubview:self.lineView];
    [self addSubview:self.selectBtn];
    
    CGFloat bottomViewHeight = 40.0f;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(70.0f);
        make.height.mas_equalTo(bottomViewHeight);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.0f);
        make.width.mas_equalTo(6.0f);
        make.height.mas_equalTo(10.0f);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(bottomViewHeight);
        make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-8.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.bottom.equalTo(self);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(0.5f);
    }];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel.mas_left);
        make.top.bottom.right.equalTo(self);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:self.titleDesc font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [JLUIFactory labelInitText:self.defaultContent font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentRight];
    }
    return _contentLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_launch_auction_arrow"]];
    }
    return _arrowImageView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.hidden = YES;
        _lineView.backgroundColor = JL_color_gray_DDDDDD;
    }
    return _lineView;
}

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (void)selectBtnClick {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *selectedDate = [formatter dateFromString:self.contentLabel.text];
    if (self.selectBlock) {
        self.selectBlock(selectedDate);
    }
}

- (void)refreshSelectedDate:(NSDate *)selectedDate {
    self.contentLabel.text = [selectedDate dateWithCustomFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.inputContent = [selectedDate dateWithCustomFormat:@"yyyy-MM-dd HH:mm:ss"];
}

@end
