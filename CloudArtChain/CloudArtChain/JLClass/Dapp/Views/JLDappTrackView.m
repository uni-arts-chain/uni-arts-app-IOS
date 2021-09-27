//
//  JLDappTrackView.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/26.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappTrackView.h"
#import "JLDappTitleView.h"
#import "JLDappEmptyView.h"

@interface JLDappTrackView ()

@property (nonatomic, strong) JLDappTitleView *titleView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) JLDappEmptyView *emptyView;

@end

@implementation JLDappTrackView

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
    _titleView = [[JLDappTitleView alloc] init];
    _titleView.didSelectBlock = ^(NSInteger index) {
        if (weakSelf.didSelectTitleBlock) {
            weakSelf.didSelectTitleBlock(index);
        }
    };
    _titleView.moreBlock = ^(NSInteger index) {
        if (weakSelf.moreBlock) {
            weakSelf.moreBlock(index);
        }
    };
    [self addSubview:_titleView];
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(@30);
    }];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
    
    _bgView = [[UIView alloc] init];
    [_scrollView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = JL_color_gray_DDDDDD;
    [self addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(@1);
    }];
    
    _emptyView = [[JLDappEmptyView alloc] init];
    _emptyView.hidden = YES;
    [_scrollView addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.scrollView);
    }];
    
    [_titleView setTitleArray:@[@"收藏",@"最近"] selectIndex:0 style:JLDappTitleViewStyleScrollDefault];
}

- (void)updateDapps {
    [_bgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    if (_dataArray.count == 0) {
        _emptyView.hidden = NO;
    }else {
        _emptyView.hidden = YES;
    }
    
    CGFloat itemW = 71;
    for (int i = 0; i < _dataArray.count; i++) {
        UIView *itemView = [[UIView alloc] init];
        itemView.tag = 100 + i;
        itemView.userInteractionEnabled = YES;
        [itemView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemViewDidTap:)]];
        [_bgView addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.bgView);
            make.left.equalTo(self.bgView).offset(i * itemW);
            make.width.mas_equalTo(@(itemW));
            if (i == _dataArray.count - 1) {
                make.right.equalTo(self.bgView);
            }
        }];
        
        UIView *contentView = [[UIView alloc] init];
        [itemView addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(itemView);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.backgroundColor = JL_color_blue_6077DF;
        imgView.layer.cornerRadius = 17.5;
        imgView.clipsToBounds = YES;
        [contentView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(contentView);
            make.width.height.mas_equalTo(@35);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"BTC";
        label.textColor = JL_color_gray_666666;
        label.font = kFontPingFangSCRegular(13);
        label.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(contentView);
            make.centerX.equalTo(contentView);
            make.top.equalTo(imgView.mas_bottom).offset(10);
        }];
    }
}

#pragma mark - event response
- (void)itemViewDidTap: (UITapGestureRecognizer *)ges {
    if (_lookDappBlock) {
        _lookDappBlock([NSString stringWithFormat:@"track: %ld", ges.view.tag - 100]);
    }
}

#pragma mark - setters and getters
- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;

    [self updateDapps];
}

@end
