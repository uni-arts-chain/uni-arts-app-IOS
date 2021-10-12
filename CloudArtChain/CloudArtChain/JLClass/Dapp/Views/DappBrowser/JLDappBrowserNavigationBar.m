//
//  JLDappBrowserNavigationBar.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/28.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappBrowserNavigationBar.h"

@interface JLDappBrowserNavigationBar ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *faceView;
@property (nonatomic, strong) UIButton *managerBtn;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, copy) JLDappBrowserNavigationBarManagerBlock managerBlock;
@property (nonatomic, copy) JLDappBrowserNavigationBarBackBlock backBlock;
@property (nonatomic, copy) JLDappBrowserNavigationBarCloseBlock closeBlock;

@end

@implementation JLDappBrowserNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
                        title: (NSString *)title
                      manager: (JLDappBrowserNavigationBarManagerBlock)manager
                         back: (JLDappBrowserNavigationBarBackBlock)back
                        close: (JLDappBrowserNavigationBarCloseBlock)close {
    _managerBlock = manager;
    _backBlock = back;
    _closeBlock = close;
    _title = title;
    return [self initWithFrame:frame];
}

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
    _titleLabel.text = _title;
    _titleLabel.textColor = JL_color_gray_101010;
    _titleLabel.font = kFontPingFangSCSCSemibold(17);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(100);
        make.right.equalTo(self).offset(-100);
        make.height.mas_equalTo(@44);
    }];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _backBtn.hidden = YES;
    [_backBtn setImage:[[UIImage imageNamed:@"icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backBtn];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.width.height.mas_equalTo(@44);
    }];
    
    
    _faceView = [[UIView alloc] init];
    _faceView.layer.cornerRadius = 16;
    _faceView.layer.borderWidth = 1;
    _faceView.layer.borderColor = JL_color_gray_DDDDDD.CGColor;
    _faceView.layer.masksToBounds = YES;
    [self addSubview:_faceView];
    [_faceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(80, 32));
    }];
    
    _managerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_managerBtn setImage:[[UIImage imageNamed:@"icon_dapp_browser_bar_manger"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_managerBtn addTarget:self action:@selector(managerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_faceView addSubview:_managerBtn];
    [_managerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.faceView);
        make.width.mas_equalTo(@40);
    }];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_closeBtn setImage:[[UIImage imageNamed:@"icon_dapp_browser_bar_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_faceView addSubview:_closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.faceView);
        make.width.mas_equalTo(@40);
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = JL_color_gray_DDDDDD;
    [_faceView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.faceView);
        make.top.equalTo(self.faceView).offset(10);
        make.bottom.equalTo(self.faceView).offset(-10);
        make.width.mas_equalTo(@1);
    }];
}

#pragma mark - event response
- (void)backBtnClick: (UIButton *)sender {
    if (_backBlock) {
        _backBlock();
    }
}

- (void)managerBtnClick: (UIButton *)sender {
    if (_managerBlock) {
        _managerBlock();
    }
}

- (void)closeBtnClick: (UIButton *)sender {
    if (_closeBlock) {
        _closeBlock();
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    _titleLabel.text = _title;
}

- (void)setIsShowBackBtn:(BOOL)isShowBackBtn {
    _isShowBackBtn = isShowBackBtn;
    
    _backBtn.hidden = !_isShowBackBtn;
}

@end
