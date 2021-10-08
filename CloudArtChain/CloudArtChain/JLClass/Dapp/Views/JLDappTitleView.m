//
//  JLDappTitleView.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/26.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappTitleView.h"

@interface JLDappTitleView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) MASConstraint *scrollViewRightConstraint;
@property (nonatomic, strong) MASConstraint *lineViewCenterXConstraint;

@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) JLDappTitleViewStyle style;

@property (nonatomic, strong) UILabel *lastTitleLabel;

@end

@implementation JLDappTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectIndex = 0;
        _style = JLDappTitleViewStyleScrollDefault;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        self.scrollViewRightConstraint = make.right.equalTo(self).offset(-60);
    }];
    
    _bgView = [[UIView alloc] init];
    [_scrollView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.hidden = YES;
    _lineView.backgroundColor = JL_color_gray_101010;
    _lineView.layer.cornerRadius = 1;
    [_scrollView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.scrollView).offset(-12);
        make.size.mas_equalTo(CGSizeMake(20, 2));
    }];
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_moreBtn setTitle:@"全部" forState:UIControlStateNormal];
    [_moreBtn setTitleColor:JL_color_gray_999999 forState:UIControlStateNormal];
    _moreBtn.titleLabel.font = kFontPingFangSCRegular(13);
    [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_moreBtn];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.width.mas_equalTo(60);
    }];
}

- (void)updateTitles {
    [_bgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    if (_titleArray.count == 0) {
        _lineView.hidden = YES;
    }else {
        _lineView.hidden = NO;
    }
    
    _moreBtn.hidden = NO;
    _lineView.hidden = NO;
    if (_style == JLDappTitleViewStyleNoScroll) {
        _lineView.hidden = YES;
    }else if (_style == JLDappTitleViewStyleScrollNoMore) {
        _moreBtn.hidden = YES;
        [_scrollViewRightConstraint uninstall];
        [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.scrollViewRightConstraint = make.right.equalTo(self);
        }];
    }

    CGFloat itemW = 60;
    for (int i = 0; i < _titleArray.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.tag = 100 + i;
        titleLabel.text = _titleArray[i];
        titleLabel.textColor = JL_color_gray_101010;
        titleLabel.font = kFontPingFangSCRegular(14);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.userInteractionEnabled = YES;
        [titleLabel addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelDidTap:)]];
        [_bgView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.bgView);
            make.left.equalTo(self.bgView).offset(i * 60);
            make.width.mas_equalTo(@(itemW));
            if (i == _titleArray.count - 1) {
                make.right.equalTo(self.bgView).offset(-15);
            }
        }];
        
        if (_selectIndex == i) {
            titleLabel.font = kFontPingFangSCSCSemibold(14);
            [_lineViewCenterXConstraint uninstall];
            [_lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                self.lineViewCenterXConstraint = make.centerX.equalTo(titleLabel);
            }];
            _lastTitleLabel = titleLabel;
        }
    }
}

#pragma mark - event response
- (void)titleLabelDidTap: (UITapGestureRecognizer *)ges {
    if ((ges.view.tag - 100) != _selectIndex) {
        _selectIndex = ges.view.tag - 100;
        
        ((UILabel *)ges.view).font = kFontPingFangSCSCSemibold(14);
        if (_lastTitleLabel) {
            _lastTitleLabel.font = kFontPingFangSCRegular(14);
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.lineViewCenterXConstraint uninstall];
            [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                self.lineViewCenterXConstraint = make.centerX.equalTo(ges.view);
            }];
            [self.scrollView layoutIfNeeded];
        }];
        
        _lastTitleLabel = (UILabel *)ges.view;
        
        if (_didSelectBlock) {
            _didSelectBlock(_selectIndex);
        }
    }
}

- (void)moreBtnClick: (UIButton *)sender {
    if (_moreBlock) {
        _moreBlock(_selectIndex);
    }
}

- (void)setTitleArray: (NSArray *)titleArray selectIndex: (NSInteger)selectIndex style: (JLDappTitleViewStyle)style {
    _titleArray = titleArray;
    _selectIndex = selectIndex;
    _style = style;
    
    [self updateTitles];
}

@end
