/**
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at https://www.live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#ifndef LAppPal_h
#define LAppPal_h

#import <CubismFramework.hpp>
#import <string>

/**
 * @brief 将平台依赖功能抽象化的Cubism Plaatform Abstraction Layer。
 *
 * 汇总与平台相关的函数，例如读取文件和获取时间
 *
 */
class LAppPal {
public:
    /**
     * @brief 读取文件作为字节数据
     *
     * 读取文件作为字节数据
     *
     * @param[in]   filePath    读取目标文件路径
     * @param[out]  outSize     文件大小
     * @return                  字节数据
     */
    static Csm::csmByte* LoadFileAsBytesWithBundle(const std::string filePath, Csm::csmSizeInt* outSize);
    
    /**
     * @brief 读取文件作为字节数据
     *
     * 读取文件作为字节数据
     *
     * @param[in]   filePath    读取目标文件路径
     * @param[out]  outSize     文件大小
     * @return                  字节数据
     */
    static Csm::csmByte* LoadFileAsBytes(const std::string filePath, Csm::csmSizeInt* outSize);


    /**
     * @brief 释放字节数据
     *
     * 释放字节数据
     *
     * @param[in]   byteData    想要解放的字节数据
     */
    static void ReleaseBytes(Csm::csmByte* byteData);

    /**
     * @biref   获得增量时间（与上一帧的差值）
     *
     * @return  增量时间[ms]
     *
     */
    static double GetDeltaTime() {return s_deltaTime;}

    /**
     * @brief 更新时间。
     */
    static void UpdateTime();

    /**
     * @brief 输出日志
     *
     * 输出日志
     *
     * @param[in]   format  格式字符串
     * @param[in]   ...     可变长度参数）字符串
     *
     */
    static void PrintLog(const Csm::csmChar* format, ...);

    /**
     * @brief 输出消息
     *
     * 输出消息
     *
     * @param[in]   message  字符串
     *
     */
    static void PrintMessage(const Csm::csmChar* message);

private:
    static double s_currentFrame;
    static double s_lastFrame;
    static double s_deltaTime;
};

#endif /* LAppPal_h */
