//
//  JLImageRectClipViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/17.
//  Copyright © 2020 朱彬. All rights reserved.
//
#import "JLImageRectClipViewController.h"

static const CGFloat KOriginalImageHeight = 210.0f;

@interface JLImageRectClipViewController ()
@property (nonatomic, strong) NSArray *orientationArray;
@property (nonatomic, assign) NSInteger currentOrientationIndex;
@property (nonatomic, strong) UIImage *originImage;
@end

@implementation JLImageRectClipViewController
- (NSArray *)orientationArray {
    if (!_orientationArray) {
        _orientationArray = @[@(UIImageOrientationUp), @(UIImageOrientationLeft), @(UIImageOrientationDown), @(UIImageOrientationRight)];
    }
    return _orientationArray;
}

- (instancetype)initWithImage:(UIImage *)image {
    if(self = [super init]) {
        _image = [self fixOrientation:image];
        self.originImage = [self fixOrientation:image];
        self.currentOrientationIndex = 0;
        self.width = kScreenWidth - 16.0f * 2;
        self.height = KOriginalImageHeight * (self.width / kScreenWidth);
        self.scaleRation = 10.0f;
        lastScale = 1.0f;
    }
    return  self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景颜色
    self.view.backgroundColor = JL_color_white_ffffff;
    [self createUI];
    [self addAllGesture];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)createUI {
    //验证 裁剪半径是否有效
    self.width = self.width > self.view.frame.size.width ? self.view.frame.size.width : self.width;
    self.height = KOriginalImageHeight * (self.width / kScreenWidth);
    
    CGFloat width  = self.view.frame.size.width;
    CGFloat height = (_image.size.height / _image.size.width) * self.view.frame.size.width;
    [self.view setBackgroundColor:JL_color_black];
    
    [_imageView removeFromSuperview];
    _imageView = [[UIImageView alloc] init];
    [_imageView setImage:_image];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_imageView setFrame:CGRectMake(0.0f, 0.0f, width, height)];
    [_imageView setCenter:self.view.center];
    self.OriginalFrame = _imageView.frame;
    [self.view addSubview:_imageView];
    
    _imageViewScale = _imageView;
    
    //覆盖层
    [_overView removeFromSuperview];
    _overView = [[UIView alloc] init];
    [_overView setBackgroundColor:JL_color_clear];
    _overView.opaque = NO;
    [_overView setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_overView];
    
    [self drawClipPath];
    [self makeImageViewFrameAdaptClipFrame];
    [self addOperationView];
}

//添加操作视图
- (void)addOperationView {
    UIView *operationView = [[UIView alloc] init];
    [self.view addSubview:operationView];
    
    UIButton *cancelBtn = [JLUIFactory buttonInitTitle:@"取消" titleColor:JL_color_white_ffffff backgroundColor:nil font:kFontPingFangSCRegular(16.0f) addTarget:self action:@selector(cancelBtnClick)];
    [operationView addSubview:cancelBtn];
    
    UIButton *clipBtn = [JLUIFactory buttonInitTitle:@"完成" titleColor:JL_color_blue_38B2F1 backgroundColor:nil font:kFontPingFangSCRegular(16.0f) addTarget:self action:@selector(clipBtnSelected)];
    [operationView addSubview:clipBtn];
    
    UIButton *rotationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rotationBtn setBackgroundImage:[UIImage imageNamed:@"ic_rotation"] forState:UIControlStateNormal];
    [rotationBtn addTarget:self action:@selector(rotationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rotationBtn];
    
    [operationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(56.0f + KStatus_Bar_Height);
    }];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(operationView).offset(25.0f);
        make.top.equalTo(operationView).offset(KStatus_Bar_Height);
        make.height.mas_equalTo(56.0f);
    }];
    [clipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(operationView).offset(-25.0f);
        make.top.equalTo(operationView).offset(KStatus_Bar_Height);
        make.height.mas_equalTo(56.0f);
    }];
    [rotationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(29.0f);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-16.0f);
    }];
    [self.view layoutIfNeeded];
}

//点击旋转按钮
- (void)rotationBtnClick {
    for (UIView *subView in self.view.subviews) {
        [subView removeFromSuperview];
    }
    self.currentOrientationIndex++;
    if (self.currentOrientationIndex > self.orientationArray.count - 1) {
        self.currentOrientationIndex = 0;
    }
    _image = [self image:self.originImage rotation:((NSNumber *)self.orientationArray[self.currentOrientationIndex]).integerValue];
    self.width = kScreenWidth - 16.0f * 2;
    self.height = KOriginalImageHeight * (self.width / kScreenWidth);
    self.scaleRation =  10.0f;
    lastScale = 1.0f;
    [self createUI];
    [self addAllGesture];
}

