/**
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at https://www.live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#ifndef LAppLive2DManager_h
#define LAppLive2DManager_h

#import <CubismFramework.hpp>
#import <Math/CubismMatrix44.hpp>
#import <Type/csmVector.hpp>
#import "LAppModel.h"

@interface LAppLive2DManager : NSObject

@property (nonatomic) Csm::CubismMatrix44 *viewMatrix; //用于模型绘制的View矩阵
@property (nonatomic) Csm::csmVector<LAppModel*> models; //模型实例容器
@property (nonatomic) Csm::csmInt32 sceneIndex; //要显示的场景索引值
@property (nonatomic, strong) NSString *modelPath;
@property (nonatomic, strong) NSString *modelJsonName;

/**
 * @brief 返回班级实例。
 *        如果没有生成实例，则在内部生成实例。
 */
+ (LAppLive2DManager*)getInstance;

/**
 * @brief 释放班里的实例。
 */
+ (void)releaseInstance;

/**
 * @brief 返回当前场景中保持的模型。
 *
 * @param[in] no 模型列表的索引值
 * @return 返回模型实例。索引值超出范围时返回NULL。
 */
- (LAppModel*)getModel:(Csm::csmUint32)no;

/**
 * @breif 释放当前场景中保留的所有模型
 */
- (void)releaseAllModel;

/**
 * @brief   拖拽屏幕时的处理
 *
 * @param[in]   x   画面的X坐标
 * @param[in]   y   画面Y坐标
 */
- (void)onDrag:(Csm::csmFloat32)x floatY:(Csm::csmFloat32)y;

/**
 * @brief  点击画面时的处理
 *
 * @param[in]   x   画面的X坐标
 * @param[in]   y   画面Y坐标
 */
- (void)onTap:(Csm::csmFloat32)x floatY:(Csm::csmFloat32)y;

/**
 * @brief   更新画面时的处理
 *          更新和绘制模型
 */
- (void)onUpdate;

/**
 * @brief   切换到下一个场景
 *          在样本应用程序中切换模型集。
 */
- (void)nextScene;

/**
 * @brief   转换镜头
 *           在样本应用程序中切换模型集。
 */
//- (void)changeScene:(Csm::csmInt32)index;

- (void)changeScene:(NSString *)path modelJsonName:(NSString *)jsonName;

/**
 * @brief   得到模型个数
 * @return  所持模型个数
 */
- (Csm::csmUint32)GetModelNum;

/**
 * @brief   设定viewMatrix
 */
- (void)SetViewMatrix:(Csm::CubismMatrix44*)m;

@end


#endif /* LAppLive2DManager_h */
