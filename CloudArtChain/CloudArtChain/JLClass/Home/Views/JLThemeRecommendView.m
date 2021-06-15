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
        self.backgroundColor = JL_color_white_ffffff;
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
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(80.0f);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.titleView.mas_bottom);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(115.0f);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.imageView.mas_bottom).offset(15.0f);
        make.bottom.equalTo(self);
    }];
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = JL_color_white_ffffff;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = kFontPingFangSCSCSemibold(19.0f);
        titleLabel.textColor = JL_color_gray_101010;
        titleLabel.text = @"主题";
        [_titleView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIView *leftLineView = [[UIView alloc] init];
        leftLineView.backgroundColor = JL_color_black;
        [_titleView addSubview:leftLineView];
        
        UIView *rightLineView = [[UIView alloc] init];
        rightLineView.backgroundColor = JL_color_black;
        [_titleView addSubview:rightLineView];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_titleView);
            make.centerX.equalTo(_titleView.mas_centerX);
        }];
        [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(21.0f);
            make.height.mas_equalTo(2.0f);
            make.right.mas_equalTo(titleLabel.mas_left).offset(-13.0f);
            make.centerY.mas_equalTo(_titleView.mas_centerY);
        }];
        [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(21.0f);
            make.height.mas_equalTo(2.0f);
            make.left.mas_equalTo(titleLabel.mas_right).offset(13.0f);
            make.centerY.mas_equalTo(_titleView.mas_centerY);
        }];
    }
    return _titleView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        ViewBorderRadius(_imageView, 5.0f, 0.0f, JL_color_clear);
    }
    return _imageView;
}

#pragma mark - 懒加载
-(UICollectionView*)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((kScreenWidth - 15.0f * 2 - 10.0f * 3) / 3.2f, 187.0f);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 10.0f;
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
    JLThemeRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JLThemeRecommendCollectionViewCell" forIndexPath:indexPath];
    [cell setThemeArtData:self.themeArray[indexPath.row] totalCount:self.themeArray.count index:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.themeArray.count - 1) {
        if (self.seeMoreBlock) {
            self.seeMoreBlock();
        }
    } else {
        if (self.themeRecommendBlock) {
            self.themeRecommendBlock(self.themeArray[indexPath.row]);
        }
    }
}

- (void)setTopicData:(Model_arts_topic_Data *)topicData {
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
