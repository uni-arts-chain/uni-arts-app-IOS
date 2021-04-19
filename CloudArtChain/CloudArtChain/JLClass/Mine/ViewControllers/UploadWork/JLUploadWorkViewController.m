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
#import "JLUploadWorkInputView.h"
#import "JLUploadWorkSelectView.h"
#import "JLUploadWorkMultiInputView.h"
#import "JLUploadWorkDescriptionView.h"
#import "JLUploadWorkDetailView.h"
#import "JLUploadWorkMoneyInputView.h"
#import "JLDatePicker.h"
#import "JLPickerView.h"

#import "NSDate+Extension.h"
#import "UIAlertController+Alert.h"
#import "UIImage+JLTool.h"


@interface JLUploadWorkViewController ()
@property (nonatomic, strong) UIView *noticeView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *basicInfoTitleLabel;
@property (nonatomic, strong) JLUploadWorkSampleView *uploadWorkSampleView;
@property (nonatomic, strong) UILabel *uploadImageTitleLabel;
@property (nonatomic, strong) JLUploadWorkImageView *uploadImageView;
@property (nonatomic, strong) JLUploadWorkInputView *workTitleView;
@property (nonatomic, strong) JLUploadWorkSelectView *categoryView;
@property (nonatomic, strong) JLUploadWorkSelectView *themeView;
@property (nonatomic, strong) JLUploadWorkSelectView *materialView;
@property (nonatomic, strong) JLUploadWorkSelectView *createDateView;
@property (nonatomic, strong) JLUploadWorkMultiInputView *sizeView;
@property (nonatomic, strong) UILabel *workDetailTitleLabel;
@property (nonatomic, strong) JLUploadWorkDescriptionView *workDetailView;
@property (nonatomic, strong) JLUploadWorkDetailView *firstDetailView;
@property (nonatomic, strong) JLUploadWorkDetailView *secondDetailView;
@property (nonatomic, strong) UILabel *otherInfoTitleLabel;
@property (nonatomic, strong) JLUploadWorkMoneyInputView *priceView;
//@property (nonatomic, strong) JLUploadWorkMoneyInputView *freightView;

@property (nonatomic, strong) UIButton *confirmUploadBtn;

// 分类
@property (nonatomic, strong) NSArray *tempCateArray;
@property (nonatomic, assign) NSInteger currentSelectedCateIndex;
@property (nonatomic, strong) Model_arts_categories_Data *currentSelectedCateData;

// 主题
@property (nonatomic, strong) NSArray *tempThemeArray;
@property (nonatomic, assign) NSInteger currentSelectedThemeIndex;
@property (nonatomic, strong) Model_arts_themes_Data *currentSelectedThemeData;

// 材质
@property (nonatomic, strong) NSArray *tempMaterialArray;
@property (nonatomic, assign) NSInteger currentSelectedMaterialIndex;
@property (nonatomic, strong) Model_arts_materials_Data *currentSelectedMaterialData;

// 创作时间
@property (nonatomic, strong) NSDate *productDate;
@end

@implementation JLUploadWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"上传作品";
    [self addBackItem];
    [self createView];
}

- (void)createView {
    [self.view addSubview:self.noticeView];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.confirmUploadBtn];
    
    [self.noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(22.0f);
    }];
    [self.confirmUploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(-KTouch_Responder_Height);
        make.height.mas_equalTo(46.0f);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.noticeView.mas_bottom);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.confirmUploadBtn.mas_top);
        make.width.mas_equalTo(kScreenWidth);
    }];
    
    [self.scrollView addSubview:self.basicInfoTitleLabel];
    [self.scrollView addSubview:self.uploadWorkSampleView];
    [self.scrollView addSubview:self.uploadImageTitleLabel];
    [self.scrollView addSubview:self.uploadImageView];
    [self.scrollView addSubview:self.workTitleView];
    [self.scrollView addSubview:self.categoryView];
    [self.scrollView addSubview:self.themeView];
    [self.scrollView addSubview:self.materialView];
    [self.scrollView addSubview:self.createDateView];
    [self.scrollView addSubview:self.sizeView];
    [self.scrollView addSubview:self.workDetailTitleLabel];
    [self.scrollView addSubview:self.workDetailView];
    [self.scrollView addSubview:self.firstDetailView];
    [self.scrollView addSubview:self.secondDetailView];
    [self.scrollView addSubview:self.otherInfoTitleLabel];
    [self.scrollView addSubview:self.priceView];
