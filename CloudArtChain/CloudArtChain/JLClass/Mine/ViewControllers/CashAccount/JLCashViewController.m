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

@property (nonatomic, assign) NSInteger currentAddImageType; // 0: 支付宝 1: 微信

@end

@implementation JLCashViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现";
    [self addBackItem];
    
    [self.view addSubview:self.contentView];
}

#pragma mark - JLCashContentViewDelegate
- (void)addImage:(NSInteger)type {
    
    self.currentAddImageType = type;
    
    [self chooseImage];
}

- (void)withdraw:(UIImage *)qrcode {
    NSLog(@"提现 收款码图片: %@", qrcode);
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
        if (weakSelf.currentAddImageType == 0) {
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

#pragma mark - private methods
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
