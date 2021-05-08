//
//  JLCreatorTableViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/25.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLCreatorTableViewCell.h"
#import "JLCreatorWorksCollectionViewCell.h"
#import "JLAuctionArtDetailViewController.h"

#import "JLArtDetailViewController.h"
#import "JLCreatorPageViewController.h"

@interface JLCreatorTableViewCell()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UIView *authorInfoView;
@property (nonatomic, strong) UIView *authorAvatarView;
@property (nonatomic, strong) UIImageView *authorAvatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *worksLabel;
@property (nonatomic, strong) UIButton *authorInfoDetailBtn;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *artsArray;
@end

@implementation JLCreatorTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.authorInfoView];
    
    [self.authorInfoView addSubview:self.authorAvatarView];
    [self.authorAvatarView addSubview:self.authorAvatarImageView];
    [self.authorInfoView addSubview:self.nameLabel];
    [self.authorInfoView addSubview:self.infoLabel];
    [self.authorInfoView addSubview:self.worksLabel];
    [self.authorInfoView addSubview:self.authorInfoDetailBtn];
    
    [self.contentView addSubview:self.collectionView];
    [self.collectionView  registerClass:[JLCreatorWorksCollectionViewCell class] forCellWithReuseIdentifier:@"JLCreatorWorksCollectionViewCell"];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = JL_color_gray_E6E6E6;
    [self.contentView addSubview:lineView];
    
    [self.authorInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(self.contentView).offset(24.0f);
        make.height.mas_equalTo(44.0f);
    }];
    [self.authorAvatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0.0f);
        make.top.bottom.equalTo(self.authorInfoView);
        make.width.mas_equalTo(44.0f);
    }];
    [self.authorAvatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.authorAvatarView).insets(UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.authorInfoView);
        make.left.equalTo(self.authorAvatarImageView.mas_right).offset(13.0f);
        make.height.mas_equalTo(22.0f);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.left.equalTo(self.nameLabel);
        make.height.mas_equalTo(22.0f);
    }];
    [self.worksLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.authorInfoView);
        make.centerY.equalTo(self.infoLabel.mas_centerY);
        make.left.equalTo(self.infoLabel.mas_right).offset(10.0f);
    }];
    [self.authorInfoDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.authorInfoView);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.authorInfoView.mas_bottom).offset(20.0f);
        make.bottom.mas_equalTo(-30.0f);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.bottom.equalTo(self.contentView);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(1.0f);
    }];
}

- (UIView *)authorInfoView {
    if (!_authorInfoView) {
        _authorInfoView = [[UIView alloc] init];
    }
    return _authorInfoView;
}

- (UIView *)authorAvatarView {
    if (!_authorAvatarView) {
        _authorAvatarView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f)];
        _authorAvatarView.backgroundColor = JL_color_white_ffffff;
        _authorAvatarView.layer.cornerRadius = 22.0f;
        _authorAvatarView.layer.masksToBounds = NO;
        _authorAvatarView.layer.shadowColor = JL_color_black.CGColor;
        _authorAvatarView.layer.shadowOpacity = 0.13f;
        _authorAvatarView.layer.shadowOffset = CGSizeZero;
        _authorAvatarView.layer.shadowRadius = 5.0f;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:_authorAvatarView.bounds];
        _authorAvatarView.layer.shadowPath = path.CGPath;
    }
    return _authorAvatarView;
}

- (UIImageView *)authorAvatarImageView {
    if (!_authorAvatarImageView) {
        _authorAvatarImageView = [[UIImageView alloc] init];
        ViewBorderRadius(_authorAvatarImageView, 20.0f, 0.0f, JL_color_clear);
    }
    return _authorAvatarImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = kFontPingFangSCSCSemibold(15.0f);
        _nameLabel.textColor = JL_color_gray_101010;
    }
    return _nameLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.font = kFontPingFangSCRegular(13.0f);
        _infoLabel.textColor = JL_color_gray_101010;
    }
    return _infoLabel;
}

