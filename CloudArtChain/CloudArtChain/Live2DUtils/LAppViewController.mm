/**
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at https://www.live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#import "LAppViewController.h"
#import <math.h>
#import <string>
#import <QuartzCore/QuartzCore.h>
#import "CubismFramework.hpp"
#import <Math/CubismMatrix44.hpp>
#import <Math/CubismViewMatrix.hpp>
#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "AppDelegate.h"
#import "LAppSprite.h"
#import "TouchManager.h"
#import "LAppDefine.h"
#import "LAppLive2DManager.h"
#import "LAppTextureManager.h"
#import "LAppPal.h"
#import "LAppModel.h"
#import "UIView+JLCorner.h"

#define BUFFER_OFFSET(bytes) ((GLubyte *)NULL + (bytes))

using namespace std;
using namespace LAppDefine;

@interface LAppViewController ()
@property (nonatomic) LAppSprite *back; //背景图像
//@property (nonatomic) LAppSprite *gear; //齿轮图像
@property (nonatomic) LAppSprite *close; //关闭图像
@property (nonatomic) LAppSprite *renderSprite; //用于绘制渲染目标
@property (nonatomic) TouchManager *touchManager; ///< 触摸管理器
@property (nonatomic) Csm::CubismMatrix44 *deviceToScreen;///< 从设备到屏幕的矩阵
@property (nonatomic) Csm::CubismViewMatrix *viewMatrix;

@end

@implementation LAppViewController
@synthesize mOpenGLRun;
@synthesize mSaveSnapshot;

- (void)releaseView {
    _renderBuffer.DestroyOffscreenFrame();

    _renderSprite = nil;
//    _gear = nil;
    _back = nil;
    _close = nil;

    GLKView *view = (GLKView *)self.view;

    view = nil;

    delete(_viewMatrix);
    _viewMatrix = nil;
    delete(_deviceToScreen);
    _deviceToScreen = nil;
    _touchManager = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mOpenGLRun = true;

    _anotherTarget = false;
    _spriteColorR = _spriteColorG = _spriteColorB = _spriteColorA = 1.0f;
    _clearColorR = _clearColorG = _clearColorB = 1.0f;
    _clearColorA = 0.0f;

    // 触摸相关的事件管理
    _touchManager = [[TouchManager alloc]init];

    // 将设备坐标转换为屏幕坐标
    _deviceToScreen = new CubismMatrix44();

    // 用于缩放或移动屏幕显示的矩阵
    _viewMatrix = new CubismViewMatrix();

    [self initializeScreen];

    [super viewDidLoad];
    GLKView *view = (GLKView*)self.view;

    // OpenGL ES2を指定
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    // set context
    [EAGLContext setCurrentContext:view.context];

    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);

    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);


    glGenBuffers(1, &_vertexBufferId);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferId);

    glGenBuffers(1, &_fragmentBufferId);
    glBindBuffer(GL_ARRAY_BUFFER,  _fragmentBufferId);
}

- (void)initializeScreen {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int width = screenRect.size.width;
    int height = screenRect.size.height;

    // 以纵向大小为基准
    float ratio = static_cast<float>(width) / static_cast<float>(height);
    float left = -ratio;
    float right = ratio;
    float bottom = ViewLogicalLeft;
    float top = ViewLogicalRight;

    // 设备对应的画面范围。X的左端、X的右端、Y的下端、Y的上端
    _viewMatrix->SetScreenRect(left, right, bottom, top);
    _viewMatrix->Scale(ViewScale, ViewScale);

    _deviceToScreen->LoadIdentity(); // 尺寸变了的时候等必须复位
    if (width > height) {
      float screenW = fabsf(right - left);
      _deviceToScreen->ScaleRelative(screenW / width, -screenW / width);
    } else {
      float screenH = fabsf(top - bottom);
      _deviceToScreen->ScaleRelative(screenH / height, -screenH / height);
    }
    _deviceToScreen->TranslateRelative(-width * 0.5f, -height * 0.5f);

    // 显示范围设置
    _viewMatrix->SetMaxScale(ViewMaxScale); // 极限放大率
    _viewMatrix->SetMinScale(ViewMinScale); // 极限缩小率

    // 可显示的最大范围
    _viewMatrix->SetMaxScreenRect(
                                  ViewLogicalMaxLeft,
                                  ViewLogicalMaxRight,
                                  ViewLogicalMaxBottom,
                                  ViewLogicalMaxTop
                                  );
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    //时间更新
    LAppPal::UpdateTime();

    if(mOpenGLRun) {
        // 清除屏幕
        glClear(GL_COLOR_BUFFER_BIT);
        
        [_back render:_vertexBufferId fragmentBufferID:_fragmentBufferId];
        
//        [_gear render:_vertexBufferId fragmentBufferID:_fragmentBufferId];
        
        LAppLive2DManager* Live2DManager = [LAppLive2DManager getInstance];
        [Live2DManager SetViewMatrix:_viewMatrix];
        [Live2DManager onUpdate];

        // 如果各个模型的绘图目标是纹理，在sprite上的绘制就在这里
        if (_renderTarget == SelectTarget_ModelFrameBuffer && _renderSprite) {
            float uvVertex[] = {
                0.0f, 0.0f,
                1.0f, 0.0f,
                0.0f, 1.0f,
                1.0f, 1.0f,
            };

            for(csmUint32 i=0; i<[Live2DManager GetModelNum]; i++) {
                float a = [self GetSpriteAlpha:i]; // 样品与α有适当的差别
                [_renderSprite SetColor:1.0f g:1.0f b:1.0f a:a];

                LAppModel* model = [Live2DManager getModel:i];
                if (model) {
                    Csm::Rendering::CubismOffscreenFrame_OpenGLES2& useTarget = model->GetRenderBuffer();
                    GLuint id = useTarget.GetColorBuffer();
                    [_renderSprite renderImmidiate:_vertexBufferId fragmentBufferID:_fragmentBufferId TextureId:id uvArray:uvVertex];
                }
            }
        }
        [_close render:_vertexBufferId fragmentBufferID:_fragmentBufferId];
        glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
        
        if (mSaveSnapshot) {
            [self saveSnapshot];
            mSaveSnapshot = false;
        }
    }
}

- (void)initializeSprite {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int width = screenRect.size.width;
    int height = screenRect.size.height;

    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    LAppTextureManager* textureManager = [delegate getTextureManager];
    const string resourcesPath = "/Res.bundle/";

    string imageName = BackImageName;
    TextureInfo* backgroundTexture = [textureManager createTextureFromPngFileWithBundle:resourcesPath+imageName];
    float x = width * 0.5f;
    float y = height * 0.5f;
    float fWidth = 300.0f;
    float fHeight = 300.0f;
    fWidth = static_cast<float>(width * 1.0f);
    fHeight = static_cast<float>(height * 1.0f);
    _back = [[LAppSprite alloc] initWithMyVar:x Y:y Width:fWidth Height:fHeight TextureId:backgroundTexture->id];

//    imageName = GearImageName;
//    TextureInfo* gearTexture = [textureManager createTextureFromPngFileWithBundle:resourcesPath+imageName];
//    x = static_cast<float>(width - gearTexture->width * 0.5f);
//    y = static_cast<float>(height - gearTexture->height * 0.5f);
//    fWidth = static_cast<float>(gearTexture->width);
//    fHeight = static_cast<float>(gearTexture->height);
//    _gear = [[LAppSprite alloc] initWithMyVar:x Y:y Width:fWidth Height:fHeight TextureId:gearTexture->id];
    
    imageName = PowerImageName;
    TextureInfo* powerTexture = [textureManager createTextureFromPngFileWithBundle:resourcesPath+imageName];
//    x = static_cast<float>(width - powerTexture->width * 0.5f);
    x = static_cast<float>(width) * 0.1f;
    y = static_cast<float>(height - powerTexture->height);
    fWidth = static_cast<float>(powerTexture->width);
    fHeight = static_cast<float>(powerTexture->height);
    _close = [[LAppSprite alloc] initWithMyVar:x Y:y Width:fWidth Height:fHeight TextureId:powerTexture->id];

    x = static_cast<float>(width) * 0.5f;
    y = static_cast<float>(height) * 0.5f;
    fWidth = static_cast<float>(width*2);
    fHeight = static_cast<float>(height*2);
    _renderSprite = [[LAppSprite alloc] initWithMyVar:x Y:y Width:fWidth/2 Height:fHeight/2 TextureId:0];
}

- (void)snapShotRefreshCloseImage {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int width = screenRect.size.width;
    int height = screenRect.size.height;
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    LAppTextureManager* textureManager = [delegate getTextureManager];
    const string resourcesPath = "/Res.bundle/";
    
    string imageName = PowerImageName;
    TextureInfo* powerTexture = [textureManager createTextureFromPngFileWithBundle:resourcesPath+imageName];
    float x = static_cast<float>(width + powerTexture->width);
    float y = static_cast<float>(height);
    float fWidth = static_cast<float>(powerTexture->width);
    float fHeight = static_cast<float>(powerTexture->height);
    _close = [[LAppSprite alloc] initWithMyVar:x Y:y Width:fWidth Height:fHeight TextureId:powerTexture->id];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];

    [_touchManager touchesBegan:point.x DeciveY:point.y];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];

    float viewX = [self transformViewX:[_touchManager getX]];
    float viewY = [self transformViewY:[_touchManager getY]];

    [_touchManager touchesMoved:point.x DeviceY:point.y];
    [[LAppLive2DManager getInstance] onDrag:viewX floatY:viewY];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSLog(@"%@", touch.view);

    CGPoint point = [touch locationInView:self.view];
    float pointY = [self transformTapY:point.y];

    // 触摸结束
    LAppLive2DManager* live2DManager = [LAppLive2DManager getInstance];
    [live2DManager onDrag:0.0f floatY:0.0f];
    {
        // 单抽头
        float getX = [_touchManager getX];// 获得逻辑坐标转换后的坐标。
        float getY = [_touchManager getY]; // 获得逻辑坐标转换后的坐标。
        float x = _deviceToScreen->TransformX(getX);
        float y = _deviceToScreen->TransformY(getY);

        if (DebugTouchLogEnable) {
            LAppPal::PrintLog("[APP]touchesEnded x:%.2f y:%.2f", x, y);
        }
        [live2DManager onTap:x floatY:y];

//         有没有碰到齿轮
//        if ([_gear isHit:point.x PointY:pointY])
//        {
//            [live2DManager nextScene];
//        }

        // 有没有点击电源按钮
        if ([_close isHit:point.x PointY:pointY]) {
            [self snapShotRefreshCloseImage];
            mSaveSnapshot = true;
        }
    }
}

// 保存截图到本地
- (void)saveSnapshot {
    WS(weakSelf)
    dispatch_after(2.0f, dispatch_get_main_queue(), ^{
        UIImage *image = [UIView snapshotImageFromView:weakSelf.view atFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight)];
    //    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        if (weakSelf.snapshotBlock) {
            weakSelf.snapshotBlock(image);
        }
    });
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [delegate finishApplication];
}

#pragma mark -- <保存到相册>
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if(error) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"图片保存失败" hideTime:KToastDismissDelayTimeInterval];
    } else {
        [[JLLoading sharedLoading] showMBSuccessTipMessage:@"已保存到手机" hideTime:KToastDismissDelayTimeInterval];
    }
}

- (float)transformViewX:(float)deviceX {
    float screenX = _deviceToScreen->TransformX(deviceX); // 获得逻辑坐标转换后的坐标。
    return _viewMatrix->InvertTransformX(screenX); // 放大、缩小和移动后的值。
}

- (float)transformViewY:(float)deviceY {
    float screenY = _deviceToScreen->TransformY(deviceY); // 获得逻辑坐标转换后的坐标。
    return _viewMatrix->InvertTransformY(screenY); // 放大、缩小和移动后的值。
}

- (float)transformScreenX:(float)deviceX {
    return _deviceToScreen->TransformX(deviceX);
}

- (float)transformScreenY:(float)deviceY {
    return _deviceToScreen->TransformY(deviceY);
}

- (float)transformTapY:(float)deviceY {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int height = screenRect.size.height;
    return deviceY * -1 + height;
}

- (void)PreModelDraw:(LAppModel&)refModel {
    // 用于绘制到其他渲染目标的帧缓冲区
    Csm::Rendering::CubismOffscreenFrame_OpenGLES2* useTarget = NULL;

    if (_renderTarget != SelectTarget_None) {
        // 绘制到其他渲染目标时
        // 要使用的目标
        useTarget = (_renderTarget == SelectTarget_ViewFrameBuffer) ? &_renderBuffer : &refModel.GetRenderBuffer();

        if (!useTarget->IsValid()) {
            // 如果绘图目标内部未创建，请在此创建
            CGRect screenRect = [[UIScreen mainScreen] nativeBounds];
            int width = screenRect.size.width;
            int height = screenRect.size.height;

            // 模型画布
            // 用Pad和Phone改变纵横
            if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
                useTarget->CreateOffscreenFrame(height, width);
            } else {
                useTarget->CreateOffscreenFrame(width, height);
            }
        }

        // 开始渲染
        useTarget->BeginDraw();
        useTarget->Clear(_clearColorR, _clearColorG, _clearColorB, _clearColorA); // 背景透明色
    }
}

- (void)PostModelDraw:(LAppModel&)refModel {
    // 用于绘制到其他渲染目标的帧缓冲区
    Csm::Rendering::CubismOffscreenFrame_OpenGLES2* useTarget = NULL;

    if (_renderTarget != SelectTarget_None) {
        // 绘制到其他渲染目标时
        // 要使用的目标
        useTarget = (_renderTarget == SelectTarget_ViewFrameBuffer) ? &_renderBuffer : &refModel.GetRenderBuffer();

        // 渲染结束
        useTarget->EndDraw();

        // 如果使用LAppView所具有的帧缓冲器，在sprite上的描绘就在这里
        if (_renderTarget == SelectTarget_ViewFrameBuffer && _renderSprite) {
            float uvVertex[] = {
                0.0f, 0.0f,
                1.0f, 0.0f,
                0.0f, 1.0f,
                1.0f, 1.0f,
            };

            float a = [self GetSpriteAlpha:0];
            [_renderSprite SetColor:1.0f g:1.0f b:1.0f a:a];
            [_renderSprite renderImmidiate:_vertexBufferId fragmentBufferID:_fragmentBufferId TextureId:useTarget->GetColorBuffer() uvArray:uvVertex];
        }
    }
}

- (void)SwitchRenderingTarget:(SelectTarget)targetType {
    _renderTarget = targetType;
}

- (void)SetRenderTargetClearColor:(float)r g:(float)g b:(float)b {
    _clearColorR = r;
    _clearColorG = g;
    _clearColorB = b;
}

- (float)GetSpriteAlpha:(int)assign {
    // 根据assign的数值适当决定
    float alpha = 0.25f + static_cast<float>(assign) * 0.5f; // 样品与α有适当的差别
    if (alpha > 1.0f) {
        alpha = 1.0f;
    }
    if (alpha < 0.1f) {
        alpha = 0.1f;
    }

    return alpha;
}
@end
