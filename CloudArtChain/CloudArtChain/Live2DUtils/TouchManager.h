/**
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at https://www.live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#ifndef TouchManager_h
#define TouchManager_h

@interface TouchManager : NSObject

@property (nonatomic, readonly) float startX; // 开始触摸时的x值
@property (nonatomic, readonly) float startY; // 开始触摸时的x值
@property (nonatomic, readonly, getter=getX) float lastX; // 单触时的x值
@property (nonatomic, readonly, getter=getY) float lastY; // 单触时的y值
@property (nonatomic, readonly, getter=getX1) float lastX1; // 双触时的第一个x的值
@property (nonatomic, readonly, getter=getY1) float lastY1; // 双触时的第一个y的值
@property (nonatomic, readonly, getter=getX2) float lastX2; // 双触时的第二个x的值
@property (nonatomic, readonly, getter=getY2) float lastY2; // 双触时的第二个y的值
@property (nonatomic, readonly) float lastTouchDistance; // 用2根以上触摸时手指的距离
@property (nonatomic, readonly) float deltaX; // 从上次的值到这次的值的x的移动距离。
@property (nonatomic, readonly) float deltaY; // 从上次的值到这次的值的y的移动距离。
@property (nonatomic, readonly) float scale; // 以此框架相乘的放大率。放大操作中以外为1。
@property (nonatomic, readonly) float touchSingle; // 单触时是true
@property (nonatomic, readonly) float flipAvailable; // 触发是否有效

/**
 * @brief 初始化
 */
- (id)init;

/**
 * @brief 解放处理
 */
- (void)dealloc;

/*
 * @brief 开始触摸时的事件
 *
 * @param[in] deviceY    触摸画面的y值
 * @param[in] deviceX    触摸画面的x值
 */
- (void)touchesBegan:(float)deviceX DeciveY:(float)deviceY;

/*
 * @brief 拖拽事件
 *
 * @param[in] deviceX    触摸画面的x值
 * @param[in] deviceY    触摸画面的y值
 */
- (void)touchesMoved:(float)deviceX DeviceY:(float)deviceY;

/*
 * @brief 拖拽事件
 *
 * @param[in] deviceX1   第一个触摸画面的x值
 * @param[in] deviceY1   第一个触摸画面的y值
 * @param[in] deviceX2   第二个触摸画面的x值
 * @param[in] deviceY2   第二个触摸画面的y值
 */
- (void)touchesMoved:(float)deviceX1 DeviceY1:(float)deviceY1 DeviceX2:(float) deviceX2 DeviceY2:(float)deviceY2;

/*
 * @brief 褶边的距离测量
 *
 * @return 轻拂距离
 */
- (float)getFlickDistance;

/*
 * @brief 求点1到点2的距离
 *
 * @param[in] x1 第一个触摸画面的x值
 * @param[in] y1 第一个触摸画面的y值
 * @param[in] x2 第二个触摸画面的x值
 * @param[in] y2 第二个触摸画面的y值
 * @return   两点距离
 */
- (float)calculateDistance:(float)x1 TouchY1:(float)y1 TouchX2:(float)x2 TouchY2:(float)y2;

/*
 * 根据两个值计算移动量。
 * 不同方向的移动量为0。在相同方向的情况下，参照绝对值较小的值
 *
 * @param[in] v1    第一个移动量
 * @param[in] v2    第二个移动量
 *
 * @return   小移动量
 */
- (float)calculateMovingAmount:(float)v1 Vector2:(float)v2;

@end

#endif /* TouchManager_h */
