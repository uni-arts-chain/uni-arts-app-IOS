//
//  WMPhotoBrowser.m
//  WMPhotoBrowser
//
//  Created by zhengwenming on 2018/1/2.
//  Copyright © 2018年 zhengwenming. All rights reserved.
//

#import "WMPhotoBrowser.h"
#import "WMPhotoBrowserCell.h"
#import "UIAlertController+Alert.h"

@interface WMPhotoBrowser ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
@property(nonatomic, assign) BOOL isHideNaviBar;
@property(nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *indexLabel;
@end

@implementation WMPhotoBrowser

- (instancetype)init{
    self = [super init];
    if (self) {
        if (@available(ios 11.0, *)) {
            UITableView.appearance.estimatedRowHeight = 0;
            UITableView.appearance.estimatedSectionFooterHeight = 0;
            UITableView.appearance.estimatedSectionHeaderHeight = 0;
        } else {
            if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
//                self.automaticallyAdjustsScrollViewInsets = NO;
            }
        }
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    } else {

    }
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollsToTop = NO;
        [_collectionView registerClass:[WMPhotoBrowserCell class] forCellWithReuseIdentifier:@"WMPhotoBrowserCell"];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentOffset = CGPointZero;
        _collectionView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * self.dataSource.count, [UIScreen mainScreen].bounds.size.height);
    }
    return _collectionView;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake(26.0f, KStatus_Bar_Height + 12.0f, 20.0f, 20.0f);
        [_closeBtn setImage:[UIImage imageNamed:@"icon_home_artdetail_photo_browser_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UILabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_white_ffffff textAlignment:NSTextAlignmentCenter];
    }
    return _indexLabel;
}

#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.title ? self.title : [NSString stringWithFormat:@"%ld/%ld", self.currentPhotoIndex + 1, self.dataSource.count];
    self.indexLabel.text = self.title;
    self.view.backgroundColor = [UIColor blackColor];
    self.isHideNaviBar = NO;
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.indexLabel];
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(-KTouch_Responder_Height - 26.0f);
    }];
    
    if (self.dataSource.count) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:(self.currentPhotoIndex) inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    } else {
        [self.dataSource addObject:[UIImage imageNamed:@"application_Defaultpicture"]];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:(self.currentPhotoIndex) inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.title isEqualToString:@"图片预览"]) {
        
    } else {
        CGPoint offSet = scrollView.contentOffset;
        self.currentPhotoIndex = (offSet.x + self.view.width / 2) / self.view.width;
        self.title = [NSString stringWithFormat:@"%ld/%ld", self.currentPhotoIndex + 1, self.dataSource.count];
        self.indexLabel.text = self.title;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

#pragma mark - UICollectionViewDataSource && Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    WMPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMPhotoBrowserCell" forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    cell.currentIndexPath = indexPath;
    self.title = [NSString stringWithFormat:@"%ld/%ld",self.currentPhotoIndex + 1, self.dataSource.count];
    self.indexLabel.text = self.title;
    if (!cell.longPressGestureBlock) {
        cell.longPressGestureBlock = ^(NSIndexPath *pressIndexPath) {
//            [weakSelf longPressGRActionWithIndexPath:pressIndexPath];
        };
    }
    return cell;
}

//长按保存图片
- (void)longPressGRActionWithIndexPath:(NSIndexPath *)indexPath {
    NSString *saveLocalAlbumTitle = @"保存到手机";
    NSMutableArray *operationTitleArray = [NSMutableArray array];
    WS(weakSelf)
    [operationTitleArray addObject:saveLocalAlbumTitle];
    
    UIAlertController *alert = [UIAlertController actionSheetWithButtonTitleArray:[operationTitleArray copy] handler:^(NSInteger index) {
        if (index == 0) {
            //保存到手机
            if (![JLTool checkPhotoAuthorizationWithController:self]) {
                return;
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:weakSelf.currentPhotoIndex inSection:0];
            WMPhotoBrowserCell *cell = (WMPhotoBrowserCell *)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];
            UIImageWriteToSavedPhotosAlbum(cell.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if(error){
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"图片保存失败" hideTime:KToastDismissDelayTimeInterval];
    }else{
        [[JLLoading sharedLoading] showMBSuccessTipMessage:@"已保存到手机" hideTime:KToastDismissDelayTimeInterval];
    }
}

- (void)backClick {
    if (self.navigationController) {
        if (self.isHideNaviBar == YES) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        } else {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
        self.isHideNaviBar = !self.isHideNaviBar;
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

