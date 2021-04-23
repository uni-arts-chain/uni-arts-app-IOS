/**
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at https://www.live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

#include <Rendering/OpenGL/CubismOffscreenSurface_OpenGLES2.hpp>
#import "LAppModel.h"

@interface LAppViewController : GLKViewController <GLKViewDelegate>

typedef NS_ENUM(NSUInteger, SelectTarget)
{
    SelectTarget_None,                ///< 在默认帧缓冲器中呈现
    SelectTarget_ModelFrameBuffer,    ///< 在LAppModel各自具有的帧缓冲器中呈现
    SelectTarget_ViewFrameBuffer,     ///< 在LAppView的帧缓冲器中呈现
};

@property (nonatomic, assign) bool mOpenGLRun;
@property (nonatomic) GLuint vertexBufferId;
@property (nonatomic) GLuint fragmentBufferId;
@property (nonatomic) GLuint programId;

@property (nonatomic) bool anotherTarget;
@property (nonatomic) Csm::Rendering::CubismOffscreenFrame_OpenGLES2 renderBuffer;

@property (nonatomic) float spriteColorR;
@property (nonatomic) float spriteColorG;
@property (nonatomic) float spriteColorB;
@property (nonatomic) float spriteColorA;
@property (nonatomic) float clearColorR;
@property (nonatomic) float clearColorG;
@property (nonatomic) float clearColorB;
@property (nonatomic) float clearColorA;
@property (nonatomic) SelectTarget renderTarget;

/**
 * @brief 解放处理
 */
- (void)dealloc;

/**
 * @brief 解放
 */
- (void)releaseView;

/**
 * @brief 进行图像的初始化。
 */
- (void)initializeSprite;

/**
 * @brief 将X坐标转换成View坐标。
 *
 * @param[in]       deviceX            设备X坐标
 */
- (float)transformViewX:(float)deviceX;

/**
 * @brief 将Y坐标转换成View坐标。
 *
 * @param[in]       deviceY            设备Y坐标
 */
- (float)transformViewY:(float)deviceY;

/**
 * @brief 将X坐标转换成Screen坐标。
 *
 * @param[in]       deviceX            设备X坐标
 */
- (float)transformScreenX:(float)deviceX;

/**
 * @brief 把Y坐标转换成Screen坐标。
 *
 * @param[in]       deviceY            设备Y坐标
 */
- (float)transformScreenY:(float)deviceY;

/**
 * @brief   在绘制一个模型之前呼叫
 */
- (void)PreModelDraw:(LAppModel&) refModel;

/**
 * @brief   绘制一个模型后立即呼叫
 */
- (void)PostModelDraw:(LAppModel&) refModel;

/**
 * @brief   在不同的渲染目标中绘制模型的样本
 *           确定绘制时的α
 */
- (float)GetSpriteAlpha:(int)assign;

/**
 * @brief 在渲染处切换
 */
- (void)SwitchRenderingTarget:(SelectTarget) targetType;

/**
 * @brief 将渲染目标切换到非默认背景时设置背景清透色
 * @param[in]   r   赤(0.0~1.0)
 * @param[in]   g   緑(0.0~1.0)
 * @param[in]   b   青(0.0~1.0)
 */
- (void)SetRenderTargetClearColor:(float)r g:(float)g b:(float)b;

@end
