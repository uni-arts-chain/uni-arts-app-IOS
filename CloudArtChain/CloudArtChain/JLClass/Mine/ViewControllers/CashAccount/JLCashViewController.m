//
//  JLCashViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/14.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLCashViewController.h"
#import "JLCashContentView.h"
#import "SLEditImageController.h"

@interface JLCashViewController ()<JLCashContentViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) JLCashContentView *contentView;

@property (nonatomic, assign) NSInteger currentAddImageType; // 1: 支付宝 2: 微信

@end

@implementation JLCashViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现";
    [self addBackItem];
    
    [self.view addSubview:self.contentView];
    
    [self setContentData];
}

#pragma mark - JLCashContentViewDelegate
- (void)addImage:(NSInteger)type {
    self.currentAddImageType = type;
    [self chooseImage];
}

- (void)withdraw: (UIImage *)qrcode payType: (NSInteger)payType isNeedUploadQRImage: (BOOL)isNeedUploadQRImage {
    NSLog(@"提现 收款码图片: %@ --- 支付方式： %@ --- 是否需要创建或者更新收款码：%@", qrcode, payType == 1 ? @"alipay" : @"weixin", isNeedUploadQRImage == 0 ? @"不需要" : @"需要");
    if (isNeedUploadQRImage) {
        [self createPayQRCode:qrcode payType:payType == 1 ? @"alipay" : @"weixin"];
    }else {
        [self launchingWithdraw:_amount payType:payType == 1 ? @"alipay" : @"weixin"];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    WS(weakSelf)
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    
    SLEditImageController *editViewController = [[SLEditImageController alloc] init];
    editViewController.image = image;
    editViewController.saveToAlbum = NO;
    editViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    editViewController.imageEditBlock = ^(UIImage * _Nonnull image) {
        if (weakSelf.currentAddImageType == 1) {
            weakSelf.contentView.addAlipayQRCodeImage = image;
        }else {
            weakSelf.contentView.addWechatQRCodeImage = image;
        }
        [picker dismissViewControllerAnimated:NO completion:nil];
        if (@available(iOS 11.0, *)) {
            UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    };
    [picker presentViewController:editViewController animated:NO completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:NO completion:nil];
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

#pragma mark - loadDatas
/// 创建支付方式
- (void)createPayQRCode: (UIImage *)qrcode payType: (NSString *)payType {
    WS(weakSelf)
    Model_payment_methods_Req *request = [[Model_payment_methods_Req alloc] init];
    Model_payment_methods_Rsp *response = [[Model_payment_methods_Rsp alloc] init];
    
    NSString *fileName = [JLNetHelper getTimeString];
    NSString *paramName = @"";
    if ([payType isEqualToString:@"alipay"]) {
        request.alipay_img = fileName;
        paramName = @"alipay_img";
        if ([NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.alipay_img[@"url"]]) {
            request.isCreate = YES;
        }
    }else {
        request.weixin_img = fileName;
        paramName = @"weixin_img";
        if ([NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.weixin_img[@"url"]]) {
            request.isCreate = YES;
        }
    }
    NSData *imageData = [UIImage compressOriginalImage:qrcode];
    response.request = request;
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestPostUploadParameters:request respondParameters:response paramsName:paramName fileName:fileName fileData:imageData callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            NSLog(@"支付方式二维码已上传");
            NSString *payUrl = response.body[@"img"][@"url"];
            if (![NSString stringIsEmpty:payUrl]) {
                if ([payType isEqualToString:@"alipay"]) {
                    [AppSingleton sharedAppSingleton].userBody.alipay_img = @{ @"url": payUrl };
                }else {
                    [AppSingleton sharedAppSingleton].userBody.weixin_img = @{ @"url": payUrl };
                }
            }
            [weakSelf launchingWithdraw:weakSelf.amount payType:payType];
        } else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
        }
    }];
}

/// 发起提现
- (void)launchingWithdraw: (NSString *)amount payType: (NSString *)payType {
    WS(weakSelf)
    Model_withdraws_Req *request = [[Model_withdraws_Req alloc] init];
    request.amount = amount;
    request.pay_type = payType;
    Model_withdraws_Rsp *response = [[Model_withdraws_Rsp alloc] init];
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            [[JLLoading sharedLoading] showMBSuccessTipMessage:@"提现申请已提交" hideTime:KToastDismissDelayTimeInterval];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
        }
    }];
}

#pragma mark - private methods
- (void)setContentData {
    if (![NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.alipay_img[@"url"]]) {
        self.contentView.alipayImgUrl = [AppSingleton sharedAppSingleton].userBody.alipay_img[@"url"];
    }
    if (![NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.weixin_img[@"url"]]) {
        self.contentView.wechatImgUrl = [AppSingleton sharedAppSingleton].userBody.weixin_img[@"url"];
    }
}

- (void)chooseImage {
    WS(weakSelf)
    [[JLLoading sharedLoading] showLoadingWithMessage:@"请稍后..." onView:self.view];
    //从手机相册选择
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = weakSelf;
    picker.allowsEditing = NO;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    [self presentViewController:picker animated:YES completion:^{
        [[JLLoading sharedLoading] hideLoading];
    }];
}

#pragma mark - setters and getters
- (JLCashContentView *)contentView {
    if (!_contentView) {
        _contentView = [[JLCashContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height)];
        _contentView.delegate = self;
    }
    return _contentView;
}

@end