- (UILabel *)worksLabel {
    if (!_worksLabel) {
        _worksLabel = [[UILabel alloc] init];
        _worksLabel.font = kFontPingFangSCRegular(13.0f);
        _worksLabel.textColor = JL_color_gray_909090;
        _worksLabel.textAlignment = NSTextAlignmentRight;
    }
    return _worksLabel;
}

- (UIButton *)authorInfoDetailBtn {
    if (!_authorInfoDetailBtn) {
        _authorInfoDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_authorInfoDetailBtn addTarget:self action:@selector(authorInfoDetailBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _authorInfoDetailBtn;
}

- (void)authorInfoDetailBtnClick {
    WS(weakSelf)
    JLCreatorPageViewController *creatorPageVC = [[JLCreatorPageViewController alloc] init];
    creatorPageVC.authorData = self.preTopicData.member;
    creatorPageVC.backBlock = ^(Model_art_author_Data * _Nonnull authorData) {
        weakSelf.preTopicData.member = authorData;
    };
    [self.viewController.navigationController pushViewController:creatorPageVC animated:YES];
}

#pragma mark - 懒加载
-(UICollectionView*)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((kScreenWidth - 15.0f - 22.0f * 2) / 2.5f, 197.0f);
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
    return self.artsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JLCreatorWorksCollectionViewCell *cell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"JLCreatorWorksCollectionViewCell" forIndexPath:indexPath];
    cell.detailData = self.artsArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Model_art_Detail_Data *artDetailData = self.artsArray[indexPath.row];
    if ([artDetailData.aasm_state isEqualToString:@"auctioning"]) {
        // 拍卖中
        JLAuctionArtDetailViewController *auctionDetailVC = [[JLAuctionArtDetailViewController alloc] init];
        auctionDetailVC.artDetailType = artDetailData.is_owner ? JLAuctionArtDetailTypeSelf : JLAuctionArtDetailTypeDetail;
        Model_auction_meetings_arts_Data *meetingsArtsData = [[Model_auction_meetings_arts_Data alloc] init];
        meetingsArtsData.art = artDetailData;
        auctionDetailVC.artsData = meetingsArtsData;
        [self.viewController.navigationController pushViewController:auctionDetailVC animated:YES];
    } else {
        JLArtDetailViewController *artDetailVC = [[JLArtDetailViewController alloc] init];
        artDetailVC.artDetailType = artDetailData.is_owner ? JLArtDetailTypeSelfOrOffShelf : JLArtDetailTypeDetail;
        artDetailVC.artDetailData = artDetailData;
        [self.viewController.navigationController pushViewController:artDetailVC animated:YES];
    }
}

- (void)setPreTopicData:(Model_members_pre_artist_topic_Data *)preTopicData {
    _preTopicData = preTopicData;
    if ([NSString stringIsEmpty:preTopicData.member.avatar[@"url"]]) {
        self.authorAvatarImageView.image = [UIImage imageNamed:@"icon_mine_avatar_placeholder"];
    } else {
        [self.authorAvatarImageView sd_setImageWithURL:[NSURL URLWithString:preTopicData.member.avatar[@"url"]] placeholderImage:[UIImage imageNamed:@"icon_mine_avatar_placeholder"]];
    }
    self.nameLabel.text = [NSString stringIsEmpty:preTopicData.member.display_name] ? @"" : preTopicData.member.display_name;
    self.worksLabel.text = [NSString stringWithFormat:@"作品 %ld", preTopicData.member.art_size];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_worksLabel.text];
    [attr addAttributes:@{NSForegroundColorAttributeName: JL_color_gray_101010} range:NSMakeRange(3, _worksLabel.text.length - 3)];
    self.worksLabel.attributedText = attr;
 
    self.infoLabel.text = [NSString stringIsEmpty:preTopicData.member.desc] ? @"" : preTopicData.member.desc;
    
    self.artsArray = preTopicData.arts;
    [self.collectionView reloadData];
}

@end
