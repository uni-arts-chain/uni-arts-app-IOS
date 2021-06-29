//
//  JLPageMenuView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/2.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLPageMenuView.h"

@interface JLPageMenuView ()
@property (nonatomic, strong) NSArray *menus;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation JLPageMenuView

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (instancetype)initWithMenus:(NSArray *)menus itemMargin:(CGFloat)itemMargin {
    if (self = [super init]) {
        self.menus = menus;
        [self createSubViewsWithItemMargin:itemMargin];
    }
    return self;
}

- (void)createSubViewsWithItemMargin:(CGFloat)itemMargin {
    self.centerView = [[UIView alloc] init];
    [self addSubview:self.centerView];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    UIButton *lastButton = nil;
    for (int i = 0; i < self.menus.count; i++) {
        NSString *title = self.menus[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:JL_color_black_101220 forState:UIControlStateNormal];
        [button setTitleColor:JL_color_mainColor forState:UIControlStateSelected];
        button.titleLabel.font = kFontPingFangSCRegular(15.0f);
        button.tag = 2000 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            button.selected = YES;
            button.titleLabel.font = kFontPingFangSCMedium(17.0f);
        }
        [self.centerView addSubview:button];
        if (i == 0) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.mas_equalTo(self.centerView);
            }];
        } else if (i == self.menus.count - 1) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.bottom.equalTo(self.centerView);
                make.left.equalTo(lastButton.mas_right).offset(itemMargin);
            }];
        } else {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.centerView);
                make.left.equalTo(lastButton.mas_right).offset(itemMargin);
            }];
        }
        lastButton = button;
        [self.buttonArray addObject:button];
    }
    
    [self.centerView addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(43.0f);
        make.height.mas_equalTo(2.0f);
        make.centerY.equalTo(self.centerView.mas_centerY).offset(15.0f);
        make.centerX.equalTo(((UIButton *)[self.buttonArray firstObject]).mas_centerX);
    }];
}

- (void)buttonClick:(UIButton *)sender {
    WS(weakSelf)
    for (UIButton *button in self.buttonArray) {
        button.selected = NO;
        button.titleLabel.font = kFontPingFangSCRegular(15.0f);
    }
    sender.selected = YES;
    sender.titleLabel.font = kFontPingFangSCMedium(17.0f);
    [UIView animateWithDuration:0.3f animations:^{
        [weakSelf.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(43.0f);
            make.height.mas_equalTo(2.0f);
            make.centerY.equalTo(self.centerView.mas_centerY).offset(15.0f);
            make.centerX.equalTo(sender.mas_centerX);
        }];
        [weakSelf.centerView layoutIfNeeded];
    }];
    if (self.indexChangedBlock) {
        self.indexChangedBlock(sender.tag - 2000);
    }
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = JL_color_mainColor;
    }
    return _bottomLine;
}

@end
