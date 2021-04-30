//
//  JLCateFilterView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/25.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLCateFilterView.h"

@interface JLCateFilterView ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) void(^selectBlock)(NSInteger index);

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation JLCateFilterView
- (NSMutableArray *)itemsArray {
    if (!_itemsArray) {
        _itemsArray = [NSMutableArray array];
    }
    return _itemsArray;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title items:(NSArray *)items selectBlock:(void(^)(NSInteger index))selectBlock {
    if (self = [super initWithFrame:frame]) {
        self.title = title;
        self.items = items;
        self.selectBlock = selectBlock;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.titleLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = JL_color_gray_8D8D8D;
    [self addSubview:lineView];
    
    [self addSubview:self.scrollView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.bottom.equalTo(self);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(17.0f);
        make.height.mas_equalTo(17.0f);
        make.width.mas_equalTo(1.0f);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(11.0f);
        make.top.right.bottom.equalTo(self);
    }];
    
    [self setupItems];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFontPingFangSCMedium(14.0f);
        _titleLabel.textColor = JL_color_gray_101010;
        _titleLabel.text = self.title;
    }
    return _titleLabel;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (void)setupItems {
    CGFloat currentX = 0.0f;
    for (int i = 0; i < self.items.count; i++) {
        UIButton *button = [self getButtonWithFrame:CGRectMake(currentX, 10.0f, [JLTool getAdaptionSizeWithText:self.items[i] labelHeight:self.frameHeight - 8.0f * 2 font:kFontPingFangSCRegular(14.0f)].width + 6.0f * 2, self.frameHeight - 10.0f * 2) title:self.items[i] tag:2001 + i];
        [self.scrollView addSubview:button];
        [self.itemsArray addObject:button];
        currentX += [JLTool getAdaptionSizeWithText:self.items[i] labelHeight:self.frameHeight - 8.0f * 2 font:kFontPingFangSCRegular(14.0f)].width + 6.0f * 2 + 14.0f;
    }
    self.scrollView.contentSize = CGSizeMake(currentX, self.frameHeight);
}

- (UIButton *)getButtonWithFrame:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:JL_color_gray_606060 forState:UIControlStateNormal];
    [button setTitleColor:JL_color_white_ffffff forState:UIControlStateSelected];
    button.titleLabel.font = kFontPingFangSCRegular(14.0f);
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    ViewBorderRadius(button, 2.0f, 0.0f, JL_color_clear);
    return button;
}

- (void)buttonClick:(UIButton *)sender {
    NSInteger selectIndex = sender.tag - 2000;
    if (self.currentIndex == selectIndex) {
        sender.selected = NO;
        sender.backgroundColor = JL_color_clear;
        self.currentIndex = 0;
    } else {
        self.currentIndex = selectIndex;
        for (UIButton *button in self.itemsArray) {
            button.selected = NO;
            button.backgroundColor = JL_color_clear;
        }
        sender.selected = YES;
        sender.backgroundColor = JL_color_gray_101010;
    }
    if (self.selectBlock) {
        self.selectBlock(self.currentIndex);
    }
}

- (void)refreshItems:(NSArray *)items {
    self.items = items;
    [self setupItems];
}

@end
