//
//  JLUploadWorkViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/17.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLUploadWorkViewController.h"

#import "JLUploadWorkSampleView.h"
#import "JLUploadWorkImageView.h"
#import "JLUploadWorkInputWithBorderView.h"
#import "JLUploadWorkSelectView.h"
#import "JLUploadWorkMultiInputView.h"
#import "JLUploadWorkDescriptionView.h"
#import "JLUploadWorkDetailView.h"
#import "JLUploadWorkMoneyInputView.h"
#import "JLDatePicker.h"
#import "JLPickerView.h"
#import "JLUploadWorkSwitchView.h"
#import "JLUploadPersentInputView.h"

#import "NSDate+Extension.h"
#import "UIAlertController+Alert.h"
#import "UIImage+JLTool.h"


@interface JLUploadWorkViewController ()
@property (nonatomic, strong) UIView *noticeView;

@property (nonatomic, strong) UIScrollView *scrollView;
// 示例
@property (nonatomic, strong) JLUploadWorkSampleView *uploadWorkSampleView;
// 上传三张作品图片
@property (nonatomic, strong) UILabel *uploadImageTitleLabel;
@property (nonatomic, strong) JLUploadWorkImageView *uploadImageView;
// 作品标题
@property (nonatomic, strong) UILabel *workTitleLabel;
@property (nonatomic, strong) JLUploadWorkInputWithBorderView *workTitleView;
// 作品主题
@property (nonatomic, strong) JLUploadWorkSelectView *themeView;
// 作品详情
@property (nonatomic, strong) UILabel *workDetailTitleLabel;
@property (nonatomic, strong) JLUploadWorkDescriptionView *workDetailView;
// 作品图片
@property (nonatomic, strong) UILabel *workDetailImageTitleLabel;
@property (nonatomic, strong) JLUploadWorkImageView *workDetailUploadImageView;
// 作品是否拆分
@property (nonatomic, strong) JLUploadWorkSwitchView *workSplitSwitchView;
// 作品拆分数量
@property (nonatomic, strong) JLUploadWorkSelectView *splitNumView;
// 价格信息
@property (nonatomic, strong) JLUploadWorkMoneyInputView *priceView;
// 版税比例
@property (nonatomic, strong) JLUploadPersentInputView *royaltyView;
// 版税有效期
@property (nonatomic, strong) JLUploadWorkSelectView *royaltyDateView;
@property (nonatomic, strong) NSDate *royaltyDate;

// 确认上传
@property (nonatomic, strong) UIButton *confirmUploadBtn;

// 主题
@property (nonatomic, strong) NSArray *tempThemeArray;
@property (nonatomic, assign) NSInteger currentSelectedThemeIndex;
@property (nonatomic, strong) Model_arts_theme_Data *currentSelectedThemeData;
// 作品是否拆分
@property (nonatomic, assign) BOOL workSplit;
// 拆分数量
@property (nonatomic, strong) NSArray *tempSplitNumArray;
@property (nonatomic, assign) NSInteger currentSelectedSplitNumIndex;
@end

@implementation JLUploadWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"上传作品";
    [self addBackItem];
    [self createView];
    [self refreshThemeArray];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(live2dSnapshotNotification:) name:@"JLLive2dSnapshotNotification" object:nil];
}

- (void)backClick {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"JLLive2dSnapshotNotification" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)live2dSnapshotNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    UIImage *snapshotImage = userInfo[@"snapshot"];
    
    [self.uploadImageView addLive2dSnapshotImage:snapshotImage];
}

