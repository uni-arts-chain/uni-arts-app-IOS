//
//  HVideoViewController.m
//  Join
//
//  Created by 黄克瑾 on 2017/1/11.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import "HVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "HAVPlayer.h"
#import "HProgressView.h"
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Utility.h"
#import "AppDelegate.h"
#import "UIImage+JLTool.h"

typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);
@interface HVideoViewController ()<AVCaptureFileOutputRecordingDelegate>

//轻触拍照，按住摄像
@property (strong, nonatomic) IBOutlet UILabel *labelTipTitle;

//视频输出流
@property (strong,nonatomic) AVCaptureMovieFileOutput *captureMovieFileOutput;
//图片输出流
//@property (strong,nonatomic) AVCaptureStillImageOutput *captureStillImageOutput;//照片输出流
//负责从AVCaptureDevice获得输入数据
@property (strong,nonatomic) AVCaptureDeviceInput *captureDeviceInput;
//后台任务标识
@property (assign,nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@property (assign,nonatomic) UIBackgroundTaskIdentifier lastBackgroundTaskIdentifier;

@property (weak, nonatomic) IBOutlet UIImageView *focusCursor; //聚焦光标

//负责输入和输出设备之间的数据传递
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;

@property (weak, nonatomic) IBOutlet UIView *confirmView;

@property (strong, nonatomic) IBOutlet UIButton *btnBack;
//重新录制
@property (strong, nonatomic) IBOutlet UIButton *btnAfresh;
//确定
@property (strong, nonatomic) IBOutlet UIButton *btnEnsure;
//摄像头切换
@property (strong, nonatomic) IBOutlet UIButton *btnCamera;

@property (strong, nonatomic) IBOutlet UIImageView *bgView;
//记录录制的时间 默认最大60秒
@property (assign, nonatomic) NSInteger seconds;

//记录需要保存视频的路径
@property (strong, nonatomic) NSURL *saveVideoUrl;

//是否在对焦
@property (assign, nonatomic) BOOL isFocus;
//@property (strong, nonatomic) IBOutlet NSLayoutConstraint *afreshCenterX;
//@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ensureCenterX;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *backCenterX;

//视频播放
@property (strong, nonatomic) HAVPlayer *player;

@property (strong, nonatomic) IBOutlet HProgressView *progressView;

//是否是摄像 YES 代表是录制  NO 表示拍照
@property (assign, nonatomic) BOOL isVideo;

@property (strong, nonatomic) UIImage *takeImage;
@property (strong, nonatomic) UIImageView *takeImageView;
@property (strong, nonatomic) IBOutlet UIImageView *imgRecord;


@end

//时间大于这个就是视频，否则为拍照
#define TimeMax 1

@implementation HVideoViewController
- (void)dealloc{
    [self removeNotification];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIImage *image = [UIImage imageNamed:@"sc_btn_take.png"];
    self.backCenterX.constant = -(kScreenWidth / 2 / 2) - image.size.width / 2 / 2;
    
    self.progressView.layer.cornerRadius = self.progressView.frame.size.width / 2;
    self.btnEnsure.layer.cornerRadius = 4.0f;
    
    if (self.HSeconds == 0) {
        self.isVideo = NO;
    }
    
    [self performSelector:@selector(hiddenTipsLabel) withObject:nil afterDelay:4];
}

- (void)setAllowTakeVideo:(BOOL)allowTakeVideo {
    _allowTakeVideo = allowTakeVideo;
//    self.labelTipTitle.text = (allowTakeVideo ? @"轻触拍照，按住摄像" : @"轻触拍照");
}

- (void)hiddenTipsLabel {
    self.labelTipTitle.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self customCamera];
    [self.session startRunning];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.session stopRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)customCamera {
    
    //初始化会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc] init];
    //设置分辨率 (设备支持的最高分辨率)
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        self.session.sessionPreset = AVCaptureSessionPresetHigh;
    }
    //取得后置摄像头
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    //添加一个音频输入设备
    AVCaptureDevice *audioCaptureDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    
    //初始化输入设备
    NSError *error = nil;
    self.captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    //添加音频
    error = nil;
    AVCaptureDeviceInput *audioCaptureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    //输出对象
    self.captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];//视频输出
    
    //将输入设备添加到会话
    if ([self.session canAddInput:self.captureDeviceInput]) {
        [self.session addInput:self.captureDeviceInput];
        [self.session addInput:audioCaptureDeviceInput];
        //设置视频防抖
        AVCaptureConnection *connection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([connection isVideoStabilizationSupported]) {
            connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeCinematic;
        }
    }
    
    //将输出设备添加到会话 (刚开始 是照片为输出对象)
    if ([self.session canAddOutput:self.captureMovieFileOutput]) {
        [self.session addOutput:self.captureMovieFileOutput];
    }
    
    //创建视频预览层，用于实时展示摄像头状态
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.frame = self.view.bounds;//CGRectMake(0, 0, self.view.width, self.view.height);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//填充模式
    [self.bgView.layer addSublayer:self.previewLayer];
    
    [self addNotificationToCaptureDevice:captureDevice];
    [self addGenstureRecognizer];
}

