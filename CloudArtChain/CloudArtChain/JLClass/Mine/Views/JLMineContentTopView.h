//
//  JLMineContentTopView.h
//  CloudArtChain
//
//  Created by jielian on 2021/6/21.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JLMineContentTopViewDelegate <NSObject>

- (void)lookHomePage;

- (void)lookWallet;

- (void)lookSetting;

@end

@interface JLMineContentTopView : UIView

@property (nonatomic, weak) id<JLMineContentTopViewDelegate> delegate;

/// 积分余额
@property (nonatomic, copy) NSString *amount;

/// 更新用户信息
- (void)refreshInfo;

@end