//点击取消按钮
- (void)cancelBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//绘制裁剪框
- (void)drawClipPath {
    CGFloat ScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat ScreenHeight = [UIScreen mainScreen].bounds.size.height;
    CGPoint center = self.view.center;
    
    self.circularFrame = CGRectMake(center.x - self.width * 0.5f, center.y - self.height * 0.5f, self.width, self.height);
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:CGRectMake(0.0f, 0.0f, ScreenWidth, ScreenHeight)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    UIBezierPath *centerPath = [UIBezierPath bezierPathWithRect:CGRectMake(center.x - self.width * 0.5f, center.y - self.height * 0.5f, self.width,  self.height)];
    [path appendPath:centerPath];
    [path setUsesEvenOddFillRule:YES];
    layer.path = path.CGPath;
    layer.fillRule = kCAFillRuleEvenOdd;
    layer.fillColor = [[UIColor colorWithHexString:@"#1A1A1A"] colorWithAlphaComponent:0.9f].CGColor;
    layer.opacity = 1.0f;
    [_overView.layer addSublayer:layer];
    
    //方框视图
    UIView *rectView = [[UIView alloc] initWithFrame:CGRectMake(center.x - self.width * 0.5f, center.y - self.height * 0.5f, self.width, self.height)];
    rectView.layer.borderColor = JL_color_white_ffffff.CGColor;
    rectView.layer.borderWidth = 1.0f;
    [_overView addSubview:rectView];
    
    //增加四个角
    UIImageView *topLeftCornerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(center.x - self.width * 0.5f, center.y - self.height * 0.5f, 29.0f, 17.0f)];
    topLeftCornerImageView.image = [UIImage imageNamed:@"ic_up_left"];
    [_overView addSubview:topLeftCornerImageView];
    
    UIImageView *topRightCornerImageView= [[UIImageView alloc] initWithFrame:CGRectMake(center.x - self.width * 0.5f + self.width - 29.0f, center.y - self.height * 0.5f, 29.0f, 17.0f)];
    topRightCornerImageView.image = [UIImage imageNamed:@"ic_up_right"];
    [_overView addSubview:topRightCornerImageView];
    
    UIImageView *bottomLeftCornerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(center.x - self.width * 0.5f, center.y - self.height * 0.5f + self.height - 17.0f, 29.0f, 17.0f)];
    bottomLeftCornerImageView.image = [UIImage imageNamed:@"ic_down_left"];
    [_overView addSubview:bottomLeftCornerImageView];
    
    UIImageView *bottomRightCornerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(center.x - self.width * 0.5f + self.width - 29.0f, center.y - self.height * 0.5f + self.height - 17.0f, 29.0f, 17.0f)];
    bottomRightCornerImageView.image = [UIImage imageNamed:@"ic_down_right"];
    [_overView addSubview:bottomRightCornerImageView];
}

//让图片自己适应裁剪框的大小
- (void)makeImageViewFrameAdaptClipFrame {
    CGFloat width = _imageView.frame.size.width ;
    CGFloat height = _imageView.frame.size.height;
    if(height < self.circularFrame.size.height) {
        width = (width / height) * self.circularFrame.size.height;
        height = self.circularFrame.size.height;
        CGRect frame = CGRectMake(0.0f, 0.0f, width, height);
        [_imageView setFrame:frame];
        [_imageView setCenter:self.view.center];
    }
}

- (void)addAllGesture {
    //捏合手势
    UIPinchGestureRecognizer *pinGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinGesture:)];
    [self.view addGestureRecognizer:pinGesture];
    //拖动手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGesture];
}

