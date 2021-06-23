//
//  JLSettingTableHeaderView.m
//  CloudArtChain
//
//  Created by jielian on 2021/6/22.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLSettingTableHeaderView.h"

@interface JLSettingTableHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JLSettingTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = JL_color_black_101220;
    _titleLabel.font = kFontPingFangSCMedium(15);
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(13);
        make.top.bottom.right.equalTo(self);
    }];
}

#pragma mark - setters and getters
- (void)setTitle:(NSString *)title {
    _title = title;
    
    _titleLabel.text = _title;
}

@end
