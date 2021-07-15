//
//  JLPopularOriginalView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/25.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLPopularOriginalView.h"
#import "JLNFTGoodCollectionCell.h"
#import "XPCollectionViewWaterfallFlowLayout.h"

@interface JLPopularOriginalView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, XPCollectionViewWaterfallFlowLayoutDataSource>
@property (nonatomic, strong) NSMutableArray *waterDataArray;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) MASConstraint *collectionViewHeightConstraint;
@end

@implementation JLPopularOriginalView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.titleView];
    [self addSubview:self.collectionView];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.height.mas_equalTo(18.0f);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.titleView.mas_bottom).offset(11.0f);
        self.collectionViewHeightConstraint = make.height.mas_equalTo(@20);
        make.bottom.equalTo(self);
    }];
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = kFontPingFangSCSCSemibold(17.0f);
        titleLabel.textColor = JL_color_black_080C19;
        titleLabel.text = @"热卖二手商品";
        [_titleView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(_titleView);
        }];

    }
    return _titleView;
}

#pragma mark - 懒加载
-(UICollectionView*)collectionView {
    if (!_collectionView) {
        XPCollectionViewWaterfallFlowLayout *layout = [[XPCollectionViewWaterfallFlowLayout alloc] init];
        layout.dataSource = self;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = JL_color_clear;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[JLNFTGoodCollectionCell class] forCellWithReuseIdentifier:@"JLNFTGoodCollectionCell"];
    }
    return _collectionView;
}

#pragma - mark - XPCollectionViewWaterfallFlowLayoutDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout *)layout numberOfColumnInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout *)layout itemWidth:(CGFloat)width heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    Model_art_Detail_Data *artDetailData = self.waterDataArray[indexPath.item];
    
    CGFloat textH = [JLTool getAdaptionSizeWithText:artDetailData.name labelWidth:width - 25 font:kFontPingFangSCMedium(13.0f)].height;
    if (textH > 36.4) {
        textH = 36.4;
    }
    return 45 + textH + artDetailData.imgHeight;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout *)layout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 12, 12, 12);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout*)layout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 12;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout*)layout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 12;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout *)layout referenceHeightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout *)layout referenceHeightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)collectionViewContentSizeChange:(CGFloat)height {
    [self.collectionViewHeightConstraint uninstall];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        self.collectionViewHeightConstraint = make.height.mas_equalTo(@(height));
    }];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.waterDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JLNFTGoodCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JLNFTGoodCollectionCell" forIndexPath:indexPath];
    cell.marketLevel = 2;
    cell.artDetailData = self.waterDataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.artDetailBlock) {
        self.artDetailBlock(self.waterDataArray[indexPath.row]);
    }
}

- (void)setPopularArray:(NSArray *)popularArray {
    [self.waterDataArray removeAllObjects];
    [self.waterDataArray addObjectsFromArray:popularArray];
    
    [self.collectionView reloadData];
    [_collectionView.mj_footer endRefreshingWithNoMoreData];
}

- (NSMutableArray *)waterDataArray {
    if (!_waterDataArray) {
        _waterDataArray = [NSMutableArray array];
    }
    return _waterDataArray;
}

@end
