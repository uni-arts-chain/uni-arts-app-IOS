//
//  JLPopularOriginalView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/25.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLPopularOriginalView.h"
#import "JLPopularOriginalCollectionViewCell.h"
#import "JLPopularCollectionWaterLayout.h"

@interface JLPopularOriginalView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray *waterDataArray;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation JLPopularOriginalView
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
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(80.0f);
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
        titleLabel.font = kFontPingFangSCSCSemibold(19.0f);
        titleLabel.textColor = JL_color_gray_101010;
        titleLabel.text = @"热门原创";
        [_titleView addSubview:titleLabel];
        
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

#pragma mark - 懒加载
-(UICollectionView*)collectionView {
    if (!_collectionView) {
        JLPopularCollectionWaterLayout *layout = [JLPopularCollectionWaterLayout layoutWithColoumn:2 data:self.waterDataArray verticleMin:14.0f horizonMin:14.0f leftMargin:15.0f rightMargin:15.0f];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, 80.0f, kScreenWidth, self.frameHeight - 80.0f) collectionViewLayout:layout];
        _collectionView.backgroundColor = JL_color_white_ffffff;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[JLPopularOriginalCollectionViewCell class] forCellWithReuseIdentifier:@"JLPopularOriginalCollectionViewCell"];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.waterDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JLPopularOriginalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JLPopularOriginalCollectionViewCell" forIndexPath:indexPath];
    cell.popularArtData = self.waterDataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.artDetailBlock) {
        self.artDetailBlock(self.waterDataArray[indexPath.row]);
    }
}

#pragma mark - private methods
- (void)handleTimer {
        
    for (int i = 0; i < self.waterDataArray.count; i++) {
        Model_art_Detail_Data *model = self.waterDataArray[i];
        model.server_time = model.server_time + 1;
    }
    [self.collectionView reloadData];
}

- (void)setPopularArray:(NSArray *)popularArray {
    [self.waterDataArray removeAllObjects];
    [self.waterDataArray addObjectsFromArray:popularArray];
    [self.collectionView reloadData];
    
    for (int i = 0; i < self.waterDataArray.count; i++) {
        Model_art_Detail_Data *model = self.waterDataArray[i];
        model.auction_start_time = @"2021-7-22 12:00:00";
        model.auction_end_time = @"2021-7-29 12:00:00";
        if (i == 0) {
            model.server_time = 1626919200;// 2021-07-22 10:00:00
        }else {
            model.server_time = 1627351200;// 2021-7-27 10:00:00
        }
    }
    
    /// 是否有拍卖作品 有启动定时器
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    WS(weakSelf)
    self.timer = [NSTimer jl_scheduledTimerWithTimeInterval:1.0 block:^{
        [weakSelf handleTimer];
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

- (NSMutableArray *)waterDataArray {
    if (!_waterDataArray) {
        _waterDataArray = [NSMutableArray array];
    }
    return _waterDataArray;
}

- (void)refreshFrame:(CGRect)frame {
    self.collectionView.frame = CGRectMake(0.0f, 80.0f, kScreenWidth, frame.size.height - 80.0f);
}

- (void)dealloc
{
    NSLog(@"释放了: %@", self.class);
}
@end
