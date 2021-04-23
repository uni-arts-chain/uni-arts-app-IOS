//
//  JLBoxDetailViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/20.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBoxDetailViewController.h"
#import "JLBoxOpenRecordViewController.h"
#import "JLBoxOpenPayViewController.h"
#import "LewPopupViewController.h"
#import "JLHomePageViewController.h"

#import "JLBoxDetailCardCollectionWaterLayout.h"
#import "JLBoxCardCollectionViewCell.h"
//#import "JLBoxOneCardView.h"
#import "JLBoxTenCardView.h"

@interface JLBoxDetailViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIButton *oneTimeButton;
@property (nonatomic, strong) UIButton *tenTimeButton;
@property (nonatomic, strong) UILabel *cardTitleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *ruleTitleLabel;
@property (nonatomic, strong) UILabel *ruleDescLabel;
@property (nonatomic, strong) UIImageView *footerImageView;

@property (nonatomic, strong) NSMutableArray *boxCardArray;
@end

@implementation JLBoxDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"哈利·波特与凤凰社";
    [self addBackItem];
    [self addRightBarButton];
    [self createSubViews];
    
    // 请求盲盒详情
    [self requestBoxDetail];
}

- (void)addRightBarButton {
    NSString *title = @"开启记录";
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(openRecordClick)];
    NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_212121, NSFontAttributeName: kFontPingFangSCRegular(15.0f)};
    [rightBarButtonItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    [rightBarButtonItem setTitleTextAttributes:dic forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)openRecordClick {
    JLBoxOpenRecordViewController *boxOpenRecordVC = [[JLBoxOpenRecordViewController alloc] init];
    [self.navigationController pushViewController:boxOpenRecordVC animated:YES];
}

- (void)createSubViews {
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.mas_equalTo(kScreenWidth);
    }];
    
    [self.scrollView addSubview:self.headerImageView];
    [self.scrollView addSubview:self.nameLabel];
    [self.scrollView addSubview:self.detailLabel];
    [self.scrollView addSubview:self.oneTimeButton];
    [self.scrollView addSubview:self.tenTimeButton];
    [self.scrollView addSubview:self.cardTitleLabel];
    [self.scrollView addSubview:self.collectionView];
    [self.scrollView addSubview:self.ruleTitleLabel];
    [self.scrollView addSubview:self.ruleDescLabel];
    [self.scrollView addSubview:self.footerImageView];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.scrollView);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(230.0f);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.headerImageView.mas_bottom);
        make.height.mas_equalTo(60.0f);
        make.width.mas_equalTo(kScreenWidth - 15.0f * 2);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18.0f);
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.width.mas_equalTo(kScreenWidth - 18.0f * 2);
    }];
    [self.oneTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(30.0f);
        make.height.mas_equalTo(43.0f);
        make.width.mas_equalTo((kScreenWidth - 20.0f * 2 - 14.0f) * 0.5f);
    }];
    [self.tenTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.oneTimeButton.mas_right).offset(14.0f);
        make.top.equalTo(self.oneTimeButton.mas_top);
        make.width.height.equalTo(self.oneTimeButton);
    }];
    [self.cardTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.oneTimeButton.mas_bottom).offset(15.0f);
        make.height.mas_equalTo(50.0f);
        make.width.mas_equalTo(kScreenWidth - 15.0f * 2);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0.0f);
        make.top.equalTo(self.cardTitleLabel.mas_bottom);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(0.0f);
    }];
    [self.ruleTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.collectionView.mas_bottom).offset(15.0f);
        make.width.mas_equalTo(kScreenWidth - 15.0f * 2);
        make.height.mas_equalTo(35.0f);
    }];
    [self.ruleDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.ruleTitleLabel.mas_bottom).offset(15.0f);
        make.width.mas_equalTo(kScreenWidth - 15.0f * 2);
    }];
    [self.footerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.ruleDescLabel.mas_bottom).offset(20.0f);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(73.0f);
        make.bottom.equalTo(self.scrollView);
    }];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = JL_color_gray_101010;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.backgroundColor = [UIColor randomColor];
    }
    return _headerImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [JLUIFactory labelInitText:@"哈利·波特与凤凰社盲盒" font:kFontPingFangSCMedium(18.0f) textColor:JL_color_white_ffffff textAlignment:NSTextAlignmentCenter];
    }
    return _nameLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [JLUIFactory labelInitText:@"哈利波特与凤凰社盲盒内含59位电影人物，开启一次将随机获得一位NFT所有权，可用于收藏或转卖" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_BEBEBE textAlignment:NSTextAlignmentCenter];
    }
    return _detailLabel;
}

