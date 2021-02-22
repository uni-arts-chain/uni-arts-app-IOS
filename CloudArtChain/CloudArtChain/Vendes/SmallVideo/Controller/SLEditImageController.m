//
//  SLEditImageController.m
//  DarkMode
//
//  Created by wsl on 2019/10/31.
//  Copyright © 2019 wsl. All rights reserved.
//

#import "SLEditImageController.h"
#import <Photos/Photos.h>
#import "UIView+SLImage.h"
#import "SLBlurView.h"
#import "SLEditMenuView.h"
#import "SLEditSelectedBox.h"
#import "SLImage.h"
#import "SLImageView.h"
#import "SLDrawView.h"
#import "SLEditTextView.h"
#import "SLMosaicView.h"
#import "UIImage+SLCommon.h"
#import "SLImageZoomView.h"
#import "SLImageClipController.h"

@interface SLEditImageController ()<UIGestureRecognizerDelegate, SLImageZoomViewDelegate>

@property (nonatomic, strong) SLImageZoomView *zoomView; // 预览视图 展示编辑的图片 可以缩放

@property (nonatomic, strong) UIView *editView;
@property (nonatomic, strong) UIImageView *editViewBackImageView;
@property (nonatomic, strong) UIButton *editBtn; //编辑
@property (nonatomic, strong) UIButton *againShotBtn;  // 再拍一次
@property (nonatomic, strong) UIButton *saveAlbumBtn;  //保存到相册

@property (nonatomic, strong) UIButton *cancleEditBtn; //取消编辑
@property (nonatomic, strong) UIButton *doneEditBtn; //完成编辑
@property (nonatomic, strong) SLEditMenuView *editMenuView; //编辑菜单栏
@property (nonatomic, strong) UIButton *trashTips; //垃圾桶提示 拖拽删除 贴图或文字

@property (nonatomic, strong) SLDrawView *drawView; // 涂鸦视图
@property (nonatomic, strong) NSMutableArray *watermarkArray; // 水印层 所有的贴图和文本
@property (nonatomic, strong) SLEditSelectedBox *selectedBox; //水印选中框
@property (nonatomic, strong) SLMosaicView *mosaicView; //马赛克画板

@property (nonatomic, assign) SLEditMenuType editingMenuType; //当前正在编辑的菜单类型
@end

@implementation SLEditImageController

#pragma mark - Override
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"图片编辑视图释放了");
}

#pragma mark - UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.zoomView];
    self.zoomView.pinchGestureRecognizer.enabled = NO;
    self.zoomView.image = self.image;
    if (self.image.size.width > 0.0f) {
       self.zoomView.imageView.frame = CGRectMake(0.0f, 0.0f, self.zoomView.sl_w, self.zoomView.sl_w * self.image.size.height/self.image.size.width);
    }
    if (self.zoomView.imageView.sl_h <= self.zoomView.sl_h) {
        self.zoomView.imageView.center = CGPointMake(self.zoomView.sl_w / 2.0f, self.zoomView.sl_h / 2.0f);
    }
    
    //添加裁剪完成监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageClippingComplete:) name:@"sl_ImageClippingComplete" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageClippingCancel) name:@"sl_ImageClippingCancel" object:nil];
    
    [self.view addSubview:self.editView];
    [self.editView addSubview:self.editViewBackImageView];
    [self.editView addSubview:self.againShotBtn];
    [self.editView addSubview:self.editBtn];
    [self.editView addSubview:self.saveAlbumBtn];
    
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(-KTouch_Responder_Height);
        make.height.mas_equalTo(75.0f);
    }];
    [self.editViewBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.editView);
    }];
    [self.againShotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24.0f);
        make.top.bottom.equalTo(self.editView);
    }];
    [self.saveAlbumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-24.0f);
        make.top.bottom.equalTo(self.editView);
    }];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.editView);
        make.width.mas_equalTo(31.0f);
        make.height.mas_equalTo(29.0f);
    }];
    
    [self.view addSubview:self.cancleEditBtn];
    [self.view addSubview:self.doneEditBtn];
}