- (void)createView {
    [self.view addSubview:self.noticeView];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.confirmUploadBtn];
    
    [self.noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(36.0f);
    }];
    [self.confirmUploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(44.0f + KTouch_Responder_Height);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.noticeView.mas_bottom);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.confirmUploadBtn.mas_top);
        make.width.mas_equalTo(kScreenWidth);
    }];
    // 示例作品
    [self.scrollView addSubview:self.uploadWorkSampleView];
    // 作品标题
    [self.scrollView addSubview:self.workTitleLabel];
    [self.scrollView addSubview:self.workTitleView];
    // 作品
    [self.scrollView addSubview:self.uploadImageView];
    // 详情
    [self.scrollView addSubview:self.workDetailView];
    // 详情图片
    [self.scrollView addSubview:self.workDetailUploadImageView];
    // 主题
    [self.scrollView addSubview:self.themeView];
    // 是否拆分
    [self.scrollView addSubview:self.workSplitSwitchView];
    // 拆分数量
    [self.scrollView addSubview:self.splitNumView];
    // 每份价格
    [self.scrollView addSubview:self.priceView];
    // 版税比例
    [self.scrollView addSubview:self.royaltyView];
    // 版税有效期
    [self.scrollView addSubview:self.royaltyDateView];
    
    [self.uploadWorkSampleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(@180);
    }];
    [self.workTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.uploadWorkSampleView.mas_bottom);
        make.height.mas_equalTo(38.0f);
        make.width.mas_equalTo(kScreenWidth);
    }];
    [self.workTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.workTitleLabel.mas_bottom);
        make.height.mas_equalTo(45.0f);
        make.width.mas_equalTo(kScreenWidth);
    }];
    [self.uploadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.workTitleView.mas_bottom);
        make.height.mas_equalTo(145);
        make.width.mas_equalTo(kScreenWidth);
    }];
    [self.workDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.uploadImageView.mas_bottom);
        make.height.mas_equalTo(140.0f);
        make.width.mas_equalTo(kScreenWidth);
    }];
    [self.workDetailUploadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.workDetailView.mas_bottom);
        make.height.mas_equalTo(145);
        make.width.mas_equalTo(kScreenWidth);
    }];
    [self.themeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.workDetailUploadImageView.mas_bottom).offset(12.0f);
        make.height.mas_equalTo(54.0f);
        make.width.mas_equalTo(kScreenWidth);
    }];
    [self.workSplitSwitchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView);
        make.top.equalTo(self.themeView.mas_bottom);
        make.height.mas_equalTo(54.0f);
        make.width.mas_equalTo(kScreenWidth);
    }];
    [self.splitNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView);
        make.top.equalTo(self.workSplitSwitchView.mas_bottom);
        make.height.mas_equalTo(20.0f);
        make.width.mas_equalTo(kScreenWidth);
    }];
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView);
        make.top.equalTo(self.workSplitSwitchView.mas_bottom);
        make.height.mas_equalTo(54.0f);
        make.width.mas_equalTo(kScreenWidth);
    }];
    [self.royaltyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView);
        make.top.equalTo(self.priceView.mas_bottom);
        make.height.mas_equalTo(54.0f);
        make.width.mas_equalTo(kScreenWidth);
    }];
    [self.royaltyDateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView);
        make.top.equalTo(self.royaltyView.mas_bottom);
        make.height.mas_equalTo(54.0f);
        make.width.mas_equalTo(kScreenWidth);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.royaltyDateView.frameBottom + 50.0f);
}

- (UIView *)noticeView {
    if (!_noticeView) {
        _noticeView = [[UIView alloc] init];
        _noticeView.backgroundColor = JL_color_white_ffffff;
        
        UILabel *noticeLabel = [JLUIFactory labelInitText:@"注意：信息通过审核后无法修改，请谨慎操作" font:kFontPingFangSCRegular(12.0f) textColor:JL_color_mainColor textAlignment:NSTextAlignmentCenter];
        [_noticeView addSubview:noticeLabel];
        [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_noticeView);
        }];
    }
    return _noticeView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (JLUploadWorkSampleView *)uploadWorkSampleView {
    if (!_uploadWorkSampleView) {
        _uploadWorkSampleView = [[JLUploadWorkSampleView alloc] init];
    }
    return _uploadWorkSampleView;
}

