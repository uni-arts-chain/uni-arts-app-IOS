/**
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at https://www.live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#ifndef LAppSprite_h
#define LAppSprite_h

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "JLArtDetailViewController.h"

@interface LAppSprite : NSObject
@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (nonatomic, readonly, getter=GetTextureId) GLuint textureId; // 纹理ID
@property (nonatomic) float spriteColorR;
@property (nonatomic) float spriteColorG;
@property (nonatomic) float spriteColorB;
@property (nonatomic) float spriteColorA;

/**
 * @brief Rect 構造体。
 */
typedef struct {
    float left;     ///< 左边
    float right;    ///< 右边
    float up;       ///< 上边
    float down;     ///< 下边
} SpriteRect;

/**
 * @brief 初期化
 *
 * @param[in]       x            x坐标
 * @param[in]       y            y坐标
 * @param[in]       width        宽度
 * @param[in]       height       高度
 * @param[in]       textureId    纹理ID
 */
- (id)initWithMyVar:(float)x Y:(float)y Width:(float)width Height:(float)height TextureId:(GLuint) textureId;

- (id)initWithJLTextureId:(GLuint) textureId textureWidth:(float)width textureHeight:(float)height;

/**
 * @brief 解放处理
 */
- (void)dealloc;

/**
 * @brief 绘制
 *
 * @param[in]     vertexBufferID    片段模式ID
 * @param[in]     fragmentBufferID  调度器ID
 */
- (void)render:(GLuint)vertexBufferID fragmentBufferID:(GLuint)fragmentBufferID;


/**
 * @brief 绘制
 *
 * @param[in]     vertexBufferID    片段模式ID
 * @param[in]     fragmentBufferID  调度器ID
 */
- (void)renderImmidiate:(GLuint)vertexBufferID fragmentBufferID:(GLuint)fragmentBufferID TextureId:(GLuint) textureId uvArray:(float *)uvArray;


/**
 * @brief 构造器
 *
 * @param[in]       pointX    x坐标
 * @param[in]       pointY    y坐标
 */
- (bool)isHit:(float)pointX PointY:(float)pointY;

/**
 * @brief 颜色设置
 *
 * @param[in]       r       红色
 * @param[in]       g       绿色
 * @param[in]       b       蓝色
 * @param[in]       a       α
 */
- (void)SetColor:(float)r g:(float)g b:(float)b a:(float)a;

@end

#endif /* LAppSprite_h */
