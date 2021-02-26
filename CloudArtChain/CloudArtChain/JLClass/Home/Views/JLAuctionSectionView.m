//
//  JLAuctionView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/21.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLAuctionSectionView.h"
#import "JLAuctionCellView.h"
#import <SDCycleScrollView/TAPageControl.h>
#import "JLDotView.h"

@interface JLAuctionSectionView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIScrollView *auctionScrollView;
@property (nonatomic, strong) TAPageControl *pageControl;
@end

@implementation JLAuctionSectionView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.titleView];
    [self addSubview:self.auctionScrollView];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.mas_equalTo(29.0f);
        make.height.mas_equalTo(20.0f);
    }];
    [self.auctionScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.titleView.mas_bottom);
        make.height.mas_equalTo(282.0f);
        make.width.mas_equalTo(kScreenWidth);
    }];
    
    [self addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(-10.0f);
    }];
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        
        UILabel *titleLabel = [JLUIFactory labelInitText:@"限时拍卖" font:kFontPingFangSCSCSemibold(20.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentCenter];
        [_titleView addSubview:titleLabel];
        
        UIImageView *leftMaskImageView = [JLUIFactory imageViewInitImageName:@"icon_home_auction_left"];
        [_titleView addSubview:leftMaskImageView];
        
        UIImageView *rightMaskImageView = [JLUIFactory imageViewInitImageName:@"icon_home_auction_right"];
        [_titleView addSubview:rightMaskImageView];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_titleView);
            make.centerX.equalTo(_titleView);
        }];
        [leftMaskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(43.0f);
            make.height.mas_equalTo(14.0f);
            make.centerY.equalTo(_titleView);
            make.right.equalTo(titleLabel.mas_left).offset(-12.0f);
        }];
        [rightMaskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(43.0f);
            make.height.mas_equalTo(14.0f);
            make.centerY.equalTo(_titleView);
            make.left.equalTo(titleLabel.mas_right).offset(12.0f);
        }];
    }
    return _titleView;
}

- (UIScrollView *)auctionScrollView {
    if (!_auctionScrollView) {
        _auctionScrollView = [[UIScrollView alloc] init];
        _auctionScrollView.showsHorizontalScrollIndicator = NO;
        _auctionScrollView.showsVerticalScrollIndicator = NO;
        _auctionScrollView.pagingEnabled = YES;
        _auctionScrollView.delegate = self;
    }
    return _auctionScrollView;
}

- (TAPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[TAPageControl alloc] init];
        _pageControl.dotViewClass = [JLDotView class];
        _pageControl.dotSize = CGSizeMake(5.0f, 5.0f);
    }
    return _pageControl;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = round(scrollView.contentOffset.x / kScreenWidth);
    self.pageControl.currentPage = page;
}

- (void)setAuctionArray:(NSArray *)auctionArray {
    WS(weakSelf)
    for (int i = 0; i < auctionArray.count; i++) {
        JLAuctionCellView *auctionCellView = [[JLAuctionCellView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0.0f, kScreenWidth, 282.0f)];
        auctionCellView.auctionData = auctionArray[i];
        auctionCellView.entryBlock = ^{
            if (weakSelf.entryBlock) {
                weakSelf.entryBlock(i);
            }
        };
        [self.auctionScrollView addSubview:auctionCellView];
    }
    [self.auctionScrollView setContentSize:CGSizeMake(kScreenWidth * auctionArray.count, 282.0f)];
    self.pageControl.numberOfPages = auctionArray.count;
    self.pageControl.currentPage = 0;
}
@end
