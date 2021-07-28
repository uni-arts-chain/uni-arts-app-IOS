//
//  JLThemeRecommendView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/25.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLThemeRecommendView.h"
#import "JLThemeRecommendCollectionViewCell.h"

@interface JLThemeRecommendView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *themeArray;
@end

@implementation JLThemeRecommendView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.titleView];
    [self addSubview:self.imageView];
    [self addSubview:self.collectionView];
    [self.collectionView  registerClass:[JLThemeRecommendCollectionViewCell class] forCellWithReuseIdentifier:@"JLThemeRecommendCollectionViewCell"];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.height.mas_equalTo(18.0f);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleView);
        make.top.equalTo(self.titleView.mas_bottom).offset(11);
        make.height.mas_equalTo(115.0f);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.imageView.mas_bottom).offset(6.0f);
        make.bottom.equalTo(self).offset(-18);
    }];
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = kFontPingFangSCSCSemibold(17.0f);
        titleLabel.textColor = JL_color_black_080C19;
        titleLabel.text = @"主题";
        [_titleView addSubview:titleLabel];
        self.titleLabel = titleLabel;;
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(_titleView);
        }];
    }
    return _titleView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        ViewBorderRadius(_imageView, 9.0f, 0.0f, JL_color_clear);
    }
    return _imageView;
}

#pragma mark - 懒加载
-(UICollectionView*)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((kScreenWidth - 7.0f) / (2 + 83.0f / 130.0f), 230.0f);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0.0f;
        flowLayout.minimumInteritemSpacing = 0.0f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(0.0f, 7.0f, 0.0f, 7.0f);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = JL_color_clear;
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.themeArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JLThemeRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JLThemeRecommendCollectionViewCell" forIndexPath:indexPath];
    [cell setThemeArtData:self.themeArray[indexPath.row] totalCount:self.themeArray.count index:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.themeArray.count - 1) {
        if (self.seeMoreBlock) {
            self.seeMoreBlock(@(self.topicData.category_id).stringValue);
        }
    } else {
        if (self.themeRecommendBlock) {
            self.themeRecommendBlock(self.themeArray[indexPath.row]);
        }
    }
}

- (void)setTopicData:(Model_arts_topic_Data *)topicData {
    _topicData = topicData;
    
    if (![NSString stringIsEmpty:topicData.app_img_file[@"url"]]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:topicData.app_img_file[@"url"]]];
    }
    if (![NSString stringIsEmpty:topicData.title]) {
        self.titleLabel.text = topicData.title;
    }
    self.themeArray = topicData.arts;
    [self.collectionView reloadData];
}

@end
