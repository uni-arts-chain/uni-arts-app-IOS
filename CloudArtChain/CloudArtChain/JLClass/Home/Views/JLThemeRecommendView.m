//
//  JLThemeRecommendView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/25.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLThemeRecommendView.h"
#import "JLPopularOriginalCollectionViewCell.h"

@interface JLThemeRecommendView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *themeArray;
@end

@implementation JLThemeRecommendView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.imageView];
    [self addSubview:self.collectionView];
    [self.collectionView  registerClass:[JLPopularOriginalCollectionViewCell class] forCellWithReuseIdentifier:@"JLPopularOriginalCollectionViewCell"];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(140.0f);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.imageView.mas_bottom).offset(16.0f);
        make.bottom.equalTo(self);
    }];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        ViewBorderRadius(_imageView, 5.0f, 0.0f, JL_color_clear);
    }
    return _imageView;
}

#pragma mark - 懒加载
-(UICollectionView*)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((kScreenWidth - 15.0f * 2 - 22.0f * 2) / 2.5f, 252.0f);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 22.0f;
        flowLayout.minimumInteritemSpacing = 0.0f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(0.0f, 15.0f, 0.0f, 15.0f);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = JL_color_white_ffffff;
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.themeArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JLPopularOriginalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JLPopularOriginalCollectionViewCell" forIndexPath:indexPath];
    cell.themeArtData = self.themeArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.themeRecommendBlock) {
        self.themeRecommendBlock(self.themeArray[indexPath.row]);
    }
}

- (void)setTopicData:(Model_arts_topic_Data *)topicData {
    if (![NSString stringIsEmpty:topicData.app_img_file[@"url"]]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:topicData.app_img_file[@"url"]]];
    }
    self.themeArray = topicData.arts;
    [self.collectionView reloadData];
}

@end
