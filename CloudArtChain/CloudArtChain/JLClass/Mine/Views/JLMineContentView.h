//
//  JLMineContentView.h
//  CloudArtChain
//
//  Created by jielian on 2021/6/21.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JLMineContentViewItemType) {
    /// 主页
    JLMineContentViewItemTypeHomePage,
    /// 上传作品
    JLMineContentViewItemTypeUploadWork,
    /// 买入订单
    JLMineContentViewItemTypeBuyOrder,
    /// 买入订单
    JLMineContentViewItemTypeSellOrder,
    /// 作品收藏
    JLMineContentViewItemTypeCollect,
    /// 消息
    JLMineContentViewItemTypeMessage,
    /// 客服
    JLMineContentViewItemTypeCustomerService,
    /// 平台积分
    JLMineContentViewItemTypeIntegral,
    /// 设置
    JLMineContentViewItemTypeSetting
};

@protocol JLMineContentViewDelegate <NSObject>
/// 跳转页面
- (void)jumpToVC: (JLMineContentViewItemType)itemType;

@end

@interface JLMineContentView : UIView

@property (nonatomic, weak) id<JLMineContentViewDelegate> delegate;

/// 积分余额
@property (nonatomic, copy) NSString *amount;

/// 更新用户信息
- (void)refreshInfo;

@end
