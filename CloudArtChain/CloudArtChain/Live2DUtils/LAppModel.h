/**
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at https://www.live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#ifndef LAppModel_h
#define LAppModel_h

#import <CubismFramework.hpp>
#import <Model/CubismUserModel.hpp>
#import <ICubismModelSetting.hpp>
#import <Type/csmRectF.hpp>
#import <Rendering/OpenGL/CubismOffscreenSurface_OpenGLES2.hpp>

/**
 * @brief 用户实际使用的模型的实现类<br>
 *         进行模型生成、功能组件生成、更新处理和呈现的调用。
 *
 */
class LAppModel : public Csm::CubismUserModel {
public:
    /**
     * @brief 构造器
     */
    LAppModel();

    /**
     * @brief 析构器
     *
     */
    virtual ~LAppModel();

    /**
     * @brief 从放置了model3.json的目录和文件路径生成模型
     *
     */
    void LoadAssets(const Csm::csmChar* dir, const  Csm::csmChar* fileName);
    
    /**
     * @brief 从放置了model3.json的目录和文件路径生成模型
     *
     */
    void DefaultLoadAssets(const Csm::csmChar* dir, const  Csm::csmChar* fileName);

    /**
     * @brief 重建渲染
     *
     */
    void ReloadRenderer();

    /**
     * @brief   模型更新处理。根据模型参数确定绘制状态。
     *
     */
    void Update();

    /**
     * @brief   绘制模型处理。传递绘制模型的空间的View-Projection矩阵。
     *
     * @param[in]  matrix  View-Projection行列
     */
    void Draw(Csm::CubismMatrix44& matrix);

    /**
     * @brief   开始参数指定的动作的再生。
     *
     * @param[in]   group                       动作组名称
     * @param[in]   no                          组内的编号
     * @param[in]   priority                    优先级
     * @param[in]   onFinishedMotionHandler     动作再生结束时调用的回调函数。NULL的情况下，不被调用。
     * @return                                  返回开始动作的识别号码。用于判定个别动作是否结束的IsFinished（）参数。无法开始时为“-1”
     */
    Csm::CubismMotionQueueEntryHandle StartMotion(const Csm::csmChar* group, Csm::csmInt32 no, Csm::csmInt32 priority, Csm::ACubismMotion::FinishedMotionCallback onFinishedMotionHandler = NULL);

    /**
     * @brief   开始随机选择的动作的再生。
     *
     * @param[in]   group                       动作组名称
     * @param[in]   priority                    优先级
     * @param[in]   onFinishedMotionHandler     动作再生结束时调用的回调函数。NULL的情况下，不被调用。
     * @return                                  返回开始动作的识别号码。用于判定个别动作是否结束的IsFinished（）参数。无法开始时为“-1”
     */
    Csm::CubismMotionQueueEntryHandle StartRandomMotion(const Csm::csmChar* group, Csm::csmInt32 priority, Csm::ACubismMotion::FinishedMotionCallback onFinishedMotionHandler = NULL);

    /**
     * @brief   设定参数指定的表情动作
     *
     * @param   expressionID    表情动作的ID
     */
    void SetExpression(const Csm::csmChar* expressionID);

    /**
     * @brief   设定随机选择的表情动作
     *
     */
    void SetRandomExpression();

    /**
     * @brief   接受活动的点燃
     *
     */
    virtual void MotionEventFired(const Live2D::Cubism::Framework::csmString& eventValue);

    /**
     * @brief    判定测试
     *            根据指定ID的顶点列表计算矩形，判定坐标是否在矩形范围内。
     *
     * @param[in]   hitAreaName     每个测试判定的对象的ID
     * @param[in]   x               进行判定的X坐标
     * @param[in]   y               进行判定的Y坐标
     */
    virtual Csm::csmBool HitTest(const Csm::csmChar* hitAreaName, Csm::csmFloat32 x, Csm::csmFloat32 y);

    /**
     * @brief   获取绘制在其他目标中所用的缓冲区
     */
    Csm::Rendering::CubismOffscreenFrame_OpenGLES2& GetRenderBuffer();

protected:
    /**
     *  @brief  绘制模型处理。传递绘制模型的空间的View-Projection矩阵。
     *
     */
    void DoDraw();

private:
    /**
     * @brief 从model3.json生成模型。
     *         根据model3.json的描述，进行模型生成、运动、物理运算等组件生成。
     *
     * @param[in]   setting     ICubism ModelSetting的实例
     *
     */
    void SetupModel(Csm::ICubismModelSetting* setting);
    
    void DefaultSetupModel(Csm::ICubismModelSetting* setting);

    /**
     * @brief 在OpenGL的纹理单元中加载纹理
     *
     */
    void SetupTextures();

    /**
     * @brief   从组名中统一加载动作数据。
     *           动作数据的名称在内部从ModelSetting取得。
     *
     * @param[in]   group  动作数据组名称
     */
    void PreloadMotionGroup(const Csm::csmChar* group);
    
    void DefaultPreloadMotionGroup(const Csm::csmChar* group);

    /**
     * @brief   从组名中统一释放动作数据
     *           动作数据的名称在内部从ModelSetting取得。
     *
     * @param[in]   group  动作数据组名称
     */
    void ReleaseMotionGroup(const Csm::csmChar* group) const;

    /**
     * @brief 释放所有动作数据
     *
     * 释放所有的动作数据。
     */
    void ReleaseMotions();

    /**
     * @brief 释放所有表情数据
     *
     * 释放所有表情数据。
     */
    void ReleaseExpressions();

    Csm::ICubismModelSetting* _modelSetting; ///< 模型设置信息
    Csm::csmString _modelHomeDir; ///< 放置模型设置的目录
    Csm::csmFloat32 _userTimeSeconds; ///< 增量时间的累计值[秒]
    Csm::csmVector<Csm::CubismIdHandle> _eyeBlinkIds; ///< 模型中设置的眨眼功能参数ID
    Csm::csmVector<Csm::CubismIdHandle> _lipSyncIds; ///< 模型中设定的唇宿功能用参数ID
    Csm::csmMap<Csm::csmString, Csm::ACubismMotion*>   _motions; ///< 正在装入的动作列表
    Csm::csmMap<Csm::csmString, Csm::ACubismMotion*>   _expressions; ///< 装入表情列表
    Csm::csmVector<Csm::csmRectF> _hitArea;
    Csm::csmVector<Csm::csmRectF> _userArea;
    const Csm::CubismId* _idParamAngleX; ///< 参数ID: ParamAngleX
    const Csm::CubismId* _idParamAngleY; ///< 参数ID: ParamAngleX
    const Csm::CubismId* _idParamAngleZ; ///< 参数ID: ParamAngleX
    const Csm::CubismId* _idParamBodyAngleX; ///< 参数ID: ParamBodyAngleX
    const Csm::CubismId* _idParamEyeBallX; ///< 参数ID: ParamEyeBallX
    const Csm::CubismId* _idParamEyeBallY; ///< 参数ID: ParamEyeBallXY

    Csm::Rendering::CubismOffscreenFrame_OpenGLES2 _renderBuffer;
};

#endif /* LAppModel_h */