- (IBAction)onCancelAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [Utility hideProgressDialog];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([[touches anyObject] view] == self.imgRecord) {
        NSLog(@"开始录制");
        //根据设备输出获得连接
        AVCaptureConnection *connection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeAudio];
        //根据连接取得设备输出的数据
        if (![self.captureMovieFileOutput isRecording]) {
            //如果支持多任务则开始多任务
            if ([[UIDevice currentDevice] isMultitaskingSupported]) {
                self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
            }
            if (self.saveVideoUrl) {
                [[NSFileManager defaultManager] removeItemAtURL:self.saveVideoUrl error:nil];
            }
            //预览图层和视频方向保持一致
            connection.videoOrientation = [self.previewLayer connection].videoOrientation;
            NSString *outputFielPath=[NSTemporaryDirectory() stringByAppendingString:@"myMovie.mov"];
            NSLog(@"save path is :%@",outputFielPath);
            NSURL *fileUrl=[NSURL fileURLWithPath:outputFielPath];
            NSLog(@"fileUrl:%@",fileUrl);
            [self.captureMovieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
        } else {
            [self.captureMovieFileOutput stopRecording];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([[touches anyObject] view] == self.imgRecord) {
        NSLog(@"结束触摸");
        if (!self.isVideo) {
            [self performSelector:@selector(endRecord) withObject:nil afterDelay:0.3f];
        } else {
            [self endRecord];
        }
    }
}

- (void)endRecord {
    [self.captureMovieFileOutput stopRecording];//停止录制
}

- (IBAction)onAfreshAction:(UIButton *)sender {
    NSLog(@"重新录制");
    [self recoverLayout];
}

- (IBAction)onEnsureAction:(UIButton *)sender {
    NSLog(@"确定 这里进行保存或者发送出去");
    WS(weakSelf)
    if (weakSelf.saveVideoUrl) {
        if (weakSelf.takeBlock) {
            weakSelf.takeBlock(weakSelf.saveVideoUrl);
        }
        
        [Utility showProgressDialogText:@"视频处理中..."];
        [weakSelf onCancelAction:nil];
    } else {
        //照片
        if (weakSelf.takeBlock) {
            weakSelf.takeBlock([weakSelf.takeImage fixOrientation]);
        }
        if (weakSelf.customDismiss) {
            [weakSelf onCancelAction:nil];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//前后摄像头的切换
- (IBAction)onCameraAction:(UIButton *)sender {
    NSLog(@"切换摄像头");
    AVCaptureDevice *currentDevice=[self.captureDeviceInput device];
    AVCaptureDevicePosition currentPosition=[currentDevice position];
    [self removeNotificationFromCaptureDevice:currentDevice];
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition = AVCaptureDevicePositionFront;//前
    if (currentPosition == AVCaptureDevicePositionUnspecified || currentPosition == AVCaptureDevicePositionFront) {
        toChangePosition = AVCaptureDevicePositionBack;//后
    }
    toChangeDevice = [self getCameraDeviceWithPosition:toChangePosition];
    [self addNotificationToCaptureDevice:toChangeDevice];
    //获得要调整的设备输入对象
    AVCaptureDeviceInput *toChangeDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:toChangeDevice error:nil];
    
    //改变会话的配置前一定要先开启配置，配置完成后提交配置改变
    [self.session beginConfiguration];
    //移除原有输入对象
    [self.session removeInput:self.captureDeviceInput];
    //添加新的输入对象
    if ([self.session canAddInput:toChangeDeviceInput]) {
        [self.session addInput:toChangeDeviceInput];
        self.captureDeviceInput = toChangeDeviceInput;
    }
    //提交会话配置
    [self.session commitConfiguration];
}

- (void)onStartTranscribe:(NSURL *)fileURL {
    if ([self.captureMovieFileOutput isRecording]) {
        -- self.seconds;
        if (self.seconds > 0) {
            if (self.HSeconds - self.seconds >= TimeMax && !self.isVideo && self.allowTakeVideo) {
                self.isVideo = YES;//长按时间超过TimeMax 表示是视频录制
                self.progressView.timeMax = self.seconds;
            }
            [self performSelector:@selector(onStartTranscribe:) withObject:fileURL afterDelay:1.0];
        } else {
            if ([self.captureMovieFileOutput isRecording]) {
                [self.captureMovieFileOutput stopRecording];
            }
        }
    }
}

#pragma mark - 视频输出代理
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    NSLog(@"开始录制...");
    self.seconds = self.HSeconds;
    [self performSelector:@selector(onStartTranscribe:) withObject:fileURL afterDelay:1.0];
}


- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    NSLog(@"视频录制完成.");
    [self changeLayout];
    if (self.isVideo) {
        self.saveVideoUrl = outputFileURL;
        if (!self.player) {
            self.player = [[HAVPlayer alloc] initWithFrame:self.bgView.bounds withShowInView:self.bgView url:outputFileURL];
        } else {
            if (outputFileURL) {
                self.player.videoUrl = outputFileURL;
                self.player.hidden = NO;
            }
        }
    } else {
        //照片
        self.saveVideoUrl = nil;
        [self videoHandlePhoto:outputFileURL];
    }
}

- (void)videoHandlePhoto:(NSURL *)url {
    AVURLAsset *urlSet = [AVURLAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlSet];
    imageGenerator.appliesPreferredTrackTransform = YES;    // 截图的时候调整到正确的方向
    NSError *error = nil;
    CMTime time = CMTimeMake(0,30);//缩略图创建时间 CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要获取某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actucalTime; //缩略图实际生成的时间
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actucalTime error:&error];
    if (error) {
        NSLog(@"截取视频图片失败:%@",error.localizedDescription);
    }
    CMTimeShow(actucalTime);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    if (image) {
        NSLog(@"视频截取成功");
    } else {
        NSLog(@"视频截取失败");
    }
    
    self.takeImage = image;//[UIImage imageWithCGImage:cgImage];
    
    [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
    
    if (!self.takeImageView) {
        self.takeImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        [self.bgView addSubview:self.takeImageView];
    }
    self.takeImageView.hidden = NO;
    self.takeImageView.image = self.takeImage;
}

#pragma mark - 通知
//注册通知
- (void)setupObservers {
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationWillResignActiveNotification object:[UIApplication sharedApplication]];
}

