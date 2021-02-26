//
//  JLAuctionDetailProductView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/18.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLAuctionDetailProductView.h"
#import "JLPopularOriginalCollectionViewCell.h"

@interface JLAuctionDetailProductView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *auctionArtList;
@end

@implementation JLAuctionDetailProductView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.titleView];
    [self addSubview:self.collectionView];
    [self.collectionView  registerClass:[JLPopularOriginalCollectionViewCell class] forCellWithReuseIdentifier:@"JLPopularOriginalCollectionViewCell"];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(66.0f);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0.0f);
    }];
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = JL_color_white_ffffff;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = kFontPingFangSCSCSemibold(17.0f);
        titleLabel.textColor = JL_color_gray_101010;
        titleLabel.text = @"全部作品";
        [_titleView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16.0f);
            make.centerY.equalTo(_titleView.mas_centerY);
        }];

        [_titleView addSubview:self.numLabel];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-16.0f);
            make.centerY.equalTo(_titleView.mas_centerY);
        }];
    }
    return _titleView;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [JLUIFactory labelInitText:@"总计0件" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_999999 textAlignment:NSTextAlignmentRight];
    }
    return _numLabel;
}

#pragma mark - 懒加载
-(UICollectionView*)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((kScreenWidth - 15.0f * 2 - 26.0f) * 0.5f, 250.0f);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 0.0f;
        flowLayout.minimumInteritemSpacing = 26.0f;
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.auctionArtList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JLPopularOriginalCollectionViewCell *cell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"JLPopularOriginalCollectionViewCell" forIndexPath:indexPath];
    cell.artsData = self.auctionArtList[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.artDetailBlock) {
        self.artDetailBlock(self.auctionArtList[indexPath.row]);
    }
}

- (void)setAuctionMeetingData:(Model_auction_meetings_Data *)auctionMeetingData auctionArtList:(NSArray *)auctionArtList {
    self.numLabel.text = [NSString stringWithFormat:@"总计%ld件", auctionMeetingData.art_size];
    self.auctionArtList = auctionArtList;
    [self.collectionView reloadData];
}
@end
