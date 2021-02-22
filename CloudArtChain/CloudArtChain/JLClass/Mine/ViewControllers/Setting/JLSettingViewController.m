//
//  JLSettingViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/15.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLSettingViewController.h"
#import "UIAlertController+Alert.h"
#import "JLModifyNickNameViewController.h"
#import "JLPersonalDescriptionViewController.h"
#import "JLBindPhoneWithoutPwdViewController.h"
#import "JLForgetPwdViewController.h"
#import "JLRealNameAuthVC.h"
#import "WYImageRectClipViewController.h"
#import <AVKit/AVKit.h>
#import "HVideoViewController.h"

#import "JLSettingTableViewCell.h"

@interface JLSettingViewController ()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, WYImageRectClipViewControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UIView *footerView;
@end

@implementation JLSettingViewController

- (NSArray *)titleArray {
    if (!_titleArray) {
//        _titleArray = @[@[@"头像", @"昵称", @"描述"], @[@"手机号", @"微信", @"登录密码"], @[@"实人认证", @"支付宝实名认证"]];
        _titleArray = @[@[@"头像", @"昵称", @"描述"], @[@"手机号"]];
    }
    return _titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = JL_color_gray_F6F6F6;
    [self addBackItem];
    [self createSubViews];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)createSubViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.mas_equalTo(-KTouch_Responder_Height);
    }];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JL_color_gray_F6F6F6;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 60.0f;
        _tableView.estimatedSectionHeaderHeight = 0.0f;
        _tableView.estimatedSectionFooterHeight = 10.0f;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = self.footerView;
        [_tableView registerClass:[JLSettingTableViewCell class] forCellReuseIdentifier:@"JLSettingTableViewCell"];
    }
    return _tableView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, 48.0f)];
        _footerView.backgroundColor = JL_color_white_ffffff;
        
        UIButton *loginoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [loginoutBtn setTitleColor:JL_color_red_D70000 forState:UIControlStateNormal];
        loginoutBtn.titleLabel.font = kFontPingFangSCRegular(16.0f);
        [loginoutBtn addTarget:self action:@selector(loginoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:loginoutBtn];
        [loginoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_footerView);
        }];
    }
    return _footerView;
}

- (void)loginoutBtnClick {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArray = self.titleArray[section];
    return sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JLSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLSettingTableViewCell" forIndexPath:indexPath];
    NSArray *sectionArray = self.titleArray[indexPath.section];
    [cell setTitle:self.titleArray[indexPath.section][indexPath.row] status:@"" isAvatar:(indexPath.section == 0 && indexPath.row == 0) showLine:indexPath.row != sectionArray.count - 1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = JL_color_gray_F6F6F6;
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                UIAlertController *alert = [UIAlertController actionSheetWithButtonTitleArray:@[@"从相册选取", @"拍照"] handler:^(NSInteger index) {
                    if (index == 0) {
                        //从手机相册选择
                        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        picker.delegate = weakSelf;
                        picker.modalPresentationStyle = UIModalPresentationFullScreen;
                        if (@available(iOS 11.0, *)) {
                            UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
                        }
                        [weakSelf presentViewController:picker animated:YES completion:nil];
                    } else {
                        [weakSelf takePhoto];
                    }
                }];
                [self presentViewController:alert animated:YES completion:nil];
            }
                break;
            case 1:
            {
                JLModifyNickNameViewController *modifyNickNameVC = [[JLModifyNickNameViewController alloc] init];
                modifyNickNameVC.saveBlock = ^(NSString * _Nonnull nickName) {
                    
                };
                [self.navigationController pushViewController:modifyNickNameVC animated:YES];
            }
                break;
            case 2:
            {
                JLPersonalDescriptionViewController *personalDescVC = [[JLPersonalDescriptionViewController alloc] init];
                personalDescVC.saveBlock = ^(NSString * _Nonnull desc) {
                    
                };
                [self.navigationController pushViewController:personalDescVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                JLBindPhoneWithoutPwdViewController *bindPhoneVC = [[JLBindPhoneWithoutPwdViewController alloc] init];
                [self.navigationController pushViewController:bindPhoneVC animated:YES];
            }
                break;
            case 1:
            {
                
            }
                break;
            case 2:
            {
                JLForgetPwdViewController *forgetPwdVC = [[JLForgetPwdViewController alloc] init];
                forgetPwdVC.forgetPwdType = JLForgetPwdTypeModify;
                [self.navigationController pushViewController:forgetPwdVC animated:YES];
            }
                break;
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
            {
                JLRealNameAuthVC *realNameVC = [[JLRealNameAuthVC alloc] init];
                [self.navigationController pushViewController:realNameVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - imagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    [picker dismissViewControllerAnimated:NO completion:nil];
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    WYImageRectClipViewController *clipView = [[WYImageRectClipViewController alloc] initWithImage:image];
    clipView.delegate = self;
    clipView.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:clipView animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:NO completion:nil];
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)wyrectClipViewController:(WYImageRectClipViewController *)clipViewController finishClipImage:(UIImage *)editImage {
    WS(weakSelf);
    [clipViewController dismissViewControllerAnimated:YES completion:^{
        JLSettingTableViewCell *avatarCell = (JLSettingTableViewCell *)[weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [avatarCell setAvatarImage:editImage];
    }];
}

- (void)takePhoto {
    WS(weakSelf)
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [JLAlert jlalertDefaultView:@"检测不到相机设备" cancel:@"确定"];
        return;
    }
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        [JLAlert jlalertDefaultView:@"相机权限受限" cancel:@"确定"];
        return;
    }
    
//    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//    imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
//    imagePickerController.delegate = self;
//    [self presentViewController:imagePickerController animated:YES completion:nil];
    //拍照
    HVideoViewController *videoView = [[NSBundle mainBundle] loadNibNamed:@"HVideoViewController" owner:nil options:nil].lastObject;
    __block typeof(videoView) weakVideoView = videoView;
    videoView.allowTakeVideo = NO;
    videoView.takeBlock = ^(id item) {
        [weakVideoView dismissViewControllerAnimated:YES completion:^{
            if ([item isKindOfClass:[UIImage class]]) {
                WYImageRectClipViewController *clipView = [[WYImageRectClipViewController alloc] initWithImage:item];
                clipView.delegate = weakSelf;
                clipView.modalPresentationStyle = UIModalPresentationFullScreen;
                [weakSelf.navigationController presentViewController:clipView animated:YES completion:nil];
            }
        }];
    };
    videoView.modalPresentationStyle = UIModalPresentationFullScreen;
    [weakSelf presentViewController:videoView animated:YES completion:nil];
}
@end