- (void)handlePinGesture:(UIPinchGestureRecognizer *)pinGesture {
    UIView *view = _imageView;
    if(pinGesture.state == UIGestureRecognizerStateBegan || pinGesture.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(_imageViewScale.transform, pinGesture.scale,pinGesture.scale);
        pinGesture.scale = 1.0f;
    } else if (pinGesture.state == UIGestureRecognizerStateEnded) {
        lastScale = 1.0f;
        CGFloat ration =  view.frame.size.width / self.OriginalFrame.size.width;
        if(ration>_scaleRation) {
            //缩放倍数 > 自定义的最大倍数
            CGRect newFrame = CGRectMake(0.0f, 0.0f, self.OriginalFrame.size.width * _scaleRation, self.OriginalFrame.size.height * _scaleRation);
            view.frame = newFrame;
        } else if (view.frame.size.width < self.circularFrame.size.width && self.OriginalFrame.size.width <= self.OriginalFrame.size.height) {
            view.frame = [self handelWidthLessHeight:view];
            view.frame = [self handleScale:view];
        } else if (view.frame.size.height < self.circularFrame.size.height && self.OriginalFrame.size.height <= self.OriginalFrame.size.width) {
            view.frame = [self handleHeightLessWidth:view];
            view.frame = [self handleScale:view];
        } else {
            view.frame = [self handleScale:view];
        }
        self.currentFrame = view.frame;
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    UIView * view = _imageView;
    if(panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGesture translationInView:view.superview];
        [view setCenter:CGPointMake(view.center.x + translation.x, view.center.y + translation.y)];
        [panGesture setTranslation:CGPointZero inView:view.superview];
    } else if (panGesture.state == UIGestureRecognizerStateEnded) {
        CGRect currentFrame = view.frame;
        //向右滑动 并且超出裁剪范围后
        if(currentFrame.origin.x >= self.circularFrame.origin.x) {
            currentFrame.origin.x = self.circularFrame.origin.x;
        }
        //向下滑动 并且超出裁剪范围后
        if(currentFrame.origin.y >= self.circularFrame.origin.y) {
            currentFrame.origin.y = self.circularFrame.origin.y;
        }
        //向左滑动 并且超出裁剪范围后
        if(currentFrame.size.width + currentFrame.origin.x < self.circularFrame.origin.x + self.circularFrame.size.width) {
            CGFloat movedLeftX = fabs(currentFrame.size.width + currentFrame.origin.x - (self.circularFrame.origin.x + self.circularFrame.size.width));
            currentFrame.origin.x += movedLeftX;
        }
        //向上滑动 并且超出裁剪范围后
        if(currentFrame.size.height + currentFrame.origin.y < self.circularFrame.origin.y + self.circularFrame.size.height) {
            CGFloat moveUpY = fabs(currentFrame.size.height + currentFrame.origin.y - (self.circularFrame.origin.y + self.circularFrame.size.height));
            currentFrame.origin.y += moveUpY;
        }
        [UIView animateWithDuration:0.05f animations:^{
            [view setFrame:currentFrame];
        }];
    }
}

//缩放结束后 确保图片在裁剪框内
- (CGRect)handleScale:(UIView *)view {
    // 图片.right < 裁剪框.right
    if(view.frame.origin.x + view.frame.size.width < self.circularFrame.origin.x + self.circularFrame.size.width) {
        CGFloat right = view.frame.origin.x + view.frame.size.width;
        CGRect viewFrame = view.frame;
        CGFloat space = self.circularFrame.origin.x + self.circularFrame.size.width - right;
        viewFrame.origin.x += space;
        view.frame = viewFrame;
    }
    // 图片.top < 裁剪框.top
    if(view.frame.origin.y > self.circularFrame.origin.y) {
        CGRect viewFrame = view.frame;
        viewFrame.origin.y = self.circularFrame.origin.y;
        view.frame = viewFrame;
    }
    // 图片.left < 裁剪框.left
    if(view.frame.origin.x > self.circularFrame.origin.x) {
        CGRect viewFrame = view.frame;
        viewFrame.origin.x = self.circularFrame.origin.x;
        view.frame = viewFrame;
    }
    // 图片.bottom < 裁剪框.bottom
    if((view.frame.size.height + view.frame.origin.y) < (self.circularFrame.origin.y + self.circularFrame.size.height)) {
        CGRect viewFrame = view.frame;
        CGFloat space = self.circularFrame.origin.y + self.circularFrame.size.height - (view.frame.size.height + view.frame.origin.y);
        viewFrame.origin.y += space;
        view.frame = viewFrame;
    }
    return view.frame;
}

// 图片的高<宽 并且缩放后的图片高小于裁剪框的高
- (CGRect)handleHeightLessWidth:(UIView *)view {
    CGRect tempFrame = view.frame;
    CGFloat rat = self.OriginalFrame.size.width / self.OriginalFrame.size.height;
    CGFloat width = self.circularFrame.size.height * rat;
    CGFloat height = self.circularFrame.size.height;
    CGFloat x = view.frame.origin.x;
    CGFloat y = self.circularFrame.origin.y;
    
    if(view.frame.origin.x > self.circularFrame.origin.x) {
        x = self.circularFrame.origin.x;
    } else if ((view.frame.origin.x + view.frame.size.width) < self.circularFrame.origin.x + self.circularFrame.size.width) {
        x = self.circularFrame.origin.x + self.circularFrame.size.width - width;
    }
    
    CGRect newFrame = CGRectMake(x, y, width,height);
    view.frame = newFrame;
    if((tempFrame.origin.x > self.circularFrame.origin.x &&(tempFrame.origin.x + tempFrame.size.width) < self.circularFrame.origin.x + self.circularFrame.size.width)) {
        [view setCenter:self.view.center];
    }
    if((tempFrame.origin.y > self.circularFrame.origin.y &&(tempFrame.origin.y + tempFrame.size.height) < self.circularFrame.origin.y + self.circularFrame.size.height)) {
        [view setCenter:CGPointMake(tempFrame.size.width / 2 + tempFrame.origin.x, view.frame.size.height / 2)];
    }
    return  view.frame;
}

