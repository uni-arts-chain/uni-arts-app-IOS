/**
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at https://www.live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#ifndef LAppAllocator_h
#define LAppAllocator_h

#import "CubismFramework.hpp"
#import "ICubismAllocator.hpp"

/**
 * @brief 安装存储位置的班级。
 *
 * 实现内存确保和释放处理的接口。
 * 从框架中调用。
 *
 */
class LAppAllocator : public Csm::ICubismAllocator
{
    /**
     * @brief  分配内存区域。
     *
     * @param[in]   size    要指定的大小。
     * @return  指定的内存区域
     */
    void* Allocate(const Csm::csmSizeType size);

    /**
     * @brief   释放内存区域。
     *
     * @param[in]   memory    解放内存。
     */
    void Deallocate(void* memory);

    /**
     * @brief 重新分配内存区域。
     *
     * @param[in]   size         要指定的大小。
     * @param[in]   alignment    要指定的大小。
     * @return  alignedAddress
     */
    void* AllocateAligned(const Csm::csmSizeType size, const Csm::csmUint32 alignment);

    /**
     * @brief 释放内存区域。
     *
     * @param[in]   alignedMemory    解放内存。
     */
    void DeallocateAligned(void* alignedMemory);
};

#endif /* LAppAllocator_h */
