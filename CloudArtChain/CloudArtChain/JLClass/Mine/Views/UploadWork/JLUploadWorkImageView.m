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
#import "JLDocumentPickerViewController.h"
#import "SSZipArchive.h"

@interface JLUploadWorkImageView ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIDocumentPickerDelegate>
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *noticeView;

@property (nonatomic, strong) JLDocumentPickerViewController *documentPickerVC;
/** live2d文件名 */
@property (nonatomic, strong) NSString *live2dFileName;
/** live2d zip文件 */
@property (nonatomic, strong) NSString *live2dZipFilePath;
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
        if (self.imageArray.count > 0) {
            JLUploadImageModel *imageModel = self.imageArray[0];
            if ([imageModel.imageType isEqualToString:@"live2d"]) {
                return;
            }
        }
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
    NSArray *sourceArray = @[@"从相册选取", @"拍照", @"Live2D"];
    if (self.imageArray.count > 0) {
        sourceArray = @[@"从相册选取", @"拍照"];
    }
    UIAlertController *alert = [UIAlertController actionSheetWithButtonTitleArray:sourceArray handler:^(NSInteger index) {
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
        } else if (index == 1) {
            SLShotViewController * shotViewController = [[SLShotViewController alloc] init];
            shotViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            shotViewController.getImageBlock = ^(UIImage * _Nonnull image) {
                JLUploadImageModel *imageModel = [JLUploadImageModel uploadImageModelWithImage:image imageType:@"png" imageData:nil];
                [weakSelf.imageArray addObject:imageModel];
                [weakSelf setupContentView];
            };
            [weakSelf.controller presentViewController:shotViewController animated:YES completion:nil];
        } else {
            // 选择Live2D文件
            if (@available(iOS 11.0, *)) {
                UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
            }
            [weakSelf.controller presentViewController:self.documentPickerVC animated:YES completion:nil];
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

- (JLDocumentPickerViewController *)documentPickerVC {
    if (!_documentPickerVC) {
        NSArray *types = @[@"public.zip-archive"];
        _documentPickerVC = [[JLDocumentPickerViewController alloc] initWithDocumentTypes:types inMode:UIDocumentPickerModeOpen];
        _documentPickerVC.delegate = self;
        _documentPickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return _documentPickerVC;
}

#pragma mark - UIDocumentPickerDelegate
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    WS(weakSelf)
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    // 清空原有数据
    [self clearUploadDirectory];
    
    // 获取授权
    BOOL fileUrlAuthozied = [urls.firstObject startAccessingSecurityScopedResource];
    if (fileUrlAuthozied) {
        // 通过文件协调工具来得到新的文件地址，以此得到文件保护功能
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
        NSError *error;
        
        [fileCoordinator coordinateReadingItemAtURL:urls.firstObject options:0 error:&error byAccessor:^(NSURL * _Nonnull newURL) {
            // 读取文件
            NSString *fileName = [newURL lastPathComponent];
            NSError *error = nil;
            NSData *fileData = [NSData dataWithContentsOfURL:newURL options:NSDataReadingMappedIfSafe error:&error];
            NSLog(@"fileData.bytes : %dKB \n bytes : %ldKB",1024*1024*10,fileData.length);
            if (error) {
                // 文件读取出错
                [[JLLoading sharedLoading] showMBFailedTipMessage:@"文件读取出错" hideTime:KToastDismissDelayTimeInterval];
            } else {
                NSString *cacheFolder = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"UploadLive2DFile"];
                if (![[NSFileManager defaultManager] fileExistsAtPath:cacheFolder]) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:nil];
                }

                NSString *zipfilePath = [cacheFolder stringByAppendingPathComponent:fileName];

                // 保存zip文件到沙盒中
                BOOL saveSuccess = [fileData writeToFile:zipfilePath atomically:YES];
                // 解压zip文件
                if (saveSuccess) {
                    [self unzipLive2DFile:zipfilePath filePathBlock:^(NSString *filePath) {
                        if ([NSString stringIsEmpty:filePath]) {
                            [[JLLoading sharedLoading] showMBFailedTipMessage:@"文件格式错误" hideTime:KToastDismissDelayTimeInterval];
                        } else {
                            NSString *fileName = [filePath lastPathComponent];
                            AppDelegate* delegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
                            [weakSelf.controller presentViewController:delegate.lAppViewController animated:YES completion:nil];
                            [delegate initializeCubism];
                            NSString *modelPath = [filePath stringByAppendingString:@"/"];
                            NSString *modelJsonName = [NSString stringWithFormat:@"%@.model3.json", fileName];
                            [delegate changeSence:modelPath jsonName:modelJsonName];
                            
                            weakSelf.live2dFileName = fileName;
                            weakSelf.live2dZipFilePath = zipfilePath;
                        }
                    }];
                }
            }
        }];
        [urls.firstObject stopAccessingSecurityScopedResource];
    } else {
        // 授权失败
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"授权失败" hideTime:KToastDismissDelayTimeInterval];
    }
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)unzipLive2DFile:(NSString *)zipPath filePathBlock:(void(^)(NSString *filePath))filePathBlock {
    NSString *cacheFolder = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"UploadLive2DFile"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cacheFolder]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    __block NSString *fileDirectory = @"";
    [SSZipArchive unzipFileAtPath:zipPath toDestination:cacheFolder progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
        if (![NSString stringIsEmpty:entry] && [entry containsString:@"model3.json"] && [NSString stringIsEmpty:fileDirectory]) {
            NSString *fileName = [NSString stringWithFormat:@"/%@", [entry lastPathComponent]];
            fileDirectory = [entry stringByReplacingOccurrencesOfString:fileName withString:@""];
        }
    } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nonnull error) {
        if (succeeded) {
            if ([NSString stringIsEmpty:fileDirectory]) {
                if (filePathBlock) {
                    filePathBlock(@"");
                }
            } else {
                NSString *filePath = [cacheFolder stringByAppendingPathComponent:fileDirectory];
                if (filePathBlock) {
                    filePathBlock(filePath);
                }
            }
        } else {
            NSLog(@"error: %@", error);
        }
    }];
}

- (void)clearUploadDirectory {
    NSString *cacheFolder = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"UploadLive2DFile"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cacheFolder]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:cacheFolder error:nil];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *fileName;
    while (fileName = [e nextObject]) {
        NSError *error;
        [fileManager removeItemAtPath:[cacheFolder stringByAppendingPathComponent:fileName] error:&error];
        if (error) {
            NSLog(@"error: %@", error);
        }
    }
}

- (void)addLive2dSnapshotImage:(UIImage *)snapshotImage {
    JLUploadImageModel *imageModel = [JLUploadImageModel uploadImageModelWithImage:snapshotImage imageType:@"live2d" imageData:nil];
    imageModel.fileName = self.live2dFileName;
    imageModel.zipFilePath = self.live2dZipFilePath;
    [self.imageArray addObject:imageModel];
    [self setupContentView];
}
@end
