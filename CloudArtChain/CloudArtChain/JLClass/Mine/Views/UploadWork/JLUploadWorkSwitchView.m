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

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISwitch *selectSwitch;
@end

@implementation JLUploadWorkSwitchView
- (instancetype)initWithTitle:(NSString *)title selectBlock:(void (^)(BOOL))selectBlock {
    if (self = [super init]) {
        self.selectTitle = title;
        self.selectBlock = selectBlock;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.selectSwitch];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.bottom.equalTo(self);
    }];
    [self.selectSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-22.0f);
        make.centerY.equalTo(self.mas_centerY);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:[NSString stringIsEmpty:self.selectTitle] ? @"" : self.selectTitle font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UISwitch *)selectSwitch {
    if (!_selectSwitch) {
        _selectSwitch = [[UISwitch alloc] init];
        [_selectSwitch addTarget:self action:@selector(selectSwitchChange) forControlEvents:UIControlEventValueChanged];
    }
    return _selectSwitch;
}

- (void)selectSwitchChange {
    if (self.selectBlock) {
        self.selectBlock(self.selectSwitch.isOn);
    }
}

@end