//进入后台就退出视频录制
- (void)applicationDidEnterBackground:(NSNotification *)notification {
    [self onCancelAction:nil];
}

/**
 *  给输入设备添加通知
 */
- (void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice {
    //注意添加区域改变捕获通知必须首先设置设备允许捕获
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled=YES;
    }];
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //捕获区域发生改变
    [notificationCenter addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

- (void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice {
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

/**
 *  移除所有通知
 */
- (void)removeNotification {
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

- (void)addNotificationToCaptureSession:(AVCaptureSession *)captureSession {
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //会话出错
    [notificationCenter addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:captureSession];
}

/**
 *  设备连接成功
 *
 *  @param notification 通知对象
 */
- (void)deviceConnected:(NSNotification *)notification {
    NSLog(@"设备已连接...");
}

/**
 *  设备连接断开
 *
 *  @param notification 通知对象
 */
- (void)deviceDisconnected:(NSNotification *)notification {
    NSLog(@"设备已断开.");
}

/**
 *  捕获区域改变
 *
 *  @param notification 通知对象
 */
- (void)areaChange:(NSNotification *)notification {
    NSLog(@"捕获区域改变...");
}

/**
 *  会话出错
 *
 *  @param notification 通知对象
 */
- (void)sessionRuntimeError:(NSNotification *)notification {
    NSLog(@"会话发生错误.");
}

/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition)position {
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position] == position) {
            return camera;
        }
    }
    return nil;
}