- (UILabel *)uploadImageTitleLabel {
    if (!_uploadImageTitleLabel) {
        _uploadImageTitleLabel = [JLUIFactory labelInitText:@"上传三张作品高清图" font:kFontPingFangSCMedium(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _uploadImageTitleLabel;
}

- (JLUploadWorkImageView *)uploadImageView {
    if (!_uploadImageView) {
        WS(weakSelf)
        _uploadImageView = [[JLUploadWorkImageView alloc] init];
        _uploadImageView.controller = weakSelf;
    }
    return _uploadImageView;
}

- (UILabel *)workTitleLabel {
    if (!_workTitleLabel) {
        _workTitleLabel = [JLUIFactory labelInitText:@"上传作品信息" font:kFontPingFangSCSCSemibold(15.0f) textColor:JL_color_black_101220 textAlignment:NSTextAlignmentLeft];
        _workTitleLabel.backgroundColor = JL_color_white_ffffff;
        _workTitleLabel.jl_contentInsets = UIEdgeInsetsMake(0, 26, 0, 0);
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = JL_color_mainColor;
        lineView.layer.cornerRadius = 2;
        [_workTitleLabel addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_workTitleLabel).offset(14);
            make.centerY.equalTo(_workTitleLabel);
            make.size.mas_equalTo(CGSizeMake(4, 15));
        }];
    }
    return _workTitleLabel;
}

- (JLUploadWorkInputWithBorderView *)workTitleView {
    if (!_workTitleView) {
        WS(weakSelf)
        _workTitleView = [[JLUploadWorkInputWithBorderView alloc] initWithMaxInput:20 placeholder:@"请输入作品标题"];
        _workTitleView.inputContentChangeBlock = ^{
            [weakSelf checkUpload];
        };
    }
    return _workTitleView;
}

- (JLUploadWorkSelectView *)themeView {
    if (!_themeView) {
        WS(weakSelf)
        _themeView = [[JLUploadWorkSelectView alloc] initWithTitle:@"作品所属主题" selectBlock:^{
            [weakSelf.view endEditing:YES];
            JLPickerView *pickerView = [[JLPickerView alloc] init];
            pickerView.dataSource = weakSelf.tempThemeArray;
            pickerView.selectIndex = weakSelf.currentSelectedThemeData == nil ? 0 : weakSelf.currentSelectedThemeIndex;
            pickerView.selectBlock = ^(NSInteger index, NSString *result) {
                [weakSelf.themeView setSelectContent:result];
                weakSelf.currentSelectedThemeIndex = index;
                weakSelf.currentSelectedThemeData = [AppSingleton sharedAppSingleton].artThemeArray[index];
                [weakSelf checkUpload];
            };
            [pickerView showWithAnimation:nil];
        }];
    }
    return _themeView;
}

- (JLUploadWorkSelectView *)splitNumView {
    if (!_splitNumView) {
        WS(weakSelf)
        _splitNumView = [[JLUploadWorkSelectView alloc] initWithTitle:@"库存数量" selectBlock:^{
            [weakSelf.view endEditing:YES];
            JLPickerView *pickerView = [[JLPickerView alloc] init];
            pickerView.dataSource = weakSelf.tempSplitNumArray;
            pickerView.selectIndex = weakSelf.currentSelectedSplitNumIndex;
            pickerView.selectBlock = ^(NSInteger index, NSString *result) {
                [weakSelf.splitNumView setSelectContent:result];
                weakSelf.currentSelectedSplitNumIndex = index;
                [weakSelf checkUpload];
            };
            [pickerView showWithAnimation:nil];
        }];
        [_splitNumView setSelectContent:self.tempSplitNumArray[self.currentSelectedSplitNumIndex]];
        _splitNumView.isSecondLevelView = YES;
        _splitNumView.hidden = YES;
    }
    return _splitNumView;
}

- (JLUploadWorkSwitchView *)workSplitSwitchView {
    if (!_workSplitSwitchView) {
        WS(weakSelf)
        _workSplitSwitchView = [[JLUploadWorkSwitchView alloc] initWithTitle:@"设置库存" selectBlock:^(BOOL workSplit) {
            weakSelf.workSplit = workSplit;
            [weakSelf.priceView refreshWithTitle:workSplit ? @"每份价格" : @"设置作品价格" showUnit:workSplit];
            if (workSplit) {
                weakSelf.splitNumView.hidden = NO;
                weakSelf.workSplitSwitchView.isHiddenBottomLine = YES;
                weakSelf.priceView.isSecondLevelView = YES;
                [weakSelf.priceView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(weakSelf.scrollView);
                    make.top.equalTo(weakSelf.splitNumView.mas_bottom);
                    make.height.mas_equalTo(50.0f);
                    make.width.mas_equalTo(kScreenWidth);
                }];
            } else {
                weakSelf.splitNumView.hidden = YES;
                weakSelf.workSplitSwitchView.isHiddenBottomLine = NO;
                weakSelf.priceView.isSecondLevelView = NO;
                [weakSelf.priceView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(weakSelf.scrollView);
                    make.top.equalTo(weakSelf.workSplitSwitchView.mas_bottom);
                    make.height.mas_equalTo(54.0f);
                    make.width.mas_equalTo(kScreenWidth);
                }];
            }
            [weakSelf.scrollView layoutIfNeeded];
            weakSelf.scrollView.contentSize = CGSizeMake(kScreenWidth, weakSelf.royaltyDateView.frameBottom + 50.0f);
            [weakSelf checkUpload];
        }];
    }
    return _workSplitSwitchView;
}

