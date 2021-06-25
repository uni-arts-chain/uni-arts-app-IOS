//
//  JLUploadWorkSwitchView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/20.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLUploadWorkSwitchView.h"

@interface JLUploadWorkSwitchView ()
@property (nonatomic, strong) NSString *selectTitle;
@property (nonatomic,   copy) void(^selectBlock)(BOOL);

@property (nonatomic, strong) UIView *leftLineView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISwitch *selectSwitch;
@end

@implementation JLUploadWorkSwitchView
- (instancetype)initWithTitle:(NSString *)title selectBlock:(void (^)(BOOL))selectBlock {
    if (self = [super init]) {
        self.backgroundColor = JL_color_white_ffffff;
        self.selectTitle = title;
        self.selectBlock = selectBlock;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.leftLineView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.selectSwitch];
    [self addSubview:self.bottomLineView];
    
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(14);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(4, 15));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLineView.mas_right).offset(9);
        make.top.bottom.equalTo(self);
    }];
    [self.selectSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12.0f);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(@1);
    }];
}

- (UIView *)leftLineView {
    if (!_leftLineView) {
        _leftLineView = [[UIView alloc] init];
        _leftLineView.backgroundColor = JL_color_mainColor;
        _leftLineView.layer.cornerRadius = 2;
    }
    return _leftLineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:[NSString stringIsEmpty:self.selectTitle] ? @"" : self.selectTitle font:kFontPingFangSCRegular(15.0f) textColor:JL_color_black_101220 textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UISwitch *)selectSwitch {
    if (!_selectSwitch) {
        _selectSwitch = [[UISwitch alloc] init];
        _selectSwitch.onTintColor = JL_color_mainColor;
        _selectSwitch.tintColor = JL_color_white_ffffff;
        _selectSwitch.transform = CGAffineTransformMakeScale(0.7, 0.7);
        [_selectSwitch addTarget:self action:@selector(selectSwitchChange) forControlEvents:UIControlEventValueChanged];
    }
    return _selectSwitch;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = JL_color_gray_EDEDEE;
    }
    return _bottomLineView;
}

- (void)setIsHiddenBottomLine:(BOOL)isHiddenBottomLine {
    _isHiddenBottomLine = isHiddenBottomLine;
    
    _bottomLineView.hidden = _isHiddenBottomLine;
}

- (void)selectSwitchChange {
    if (self.selectBlock) {
        self.selectBlock(self.selectSwitch.isOn);
    }
}

@end
