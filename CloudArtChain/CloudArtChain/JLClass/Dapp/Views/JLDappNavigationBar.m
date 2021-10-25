//
//  JLDappNavigationBar.m
//  CloudArtChain
//
//  Created by jielian on 2021/10/25.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappNavigationBar.h"

@interface JLDappNavigationBar ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *chooseBtn;

@property (nonatomic, strong) MASConstraint *chooseBtnWidthConstraint;

@end

@implementation JLDappNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = JL_color_white_ffffff;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _chooseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_chooseBtn setTitleColor:JL_color_blue_627EEA forState:UIControlStateNormal];
    _chooseBtn.titleLabel.font = kFontPingFangSCRegular(12);
    [_chooseBtn setImage:[[UIImage imageNamed:@"icon_dapp_arrow_down"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_chooseBtn setImagePosition:LXMImagePositionRight spacing:5];
    [_chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_chooseBtn];
    [_chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(@26);
        self.chooseBtnWidthConstraint = make.width.mas_equalTo(@200);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"发现";
    _titleLabel.textColor = JL_color_gray_101010;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = kFontPingFangSCRegular(15);
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.chooseBtn.mas_top);
    }];
}

#pragma mark - event response
- (void)chooseBtnClick: (UIButton *)sender {
    if (_chooseBlock) {
        _chooseBlock();
    }
}

#pragma mark - setters and getters
- (void)setChainServerName:(NSString *)chainServerName {
    _chainServerName = chainServerName;
    
    CGFloat width = [JLTool getAdaptionSizeWithText:_chainServerName labelHeight:30 font:kFontPingFangSCRegular(12)].width + 55;
    
    [_chooseBtnWidthConstraint uninstall];
    [_chooseBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        self.chooseBtnWidthConstraint = make.width.mas_equalTo(@(width));
    }];
    
    [_chooseBtn setTitle:_chainServerName forState:UIControlStateNormal];
    [_chooseBtn setImagePosition:LXMImagePositionRight spacing:5];
}

@end