#pragma mark - HelpMethods
// 添加拖拽、缩放、旋转、单击、双击手势
- (void)addRotateAndPinchGestureRecognizer:(UIView *)view {
    //单击手势选中
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [view addGestureRecognizer:singleTap];
    if ([view isKindOfClass:[UILabel class]]) {
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
        doubleTap.numberOfTapsRequired = 2;
        doubleTap.numberOfTouchesRequired = 1;
        [singleTap requireGestureRecognizerToFail:doubleTap];
        [view addGestureRecognizer:doubleTap];
    }
    //拖拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragAction:)];
    pan.minimumNumberOfTouches = 1;
    [view addGestureRecognizer:pan];
    //缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    pinchGestureRecognizer.delegate = self;
    [view addGestureRecognizer:pinchGestureRecognizer];
    //旋转手势
    UIRotationGestureRecognizer *rotateRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateAction:)];
    [view addGestureRecognizer:rotateRecognizer];
    rotateRecognizer.delegate = self;
}

//置顶视图
- (void)topSelectedView:(UIView *)topView {
    [self.zoomView.imageView bringSubviewToFront:topView];
    [self.watermarkArray removeObject:topView];
    [self.watermarkArray addObject:topView];
    [SLDelayPerform sl_cancelDelayPerform]; //取消延迟执行
    self.selectedBox.frame = topView.bounds;
    [topView addSubview:self.selectedBox];
}

// 隐藏预览按钮
- (void)hiddenPreviewButton:(BOOL)isHidden {
    self.againShotBtn.hidden = isHidden;
    self.editBtn.hidden = isHidden;
    self.saveAlbumBtn.hidden = isHidden;
}

// 隐藏编辑时菜单按钮
- (void)hiddenEditMenus:(BOOL)isHidden {
    self.cancleEditBtn.hidden = isHidden;
    self.doneEditBtn.hidden = isHidden;
    self.editMenuView.hidden = isHidden;
}

#pragma mark - Setter
- (void)setEditingMenuType:(SLEditMenuType)editingMenuType {
    _editingMenuType = editingMenuType;
    switch (_editingMenuType) {
        case SLEditMenuTypeUnknown:
            self.zoomView.scrollEnabled = YES;
            self.zoomView.pinchGestureRecognizer.enabled = YES;
            break;
        case SLEditMenuTypeGraffiti:
            self.zoomView.pinchGestureRecognizer.enabled = YES;
            self.zoomView.scrollEnabled = NO;
            break;
        case SLEditMenuTypeText:
            self.zoomView.scrollEnabled = YES;
            self.zoomView.pinchGestureRecognizer.enabled = NO;
            break;
        case SLEditMenuTypeSticking:
            self.zoomView.scrollEnabled = YES;
            self.zoomView.pinchGestureRecognizer.enabled = NO;
            break;
        case SLEditMenuTypePictureMosaic:
            self.zoomView.scrollEnabled = NO;
            self.zoomView.pinchGestureRecognizer.enabled = YES;
            break;
        case SLEditMenuTypePictureClipping:
            self.zoomView.scrollEnabled = YES;
            self.zoomView.pinchGestureRecognizer.enabled = YES;
            break;
        default:
            break;
    }
}

#pragma mark - Getter
- (SLImageZoomView *)zoomView {
    if (_zoomView == nil) {
        _zoomView = [[SLImageZoomView alloc] initWithFrame:self.view.bounds];
        _zoomView.backgroundColor = [UIColor blackColor];
        _zoomView.userInteractionEnabled = YES;
        _zoomView.maximumZoomScale = 4.0f;
        _zoomView.zoomViewDelegate = self;
    }
    return _zoomView;
}

- (UIView *)editView {
    if (!_editView) {
        _editView = [[UIView alloc] init];
    }
    return _editView;
}

- (UIImageView *)editViewBackImageView {
    if (!_editViewBackImageView) {
        _editViewBackImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_imageclip_back"]];
    }
    return _editViewBackImageView;
}

