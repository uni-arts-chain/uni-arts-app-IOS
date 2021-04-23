/**
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at https://www.live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#ifndef LAppDefine_h
#define LAppDefine_h

#import <Foundation/Foundation.h>
#import <CubismFramework.hpp>

/**
 * @brief  Sample 在App中使用的常数
 *
 */
namespace LAppDefine {

    using namespace Csm;

    extern const csmFloat32 ViewScale;              ///< 缩放率
    extern const csmFloat32 ViewMaxScale;           ///< 最大缩放率
    extern const csmFloat32 ViewMinScale;           ///< 最小缩放率

    extern const csmFloat32 ViewLogicalLeft;        ///< 逻辑视图坐标系的左端值
    extern const csmFloat32 ViewLogicalRight;       ///< 逻辑视图坐标系的右边缘值
    extern const csmFloat32 ViewLogicalBottom;      ///< 逻辑视图坐标系的下端值
    extern const csmFloat32 ViewLogicalTop;         ///< 逻辑视图坐标系的上端值

    extern const csmFloat32 ViewLogicalMaxLeft;     ///< 逻辑视图坐标系左端的最大值
    extern const csmFloat32 ViewLogicalMaxRight;    ///< 逻辑视图坐标系右端的最大值
    extern const csmFloat32 ViewLogicalMaxBottom;   ///< 逻辑视图坐标系下端的最大值
    extern const csmFloat32 ViewLogicalMaxTop;      ///< 逻辑视图坐标系上边缘的最大值

//    extern const csmChar* ResourcesPath;            ///< 素材路径
    extern const csmChar* BackImageName;         ///< 背景图像文件
    extern const csmChar* GearImageName;         ///< 齿轮图像文件
    extern const csmChar* PowerImageName;        ///< 结束按钮图像文件

    // 模型定义--------------------------------------------
    extern const csmChar* ModelDir[];               ///< 配置了模型的目录名的排列.使目录名和model3.json的名字一致。
    extern const csmInt32 ModelDirSize;             ///< 模型目录排列大小

    // 匹配外部定义文件（json）
    extern const csmChar* MotionGroupIdle;          ///< 怠速时播放的动作列表
    extern const csmChar* MotionGroupTapBody;       ///< 点击身体时播放的动作列表

    // 匹配外部定义文件（json）
    extern const csmChar* HitAreaNameHead;          ///< 判定中的[Head]标签
    extern const csmChar* HitAreaNameBody;          ///< 判定中的[Body]标签

    // 动作优先度常数
    extern const csmInt32 PriorityNone;             ///< 动作优先级常数: 0
    extern const csmInt32 PriorityIdle;             ///< 动作优先级常数: 1
    extern const csmInt32 PriorityNormal;           ///< 动作优先级常数: 2
    extern const csmInt32 PriorityForce;            ///< 动作优先级常数: 3

    // 显示调试日志
    extern const csmBool DebugLogEnable;            ///< 启用/禁用调试日志显示
    extern const csmBool DebugTouchLogEnable;       ///< 触摸处理的调试用日志显示的有效/无效

    // 设置从Framework输出的日志级别
    extern const CubismFramework::Option::LogLevel CubismLoggingLevel;
}

#endif /* LAppDefine_h */
