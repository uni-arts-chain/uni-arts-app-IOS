//
//  JLMineContentView.m
//  CloudArtChain
//
//  Created by jielian on 2021/6/21.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLMineContentView.h"
#import "JLMineContentTopView.h"
#import "JLMineContentMiddleView.h"
#import "JLMineContentBottomView.h"

@interface JLMineContentView () <JLMineContentTopViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) JLMineContentTopView *topView;

@property (nonatomic, strong) JLMineContentMiddleView *middleView;

@property (nonatomic, strong) JLMineContentBottomView *bottomView;

@end

@implementation JLMineContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    WS(weakSelf)
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    _bgView = [[UIView alloc] init];
    [_scrollView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    _topView = [[JLMineContentTopView alloc] init];
    _topView.delegate = self;
    [_bgView addSubview:_topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(@(126 + KStatusBar_Navigation_Height));
    }];
    
    _middleView = [[JLMineContentMiddleView alloc] init];
    _middleView.selectItemBlock = ^(NSInteger index) {
        [weakSelf middleJump:index];
    };
    [_bgView addSubview:_middleView];
    [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(-19);
        make.left.equalTo(self.bgView).offset(12);
        make.right.equalTo(self.bgView).offset(-12);
        make.height.mas_equalTo(@100);
    }];
    
    _bottomView = [[JLMineContentBottomView alloc] init];
    _bottomView.selectItemBlock = ^(NSInteger index) {
        [weakSelf bottomJump:index];
    };
    [_bgView addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.middleView.mas_bottom).offset(16);
        make.left.right.equalTo(self.middleView);
        make.bottom.equalTo(self.bgView);
    }];
}

#pragma mark - JLMineContentTopViewDelegate
- (void)lookHomePage {
    if (_delegate && [_delegate respondsToSelector:@selector(jumpToVC:)]) {
        [_delegate jumpToVC:JLMineContentViewItemTypeHomePage];
    }
}

- (void)lookWallet {
    if (_delegate && [_delegate respondsToSelector:@selector(jumpToVC:)]) {
        [_delegate jumpToVC:JLMineContentViewItemTypeIntegral];
    }
}

- (void)lookSetting {
    if (_delegate && [_delegate respondsToSelector:@selector(jumpToVC:)]) {
        [_delegate jumpToVC:JLMineContentViewItemTypeSetting];
    }
}

#pragma mark - public methods
- (void)refreshInfo {
    [_topView refreshInfo];
}

#pragma mark - private methods
- (void)middleJump:(NSInteger)index {
    if (index == 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(jumpToVC:)]) {
            [_delegate jumpToVC:JLMineContentViewItemTypeBuyOrder];
        }
    }else if (index == 1) {
        if (_delegate && [_delegate respondsToSelector:@selector(jumpToVC:)]) {
            [_delegate jumpToVC:JLMineContentViewItemTypeSellOrder];
        }
    }else if (index == 2) {
        if (_delegate && [_delegate respondsToSelector:@selector(jumpToVC:)]) {
            [_delegate jumpToVC:JLMineContentViewItemTypeMessage];
        }
    }else if (index == 3) {
        if (_delegate && [_delegate respondsToSelector:@selector(jumpToVC:)]) {
            [_delegate jumpToVC:JLMineContentViewItemTypeCustomerService];
        }
    }
}

- (void)bottomJump: (NSInteger)index {
    if (index == 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(jumpToVC:)]) {
            [_delegate jumpToVC:JLMineContentViewItemTypeHomePage];
        }
    }else if (index == 1) {
        if (_delegate && [_delegate respondsToSelector:@selector(jumpToVC:)]) {
            [_delegate jumpToVC:JLMineContentViewItemTypeUploadWork];
        }
    }else if (index == 2) {
        if (_delegate && [_delegate respondsToSelector:@selector(jumpToVC:)]) {
            [_delegate jumpToVC:JLMineContentViewItemTypeCollect];
        }
    }
}

#pragma mark - setters and getters
- (void)setAmount:(NSString *)amount {
    _amount = amount;
    
    _topView.amount = _amount;
}

@end
