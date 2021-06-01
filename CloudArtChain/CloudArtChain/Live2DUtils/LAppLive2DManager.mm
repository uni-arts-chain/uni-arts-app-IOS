/**
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at https://www.live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "LAppLive2DManager.h"
#import "AppDelegate.h"
#import "LAppViewController.h"
#import "LAppModel.h"
#import "LAppDefine.h"
#import "LAppPal.h"

@interface LAppLive2DManager()
- (id)init;
- (void)dealloc;
@end

@implementation LAppLive2DManager

static LAppLive2DManager* s_instance = nil;


void FinishedMotion(Csm::ACubismMotion* self) {
    LAppPal::PrintLog("Motion Finished: %x", self);
}

+ (LAppLive2DManager*)getInstance {
    @synchronized(self)
    {
        if(s_instance == nil {
            s_instance = [[LAppLive2DManager alloc] init];
        }
    }
    return s_instance;
}

+ (void)releaseInstance {
    if(s_instance != nil) {
        s_instance = nil;
    }
}

- (id)init {
    self = [super init];
    if ( self ) {
        _viewMatrix = nil;
        _sceneIndex = 0;

        _viewMatrix = new Csm::CubismMatrix44();

//        [self changeScene:_sceneIndex];
//        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Res" ofType:@"bundle"];
//        NSString *modelPath = [NSString stringWithFormat:@"%@/Haru/", bundlePath];
//        [self defaultScene:@"/Res.bundle/Haru/" modelJsonName:@"Haru.model3.json"];
//        [self changeScene:modelPath modelJsonName:@"Haru.model3.json"];
    }
    return self;
}

- (void)defaultScene:(NSString *)path modelJsonName:(NSString *)jsonName {
    if (path != nil && path.length > 0 && jsonName != nil && jsonName.length > 0) {
        if (LAppDefine::DebugLogEnable) {
            LAppPal::PrintLog("[APP]model index: %d", _sceneIndex);
        }

        // 从ModelDir[]中保存的目录名称
        // 决定model3.json的传球。
        // 使目录名和model3.json的名字一致。
    //    std::string model = LAppDefine::ModelDir[index];
    //    std::string modelPath = "/Res.bundle/" + model + "/";
    //    std::string modelJsonName = LAppDefine::ModelDir[index];
    //    modelJsonName += ".model3.json";
        
        std::string modelPath = [path UTF8String];
        std::string modelJsonName = [jsonName UTF8String];

        [self releaseAllModel];
        _models.PushBack(new LAppModel());
        _models[0]->DefaultLoadAssets(modelPath.c_str(), modelJsonName.c_str());

        /*
         * 提出进行模型半透明显示的样品。
         * 这里定义了USE RENDER TARGET、USE MODEL RENDER TARGET的情况
         * 在另一个渲染目标上绘制模型，将绘制结果作为纹理粘贴在另一个拼接上。
         */
        {
    #if defined(USE_RENDER_TARGET)
            // 在LAppView的目标上进行绘制时，请选择此项
            SelectTarget useRenderTarget = SelectTarget_ViewFrameBuffer;
    #elif defined(USE_MODEL_RENDER_TARGET)
            // 如果要绘制每个LAppModel的目标，请选择此项
            SelectTarget useRenderTarget = SelectTarget_ModelFrameBuffer;
    #else
            // 在默认的主帧缓冲器中呈现（通常）
            SelectTarget useRenderTarget = SelectTarget_None;
    #endif

    #if defined(USE_RENDER_TARGET) || defined(USE_MODEL_RENDER_TARGET)
            // 作为个别添加α的样品，制作另一个模型，稍微错开位置
            _models.PushBack(new LAppModel());
            _models[1]->LoadAssets(modelPath.c_str(), modelJsonName.c_str());
            _models[1]->GetModelMatrix()->TranslateX(0.2f);
    #endif

            float clearColorR = 1.0f;
            float clearColorG = 1.0f;
            float clearColorB = 1.0f;

            AppDelegate* delegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
            LAppViewController* view = [delegate lAppViewController];

            [view SwitchRenderingTarget:useRenderTarget];
            [view SetRenderTargetClearColor:clearColorR g:clearColorG b:clearColorB];
        }
    }
}

- (void)dealloc {
    [self releaseAllModel];
}

- (void)releaseAllModel {
    for (Csm::csmUint32 i = 0; i < _models.GetSize(); i++) {
        delete _models[i];
    }

    _models.Clear();
}

