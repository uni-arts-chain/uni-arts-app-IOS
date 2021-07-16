//
//  JLScrollTitleView.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/14.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLScrollTitleView.h"

@interface JLScrollTitleView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIButton *currentSelectBtn;

@property (nonatomic, strong) MASConstraint *lineCenterXConstraint;

@end

@implementation JLScrollTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = JL_color_gray_F6F6F6;
        _screenMax = 4;
        _defaultIndex = 0;
        _itemSize = CGSizeMake(self.frameWidth / 4, self.frameHeight);
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    _bgView = [[UIView alloc] init];
    [_scrollView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = JL_color_gray_101010;
    [_scrollView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView);
        make.size.mas_equalTo(@(CGSizeMake(30, 2)));
        self.lineCenterXConstraint = make.centerX.equalTo(self.bgView);
    }];
}

- (void)updateUI {
    [_bgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    for (int i = 0; i < _titleArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 100 + i;
        [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:JL_color_gray_101010 forState:UIControlStateNormal];
        btn.titleLabel.font = kFontPingFangSCRegular(15);
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.bgView);
            make.left.equalTo(self.bgView).offset(i * self.itemSize.width);
            make.size.mas_equalTo(@(self.itemSize));
            if (i == _titleArray.count - 1) {
                make.right.equalTo(self.bgView);
            }
        }];
        
        if (_defaultIndex == i) {
            _currentSelectBtn = btn;
            _currentIndex = i;
            btn.titleLabel.font = kFontPingFangSCSCSemibold(15);
            
            [_lineCenterXConstraint uninstall];
            [_lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                self.lineCenterXConstraint = make.centerX.equalTo(btn);
            }];
        }
    }
}

#pragma mark - event response
- (void)btnClick: (UIButton *)sender {
    if (sender.tag == _currentSelectBtn.tag) {
        return;
    }
    
    _currentSelectBtn.titleLabel.font = kFontPingFangSCRegular(15);
    sender.titleLabel.font = kFontPingFangSCSCSemibold(15);
    
    _currentIndex = sender.tag - 100;
    _currentSelectBtn = sender;
    
    [_lineCenterXConstraint uninstall];
    [UIView animateWithDuration:0.25 animations:^{
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.lineCenterXConstraint = make.centerX.equalTo(sender);
        }];
        [self.scrollView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self updateContentOffset];
    }];
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectIndex:)]) {
        [_delegate didSelectIndex:_currentIndex];
    }
}

#pragma mark - private methods
- (void)updateContentOffset {
    CGRect frame = _currentSelectBtn.frame;
    CGFloat itemX = frame.origin.x;
    CGFloat width = self.bounds.size.width;
    CGSize contentSize = self.scrollView.contentSize;
    if (itemX > (width / 2)) {
        CGFloat targetX = 0.0;
        if ((contentSize.width - itemX) <= width / 2) {
            targetX = contentSize.width - width;
        }else {
            targetX = frame.origin.x - width / 2 + frame.size.width / 2;
        }
        if (targetX + width > contentSize.width) {
            targetX = contentSize.width - width;
        }
        [self.scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES];
    }else {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

#pragma mark - public methods
/// 滑动偏移量
- (void)scrollOffset: (CGFloat)offset {
        
    if ((NSInteger)(offset * 1000000) % (NSInteger)(kScreenWidth * 1000000) == 0) {
        _currentIndex = offset / kScreenWidth;
    }
    // 当前页的偏移
    CGFloat currentPageW = _currentIndex * kScreenWidth;

    if (offset > currentPageW) {
        // 左滑
        float percent = (offset - currentPageW) / kScreenWidth;
        
        [self.lineCenterXConstraint uninstall];
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.lineCenterXConstraint = make.centerX.equalTo(self.currentSelectBtn).offset(self.itemSize.width * percent);
        }];
    }else if (offset < currentPageW) {
        // 右滑
        float percent = (currentPageW - offset) / kScreenWidth;
        
        [self.lineCenterXConstraint uninstall];
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.lineCenterXConstraint = make.centerX.equalTo(self.currentSelectBtn).offset(-self.itemSize.width * percent);
        }];
    }else {
        [_bgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.tag >= 100) {
                if (obj.tag - 100 == _currentIndex) {
                    self.currentSelectBtn = obj;
                    ((UIButton *)obj).titleLabel.font = kFontPingFangSCSCSemibold(15);
                }else {
                    ((UIButton *)obj).titleLabel.font = kFontPingFangSCRegular(15);
                }
            }
        }];
        [self.lineCenterXConstraint uninstall];
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.lineCenterXConstraint = make.centerX.equalTo(self.currentSelectBtn);
        }];
        
        [self updateContentOffset];
    }
}

#pragma mark - setters and getters
- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    _itemSize = CGSizeMake(self.frameWidth / (_titleArray.count > _screenMax ? _screenMax : _titleArray.count), self.frameHeight);
    
    [self updateUI];
}

- (void)setScreenMax:(NSInteger)screenMax {
    _screenMax = screenMax;
    
    _itemSize = CGSizeMake(self.frameWidth / _screenMax, self.frameHeight);
}

- (void)setDefaultIndex:(NSInteger)defaultIndex {
    _defaultIndex = defaultIndex;
    
    [self updateUI];
}

@end
