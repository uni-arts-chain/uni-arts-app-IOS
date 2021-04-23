/**
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at https://www.live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#ifndef LAppTextureManager_h
#define LAppTextureManager_h

#import <string>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <Type/csmVector.hpp>

@interface LAppTextureManager : NSObject

/**
 * @brief 图像信息结构
 */
typedef struct
{
    GLuint id;              ///< 纹理ID
    int width;              ///< 宽度
    int height;             ///< 高度
    std::string fileName;       ///< 文件名
}TextureInfo;

/**
 * @brief 初始化
 */
- (id)init;

/**
 * @brief 解放处理
 *
 */
- (void)dealloc;


/**
 * @brief 预多级处理
 *
 * @param[in] red  图像Red值
 * @param[in] green  图像的Green值
 * @param[in] blue  图像的Blue值
 * @param[in] alpha  图像的Alpha值
 *
 * @return 预多级处理后的颜色值
 */
- (unsigned int)pemultiply:(unsigned char)red Green:(unsigned char)green Blue:(unsigned char)blue Alpha:(unsigned char) alpha;


/**
 * @brief 装入图像
 *
 * @param[in] fileName  要装入的图像文件路径名称
 * @return 图像信息。读取失败时返回NULL
 */
- (TextureInfo*)createTextureFromPngFile:(std::string)fileName;

- (TextureInfo*)createTextureFromPngFileWithBundle:(std::string)fileName;

/**
 * @brief 图像释放
 *
 * 释放数组中所有图像
 */
- (void)releaseTextures;

/**
 * @brief 图像释放
 *
 * 释放指定纹理ID的图像
 * @param[in] textureId  要释放的纹理ID
 **/
- (void)releaseTextureWithId:(Csm::csmUint32)textureId;

/**
 * @brief 图像释放
 *
 * 释放指定名称的图像
 * @param[in] fileName  要释放的图像文件路径名
 **/
- (void)releaseTextureByName:(std::string)fileName;

@end
#endif /* LAppTextureManager_h */