- (UILabel *)workDetailTitleLabel {
    if (!_workDetailTitleLabel) {
        _workDetailTitleLabel = [JLUIFactory labelInitText:@"作品评析" font:kFontPingFangSCMedium(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _workDetailTitleLabel;
}

- (JLUploadWorkDescriptionView *)workDetailView {
    if (!_workDetailView) {
        WS(weakSelf)
        _workDetailView = [[JLUploadWorkDescriptionView alloc] initWithMax:1000 placeholder:@"请对作品进行说明..." placeHolderColor:nil textFont:nil textColor:nil borderColor:JL_color_gray_B9B9B9];
        _workDetailView.backgroundColor = JL_color_white_ffffff;
        _workDetailView.inputContentChangeBlock = ^{
            [weakSelf checkUpload];
        };
    }
    return _workDetailView;
}

- (UILabel *)workDetailImageTitleLabel {
    if (!_workDetailImageTitleLabel) {
        _workDetailImageTitleLabel =  [JLUIFactory labelInitText:@"作品图片" font:kFontPingFangSCMedium(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _workDetailImageTitleLabel;
}

- (JLUploadWorkImageView *)workDetailUploadImageView {
    if (!_workDetailUploadImageView) {
        WS(weakSelf)
        _workDetailUploadImageView = [[JLUploadWorkImageView alloc] init];
        _workDetailUploadImageView.isOnlySelectImage = YES;
        _workDetailUploadImageView.controller = weakSelf;
    }
    return _workDetailUploadImageView;
}

- (JLUploadWorkMoneyInputView *)priceView {
    if (!_priceView) {
        WS(weakSelf)
        _priceView = [[JLUploadWorkMoneyInputView alloc] initWithTitle:@"设置作品价格"];
        _priceView.inputContentChangeBlock = ^{
            [weakSelf checkUpload];
        };
    }
    return _priceView;
}

- (JLUploadPersentInputView *)royaltyView {
    if (!_royaltyView) {
        _royaltyView = [[JLUploadPersentInputView alloc] initWithTitle:@"设置版税比例"];
    }
    return _royaltyView;
}

- (JLUploadWorkSelectView *)royaltyDateView {
    if (!_royaltyDateView) {
        WS(weakSelf)
        _royaltyDateView = [[JLUploadWorkSelectView alloc] initWithTitle:@"设置版税有效期" selectBlock:^{
            [weakSelf.view endEditing:YES];
            JLDatePicker *datePicker = [[JLDatePicker alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:weakSelf.royaltyDate == nil ? [NSDate date] : weakSelf.royaltyDate CompleteBlock:^(NSDate *selectedDate) {
                [weakSelf.royaltyDateView setSelectContent:[selectedDate dateWithCustomFormat:@"yyyy年MM月dd日"]];
                weakSelf.royaltyDate = selectedDate;
            }];
            datePicker.newStyle = YES;
            datePicker.minLimitDate = [NSDate date];
            [datePicker show];
        }];
        _royaltyDateView.isHiddenBottomLine = YES;
    }
    return _royaltyDateView;
}

- (UIButton *)confirmUploadBtn {
    if (!_confirmUploadBtn) {
        _confirmUploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmUploadBtn setTitle:@"确认上传" forState:UIControlStateNormal];
        [_confirmUploadBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _confirmUploadBtn.titleLabel.font = kFontPingFangSCMedium(16.0f);
        _confirmUploadBtn.backgroundColor = JL_color_gray_BEBEBE;
        _confirmUploadBtn.enabled = NO;
        [_confirmUploadBtn addTarget:self action:@selector(confirmUploadBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmUploadBtn;
}

- (void)checkUpload {
    if ([self.uploadImageView getImageArray].count == 0) {
        self.confirmUploadBtn.enabled = NO;
        self.confirmUploadBtn.backgroundColor = JL_color_gray_BEBEBE;
        return;
    }
    if ([NSString stringIsEmpty:self.workTitleView.inputContent]) {
        self.confirmUploadBtn.enabled = NO;
        self.confirmUploadBtn.backgroundColor = JL_color_gray_BEBEBE;
        return;
    }
    if ([NSString stringIsEmpty:self.workDetailView.inputContent]) {
        self.confirmUploadBtn.enabled = NO;
        self.confirmUploadBtn.backgroundColor = JL_color_gray_BEBEBE;
        return;
    }
    if (self.currentSelectedThemeData == nil) {
        self.confirmUploadBtn.enabled = NO;
        self.confirmUploadBtn.backgroundColor = JL_color_gray_BEBEBE;
        return;
    }
//    if ([NSString stringIsEmpty:self.priceView.inputContent]) {
//        self.confirmUploadBtn.enabled = NO;
//        self.confirmUploadBtn.backgroundColor = JL_color_gray_BEBEBE;
//        return;
//    }
    self.confirmUploadBtn.enabled = YES;
    self.confirmUploadBtn.backgroundColor = JL_color_mainColor;
}

- (void)confirmUploadBtnClick {
    WS(weakSelf)
    if ([self.uploadImageView getImageArray].count == 0) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请至少上传一张作品图片" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    if ([NSString stringIsEmpty:self.workTitleView.inputContent]) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请填写作品标题" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    if ([NSString stringIsEmpty:self.workDetailView.inputContent]) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请填写作品评析" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    if (self.currentSelectedThemeData == nil) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请选择作品所属主题" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    if (![NSString stringIsEmpty:self.royaltyView.inputContent]) {
        if (![JLUtils isPureInt:self.royaltyView.inputContent]) {
            [[JLLoading sharedLoading] showMBFailedTipMessage:@"请设置正确的版税比例" hideTime:KToastDismissDelayTimeInterval];
            return;
        }
        NSDecimalNumber *royaltyNumber = [NSDecimalNumber decimalNumberWithString:self.royaltyView.inputContent];
        if ([royaltyNumber isGreaterThan:[NSDecimalNumber decimalNumberWithString:@"100"]]) {
            [[JLLoading sharedLoading] showMBFailedTipMessage:@"版税比例不能超过100%" hideTime:KToastDismissDelayTimeInterval];
            return;
        }
    }
    if (self.royaltyDate != nil && [NSString stringIsEmpty:self.royaltyView.inputContent]) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请设置版税比例" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
//    if ([NSString stringIsEmpty:self.priceView.inputContent]) {
//        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请填写作品价格" hideTime:KToastDismissDelayTimeInterval];
//        return;
//    }
    
    // 判断是否是上传Live2d文件
    JLUploadImageModel *firstImageModel = [[self.uploadImageView getImageArray] firstObject];
    
    // 判断是否为视频文件
    if (![NSString stringIsEmpty:firstImageModel.videoUrl.absoluteString]) {
        [self uploadVideo:firstImageModel];
        return;
    }
    
    if ([firstImageModel.imageType isEqualToString:@"live2d"]) {
        [self uploadZipFile];
    } else {
        NSMutableArray *paramsArray = [NSMutableArray array];
        NSMutableArray *fileNameArray = [NSMutableArray array];
        NSMutableArray *fileDataArray = [NSMutableArray array];
        NSMutableArray *mainFileNameArray = [NSMutableArray array];
        NSMutableArray *detailFileNameArray = [NSMutableArray array];
        NSMutableArray *fileTypeArray = [NSMutableArray array];
        
        for (JLUploadImageModel *imageModel in [self.uploadImageView getImageArray]) {
            NSString *fileTimeString = [NSString stringWithFormat:@"%@%d", [JLNetHelper getTimeString], (arc4random() % 999999)];
            [mainFileNameArray addObject:fileTimeString];
        }
        // 作品详情图片
        for (JLUploadImageModel *imageModel in [self.workDetailUploadImageView getImageArray]) {
            NSString *fileTimeString = [NSString stringWithFormat:@"%@%d", [JLNetHelper getTimeString], (arc4random() % 999999)];
            [detailFileNameArray addObject:fileTimeString];
        }
        Model_arts_Req *request = [[Model_arts_Req alloc] init];
        request.img_main_file1 = mainFileNameArray[0];
        [paramsArray addObject:@"img_main_file1"];
        [fileNameArray addObject:mainFileNameArray[0]];
        [fileDataArray addObject:((JLUploadImageModel *)[self.uploadImageView getImageArray][0]).imageData];
        [fileTypeArray addObject:((JLUploadImageModel *)[self.uploadImageView getImageArray][0]).imageType];
        if (mainFileNameArray.count > 1) {
            request.img_main_file2 = mainFileNameArray[1];
            [paramsArray addObject:@"img_main_file2"];
            [fileNameArray addObject:mainFileNameArray[1]];
            [fileDataArray addObject:((JLUploadImageModel *)[self.uploadImageView getImageArray][1]).imageData];
            [fileTypeArray addObject:((JLUploadImageModel *)[self.uploadImageView getImageArray][1]).imageType];
        }
        if (mainFileNameArray.count > 2) {
            request.img_main_file3 = mainFileNameArray[2];
            [paramsArray addObject:@"img_main_file3"];
            [fileNameArray addObject:mainFileNameArray[2]];
            [fileDataArray addObject:((JLUploadImageModel *)[self.uploadImageView getImageArray][2]).imageData];
            [fileTypeArray addObject:((JLUploadImageModel *)[self.uploadImageView getImageArray][2]).imageType];
        }
        // 作品详情图片
        for (int i = 0; i < detailFileNameArray.count; i++) {
            if (i == 0) {
                request.img_detail_file1 = detailFileNameArray[i];
                [paramsArray addObject:@"img_detail_file1"];
            }
            if (i == 1) {
                request.img_detail_file2 = detailFileNameArray[i];
                [paramsArray addObject:@"img_detail_file2"];
            }
            if (i == 2) {
                request.img_detail_file3 = detailFileNameArray[i];
                [paramsArray addObject:@"img_detail_file3"];
            }
            [fileNameArray addObject:detailFileNameArray[i]];
            [fileDataArray addObject:((JLUploadImageModel *)[self.workDetailUploadImageView getImageArray][i]).imageData];
            [fileTypeArray addObject:((JLUploadImageModel *)[self.workDetailUploadImageView getImageArray][i]).imageType];
        }
        request.name = self.workTitleView.inputContent;
        request.category_id = self.currentSelectedThemeData.ID;
        request.details = self.workDetailView.inputContent;
        request.is_refungible = self.workSplit ? @"true" : @"false";
        if (self.workSplit) {
            request.refungible_decimal = [self.tempSplitNumArray[self.currentSelectedSplitNumIndex] stringByReplacingOccurrencesOfString:@"份" withString:@""];
        }
        if (![NSString stringIsEmpty:self.priceView.inputContent]) {
            request.price = self.priceView.inputContent;
        }
        if (![NSString stringIsEmpty:self.royaltyView.inputContent]) {
            NSDecimalNumber *royaltyPersentNumber = [NSDecimalNumber decimalNumberWithString:self.royaltyView.inputContent];
            NSDecimalNumber *royaltyNumber = [royaltyPersentNumber decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
            request.royalty = royaltyNumber.stringValue;
        }
        if (self.royaltyDate != nil) {
            NSInteger royaltyDateTimeInterval = [self.royaltyDate timeIntervalSince1970] * 1000;
            request.royalty_expired_at = @(royaltyDateTimeInterval).stringValue;
        }
        request.resource_type = 1;
        for (JLUploadImageModel *imageModel in [self.uploadImageView getImageArray]) {
            if ([imageModel.imageType isEqualToString:@"gif"]) {
                request.resource_type = 2;
                break;
            }
        }
        Model_arts_Rsp *response = [[Model_arts_Rsp alloc] init];
        
        [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
        [JLNetHelper netRequestUploadImagesParameters:request respondParameters:response paramsNames:[paramsArray copy] fileNames:[fileNameArray copy] fileData:[fileDataArray copy] fileType:[fileTypeArray copy] callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
            [[JLLoading sharedLoading] hideLoading];
            if (netIsWork) {
                [JLAlertTipView alertWithTitle:@"提示" message:@"作品已上传，请耐心等待审核结果" doneTitle:@"确定" done:^{
                    if (weakSelf.uploadSuccessBackBlock) {
                        weakSelf.uploadSuccessBackBlock();
                    }
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"JLLive2dSnapshotNotification" object:nil];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            } else {
                [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
            }
        }];
    }
}

- (void)uploadVideo:(JLUploadImageModel *)imageModel {
    
    NSMutableArray *paramsArray = [NSMutableArray array];
    NSMutableArray *fileNameArray = [NSMutableArray array];
    NSMutableArray *fileDataArray = [NSMutableArray array];
    NSMutableArray *detailFileNameArray = [NSMutableArray array];
    NSMutableArray *fileTypeArray = [NSMutableArray array];
    // 图片
    [paramsArray addObject:@"img_main_file1"];
    [fileNameArray addObject:[NSString stringWithFormat:@"%@%d", [JLNetHelper getTimeString], (arc4random() % 999999)]];
    UIImage *image = [UIImage thumbnailImageForVideo:imageModel.videoUrl atTime:1.0];
    NSData *imageData = [NSData getDataFromImage:image];
    NSString *imageType = [JLTool contentTypeForImageData:imageData];
    [fileTypeArray addObject:imageType];
    [fileDataArray addObject:imageData];
    
    Model_arts_Req *request = [[Model_arts_Req alloc] init];
    request.img_main_file1 = fileNameArray[0];
    // 作品详情图片
    for (JLUploadImageModel *imageModel in [self.workDetailUploadImageView getImageArray]) {
        NSString *fileTimeString = [NSString stringWithFormat:@"%@%d", [JLNetHelper getTimeString], (arc4random() % 999999)];
        [detailFileNameArray addObject:fileTimeString];
    }
    for (int i = 0; i < detailFileNameArray.count; i++) {
        if (i == 0) {
            request.img_detail_file1 = detailFileNameArray[i];
            [paramsArray addObject:@"img_detail_file1"];
        }
        if (i == 1) {
            request.img_detail_file2 = detailFileNameArray[i];
            [paramsArray addObject:@"img_detail_file2"];
        }
        if (i == 2) {
            request.img_detail_file3 = detailFileNameArray[i];
            [paramsArray addObject:@"img_detail_file3"];
        }
        [fileNameArray addObject:detailFileNameArray[i]];
        [fileDataArray addObject:((JLUploadImageModel *)[self.workDetailUploadImageView getImageArray][i]).imageData];
        [fileTypeArray addObject:((JLUploadImageModel *)[self.workDetailUploadImageView getImageArray][i]).imageType];
    }
    request.name = self.workTitleView.inputContent;
    request.category_id = self.currentSelectedThemeData.ID;
    request.details = self.workDetailView.inputContent;
    request.is_refungible = self.workSplit ? @"true" : @"false";
    if (self.workSplit) {
        request.refungible_decimal = [self.tempSplitNumArray[self.currentSelectedSplitNumIndex] stringByReplacingOccurrencesOfString:@"份" withString:@""];
    }
    if (![NSString stringIsEmpty:self.priceView.inputContent]) {
        request.price = self.priceView.inputContent;
    }
    if (![NSString stringIsEmpty:self.royaltyView.inputContent]) {
        NSDecimalNumber *royaltyPersentNumber = [NSDecimalNumber decimalNumberWithString:self.royaltyView.inputContent];
        NSDecimalNumber *royaltyNumber = [royaltyPersentNumber decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
        request.royalty = royaltyNumber.stringValue;
    }
    if (self.royaltyDate != nil) {
        NSInteger royaltyDateTimeInterval = [self.royaltyDate timeIntervalSince1970] * 1000;
        request.royalty_expired_at = @(royaltyDateTimeInterval).stringValue;
    }
    request.resource_type = 4;
    Model_arts_Rsp *response = [[Model_arts_Rsp alloc] init];
   
    // 视频
    [paramsArray addObject:@"img_main_file2"];
    [fileNameArray addObject:[NSString stringWithFormat:@"%@%d.mp4", [JLNetHelper getTimeString], (arc4random() % 999999)]];
    NSData *videoData = [NSData dataWithContentsOfURL:imageModel.videoUrl.filePathURL];
    [fileTypeArray addObject:@"mp4"];
    [fileDataArray addObject:videoData];
    request.img_main_file2 = [fileNameArray lastObject];
    
    NSLog(@"视频文件大小: %.2fM", [videoData length] / 1024.0 / 1024.0);
    if ([videoData length] / 1024.0 / 1024.0 > 50.0) {
        [JLAlert jlalertView:@"提示" message:@"视频文件不能大于50M" cancel:@"好的"];
        return;
    }
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    WS(weakSelf)
    [JLNetHelper netRequestUploadVideoParameters:request respondParameters:response paramsNames:paramsArray fileNames:fileNameArray fileData:fileDataArray fileType:fileTypeArray callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
       [[JLLoading sharedLoading] hideLoading];
       if (netIsWork) {
           [JLAlertTipView alertWithTitle:@"提示" message:@"作品已上传，请耐心等待审核结果" doneTitle:@"确定" done:^{
               if (weakSelf.uploadSuccessBackBlock) {
                   weakSelf.uploadSuccessBackBlock();
               }
               [[NSNotificationCenter defaultCenter] removeObserver:self name:@"JLLive2dSnapshotNotification" object:nil];
               [weakSelf.navigationController popViewControllerAnimated:YES];
           }];
       } else {
           [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
       }
    }];
}

- (void)uploadZipFile {
    WS(weakSelf)
    NSString *fileTimeString = [NSString stringWithFormat:@"%@%d.zip", [JLNetHelper getTimeString], (arc4random() % 999999)];
    Model_arts_upload_live2d_file_Req *request = [[Model_arts_upload_live2d_file_Req alloc] init];
    request.live2d_file = fileTimeString;
    Model_arts_upload_live2d_file_Rsp *response = [[Model_arts_upload_live2d_file_Rsp alloc] init];
    
    JLUploadImageModel *firstImageModel = [[self.uploadImageView getImageArray] firstObject];
    NSData *fileData = [NSData dataWithContentsOfFile:firstImageModel.zipFilePath];
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestUploadZipFileParameters:request respondParameters:response paramName:@"live2d_file" fileName:fileTimeString fileData:fileData callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            [weakSelf saveLive2dToServer:response.body];
        } else {
            [[JLLoading sharedLoading] hideLoading];
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
        }
    }];
}

/** 服务端保存live2d */
- (void)saveLive2dToServer:(Model_arts_upload_live2d_file_Data *)live2dFileData {
    WS(weakSelf)
    NSMutableArray *paramsArray = [NSMutableArray array];
    NSMutableArray *fileNameArray = [NSMutableArray array];
    NSMutableArray *detailFileNameArray = [NSMutableArray array];
    NSMutableArray *fileDataArray = [NSMutableArray array];
    NSMutableArray *mainFileNameArray = [NSMutableArray array];
    NSMutableArray *fileTypeArray = [NSMutableArray array];
    
    for (JLUploadImageModel *imageModel in [self.uploadImageView getImageArray]) {
        NSString *fileTimeString = [NSString stringWithFormat:@"%@%d", [JLNetHelper getTimeString], (arc4random() % 999999)];
        [mainFileNameArray addObject:fileTimeString];
    }
    // 作品详情图片
    for (JLUploadImageModel *imageModel in [self.workDetailUploadImageView getImageArray]) {
        NSString *fileTimeString = [NSString stringWithFormat:@"%@%d", [JLNetHelper getTimeString], (arc4random() % 999999)];
        [detailFileNameArray addObject:fileTimeString];
    }
    Model_arts_Req *request = [[Model_arts_Req alloc] init];
    if (mainFileNameArray.count > 1) {
        request.img_main_file1 = mainFileNameArray[1];
        [paramsArray addObject:@"img_main_file1"];
        [fileNameArray addObject:mainFileNameArray[1]];
        [fileDataArray addObject:((JLUploadImageModel *)[self.uploadImageView getImageArray][1]).imageData];
        [fileTypeArray addObject:((JLUploadImageModel *)[self.uploadImageView getImageArray][1]).imageType];
    } else {
        request.img_main_file1 = mainFileNameArray[0];
        [paramsArray addObject:@"img_main_file1"];
        [fileNameArray addObject:mainFileNameArray[0]];
        [fileDataArray addObject:((JLUploadImageModel *)[self.uploadImageView getImageArray][0]).imageData];
        [fileTypeArray addObject:((JLUploadImageModel *)[self.uploadImageView getImageArray][0]).imageType];
    }
    // 作品详情图片
    for (int i = 0; i < detailFileNameArray.count; i++) {
        if (i == 0) {
            request.img_detail_file1 = detailFileNameArray[i];
            [paramsArray addObject:@"img_detail_file1"];
        }
        if (i == 1) {
            request.img_detail_file2 = detailFileNameArray[i];
            [paramsArray addObject:@"img_detail_file2"];
        }
        if (i == 2) {
            request.img_detail_file3 = detailFileNameArray[i];
            [paramsArray addObject:@"img_detail_file3"];
        }
        [fileNameArray addObject:detailFileNameArray[i]];
        [fileDataArray addObject:((JLUploadImageModel *)[self.workDetailUploadImageView getImageArray][i]).imageData];
        [fileTypeArray addObject:((JLUploadImageModel *)[self.workDetailUploadImageView getImageArray][i]).imageType];
    }
    request.name = self.workTitleView.inputContent;
    request.category_id = self.currentSelectedThemeData.ID;
    request.details = self.workDetailView.inputContent;
    request.is_refungible = self.workSplit ? @"true" : @"false";
    if (self.workSplit) {
        request.refungible_decimal = [self.tempSplitNumArray[self.currentSelectedSplitNumIndex] stringByReplacingOccurrencesOfString:@"份" withString:@""];
    }
    if (![NSString stringIsEmpty:self.priceView.inputContent]) {
        request.price = self.priceView.inputContent;
    }
    if (![NSString stringIsEmpty:self.royaltyView.inputContent]) {
        NSDecimalNumber *royaltyPersentNumber = [NSDecimalNumber decimalNumberWithString:self.royaltyView.inputContent];
        NSDecimalNumber *royaltyNumber = [royaltyPersentNumber decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
        request.royalty = royaltyNumber.stringValue;
    }
    if (self.royaltyDate != nil) {
        NSInteger royaltyDateTimeInterval = [self.royaltyDate timeIntervalSince1970] * 1000;
        request.royalty_expired_at = @(royaltyDateTimeInterval).stringValue;
    }
    request.resource_type = 3;
    request.live2d_file = live2dFileData.live2d_file;
    request.live2d_ipfs_hash = live2dFileData.live2d_ipfs_hash;
    request.live2d_ipfs_zip_hash = live2dFileData.live2d_ipfs_zip_hash;

    Model_arts_Rsp *response = [[Model_arts_Rsp alloc] init];
    
    [JLNetHelper netRequestUploadImagesParameters:request respondParameters:response paramsNames:[paramsArray copy] fileNames:[fileNameArray copy] fileData:[fileDataArray copy] fileType:[fileTypeArray copy] callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            [JLAlertTipView alertWithTitle:@"提示" message:@"作品已上传，请耐心等待审核结果" doneTitle:@"确定" done:^{
                if (weakSelf.uploadSuccessBackBlock) {
                    weakSelf.uploadSuccessBackBlock();
                }
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"JLLive2dSnapshotNotification" object:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
        }
    }];
}

- (NSArray *)tempThemeArray {
    if (!_tempThemeArray) {
        NSMutableArray *themeArray = [NSMutableArray array];
        for (Model_arts_theme_Data *themeData in [AppSingleton sharedAppSingleton].artThemeArray) {
            [themeArray addObject:themeData.title];
        }
        _tempThemeArray = [themeArray copy];
    }
    return _tempThemeArray;
}

- (void)refreshThemeArray {
    if ([AppSingleton sharedAppSingleton].artThemeArray.count == 0) {
        [[AppSingleton sharedAppSingleton] requestArtThemeWithSuccessBlock:nil];
    }
}

- (NSArray *)tempSplitNumArray {
    if (!_tempSplitNumArray) {
        _tempSplitNumArray = @[@"10份", @"100份", @"1000份", @"10000份"];
    }
    return _tempSplitNumArray;
}

@end