- (LAppModel*)getModel:(Csm::csmUint32)no {
    if (no < _models.GetSize()) {
        return _models[no];
    }
    return nil;
}

- (void)onDrag:(Csm::csmFloat32)x floatY:(Csm::csmFloat32)y {
    for (Csm::csmUint32 i = 0; i < _models.GetSize(); i++) {
        Csm::CubismUserModel* model = static_cast<Csm::CubismUserModel*>([self getModel:i]);
        model->SetDragging(x,y);
    }
}

- (void)onTap:(Csm::csmFloat32)x floatY:(Csm::csmFloat32)y {
    if (LAppDefine::DebugLogEnable) {
        LAppPal::PrintLog("[APP]tap point: {x:%.2f y:%.2f}", x, y);
    }

    for (Csm::csmUint32 i = 0; i < _models.GetSize(); i++) {
        if(_models[i]->HitTest(LAppDefine::HitAreaNameHead,x,y)) {
            if (LAppDefine::DebugLogEnable) {
                LAppPal::PrintLog("[APP]hit area: [%s]", LAppDefine::HitAreaNameHead);
            }
            _models[i]->SetRandomExpression();
        } else if (_models[i]->HitTest(LAppDefine::HitAreaNameBody, x, y)) {
            if (LAppDefine::DebugLogEnable) {
                LAppPal::PrintLog("[APP]hit area: [%s]", LAppDefine::HitAreaNameBody);
            }
            _models[i]->StartRandomMotion(LAppDefine::MotionGroupTapBody, LAppDefine::PriorityNormal, FinishedMotion);
        }
    }
}

- (void)onUpdate {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int width = screenRect.size.width;
    int height = screenRect.size.height;

    AppDelegate* delegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    LAppViewController* view = [delegate lAppViewController];

    Csm::CubismMatrix44 projection;
    Csm::csmUint32 modelCount = _models.GetSize();
    for (Csm::csmUint32 i = 0; i < modelCount; ++i) {
        LAppModel* model = [self getModel:i];
        if (model->GetModel()->GetCanvasWidth() > 1.0f && width < height) {
          // 在纵向窗口中显示横向长的模型时，根据模型的横向尺寸计算scale
          model->GetModelMatrix()->SetWidth(2.0f);
          projection.Scale(1.0f, static_cast<float>(width) / static_cast<float>(height));
        } else {
          projection.Scale(static_cast<float>(height) / static_cast<float>(width), 1.0f);
        }

        // 必要时在这里相乘
        if (_viewMatrix != NULL) {
          projection.MultiplyByMatrix(_viewMatrix);
        }

        [view PreModelDraw:*model];

        model->Update();
        model->Draw(projection);///< 因为是参考交货，所以projection变质

        [view PostModelDraw:*model];
    }
}

- (void)nextScene; {
    Csm::csmInt32 no = (_sceneIndex + 1) % LAppDefine::ModelDirSize;
//    [self changeScene:no];
}

- (void)changeScene:(NSString *)path modelJsonName:(NSString *)jsonName {
    if (path != nil && path.length > 0 && jsonName != nil && jsonName.length > 0) {
        if (LAppDefine::DebugLogEnable) {
            LAppPal::PrintLog("[APP]model index: %d", _sceneIndex);
        }

        // ModelDir[]に保持したディレクトリ名から
        // model3.jsonのパスを決定する.
        // ディレクトリ名とmodel3.jsonの名前を一致させておくこと.
    //    std::string model = LAppDefine::ModelDir[index];
    //    std::string modelPath = "/Res.bundle/" + model + "/";
    //    std::string modelJsonName = LAppDefine::ModelDir[index];
    //    modelJsonName += ".model3.json";
        
        std::string modelPath = [path UTF8String];
        std::string modelJsonName = [jsonName UTF8String];

        [self releaseAllModel];
        _models.PushBack(new LAppModel());
        _models[0]->LoadAssets(modelPath.c_str(), modelJsonName.c_str());

        /*
         * モデル半透明表示を行うサンプルを提示する。
         * ここでUSE_RENDER_TARGET、USE_MODEL_RENDER_TARGETが定義されている場合
         * 別のレンダリングターゲットにモデルを描画し、描画結果をテクスチャとして別のスプライトに張り付ける。
         */
        {
    #if defined(USE_RENDER_TARGET)
            // LAppViewの持つターゲットに描画を行う場合、こちらを選択
            SelectTarget useRenderTarget = SelectTarget_ViewFrameBuffer;
    #elif defined(USE_MODEL_RENDER_TARGET)
            // 各LAppModelの持つターゲットに描画を行う場合、こちらを選択
            SelectTarget useRenderTarget = SelectTarget_ModelFrameBuffer;
    #else
            // デフォルトのメインフレームバッファへレンダリングする(通常)
            SelectTarget useRenderTarget = SelectTarget_None;
    #endif

    #if defined(USE_RENDER_TARGET) || defined(USE_MODEL_RENDER_TARGET)
//             モデル個別にαを付けるサンプルとして、もう1体モデルを作成し、少し位置をずらす
            _models.PushBack(new LAppModel());
            _models[1]->LoadAssets(modelPath.c_str(), modelJsonName.c_str());
            _models[1]->GetModelMatrix()->TranslateX(0.2f);
    #endif

            float clearColorR = 1.0f;
            float clearColorG = 1.0f;
            float clearColorB = 1.0f;

            AppDelegate* delegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
            LAppViewController* view = [delegate lAppViewController];

            [view SwitchRenderingTarget:useRenderTarget];
            [view SetRenderTargetClearColor:clearColorR g:clearColorG b:clearColorB];
        }
    }
}

