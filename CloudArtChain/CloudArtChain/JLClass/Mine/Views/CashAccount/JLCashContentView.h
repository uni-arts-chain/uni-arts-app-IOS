//
//  JLCashContentView.h
//  CloudArtChain
//
//  Created by jielian on 2021/7/14.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const QRCodeImage;
extern NSString * const PayType;
extern NSString * const NeedUploadQRImage;

@protocol JLCashContentViewDelegate <NSObject>

/// 添加收款码图片
/// @param type 支付宝或者微信 1: 支付宝 2: 微信
- (void)addImage:(NSInteger)type;

/// 提现
/// @param qrInfoArray 提现收款码相关信息(二维码、支付方式、创建or更新)
/// @param needUploadCount 需要上传的数量 
/// @param withdrawType 选择提现方式 1: 支付宝 2: 微信
- (void)withdraw: (NSArray<NSDictionary *> *)qrInfoArray needUploadCount: (NSInteger)needUploadCount withdrawType: (NSInteger)withdrawType;

@end

@interface JLCashContentView : UIView

@property (nonatomic, weak) id<JLCashContentViewDelegate> delegate;

@property (nonatomic, copy) NSString *alipayImgUrl;

@property (nonatomic, copy) NSString *wechatImgUrl;

@property (nonatomic, strong) UIImage *addAlipayQRCodeImage;

@property (nonatomic, strong) UIImage *addWechatQRCodeImage;

@end

NS_ASSUME_NONNULL_END
