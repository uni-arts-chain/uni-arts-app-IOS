/**
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at https://www.live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#import <Foundation/Foundation.h>
#import "LAppDefine.h"

namespace LAppDefine {

    using namespace Csm;

    // 画面
    const csmFloat32 ViewScale = 1.0f;
    const csmFloat32 ViewMaxScale = 2.0f;
    const csmFloat32 ViewMinScale = 0.8f;

    const csmFloat32 ViewLogicalLeft = -1.0f;
    const csmFloat32 ViewLogicalRight = 1.0f;
    const csmFloat32 ViewLogicalBottom = -1.0f;
    const csmFloat32 ViewLogicalTop = 1.0f;

    const csmFloat32 ViewLogicalMaxLeft = -2.0f;
    const csmFloat32 ViewLogicalMaxRight = 2.0f;
    const csmFloat32 ViewLogicalMaxBottom = -2.0f;
    const csmFloat32 ViewLogicalMaxTop = 2.0f;

    // 相对路径
//    const csmChar* ResourcesPath = [[[NSBundle mainBundle] pathForResource:@"Res" ofType:@""] UTF8String];

//    const csmChar* ResourcesPath = "Res/";
//      const csmChar* ResourcesPath = "/Res.bundle/";
//    const csmChar* ResourcesPath = [[NSString stringWithFormat:@"%@/", [[NSBundle mainBundle] pathForResource:@"Res" ofType:@"bundle"]] UTF8String];

    // 模型后面的背景图像文件
    const csmChar* BackImageName = "back_white.png";
    // 齿轮
    const csmChar* GearImageName = "icon_gear.png";
    // 结束按钮
    const csmChar* PowerImageName = "close_white.png";

    // 模型定义------------------------------------------
    // 配置模型的目录名称排列
    // 使目录名和model3.json的名字一致
    const csmChar* ModelDir[] = {
        "Haru",
        "Hiyori",
        "Mark",
        "Natori",
        "Rice"
    };
    const csmInt32 ModelDirSize = sizeof(ModelDir) / sizeof(const csmChar*);

    // 匹配外部定义文件（json）
    const csmChar* MotionGroupIdle = "Idle"; // 怠速
    const csmChar* MotionGroupTapBody = "TapBody"; // 点击头身体的时候

    // 匹配外部定义文件（json）
    const csmChar* HitAreaNameHead = "Head";
    const csmChar* HitAreaNameBody = "Body";

    // 动作优先度常数
    const csmInt32 PriorityNone = 0;
    const csmInt32 PriorityIdle = 1;
    const csmInt32 PriorityNormal = 2;
    const csmInt32 PriorityForce = 3;

    // 调试日志的显示选项
    const csmBool DebugLogEnable = true;
    const csmBool DebugTouchLogEnable = false;

    // 设置从Framework输出的日志级别
    const CubismFramework::Option::LogLevel CubismLoggingLevel = CubismFramework::Option::LogLevel_Verbose;
}
