//
//  JLDappChainView.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/26.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappChainView.h"
#import "JLDappEmptyView.h"

@interface JLDappChainView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) JLDappEmptyView *emptyView;

@property (nonatomic, assign) CGFloat pageWidth;
@property (nonatomic, assign) CGFloat pageRightInset;
@property (nonatomic, assign) CGFloat dappHeight;
@property (nonatomic, assign) NSInteger allPageNum;
@property (nonatomic, assign) NSInteger currentPage; // 当前处于第几页

@end

@implementation JLDappChainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pageRightInset = 30;
        _pageWidth = kScreenWidth - _pageRightInset;
        _dappHeight = 64;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    
    _bgView = [[UIView alloc] init];
    [_scrollView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    
    _emptyView = [[JLDappEmptyView alloc] init];
    _emptyView.hidden = YES;
    [_scrollView addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.scrollView);
    }];
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
    
    NSInteger lastPageIndex = 0;
    for (int i = 0; i < _dataArray.count; i++) {
        if (i % 3 == 0) {
            lastPageIndex = i;
            _allPageNum += 1;
        }
    }

    UIView *itemBgView = nil;
    for (int i = 0; i < _dataArray.count; i++) {
        CGFloat leftConstrant = 0.0;
        CGFloat topConstrant = 0.0;
        if (i % 3 == 0) {
            topConstrant = 0;
            leftConstrant = i / 3 * _pageWidth;
            
            itemBgView = [[UIView alloc] init];
            [_bgView addSubview:itemBgView];
            [itemBgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.bgView);
                make.left.equalTo(self.bgView).offset(leftConstrant);
                make.width.mas_equalTo(@(self.pageWidth));
                if (i == lastPageIndex) {
                    make.right.equalTo(self.bgView).offset(-(self.pageRightInset));
                }
            }];
        }else {
            topConstrant = _dappHeight * (i % 3);
        }
        
        UIView *itemView = [[UIView alloc] init];
        itemView.tag = 100 + i;
        itemView.userInteractionEnabled = YES;
        [itemView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemViewDidTap:)]];
        [itemBgView addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(itemBgView).offset(topConstrant);
            make.left.right.equalTo(itemBgView);
            make.height.mas_equalTo(@(self.dappHeight));
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.backgroundColor = JL_color_blue_6077DF;
        imgView.layer.cornerRadius = 17.5;
        imgView.layer.borderWidth = 1;
        imgView.layer.borderColor = JL_color_gray_DDDDDD.CGColor;
        imgView.clipsToBounds = YES;
        [itemView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(itemView).offset(15);
            make.centerY.equalTo(itemView);
            make.width.height.mas_equalTo(@35);
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = @"Uniswap";
        nameLabel.textColor = JL_color_gray_101010;
        nameLabel.font = kFontPingFangSCRegular(15);
        [itemView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView).offset(-2);
            make.left.equalTo(imgView.mas_right).offset(17);
            make.right.equalTo(itemView);
        }];
        
        UILabel *descLabel = [[UILabel alloc] init];
        descLabel.text = @"去中心化流通平台";
        descLabel.textColor = JL_color_gray_999999;
        descLabel.font = kFontPingFangSCRegular(12);
        [itemView addSubview:descLabel];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(imgView).offset(2);
            make.left.equalTo(imgView.mas_right).offset(17);
            make.right.equalTo(itemView);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = JL_color_gray_DDDDDD;
        [itemView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(itemView).offset(66);
            make.bottom.right.equalTo(itemView);
            make.height.mas_equalTo(@1);
        }];
    }
}

#pragma mark - UIScrollViewDelegate 方法
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGPoint targetOffset = [self nearestPageTargetOffsetForOffset:*targetContentOffset];
    targetContentOffset->x = targetOffset.x;
    targetContentOffset->y = targetOffset.y;
}

#pragma mark - event response
- (void)itemViewDidTap: (UITapGestureRecognizer *)ges {
    if (_lookDappBlock) {
        _lookDappBlock([NSString stringWithFormat:@"chain: %ld", ges.view.tag - 100]);
    }
}

#pragma mark - private methods
- (CGPoint)nearestPageTargetOffsetForOffset:(CGPoint)offset {
    if (fabs(offset.x - _currentPage * _pageWidth) >= 50) {
        if (offset.x > _currentPage * _pageWidth) {
            CGFloat targetX = _pageWidth * (_currentPage + 1);
            _currentPage += 1;
            return CGPointMake(targetX, offset.y);
        }else {
            CGFloat targetX = _pageWidth * (_currentPage - 1);
            _currentPage -= 1;
            return CGPointMake(targetX, offset.y);
        }
    }else {
        CGFloat targetX = _pageWidth * _currentPage;
        return CGPointMake(targetX, offset.y);
    }
}

#pragma mark - setters and getters
- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
        
    [self updateDapps];
}

@end