//- (void)changeScene:(Csm::csmInt32)index;
//{
//    _sceneIndex = index;
//    if (LAppDefine::DebugLogEnable)
//    {
//        LAppPal::PrintLog("[APP]model index: %d", _sceneIndex);
//    }
//
//    // ModelDir[]に保持したディレクトリ名から
//    // model3.jsonのパスを決定する.
//    // ディレクトリ名とmodel3.jsonの名前を一致させておくこと.
////    std::string model = LAppDefine::ModelDir[index];
////    std::string modelPath = "/Res.bundle/" + model + "/";
////    std::string modelJsonName = LAppDefine::ModelDir[index];
////    modelJsonName += ".model3.json";
//
//    std::string modelPath = "/Res.bundle/Haru/";
//    std::string modelJsonName = "Haru.model3.json";
//
//    [self releaseAllModel];
//    _models.PushBack(new LAppModel());
//    _models[0]->LoadAssets(modelPath.c_str(), modelJsonName.c_str());
//
//    /*
//     * モデル半透明表示を行うサンプルを提示する。
//     * ここでUSE_RENDER_TARGET、USE_MODEL_RENDER_TARGETが定義されている場合
//     * 別のレンダリングターゲットにモデルを描画し、描画結果をテクスチャとして別のスプライトに張り付ける。
//     */
//    {
//#if defined(USE_RENDER_TARGET)
//        // LAppViewの持つターゲットに描画を行う場合、こちらを選択
//        SelectTarget useRenderTarget = SelectTarget_ViewFrameBuffer;
//#elif defined(USE_MODEL_RENDER_TARGET)
//        // 各LAppModelの持つターゲットに描画を行う場合、こちらを選択
//        SelectTarget useRenderTarget = SelectTarget_ModelFrameBuffer;
//#else
//        // デフォルトのメインフレームバッファへレンダリングする(通常)
//        SelectTarget useRenderTarget = SelectTarget_None;
//#endif
//
//#if defined(USE_RENDER_TARGET) || defined(USE_MODEL_RENDER_TARGET)
//        // モデル個別にαを付けるサンプルとして、もう1体モデルを作成し、少し位置をずらす
//        _models.PushBack(new LAppModel());
//        _models[1]->LoadAssets(modelPath.c_str(), modelJsonName.c_str());
//        _models[1]->GetModelMatrix()->TranslateX(0.2f);
//#endif
//
//        float clearColorR = 1.0f;
//        float clearColorG = 1.0f;
//        float clearColorB = 1.0f;
//
//        AppDelegate* delegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
//        LAppViewController* view = [delegate lAppViewController];
//
//        [view SwitchRenderingTarget:useRenderTarget];
//        [view SetRenderTargetClearColor:clearColorR g:clearColorG b:clearColorB];
//    }
//}

- (Csm::csmUint32)GetModelNum; {
    return _models.GetSize();
}

- (void)SetViewMatrix:(Csm::CubismMatrix44*)m {
    for (int i = 0; i < 16; i++) {
        _viewMatrix->GetArray()[i] = m->GetArray()[i];
    }
}
@end