- (UIButton *)editBtn {
    if (_editBtn == nil) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setImage:[UIImage imageNamed:@"icon_imageclip_clip"] forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

- (UIButton *)againShotBtn {
    if (_againShotBtn == nil) {
        _againShotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_againShotBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_againShotBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _againShotBtn.titleLabel.font = kFontPingFangSCRegular(16.0f);
        [_againShotBtn addTarget:self action:@selector(againShotBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _againShotBtn;
}

- (UIButton *)saveAlbumBtn {
    if (_saveAlbumBtn == nil) {
        _saveAlbumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveAlbumBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_saveAlbumBtn setTitleColor:JL_color_blue_38B2F1 forState:UIControlStateNormal];
        _saveAlbumBtn.titleLabel.font = kFontPingFangSCRegular(16.0f);
        [_saveAlbumBtn addTarget:self action:@selector(saveAlbumBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveAlbumBtn;
}

- (UIButton *)cancleEditBtn {
    if (_cancleEditBtn == nil) {
        _cancleEditBtn = [[UIButton alloc] initWithFrame:CGRectMake(15.0f, 30.0f, 40.0f, 30.0f)];
        _cancleEditBtn.hidden = YES;
        [_cancleEditBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleEditBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancleEditBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_cancleEditBtn addTarget:self action:@selector(cancleEditBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleEditBtn;
}

- (UIButton *)doneEditBtn {
    if (_doneEditBtn == nil) {
        _doneEditBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.sl_w - 50.0f - 15.0f, 30.0f, 40.0f, 30.0f)];
        _doneEditBtn.hidden = YES;
        _doneEditBtn.backgroundColor = [UIColor colorWithRed:140.0f / 255.0f green:213.0f / 255.0f blue:155.0f / 255.0f alpha:1.0f];
        [_doneEditBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_doneEditBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _doneEditBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _doneEditBtn.layer.cornerRadius = 4.0f;
        [_doneEditBtn addTarget:self action:@selector(doneEditBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneEditBtn;
}

- (SLEditMenuView *)editMenuView {
    if (!_editMenuView) {
        _editMenuView = [[SLEditMenuView alloc] initWithFrame:CGRectMake(0.0f, self.view.sl_h - 80.0f - 60.0f, self.view.sl_w, 80.0f + 60.0f)];
        _editMenuView.hidden = YES;
        __weak typeof(self) weakSelf = self;
        _editMenuView.editObject = SLEditObjectPicture;
        _editMenuView.selectEditMenu = ^(SLEditMenuType editMenuType, NSDictionary * _Nullable setting) {
            weakSelf.editingMenuType = ![setting[@"hidden"] boolValue] ? editMenuType : SLEditMenuTypeUnknown;
            if (editMenuType == SLEditMenuTypeGraffiti) {
                weakSelf.drawView.userInteractionEnabled = ![setting[@"hidden"] boolValue];
                if ([setting[@"hidden"] boolValue]) weakSelf.editingMenuType = SLEditMenuTypeUnknown;
                [weakSelf.zoomView.imageView insertSubview:weakSelf.drawView atIndex:([weakSelf.zoomView.imageView.subviews containsObject:weakSelf.mosaicView] ? 1: 0)];
                if (setting[@"lineColor"]) {
                    weakSelf.drawView.lineColor = setting[@"lineColor"];
                }
                if (setting[@"goBack"]) {
                    [weakSelf.drawView goBack];
                }
            } else {
                weakSelf.drawView.userInteractionEnabled = NO;
            }
            if (editMenuType == SLEditMenuTypeSticking) {
                SLImage *image = setting[@"image"];
                if ([setting[@"hidden"] boolValue]) weakSelf.editingMenuType = SLEditMenuTypeUnknown;
                if (image) {
                    SLImageView *imageView = [[SLImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, image.size.width/[UIScreen mainScreen].scale, image.size.height/[UIScreen mainScreen].scale)];
                    imageView.autoPlayAnimatedImage = NO;
                    imageView.userInteractionEnabled = YES;
                    CGRect imageRect = [weakSelf.zoomView convertRect:weakSelf.zoomView.imageView.frame toView:weakSelf.view];
                    CGPoint center = CGPointZero;
                    center.x = fabs(imageRect.origin.x)+weakSelf.zoomView.sl_w / 2.0f;
                    center.y = 0.0f;
                    if (imageRect.origin.y >= 0.0f && imageRect.size.height <= weakSelf.zoomView.sl_h) {
                        center.y = imageRect.size.height / 2.0f;
                    } else {
                        center.y = fabs(imageRect.origin.y) + weakSelf.zoomView.sl_h / 2.0f;
                    }
                    imageView.transform = CGAffineTransformMakeScale(1.0f / weakSelf.zoomView.zoomScale, 1.0f / weakSelf.zoomView.zoomScale);
                    center = CGPointMake(center.x / weakSelf.zoomView.zoomScale, center.y / weakSelf.zoomView.zoomScale);
                    imageView.center = center;
                    imageView.image = image;
                    [weakSelf.watermarkArray addObject:imageView];
                    [weakSelf.zoomView.imageView addSubview:imageView];
                    [weakSelf addRotateAndPinchGestureRecognizer:imageView];
                    [weakSelf topSelectedView:imageView];
                    [SLDelayPerform sl_startDelayPerform:^{
                        [weakSelf.selectedBox removeFromSuperview];
                    } afterDelay:1.0f];
                }
            }
            if (editMenuType == SLEditMenuTypeText) {
                SLEditTextView *editTextView = [[SLEditTextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SL_kScreenWidth, SL_kScreenHeight)];
                [weakSelf.view addSubview:editTextView];
                if ([setting[@"hidden"] boolValue]) weakSelf.editingMenuType = SLEditMenuTypeUnknown;
                editTextView.editTextCompleted = ^(UILabel * _Nullable label) {
                    if (label.text.length == 0 || label == nil) {
                        return;
                    }
                    CGRect imageRect = [weakSelf.zoomView convertRect:weakSelf.zoomView.imageView.frame toView:weakSelf.view];
                    CGPoint center = CGPointZero;
                    center.x = fabs(imageRect.origin.x)+weakSelf.zoomView.sl_w / 2.0f;
                    center.y = 0.0f;
                    if (imageRect.origin.y >= 0.0f && imageRect.size.height <= weakSelf.zoomView.sl_h) {
                        center.y = imageRect.size.height / 2.0f;
                    } else {
                        center.y = fabs(imageRect.origin.y) + weakSelf.zoomView.sl_h / 2.0f;
                    }
                    label.transform = CGAffineTransformMakeScale(1.0f / weakSelf.zoomView.zoomScale, 1.0f / weakSelf.zoomView.zoomScale);
                    center = CGPointMake(center.x / weakSelf.zoomView.zoomScale, center.y / weakSelf.zoomView.zoomScale);
                    label.center = center;
                    [weakSelf.zoomView.imageView addSubview:label];
                    [weakSelf.watermarkArray addObject:label];
                    [weakSelf addRotateAndPinchGestureRecognizer:label];
                    [weakSelf topSelectedView:label];
                    [SLDelayPerform sl_startDelayPerform:^{
                        [weakSelf.selectedBox removeFromSuperview];
                    } afterDelay:1.0f];
                };
            }
            if(editMenuType == SLEditMenuTypePictureMosaic) {
                if (setting[@"mosaicType"]) {
                    weakSelf.mosaicView.userInteractionEnabled = ![setting[@"hidden"] boolValue];
                    if ([setting[@"hidden"] boolValue]) weakSelf.editingMenuType = SLEditMenuTypeUnknown;
                    weakSelf.mosaicView.mosaicType = [setting[@"mosaicType"] integerValue];
                    [weakSelf.zoomView.imageView insertSubview:weakSelf.mosaicView atIndex:0];
                }
                if (setting[@"goBack"]) {
                    [weakSelf.mosaicView goBack];
                }
            } else {
                weakSelf.mosaicView.userInteractionEnabled = NO;
            }
            if (editMenuType == SLEditMenuTypePictureClipping) {
                SLImageClipController *imageClipController = [[SLImageClipController alloc] init];
                imageClipController.modalPresentationStyle = UIModalPresentationFullScreen;
                [weakSelf.selectedBox removeFromSuperview];
                UIImage *image = [weakSelf.zoomView.imageView sl_imageByViewInRect:weakSelf.zoomView.imageView.bounds];
                imageClipController.image = image;
                [weakSelf presentViewController:imageClipController animated:NO completion:nil];
            }
        };
        [self.view addSubview:_editMenuView];
        [_editMenuView defaultClipAction];
    }
    return _editMenuView;
}

- (UIButton *)trashTips {
    if (!_trashTips) {
        _trashTips = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 20.0f)];
        _trashTips.center = CGPointMake(SL_kScreenWidth / 2.0f, SL_kScreenHeight - 60.0f);
        [_trashTips setTitle:@"拖动到此处删除" forState:UIControlStateNormal];
        [_trashTips setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _trashTips.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _trashTips;
}

- (SLDrawView *)drawView {
    if (!_drawView) {
        _drawView = [[SLDrawView alloc] initWithFrame:self.zoomView.imageView.bounds];
        _drawView.backgroundColor = [UIColor clearColor];
        _drawView.lineWidth = 5.0f;
        __weak typeof(self) weakSelf = self;
        _drawView.drawBegan = ^{
            [weakSelf hiddenEditMenus:YES];
        };
        _drawView.drawEnded = ^{
            [weakSelf hiddenEditMenus:NO];
        };
    }
    return _drawView;
}

- (NSMutableArray *)watermarkArray {
    if (!_watermarkArray) {
        _watermarkArray = [NSMutableArray array];
    }
    return _watermarkArray;
}

- (SLEditSelectedBox *)selectedBox {
    if (!_selectedBox) {
        _selectedBox = [[SLEditSelectedBox alloc] init];
    }
    return _selectedBox;
}

- (SLMosaicView *)mosaicView {
    if (!_mosaicView) {
        _mosaicView = [[SLMosaicView alloc] initWithFrame:self.zoomView.imageView.bounds];
        __weak typeof(self) weakSelf = self;
        _mosaicView.squareWidth = 15.0f;
        _mosaicView.paintSize = CGSizeMake(40.0f, 40.0f);
        _mosaicView.brushColor = ^UIColor *(CGPoint point) {
            point.x = point.x / weakSelf.view.frame.size.width * weakSelf.zoomView.image.size.width;
            point.y = point.y / weakSelf.view.frame.size.height * weakSelf.zoomView.image.size.height;
            point.x = point.x / self.zoomView.zoomScale;
            point.y = point.y / self.zoomView.zoomScale;
            return [weakSelf.zoomView.image sl_colorAtPixel:point];
        };
        _mosaicView.brushBegan = ^{
            [weakSelf hiddenEditMenus:YES];
        };
        _mosaicView.brushEnded = ^{
            [weakSelf hiddenEditMenus:NO];
        };
        _mosaicView.userInteractionEnabled = YES;
    }
    return _mosaicView;
}

#pragma mark - Events Handle
//编辑
- (void)editBtnClicked:(id)sender {
    self.zoomView.pinchGestureRecognizer.enabled = YES;
    [self hiddenEditMenus:NO];
    [self hiddenPreviewButton:YES];
}

//再试一次 继续拍摄
- (void)againShotBtnClicked:(id)sender {
    if (self.againShotBlock) {
        self.againShotBlock();
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

//保存到相册
- (void)saveAlbumBtnClicked:(id)sender {
    if (self.saveToAlbum) {
        if(self.image) {
            UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    SL_DISPATCH_ON_MAIN_THREAD(^{
        [self dismissViewControllerAnimated:NO completion:nil];
        if (self.image && self.imageEditBlock) {
            self.imageEditBlock(self.image);
        }
    });
}

//保存图片完成后调用的方法
- (void)savedPhotoImage:(UIImage*)image didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        NSLog(@"保存图片出错%@", error.localizedDescription);
    } else {
        NSLog(@"保存图片成功");
    }
}

//取消编辑
- (void)cancleEditBtnClicked:(id)sender {
    [self hiddenPreviewButton:NO];
    [self hiddenEditMenus:YES];
    [self.selectedBox removeFromSuperview];
    [_editMenuView removeFromSuperview];
    _editMenuView = nil;
    [_drawView removeFromSuperview];
    _drawView = nil;
    [_mosaicView removeFromSuperview];
    _mosaicView = nil;
    for (UIView *view in self.watermarkArray) {
        [view removeFromSuperview];
    }
    [self.watermarkArray removeAllObjects];
    self.zoomView.zoomScale = 1.0f;
    self.zoomView.image = self.image;
    self.zoomView.pinchGestureRecognizer.enabled = NO;
    self.zoomView.imageView.frame = CGRectMake(0.0f, 0.0f, self.zoomView.sl_w, self.zoomView.sl_w * self.image.size.height / self.image.size.width);
    if (self.zoomView.imageView.sl_h <= self.zoomView.sl_h) {
        self.zoomView.imageView.center = CGPointMake(self.zoomView.sl_w / 2.0f, self.zoomView.sl_h / 2.0f);
    }
    self.zoomView.contentSize = CGSizeMake(self.zoomView.imageView.sl_w, self.zoomView.imageView.sl_h);
}

//完成编辑 导出编辑后的对象
- (void)doneEditBtnClicked:(id)sender {
    [self.selectedBox removeFromSuperview];
    self.image = [self.zoomView.imageView sl_imageByViewInRect:self.zoomView.imageView.bounds];
    [self cancleEditBtnClicked:nil];
}

// 点击水印视图
- (void)singleTapAction:(UITapGestureRecognizer *)singleTap {
    [self topSelectedView:singleTap.view];
    if (singleTap.state == UIGestureRecognizerStateFailed || singleTap.state == UIGestureRecognizerStateEnded) {
        [SLDelayPerform sl_startDelayPerform:^{
            [self.selectedBox removeFromSuperview];
        } afterDelay:1.0f];
    }
}

//双击 文本水印 开始编辑文本
- (void)doubleTapAction:(UITapGestureRecognizer *)doubleTap {
    [self topSelectedView:doubleTap.view];
    doubleTap.view.hidden = YES;
    UILabel *tapLabel = (UILabel *)doubleTap.view;
    SLEditTextView *editTextView = [[SLEditTextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SL_kScreenWidth, SL_kScreenHeight)];
    editTextView.configureEditParameters(@{@"textColor":tapLabel.textColor, @"backgroundColor":tapLabel.backgroundColor, @"text":tapLabel.text});
    editTextView.editTextCompleted = ^(UILabel * _Nullable label) {
        doubleTap.view.hidden = NO;
        if (label == nil) {
            return;
        }
        label.transform = tapLabel.transform;
        label.center = tapLabel.center;
        [tapLabel removeFromSuperview];
        [self.watermarkArray removeObject:tapLabel];
        [self.watermarkArray addObject:label];
        [self.zoomView.imageView addSubview:label];
        [self addRotateAndPinchGestureRecognizer:label];
        [self topSelectedView:label];
        [SLDelayPerform sl_startDelayPerform:^{
            [self.selectedBox removeFromSuperview];
        } afterDelay:1.0f];
    };
    [self.view addSubview:editTextView];
}

// 拖拽 水印视图
- (void)dragAction:(UIPanGestureRecognizer *)pan {
    // 返回的是相对于最原始的手指的偏移量
    CGPoint transP = [pan translationInView:self.zoomView.imageView];
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.zoomView.imageView.clipsToBounds = NO;
        [self hiddenEditMenus:YES];
        [self.view addSubview:self.trashTips];
        [self topSelectedView:pan.view];
    } else if (pan.state == UIGestureRecognizerStateChanged ) {
        pan.view.center = CGPointMake(pan.view.center.x + transP.x, pan.view.center.y + transP.y);
        [pan setTranslation:CGPointZero inView:self.zoomView.imageView];
        //获取拖拽的视图在屏幕上的位置
        CGRect rect = [pan.view convertRect: pan.view.bounds toView:self.view];
        //是否删除 删除视图Y < 视图中心点Y坐标
        if (self.trashTips.center.y < rect.origin.y+rect.size.height / 2.0f) {
            [self.trashTips setTitle:@"松手即可删除" forState:UIControlStateNormal];
            [self.trashTips setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        } else {
            [self.trashTips setTitle:@"拖动到此处删除" forState:UIControlStateNormal];
            [self.trashTips setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    } else if (pan.state == UIGestureRecognizerStateFailed || pan.state == UIGestureRecognizerStateEnded) {
        [self hiddenEditMenus:NO];
        self.zoomView.imageView.clipsToBounds = YES;
        //获取拖拽的视图在屏幕上的位置
        CGRect rect = [pan.view convertRect: pan.view.bounds toView:self.view];
        CGRect imageRect = [self.zoomView convertRect:self.zoomView.imageView.frame toView:self.view];
        //删除拖拽的视图
        if (self.trashTips.center.y < rect.origin.y+rect.size.height / 2.0f) {
            [pan.view  removeFromSuperview];
            [self.watermarkArray removeObject:(SLImageView *)pan.view];
        } else if (!CGRectIntersectsRect(imageRect, rect)) {
            //如果出了父视图zoomView的范围，则置于父视图中心
            CGPoint center = CGPointZero;
            center.x = fabs(imageRect.origin.x)+self.zoomView.sl_w / 2.0f;
            center.y = 0.0f;
            if (imageRect.origin.y >= 0.0f && imageRect.size.height <= self.zoomView.sl_h) {
                center.y = imageRect.size.height / 2.0f;
            } else {
                center.y = fabs(imageRect.origin.y) + self.zoomView.sl_h / 2.0f;
            }
            center = CGPointMake(center.x/self.zoomView.zoomScale, center.y/self.zoomView.zoomScale);
            pan.view.center = center;
        }
        [self.trashTips removeFromSuperview];
        [SLDelayPerform sl_startDelayPerform:^{
            [self.selectedBox removeFromSuperview];
        } afterDelay:1.0f];
    }
}

//缩放 水印视图
- (void)pinchAction:(UIPinchGestureRecognizer *)pinch {
    if (pinch.state == UIGestureRecognizerStateBegan) {
        [self topSelectedView:pinch.view];
        self.zoomView.pinchGestureRecognizer.enabled = NO;
        self.zoomView.imageView.clipsToBounds = NO;
    }else if (pinch.state == UIGestureRecognizerStateFailed || pinch.state == UIGestureRecognizerStateEnded){
        [SLDelayPerform sl_startDelayPerform:^{
            [self.selectedBox removeFromSuperview];
        } afterDelay:1.0f];
        self.zoomView.pinchGestureRecognizer.enabled = YES;
        self.zoomView.imageView.clipsToBounds = YES;
    }
    pinch.view.transform = CGAffineTransformScale(pinch.view.transform, pinch.scale, pinch.scale);
    pinch.scale = 1.0f;
}

//旋转 水印视图 注意：旋转之后的frame会变！！！
- (void)rotateAction:(UIRotationGestureRecognizer *)rotation {
    if (rotation.state == UIGestureRecognizerStateBegan) {
        [self topSelectedView:rotation.view];
    }else if (rotation.state == UIGestureRecognizerStateFailed || rotation.state == UIGestureRecognizerStateEnded){
        [SLDelayPerform sl_startDelayPerform:^{
            [self.selectedBox removeFromSuperview];
        } afterDelay:1.0f];
    }
    rotation.view.transform = CGAffineTransformRotate(rotation.view.transform, rotation.rotation);
    // 将旋转的弧度清零(注意不是将图片旋转的弧度清零, 而是将当前手指旋转的弧度清零)
    rotation.rotation = 0.0f;
}

// 图片裁剪完成
- (void)imageClippingComplete:(NSNotification *)notification {
    UIImage *clipImage = notification.userInfo[@"image"];
    self.zoomView.zoomScale = 1.0f;
    self.zoomView.image = clipImage;
    self.zoomView.imageView.frame = CGRectMake(0.0f, 0.0f, self.zoomView.sl_w, self.zoomView.sl_w * clipImage.size.height / clipImage.size.width);
    if (self.zoomView.imageView.sl_h <= self.zoomView.sl_h) {
        self.zoomView.imageView.center = CGPointMake(self.zoomView.sl_w / 2.0f, self.zoomView.sl_h / 2.0f);
    }
    self.zoomView.contentSize = CGSizeMake(self.zoomView.imageView.sl_w, self.zoomView.imageView.sl_h);
    
    _drawView.frame = self.zoomView.imageView.bounds;
    _mosaicView.frame = self.zoomView.imageView.bounds;
    [_drawView clear];
    [_mosaicView clear];
    for (UIView *view in self.watermarkArray) {
        [view removeFromSuperview];
    }
    [self.watermarkArray removeAllObjects];
    
    [self doneEditBtnClicked:nil];
}

- (void)imageClippingCancel {
    [self cancleEditBtnClicked:nil];
}

#pragma mark - UIGestureRecognizerDelegate
// 该方法返回的BOOL值决定了view是否能够同时响应多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //     NSLog(@"%@ - %@", gestureRecognizer.class, otherGestureRecognizer.class);
    return YES;
}

#pragma mark - SLZoomViewDelegate
- (void)zoomViewDidEndMoveImage:(SLImageZoomView *)zoomView {
    self.drawView.lineWidth = 5.0f / self.zoomView.zoomScale;
    self.mosaicView.squareWidth = 15.0f / self.zoomView.zoomScale;
    self.mosaicView.paintSize = CGSizeMake(40.0f / self.zoomView.zoomScale, 40.0f / self.zoomView.zoomScale);
}
@end