/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
- (void)changeDeviceProperty:(PropertyChangeBlock)propertyChange {
    AVCaptureDevice *captureDevice= [self.captureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        //自动白平衡
        if ([captureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
            [captureDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
        }
        //自动根据环境条件开启闪光灯
        if ([captureDevice isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [captureDevice setFlashMode:AVCaptureFlashModeAuto];
        }
        
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    } else {
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

/**
 *  设置闪光灯模式
 *
 *  @param flashMode 闪光灯模式
 */
- (void)setFlashMode:(AVCaptureFlashMode)flashMode {
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFlashModeSupported:flashMode]) {
            [captureDevice setFlashMode:flashMode];
        }
    }];
}

/**
 *  设置聚焦模式
 *
 *  @param focusMode 聚焦模式
 */
- (void)setFocusMode:(AVCaptureFocusMode)focusMode {
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}

/**
 *  设置曝光模式
 *
 *  @param exposureMode 曝光模式
 */
- (void)setExposureMode:(AVCaptureExposureMode)exposureMode {
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
    }];
}

/**
 *  设置聚焦点
 *
 *  @param point 聚焦点
 */
- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point {
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
//        if ([captureDevice isFocusPointOfInterestSupported]) {
//            [captureDevice setFocusPointOfInterest:point];
//        }
//        if ([captureDevice isExposurePointOfInterestSupported]) {
//            [captureDevice setExposurePointOfInterest:point];
//        }
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}

/**
 *  添加点按手势，点按时聚焦
 */
- (void)addGenstureRecognizer {
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    [self.bgView addGestureRecognizer:tapGesture];
}

- (void)tapScreen:(UITapGestureRecognizer *)tapGesture {
    if ([self.session isRunning]) {
        CGPoint point= [tapGesture locationInView:self.bgView];
        //将UI坐标转化为摄像头坐标
        CGPoint cameraPoint= [self.previewLayer captureDevicePointOfInterestForPoint:point];
        [self setFocusCursorWithPoint:point];
        [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposureMode:AVCaptureExposureModeContinuousAutoExposure atPoint:cameraPoint];
    }
}

/**
 *  设置聚焦光标位置
 *
 *  @param point 光标位置
 */
- (void)setFocusCursorWithPoint:(CGPoint)point {
    WS(weakSelf)
    if (!self.isFocus) {
        self.isFocus = YES;
        self.focusCursor.center=point;
        self.focusCursor.transform = CGAffineTransformMakeScale(1.25f, 1.25f);
        self.focusCursor.alpha = 1.0f;
        [UIView animateWithDuration:0.5f animations:^{
            weakSelf.focusCursor.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [weakSelf performSelector:@selector(onHiddenFocusCurSorAction) withObject:nil afterDelay:0.5f];
        }];
    }
}

- (void)onHiddenFocusCurSorAction {
    self.focusCursor.alpha = 0.0f;
    self.isFocus = NO;
}

//拍摄完成时调用
- (void)changeLayout {
    WS(weakSelf)
    self.imgRecord.hidden = YES;
    self.btnCamera.hidden = YES;
    self.confirmView.hidden = NO;
//    self.btnAfresh.hidden = NO;
//    self.btnEnsure.hidden = NO;
    self.btnBack.hidden = YES;
    if (self.isVideo) {
        [self.progressView clearProgress];
    }
//    self.afreshCenterX.constant = -(kScreenWidth/2/2);
//    self.ensureCenterX.constant = kScreenWidth/2/2;
    [UIView animateWithDuration:0.25f animations:^{
        [weakSelf.view layoutIfNeeded];
    }];
    
    self.lastBackgroundTaskIdentifier = self.backgroundTaskIdentifier;
    self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    [self.session stopRunning];
}


//重新拍摄时调用
- (void)recoverLayout {
    WS(weakSelf)
    if (weakSelf.isVideo) {
        weakSelf.isVideo = NO;
        [weakSelf.player stopPlayer];
        weakSelf.player.hidden = YES;
    }
    [weakSelf.session startRunning];

    if (!weakSelf.takeImageView.hidden) {
        weakSelf.takeImageView.hidden = YES;
    }
//    self.saveVideoUrl = nil;
//    weakSelf.afreshCenterX.constant = 0;
//    weakSelf.ensureCenterX.constant = 0;
    weakSelf.imgRecord.hidden = NO;
    weakSelf.btnCamera.hidden = NO;
    weakSelf.confirmView.hidden = YES;
//    weakSelf.btnAfresh.hidden = YES;
//    weakSelf.btnEnsure.hidden = YES;
    weakSelf.btnBack.hidden = NO;
    [UIView animateWithDuration:0.25f animations:^{
        [weakSelf.view layoutIfNeeded];
    }];
}
@end
