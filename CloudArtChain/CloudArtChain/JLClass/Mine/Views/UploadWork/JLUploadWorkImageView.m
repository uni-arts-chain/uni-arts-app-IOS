//
//  JLUploadWorkImageView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/17.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLUploadWorkImageView.h"
#import "UIAlertController+Alert.h"
#import "JLImageRectClipViewController.h"
#import "SLShotViewController.h"
#import "SLEditImageController.h"
#import <SDWebImage/UIImage+GIF.h>

@interface JLUploadWorkImageView ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *noticeView;
@end

@implementation JLUploadWorkImageView

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (instancetype)init {
    if (self = [super init]) {
        [self createView];
    }
    return self;
}

- (void)createView {
    [self addSubview:self.contentView];
    [self addSubview:self.noticeView];
    
    [self.noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(55.0f);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.bottom.equalTo(self.noticeView.mas_top);
    }];
    [self setupContentView];
}

- (UIView *)noticeView {
    if (!_noticeView) {
        _noticeView = [[UIView alloc] init];
        
        UIImageView *noticeImageView = [JLUIFactory imageViewInitImageName:@"icon_mine_upload_notice"];
        [_noticeView addSubview:noticeImageView];
        
        UILabel *noticeLabel = [JLUIFactory labelInitText:@"上传作品(支持静态图、GIF)" font:kFontPingFangSCRegular(12.0f) textColor:JL_color_other_B25F00 textAlignment:NSTextAlignmentLeft];
        [_noticeView addSubview:noticeLabel];
        
        [noticeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_noticeView);
            make.size.mas_equalTo(13.0f);
            make.centerY.equalTo(_noticeView.mas_centerY);
        }];
        [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(noticeImageView.mas_right).offset(5.0f);
            make.centerY.equalTo(noticeImageView.mas_centerY);
        }];
    }
    return _noticeView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (void)setupContentView {
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat itemWidth = (kScreenWidth - 15.0f * 2 - 11.0f * 2) / 3.0f;
    CGFloat itemSep = 11.0f;
    for (int i = 0; i < self.imageArray.count; i++) {
        UIView *itemView = [self itemViewWithIndex:i];
        [self.contentView addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(i * (itemWidth + itemSep));
            make.top.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(itemWidth);
        }];
    }
    if (self.imageArray.count < 3) {
        UIView *addView = [self uploadImageView];
        [self.contentView addSubview:addView];
        [addView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageArray.count * (itemWidth + itemSep));
            make.top.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(itemWidth);
        }];
    }
}

- (UIView *)uploadImageView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = JL_color_gray_EBEBEB;
    ViewBorderRadius(view, 5.0f, 0.0f, JL_color_clear);
    
    UIView *centerView = [[UIView alloc] init];
    [view addSubview:centerView];
    
    UIImageView *addImageView = [JLUIFactory imageViewInitImageName:@"icon_mine_upload_add"];
    [centerView addSubview:addImageView];
    
    UILabel *addLabel = [JLUIFactory labelInitText:@"上传图片" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_909090 textAlignment:NSTextAlignmentCenter];
    [centerView addSubview:addLabel];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addButton];
    
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.centerY.equalTo(view);
    }];
    [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerView);
        make.size.mas_equalTo(28.0f);
        make.centerX.equalTo(centerView);
    }];
    [addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(centerView);
        make.height.mas_equalTo(13.0f);
        make.top.equalTo(addImageView.mas_bottom).offset(12.0f);
    }];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    return view;
}

- (void)addButtonClick {
    WS(weakSelf)
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
            [weakSelf.controller presentViewController:picker animated:YES completion:nil];
        } else {
            SLShotViewController * shotViewController = [[SLShotViewController alloc] init];
            shotViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            shotViewController.getImageBlock = ^(UIImage * _Nonnull image) {
                JLUploadImageModel *imageModel = [JLUploadImageModel uploadImageModelWithImage:image imageType:@"png" imageData:nil];
                [weakSelf.imageArray addObject:imageModel];
                [weakSelf setupContentView];
            };
            [weakSelf.controller presentViewController:shotViewController animated:YES completion:nil];
        }
    }];
    [self.controller presentViewController:alert animated:YES completion:nil];
}

- (UIView *)itemViewWithIndex:(NSInteger)index {
    UIView *view = [[UIView alloc] init];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    JLUploadImageModel *imageModel = self.imageArray[index];
    if ([imageModel.imageType isEqualToString:@"gif"]) {
        UIImage *gifImage = [UIImage sd_imageWithGIFData:imageModel.imageData];
        imageView.image = gifImage;
    } else {
        imageView.image = imageModel.image;
    }
    ViewBorderRadius(imageView, 5.0f, 0.0f, JL_color_clear);
    [view addSubview:imageView];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setImage:[UIImage imageNamed:@"icon_mine_upload_delete"] forState:UIControlStateNormal];
    deleteBtn.tag = index;
    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:deleteBtn];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(view);
        make.top.mas_equalTo(6.0f);
        make.right.mas_equalTo(-7.0f);
    }];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(view);
        make.size.mas_equalTo(18.0f);
    }];
    
    return view;
}

- (void)deleteBtnClick:(UIButton *)sender {
    [self.imageArray removeObjectAtIndex:sender.tag];
    [self setupContentView];
}

#pragma mark - imagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    WS(weakSelf)
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    [picker dismissViewControllerAnimated:NO completion:nil];
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
//    WYImageRectClipViewController *clipView = [[WYImageRectClipViewController alloc] initWithImage:image];
//    clipView.delegate = self;
//    clipView.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self.controller.navigationController presentViewController:clipView animated:YES completion:nil];
    NSData *imageData = [NSData dataWithContentsOfFile:info[@"UIImagePickerControllerImageURL"]];
    NSString *imageType = [JLTool contentTypeForImageData:imageData];
    
    if ([imageType isEqualToString:@"gif"]) {
        JLUploadImageModel *imageModel = [JLUploadImageModel uploadImageModelWithImage:image imageType:@"gif" imageData:imageData];
        [self.imageArray addObject:imageModel];
        [self setupContentView];
    } else {
        SLEditImageController *editViewController = [[SLEditImageController alloc] init];
        editViewController.image = image;
        editViewController.saveToAlbum = NO;
        editViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        editViewController.imageEditBlock = ^(UIImage * _Nonnull image) {
            JLUploadImageModel *imageModel = [JLUploadImageModel uploadImageModelWithImage:image imageType:@"png" imageData:nil];
            [weakSelf.imageArray addObject:imageModel];
            [weakSelf setupContentView];
        };
        [self.controller.navigationController presentViewController:editViewController animated:NO completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:NO completion:nil];
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

//- (void)wyrectClipViewController:(WYImageRectClipViewController *)clipViewController finishClipImage:(UIImage *)editImage {
//    WS(weakSelf);
//    [clipViewController dismissViewControllerAnimated:YES completion:^{
//        [weakSelf.imageArray addObject:editImage];
//        [weakSelf setupContentView];
//    }];
//}

- (NSArray *)getImageArray {
    return [self.imageArray copy];
}
@end
