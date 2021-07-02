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
/// 是否不可以反选
@property (nonatomic, assign) BOOL isNoDeSelect;
/// 是否有全部选项
@property (nonatomic, assign) BOOL isShowAllItem;
@end

@implementation JLCateFilterView
- (NSMutableArray *)itemsArray {
    if (!_itemsArray) {
        _itemsArray = [NSMutableArray array];
    }
    return _itemsArray;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title items:(NSArray *)items isNoDeSelect: (BOOL)isNoDeSelect defaultSelectIndex: (NSInteger)defaultSelectIndex isShowAllItem:(BOOL)isShowAllItem selectBlock:(void(^)(NSInteger index))selectBlock {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        self.title = title;
        self.items = items;
        self.currentIndex = defaultSelectIndex;
        self.isNoDeSelect = isNoDeSelect;
        self.isShowAllItem = isShowAllItem;
        self.selectBlock = selectBlock;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.titleLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = JL_color_gray_E1E1E1;
    [self addSubview:lineView];
    
    [self addSubview:self.scrollView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13.0f);
        make.top.bottom.equalTo(self);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(8.0f);
        make.height.mas_equalTo(16.0f);
        make.width.mas_equalTo(1.0f);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(8.0f);
        make.top.right.bottom.equalTo(self);
    }];
    
    [self setupItems];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFontPingFangSCRegular(15.0f);
        _titleLabel.textColor = JL_color_black_101220;
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
    
    NSInteger offsetIndex = 0;
    if (_isShowAllItem) {
        self.currentIndex = 0;
        
        UIButton *button = [self getButtonWithFrame:CGRectMake(currentX, (self.frameHeight - 22) / 2, [JLTool getAdaptionSizeWithText:@"全部" labelHeight:22 font:kFontPingFangSCRegular(14.0f)].width + 8.0f * 2, 22) title:@"全部" tag:100];
        button.selected = YES;
        button.backgroundColor = JL_color_mainColor;
        ViewBorderRadius(button, 3.0f, 0.0f, JL_color_clear);
        [self.scrollView addSubview:button];
        [self.itemsArray addObject:button];
        currentX += [JLTool getAdaptionSizeWithText:@"全部" labelHeight:22 font:kFontPingFangSCRegular(14.0f)].width + 8.0f * 2 + 6.0f;
        
        offsetIndex += 1;
    }
    for (int i = 0; i < self.items.count; i++) {
        UIButton *button = [self getButtonWithFrame:CGRectMake(currentX, (self.frameHeight - 22) / 2, [JLTool getAdaptionSizeWithText:self.items[i] labelHeight:22 font:kFontPingFangSCRegular(14.0f)].width + 8.0f * 2, 22) title:self.items[i] tag:100 + i + offsetIndex];
        if (!_isShowAllItem && _currentIndex == i) {
            button.selected = YES;
            button.backgroundColor = JL_color_mainColor;
            ViewBorderRadius(button, 3.0f, 0.0f, JL_color_clear);
        }
        [self.scrollView addSubview:button];
        [self.itemsArray addObject:button];
        currentX += [JLTool getAdaptionSizeWithText:self.items[i] labelHeight:22 font:kFontPingFangSCRegular(14.0f)].width + 8.0f * 2 + 6.0f;
    }
    self.scrollView.contentSize = CGSizeMake(currentX, self.frameHeight);
}

- (UIButton *)getButtonWithFrame:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:JL_color_black_101220 forState:UIControlStateNormal];
    [button setTitleColor:JL_color_white_ffffff forState:UIControlStateSelected];
    button.titleLabel.font = kFontPingFangSCRegular(13.0f);
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    ViewBorderRadius(button, 3.0f, 1.0f, JL_color_gray_E1E1E1);
    return button;
}

- (void)buttonClick:(UIButton *)sender {
    if (_isShowAllItem && sender.tag - 100 == 0) {
        return;
    }
    
    if (_isNoDeSelect) {
        self.currentIndex = sender.tag - 100;
    }else {
        if (self.currentIndex == sender.tag - 100) {
            sender.selected = NO;
            sender.backgroundColor = JL_color_clear;
            ViewBorderRadius(sender, 3.0f, 1.0f, JL_color_gray_E1E1E1);
            self.currentIndex = 0;
            
            if (_isShowAllItem) {
                UIButton *button = self.itemsArray[0];
                button.selected = YES;
                button.backgroundColor = JL_color_mainColor;
                ViewBorderRadius(button, 3.0f, 0.0f, JL_color_clear);
            }
        } else {
            self.currentIndex = sender.tag - 100;
            for (UIButton *button in self.itemsArray) {
                button.selected = NO;
                button.backgroundColor = JL_color_clear;
                ViewBorderRadius(button, 3.0f, 1.0f, JL_color_gray_E1E1E1);
            }
            sender.selected = YES;
            sender.backgroundColor = JL_color_mainColor;
            ViewBorderRadius(sender, 3.0f, 0.0f, JL_color_clear);
        }
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
