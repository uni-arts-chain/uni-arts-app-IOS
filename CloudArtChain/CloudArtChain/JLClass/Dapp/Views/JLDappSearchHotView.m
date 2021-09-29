//
//  JLDappSearchHotView.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/28.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappSearchHotView.h"
#import "JLEmptyDataView.h"

#pragma mark -- JLDappSearchHotView
@interface JLDappSearchHotView ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) JLEmptyDataView *emptyDataView;

@end

@implementation JLDappSearchHotView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"热门搜索";
    _titleLabel.textColor = JL_color_gray_101010;
    _titleLabel.font = kFontPingFangSCSCSemibold(14);
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self);
        make.top.equalTo(self);
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 13;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.itemSize = CGSizeMake(self.frameWidth / 5, self.frameWidth / 5);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = JL_color_white_ffffff;
    _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:JLDappSearchHotCell.class forCellWithReuseIdentifier:NSStringFromClass(JLDappSearchHotCell.class)];
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.right.bottom.equalTo(self);
    }];
    
    _emptyDataView = [[JLEmptyDataView alloc] init];
    _emptyDataView.hidden = YES;
    [self addSubview:_emptyDataView];
    [_emptyDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.collectionView);
        make.height.mas_equalTo(@300);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _hotSearchArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JLDappSearchHotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(JLDappSearchHotCell.class) forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(lookDappWithUrl:)]) {
        [_delegate lookDappWithUrl:@"xx"];
    }
}

#pragma mark - setters and getters
- (void)setHotSearchArray:(NSArray *)hotSearchArray {
    _hotSearchArray = hotSearchArray;
    
    if (_hotSearchArray.count == 0) {
        _emptyDataView.hidden = NO;
    }else {
        _emptyDataView.hidden = YES;
    }
    
    [_collectionView reloadData];
}

@end

#pragma mark -- JLDappSearchHotCell
@interface JLDappSearchHotCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation JLDappSearchHotCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _bgView = [[UIView alloc] init];
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
    
    _imgView = [[UIImageView alloc] init];
    _imgView.backgroundColor = JL_color_blue_6077DF;
    _imgView.layer.cornerRadius = 17.5;
    _imgView.layer.borderWidth = 1;
    _imgView.layer.borderColor = JL_color_gray_DDDDDD.CGColor;
    _imgView.clipsToBounds = YES;
    [_bgView addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bgView);
        make.width.height.mas_equalTo(@35);
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = @"BTC";
    _nameLabel.textColor = JL_color_gray_101010;
    _nameLabel.font = kFontPingFangSCRegular(13);
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView);
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.imgView.mas_bottom).offset(8);
    }];
}

#pragma mark - setters and getters

- (void)setDappData:(Model_dapp_Data *)dappData {
    _dappData = dappData;
    
    
}

@end