//    [self.scrollView addSubview:self.freightView];
    
    [self.basicInfoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.scrollView);
        make.height.mas_equalTo(40.0f);
        make.width.mas_equalTo(kScreenWidth - 15.0f * 2);
    }];
    [self.uploadWorkSampleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.basicInfoTitleLabel.mas_bottom);
        make.width.mas_equalTo(kScreenWidth);
    }];
    [self.uploadImageTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.uploadWorkSampleView.mas_bottom).offset(15.0f);
        make.width.mas_equalTo(kScreenWidth - 15.0f * 2);
        make.height.mas_equalTo(35.0f);
    }];
    [self.uploadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.uploadImageTitleLabel.mas_bottom);
        make.height.mas_equalTo(93.0f);
        make.width.mas_equalTo(kScreenWidth);
    }];
    [self.workTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.uploadImageView.mas_bottom);
        make.height.mas_equalTo(64.0f);
        make.width.mas_equalTo(kScreenWidth);
    }];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.workTitleView.mas_bottom);
        make.height.mas_equalTo(64.0f);
        make.width.mas_equalTo(kScreenWidth);
    }];
    [self.themeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.categoryView.mas_bottom);
        make.height.mas_equalTo(64.0f);
        make.width.mas_equalTo(kScreenWidth);
    }];
    [self.materialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.themeView.mas_bottom);
        make.height.mas_equalTo(64.0f);
        make.width.mas_equalTo(kScreenWidth);
    }];
    [self.createDateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.materialView.mas_bottom);
        make.height.mas_equalTo(64.0f);
        make.width.mas_equalTo(kScreenWidth);
    }];
    [self.sizeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.createDateView.mas_bottom);
        make.height.mas_equalTo(64.0f);
        make.width.mas_equalTo(kScreenWidth);
    }];
    [self.workDetailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.sizeView.mas_bottom).offset(4.0f);
        make.height.mas_equalTo(49.0f);
        make.width.mas_equalTo(kScreenWidth - 15.0f * 2);
    }];
    [self.workDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.workDetailTitleLabel.mas_bottom);
        make.height.mas_equalTo(176.0f);
        make.width.mas_equalTo(kScreenWidth - 15.0f * 2);
    }];
    [self.firstDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.workDetailView.mas_bottom).offset(27.0f);
        make.height.mas_equalTo(121.0f);
        make.width.mas_equalTo(kScreenWidth);
    }];
    [self.secondDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.firstDetailView.mas_bottom).offset(22.0f);
        make.height.mas_equalTo(121.0f);
        make.width.mas_equalTo(kScreenWidth);
    }];
    [self.otherInfoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.secondDetailView.mas_bottom);
        make.height.mas_equalTo(60.0f);
        make.width.mas_equalTo(kScreenWidth - 15.0f * 2);
    }];
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView);
        make.top.equalTo(self.otherInfoTitleLabel.mas_bottom);
        make.height.mas_equalTo(30.0f);
        make.width.mas_equalTo(kScreenWidth);
    }];
//    [self.freightView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.scrollView);
//        make.top.equalTo(self.priceView.mas_bottom).offset(20.0f);
//        make.height.mas_equalTo(30.0f);
//        make.width.mas_equalTo(kScreenWidth);
//    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.priceView.frameBottom + 60.0f);
}