- (UIButton *)oneTimeButton {
    if (!_oneTimeButton) {
        _oneTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_oneTimeButton setTitle:@"开启 x1" forState:UIControlStateNormal];
        [_oneTimeButton setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _oneTimeButton.titleLabel.font = kFontPingFangSCMedium(15.0f);
        [_oneTimeButton setBackgroundImage:[UIImage imageNamed:@"icon_box_one_time"] forState:UIControlStateNormal];
        [_oneTimeButton addTarget:self action:@selector(oneTimeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _oneTimeButton;
}

- (void)oneTimeButtonClick {
    WS(weakSelf)
    JLBoxTenCardView *boxTenCardView = [[JLBoxTenCardView alloc] initWithFrame:CGRectMake(0, 0, 295.0f, 490.0f)];
    boxTenCardView.closeBlock = ^{
        [weakSelf lew_dismissPopupView];
    };
    boxTenCardView.homepageBlock = ^{
        JLHomePageViewController *homePageVC = [[JLHomePageViewController alloc] init];
        [weakSelf.navigationController pushViewController:homePageVC animated:YES];
        [weakSelf lew_dismissPopupViewWithanimation:nil];
    };
    boxTenCardView.center = self.view.window.center;
    ViewBorderRadius(boxTenCardView, 5.0f, 0.0f, JL_color_clear);
    LewPopupViewAnimationSpring *animation = [[LewPopupViewAnimationSpring alloc] init];
    [self lew_presentPopupView:boxTenCardView animation:animation backgroundClickable:NO dismissed:^{
       NSLog(@"动画结束");
    }];
}

- (UIButton *)tenTimeButton {
    if (!_tenTimeButton) {
        _tenTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tenTimeButton setTitle:@"开启10次" forState:UIControlStateNormal];
        [_tenTimeButton setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _tenTimeButton.titleLabel.font = kFontPingFangSCMedium(15.0f);
        [_tenTimeButton setBackgroundImage:[UIImage imageNamed:@"icon_box_ten_time"] forState:UIControlStateNormal];
        [_tenTimeButton addTarget:self action:@selector(tenTimeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tenTimeButton;
}

- (void)tenTimeButtonClick {
    JLBoxOpenPayViewController *boxOpenPayVC = [[JLBoxOpenPayViewController alloc] init];
    [self.navigationController pushViewController:boxOpenPayVC animated:YES];
}

- (UILabel *)cardTitleLabel {
    if (!_cardTitleLabel) {
        _cardTitleLabel = [JLUIFactory labelInitText:@"可能获得" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_999999 textAlignment:NSTextAlignmentLeft];
    }
    return _cardTitleLabel;
}

- (UILabel *)ruleTitleLabel {
    if (!_ruleTitleLabel) {
        _ruleTitleLabel = [JLUIFactory labelInitText:@"规则说明：" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_BEBEBE textAlignment:NSTextAlignmentLeft];
    }
    return _ruleTitleLabel;
}

- (UILabel *)ruleDescLabel {
    if (!_ruleDescLabel) {
        _ruleDescLabel = [JLUIFactory labelInitText:@"1. 哈利波特与凤凰社盲盒内含59位电影人物，开启一次将随机获得一位NFT所有权。 \r\n2. 哈利波特与凤凰社盲盒内含59位电影人物，开启一次将随机获得一张卡片。 \r\n3. 哈利波特与凤凰社盲盒内含59位电影人物，开启一次将随机获得一位NFT所有权，可用于收藏。 \r\n4. 哈利波特与凤凰社盲盒内含59位电影人物，开启一次将随机获得一位NFT所有权，可用于收藏或转卖。" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_BEBEBE textAlignment:NSTextAlignmentLeft];
    }
    return _ruleDescLabel;
}

- (UIImageView *)footerImageView {
    if (!_footerImageView) {
        _footerImageView = [[UIImageView alloc] init];
        _footerImageView.backgroundColor = [UIColor randomColor];
    }
    return _footerImageView;
}

-(UICollectionView*)collectionView {
    if (!_collectionView) {
        JLBoxDetailCardCollectionWaterLayout *layout = [JLBoxDetailCardCollectionWaterLayout layoutWithColoumn:2 data:self.boxCardArray verticleMin:14.0f horizonMin:14.0f leftMargin:15.0f rightMargin:15.0f];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, self.cardTitleLabel.frameBottom, kScreenWidth, 0.0f) collectionViewLayout:layout];
        _collectionView.backgroundColor = JL_color_clear;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[JLBoxCardCollectionViewCell class] forCellWithReuseIdentifier:@"JLBoxCardCollectionViewCell"];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.boxCardArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JLBoxCardCollectionViewCell *cell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"JLBoxCardCollectionViewCell" forIndexPath:indexPath];
    cell.artDetailData = self.boxCardArray[indexPath.row];
    return cell;
}

- (NSMutableArray *)boxCardArray {
    if (!_boxCardArray) {
        _boxCardArray = [NSMutableArray array];
    }
    return _boxCardArray;
}

- (void)requestBoxDetail {
    WS(weakSelf)
    Model_arts_selling_Req *request = [[Model_arts_selling_Req alloc] init];
    request.page = 1;
    request.per_page = kPageSize;
    Model_arts_selling_Rsp *response = [[Model_arts_selling_Rsp alloc] init];
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            [weakSelf.boxCardArray removeAllObjects];
            [weakSelf.boxCardArray addObjectsFromArray:response.body];
            [weakSelf.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo([self getCollectionHeight]);
            }];
            [weakSelf.scrollView layoutIfNeeded];
            [self.collectionView reloadData];
        }
    }];
}

- (CGFloat)getCollectionHeight {
    CGFloat columnFirstHeight = 0.0f;
    CGFloat columnSecondHeight = 0.0f;
    CGFloat itemW = (kScreenWidth - 15.0f * 2 - 14.0f) / 2;
    for (int i = 0; i < self.boxCardArray.count; i++) {
        Model_art_Detail_Data *iconModel = self.boxCardArray[i];
        //计算每个cell的高度
        float itemH = [self getcellHWithOriginSize:CGSizeMake(itemW, iconModel.imgHeight) itemW:itemW] + 14.0f;
        if (columnFirstHeight <= columnSecondHeight) {
            columnFirstHeight += itemH;
        } else {
            columnSecondHeight += itemH;
        }
    }
    return MAX(columnFirstHeight, columnSecondHeight);
}

//计算cell的高度
- (float)getcellHWithOriginSize:(CGSize)originSize itemW:(float)itemW {
    return itemW * originSize.height / originSize.width;
}

@end
