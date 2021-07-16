//
//  JLCashContentView.h
//  CloudArtChain
//
//  Created by jielian on 2021/7/14.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JLCashContentViewDelegate <NSObject>

/// 添加收款码图片
/// @param type 支付宝或者微信
- (void)addImage:(NSInteger)type;

/// 提现
/// @param qrcode 提现收款码
- (void)withdraw: (UIImage *)qrcode;

@end

@interface JLCashContentView : UIView

@property (nonatomic, weak) id<JLCashContentViewDelegate> delegate;

@property (nonatomic, copy) NSString *alipayQRCodeImageUrl;

@property (nonatomic, copy) NSString *wechatQRCodeImageUrl;

@property (nonatomic, strong) UIImage *addAlipayQRCodeImage;

@property (nonatomic, strong) UIImage *addWechatQRCodeImage;

@end

NS_ASSUME_NONNULL_END