- (UIView *)noticeView {
    if (!_noticeView) {
        _noticeView = [[UIView alloc] init];
        _noticeView.backgroundColor = JL_color_orange_FFEBD4;
        
        UILabel *noticeLabel = [JLUIFactory labelInitText:@"注意：信息通过审核后无法修改，请谨慎操作" font:kFontPingFangSCRegular(12.0f) textColor:JL_color_other_B25F00 textAlignment:NSTextAlignmentCenter];
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
        _scrollView.backgroundColor = JL_color_white_ffffff;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UILabel *)basicInfoTitleLabel {
    if (!_basicInfoTitleLabel) {
        _basicInfoTitleLabel = [JLUIFactory labelInitText:@"基本信息" font:kFontPingFangSCSCSemibold(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _basicInfoTitleLabel;
}

- (JLUploadWorkSampleView *)uploadWorkSampleView {
    if (!_uploadWorkSampleView) {
        _uploadWorkSampleView = [[JLUploadWorkSampleView alloc] init];
    }
    return _uploadWorkSampleView;
}

- (UILabel *)uploadImageTitleLabel {
    if (!_uploadImageTitleLabel) {
        _uploadImageTitleLabel = [JLUIFactory labelInitText:@"上传三张作品高清图片" font:kFontPingFangSCSCSemibold(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _uploadImageTitleLabel;
}

- (JLUploadWorkImageView *)uploadImageView {
    if (!_uploadImageView) {
        _uploadImageView = [[JLUploadWorkImageView alloc] init];
        _uploadImageView.controller = self;
    }
    return _uploadImageView;
}

- (JLUploadWorkInputView *)workTitleView {
    if (!_workTitleView) {
        _workTitleView = [[JLUploadWorkInputView alloc] initWithMaxInput:10 placeholder:@"请输入作品标题"];
    }
    return _workTitleView;
}

- (JLUploadWorkSelectView *)categoryView {
    if (!_categoryView) {
        WS(weakSelf)
        _categoryView = [[JLUploadWorkSelectView alloc] initWithPlaceHolder:@"请选择分类" selectBlock:^{
            [weakSelf.view endEditing:YES];
            JLPickerView *pickerView = [[JLPickerView alloc] init];
            pickerView.dataSource = self.tempCateArray;
            pickerView.selectIndex = weakSelf.currentSelectedCateData == nil ? 0 : weakSelf.currentSelectedCateIndex;
            pickerView.selectBlock = ^(NSInteger index, NSString *result) {
                [weakSelf.categoryView setSelectContent:result];
                weakSelf.currentSelectedCateIndex = index;
                weakSelf.currentSelectedCateData = [AppSingleton sharedAppSingleton].artCategoryArray[index];
            };
            [pickerView showWithAnimation:nil];
        }];
    }
    return _categoryView;
}

- (JLUploadWorkSelectView *)themeView {
    if (!_themeView) {
        WS(weakSelf)
        _themeView = [[JLUploadWorkSelectView alloc] initWithPlaceHolder:@"请选择题材" selectBlock:^{
            [weakSelf.view endEditing:YES];
            JLPickerView *pickerView = [[JLPickerView alloc] init];
            pickerView.dataSource = self.tempThemeArray;
            pickerView.selectIndex = weakSelf.currentSelectedThemeData == nil ? 0 : weakSelf.currentSelectedThemeIndex;
            pickerView.selectBlock = ^(NSInteger index, NSString *result) {
                [weakSelf.themeView setSelectContent:result];
                weakSelf.currentSelectedThemeIndex = index;
                weakSelf.currentSelectedThemeData = [AppSingleton sharedAppSingleton].artThemeArray[index];
            };
            [pickerView showWithAnimation:nil];
        }];
    }
    return _themeView;
}

- (JLUploadWorkSelectView *)materialView {
    if (!_materialView) {
        WS(weakSelf)
        _materialView = [[JLUploadWorkSelectView alloc] initWithPlaceHolder:@"请选择作品材质" selectBlock:^{
            [weakSelf.view endEditing:YES];
            JLPickerView *pickView = [[JLPickerView alloc] init];
            pickView.dataSource = self.tempMaterialArray;
            pickView.selectIndex = weakSelf.currentSelectedMaterialData == nil ? 0 : weakSelf.currentSelectedMaterialIndex;
            pickView.selectBlock = ^(NSInteger index, NSString *result) {
                [weakSelf.materialView setSelectContent:result];
                weakSelf.currentSelectedThemeIndex = index;
                weakSelf.currentSelectedMaterialData = [AppSingleton sharedAppSingleton].artMaterialArray[index];
            };
            [pickView showWithAnimation:nil];
        }];
    }
    return _materialView;
}

- (JLUploadWorkSelectView *)createDateView {
    if (!_createDateView) {
        WS(weakSelf)
        _createDateView = [[JLUploadWorkSelectView alloc] initWithPlaceHolder:@"请选择创作时间" selectBlock:^{
            JLDatePicker *datePicker = [[JLDatePicker alloc] initWithDateStyle:DateStyleShowYearMonth scrollToDate:weakSelf.productDate == nil ? [NSDate date] : weakSelf.productDate CompleteBlock:^(NSDate *selectedDate) {
                [weakSelf.createDateView setSelectContent:[selectedDate dateWithCustomFormat:@"yyyy年MM月"]];
                weakSelf.productDate = selectedDate;
            }];
            datePicker.newStyle = YES;
            datePicker.maxLimitDate = [NSDate date];
            [datePicker show];
        }];
    }
    return _createDateView;
}

- (JLUploadWorkMultiInputView *)sizeView {
    if (!_sizeView) {
        _sizeView = [[JLUploadWorkMultiInputView alloc] initWithTitle:@"请输入作品尺寸(cm)"];
    }
    return _sizeView;
}

- (UILabel *)workDetailTitleLabel {
    if (!_workDetailTitleLabel) {
        _workDetailTitleLabel = [JLUIFactory labelInitText:@"作品详情" font:kFontPingFangSCSCSemibold(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _workDetailTitleLabel;
}

- (JLUploadWorkDescriptionView *)workDetailView {
    if (!_workDetailView) {
        _workDetailView = [[JLUploadWorkDescriptionView alloc] initWithMax:200 placeholder:@"请输入你对作品的整体评析..." placeHolderColor:nil textFont:nil textColor:nil borderColor:nil];
    }
    return _workDetailView;
}

- (JLUploadWorkDetailView *)firstDetailView {
    if (!_firstDetailView) {
        _firstDetailView = [[JLUploadWorkDetailView alloc] init];
        _firstDetailView.controller = self;
    }
    return _firstDetailView;
}

- (JLUploadWorkDetailView *)secondDetailView {
    if (!_secondDetailView) {
        _secondDetailView = [[JLUploadWorkDetailView alloc] init];
        _secondDetailView.controller = self;
    }
    return _secondDetailView;
}

- (UILabel *)otherInfoTitleLabel {
    if (!_otherInfoTitleLabel) {
        _otherInfoTitleLabel = [JLUIFactory labelInitText:@"其他信息" font:kFontPingFangSCSCSemibold(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _otherInfoTitleLabel;
}

- (JLUploadWorkMoneyInputView *)priceView {
    if (!_priceView) {
        _priceView = [[JLUploadWorkMoneyInputView alloc] initWithTitle:@"作品价格"];
    }
    return _priceView;
}

//- (JLUploadWorkMoneyInputView *)freightView {
//    if (!_freightView) {
//        _freightView = [[JLUploadWorkMoneyInputView alloc] initWithTitle:@"运费"];
//    }
//    return _freightView;
//}

- (UIButton *)confirmUploadBtn {
    if (!_confirmUploadBtn) {
        _confirmUploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmUploadBtn setTitle:@"确认上传" forState:UIControlStateNormal];
        [_confirmUploadBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _confirmUploadBtn.titleLabel.font = kFontPingFangSCRegular(17.0f);
        _confirmUploadBtn.backgroundColor = JL_color_blue_38B2F1;
        [_confirmUploadBtn addTarget:self action:@selector(confirmUploadBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmUploadBtn;
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
    if (self.currentSelectedCateData == nil) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请选择作品分类" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    if (self.currentSelectedThemeData == nil) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请选择作品题材" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    if (self.currentSelectedMaterialData == nil) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请选择作品材质" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    if (self.productDate == nil) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请选择作品创作时间" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    if ([NSString stringIsEmpty:self.sizeView.firstInputContent] || [NSString stringIsEmpty:self.sizeView.secondInputContent]) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请填写作品尺寸" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    if ([NSString stringIsEmpty:self.workDetailView.inputContent]) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请填写作品评析" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    if (([self.firstDetailView getDetailImage] == nil && [self.secondDetailView getDetailImage] == nil) || (![NSString stringIsEmpty:[self.firstDetailView getDetailDescContent]] && [self.firstDetailView getDetailImage] == nil) || (![NSString stringIsEmpty:[self.secondDetailView getDetailDescContent]] && [self.secondDetailView getDetailImage] == nil)) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请上传作品细节图片" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    if (([NSString stringIsEmpty:[self.firstDetailView getDetailDescContent]] && [NSString stringIsEmpty:[self.secondDetailView getDetailDescContent]]) || ([NSString stringIsEmpty:[self.firstDetailView getDetailDescContent]] && [self.firstDetailView getDetailImage] != nil) || ([NSString stringIsEmpty:[self.secondDetailView getDetailDescContent]] && [self.secondDetailView getDetailImage] != nil)) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请填写细节剖析" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    if ([NSString stringIsEmpty:self.priceView.inputContent]) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请填写作品价格" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    
    NSMutableArray *paramsArray = [NSMutableArray array];
    NSMutableArray *fileNameArray = [NSMutableArray array];
    NSMutableArray *fileDataArray = [NSMutableArray array];
    NSMutableArray *mainFileNameArray = [NSMutableArray array];
    for (UIImage *image in [self.uploadImageView getImageArray]) {
        NSString *fileTimeString = [NSString stringWithFormat:@"%@%d", [JLNetHelper getTimeString], (arc4random() % 999999)];
        [mainFileNameArray addObject:fileTimeString];
    }
    Model_arts_Req *request = [[Model_arts_Req alloc] init];
    request.img_main_file1 = mainFileNameArray[0];
    [paramsArray addObject:@"img_main_file1"];
    [fileNameArray addObject:mainFileNameArray[0]];
    [fileDataArray addObject:[UIImage compressOriginalImage:[self.uploadImageView getImageArray][0]]];
    if (mainFileNameArray.count > 1) {
        request.img_main_file2 = mainFileNameArray[1];
        [paramsArray addObject:@"img_main_file2"];
        [fileNameArray addObject:mainFileNameArray[1]];
        [fileDataArray addObject:[UIImage compressOriginalImage:[self.uploadImageView getImageArray][1]]];
    }
    if (mainFileNameArray.count > 2) {
        request.img_main_file3 = mainFileNameArray[2];
        [paramsArray addObject:@"img_main_file3"];
        [fileNameArray addObject:mainFileNameArray[2]];
        [fileDataArray addObject:[UIImage compressOriginalImage:[self.uploadImageView getImageArray][2]]];
    }
    request.name = self.workTitleView.inputContent;
    request.category_id = self.currentSelectedCateData.ID;
    request.theme_id = self.currentSelectedThemeData.ID;
    request.material_id = self.currentSelectedMaterialData.ID;
    request.produce_at = @([self.productDate timeIntervalSince1970]).stringValue;
    request.size_width = self.sizeView.firstInputContent;
    request.size_length = self.sizeView.secondInputContent;
    request.details = self.workDetailView.inputContent;
    
    NSString *fileDetailTimeStringFirst = [NSString stringWithFormat:@"%@%d", [JLNetHelper getTimeString], (arc4random() % 999999)];
    request.img_detail_file1 = fileDetailTimeStringFirst;
    request.img_detail_file1_desc = [NSString stringIsEmpty:[self.firstDetailView getDetailDescContent]] ? [self.secondDetailView getDetailDescContent] : [self.firstDetailView getDetailDescContent];
    [paramsArray addObject:@"img_detail_file1"];
    [fileNameArray addObject:fileDetailTimeStringFirst];
    [fileDataArray addObject:([self.firstDetailView getDetailImage] == nil ? [UIImage compressOriginalImage:[self.secondDetailView getDetailImage]] : [UIImage compressOriginalImage:[self.firstDetailView getDetailImage]])];
    
    if ([self.firstDetailView getDetailImage] != nil && [self.secondDetailView getDetailImage] != nil) {
        NSString *fileDetailTimeStringSecond = [NSString stringWithFormat:@"%@%d", [JLNetHelper getTimeString], (arc4random() % 999999)];
        request.img_detail_file2 = fileDetailTimeStringSecond;
        request.img_detail_file2_desc = [self.secondDetailView getDetailDescContent];
        [paramsArray addObject:@"img_detail_file2"];
        [fileNameArray addObject:fileDetailTimeStringSecond];
        [fileDataArray addObject:[UIImage compressOriginalImage:[self.secondDetailView getDetailImage]]];
    }
    request.price = self.priceView.inputContent;
    Model_arts_Rsp *response = [[Model_arts_Rsp alloc] init];
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestUploadImagesParameters:request respondParameters:response paramsNames:[paramsArray copy] fileNames:[fileNameArray copy] fileData:[fileDataArray copy] callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            UIAlertController *alert = [UIAlertController alertShowWithTitle:@"提示" message:@"作品已上传，请等待审核\r\n可在“我的主页中”查看审核进度" cancel:@"取消" cancelHandler:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } confirm:@"去查看" confirmHandler:^{
                if (weakSelf.checkProcessBlock) {
                    weakSelf.checkProcessBlock();
                } else {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
        }
    }];
}

- (NSArray *)tempCateArray {
    if (!_tempCateArray) {
        NSMutableArray *cateArray = [NSMutableArray array];
        for (Model_arts_categories_Data *cateData in [AppSingleton sharedAppSingleton].artCategoryArray) {
            [cateArray addObject:cateData.title];
        }
        _tempCateArray = [cateArray copy];
    }
    return _tempCateArray;
}

- (NSArray *)tempThemeArray {
    if (!_tempThemeArray) {
        NSMutableArray *themeArray = [NSMutableArray array];
        for (Model_arts_themes_Data *themeData in [AppSingleton sharedAppSingleton].artThemeArray) {
            [themeArray addObject:themeData.title];
        }
        _tempThemeArray = [themeArray copy];
    }
    return _tempThemeArray;
}

- (NSArray *)tempMaterialArray {
    if (!_tempMaterialArray) {
        NSMutableArray *materialArray = [NSMutableArray array];
        for (Model_arts_materials_Data *materialData in [AppSingleton sharedAppSingleton].artMaterialArray) {
            [materialArray addObject:materialData.title];
        }
        _tempMaterialArray = [materialArray copy];
    }
    return _tempMaterialArray;
}
@end
