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
@property (nonatomic, strong) JLUploadWorkMoneyInputView *freightView;

@property (nonatomic, strong) UIButton *confirmUploadBtn;
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
    [self.scrollView addSubview:self.freightView];
    
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
    [self.freightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView);
        make.top.equalTo(self.priceView.mas_bottom).offset(20.0f);
        make.height.mas_equalTo(30.0f);
        make.width.mas_equalTo(kScreenWidth);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.freightView.frameBottom + 60.0f);
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
        _categoryView = [[JLUploadWorkSelectView alloc] initWithPlaceHolder:@"请选择分类" selectBlock:^{
            
        }];
    }
    return _categoryView;
}

- (JLUploadWorkSelectView *)themeView {
    if (!_themeView) {
        _themeView = [[JLUploadWorkSelectView alloc] initWithPlaceHolder:@"请选择题材" selectBlock:^{
            
        }];
    }
    return _themeView;
}

- (JLUploadWorkSelectView *)materialView {
    if (!_materialView) {
        _materialView = [[JLUploadWorkSelectView alloc] initWithPlaceHolder:@"请选择作品材质" selectBlock:^{
            
        }];
    }
    return _materialView;
}

- (JLUploadWorkSelectView *)createDateView {
    if (!_createDateView) {
        _createDateView = [[JLUploadWorkSelectView alloc] initWithPlaceHolder:@"请选择创作时间" selectBlock:^{
            
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
        _workDetailView = [[JLUploadWorkDescriptionView alloc] initWithMax:200 placeholder:@"请输入你对作品的整体评析..." placeHolderColor:nil textFont:nil textColor:nil];
    }
    return _workDetailView;
}

- (JLUploadWorkDetailView *)firstDetailView {
    if (!_firstDetailView) {
        _firstDetailView = [[JLUploadWorkDetailView alloc] init];
    }
    return _firstDetailView;
}

- (JLUploadWorkDetailView *)secondDetailView {
    if (!_secondDetailView) {
        _secondDetailView = [[JLUploadWorkDetailView alloc] init];
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

- (JLUploadWorkMoneyInputView *)freightView {
    if (!_freightView) {
        _freightView = [[JLUploadWorkMoneyInputView alloc] initWithTitle:@"运费"];
    }
    return _freightView;
}

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
    [self.navigationController popViewControllerAnimated:YES];
}
@end