//图片的宽<高 并且缩放后的图片宽小于裁剪框的宽
- (CGRect)handelWidthLessHeight:(UIView *)view {
    CGFloat rat = self.OriginalFrame.size.height / self.OriginalFrame.size.width;
    CGRect tempFrame = view.frame;
    CGFloat width = self.circularFrame.size.width;
    CGFloat height = self.circularFrame.size.height * rat;
    
    CGFloat x = self.circularFrame.origin.x;
    CGFloat y = view.frame.origin.y;
    
    if(view.frame.origin.y > self.circularFrame.origin.y) {
        y = self.circularFrame.origin.y;
    } else if ((view.frame.origin.y + view.frame.size.height) < self.circularFrame.origin.y + self.circularFrame.size.height) {
        y = self.circularFrame.origin.y + self.circularFrame.size.height - height ;
    }
    CGRect newFrame = CGRectMake(x, y, width,height);
    view.frame = newFrame;
    if((tempFrame.origin.y > self.circularFrame.origin.y && (tempFrame.origin.y + tempFrame.size.height) < self.circularFrame.origin.y + self.circularFrame.size.height)) {
        [view setCenter:self.view.center];
    }
    if((tempFrame.origin.x > self.circularFrame.origin.x && (tempFrame.origin.x + tempFrame.size.width) < self.circularFrame.origin.x + self.circularFrame.size.width)) {
        CGSize size = CGSizeMake(self.circularFrame.size.width, (tempFrame.size.height / tempFrame.size.width) * self.circularFrame.size.width);
        view.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
        [view setCenter:CGPointMake(view.frame.size.width / 2, tempFrame.size.height / 2 + tempFrame.origin.y)];
    }
    return  view.frame;
}

- (void)clipBtnSelected {
    [self.delegate jlrectClipViewController:self finishClipImage:[self getSmallImage]];
}

//修复图片显示方向问题
- (UIImage *)fixOrientation:(UIImage *)image {
    if (image.imageOrientation == UIImageOrientationUp) {
        return image;
    }
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0.0f);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        default:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0.0f);
            transform = CGAffineTransformScale(transform, -1.0f, 1.0f);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0.0f);
            transform = CGAffineTransformScale(transform, -1.0f, 1.0f);
            break;
            
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0.0f, 0.0f, image.size.height, image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), image.CGImage);
            break;
    }
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//方形裁剪
- (UIImage *)getSmallImage {
    CGFloat width = _imageView.frame.size.width;
    CGFloat rationScale = (width / _image.size.width);
    
    CGFloat origX = (self.circularFrame.origin.x - _imageView.frame.origin.x) / rationScale;
    CGFloat origY = (self.circularFrame.origin.y - _imageView.frame.origin.y) / rationScale;
    CGFloat oriWidth = self.circularFrame.size.width / rationScale;
    CGFloat oriHeight = self.circularFrame.size.height / rationScale;
    
    CGRect myRect = CGRectMake(origX, origY, oriWidth, oriHeight);
    CGImageRef imageRef = CGImageCreateWithImageInRect(_image.CGImage, myRect);
    UIGraphicsBeginImageContext(myRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myRect, imageRef);
    UIImage * clipImage = [UIImage imageWithCGImage:imageRef];
    UIGraphicsEndImageContext();
    return clipImage;
}

//圆形图片
- (UIImage *)CircularClipImage:(UIImage *)image {
    CGFloat arcCenterX = image.size.width / 2;
    CGFloat arcCenterY = image.size.height / 2;
    
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextAddArc(context, arcCenterX , arcCenterY, image.size.width/ 2 , 0.0f, 2 * M_PI, NO);
    CGContextClip(context);
    CGRect myRect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    [image drawInRect:myRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation {
    double rotate = 0.0f;
    CGRect rect;
    float translateX = 0.0f;
    float translateY = 0.0f;
    float scaleX = 1.0f;
    float scaleY = 1.0f;
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0.0f, 0.0f, image.size.height, image.size.width);
            translateX = 0.0f;
            translateY = -rect.size.width;
            scaleY = rect.size.width / rect.size.height;
            scaleX = rect.size.height / rect.size.width;
            break;
            
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0.0f, 0.0f, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0.0f;
            scaleY = rect.size.width / rect.size.height;
            scaleX = rect.size.height / rect.size.width;
            break;
            
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
            
        default:
            rotate = 0.0f;
            rect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
            translateX = 0.0f;
            translateY = 0.0f;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0f, rect.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context,CGRectMake(0.0f, 0.0f, rect.size.width, rect.size.height), image.CGImage);
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    return newPic;
}

- (void)dealloc {
    NSLog(@"相册裁剪界面销毁了");
}
@end
