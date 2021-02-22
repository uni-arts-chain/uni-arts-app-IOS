//
//  JLAlert.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <LEEAlert/LEEAlert.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLAlert : LEEAlert
//配置通用颜色
+ (void)jlconfigCancelAction:(LEEAction*)action title:(NSString*)title;

+ (void)jlconfigConfirmAction:(LEEAction*)action title:(NSString*)title;

+ (void)jlalertView:(NSString*)message cancel:(NSString*)cancel;

+ (void)jlalertView:(NSString*)title message:(NSString*)message cancel:(NSString*)cancel;
+ (void)jlalertView:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel cancelBlock:(void(^)(void))cancelBlock confirm:(NSString *)confirm confirmBlock:(void(^)(void))confirmBlock;

+ (void)jlalertDefaultView:(NSString*)message cancel:(NSString*)cancel;
+ (void)jlalertDefaultView:(NSString*)title message:(NSString*)message cancel:(NSString*)cancel;
+ (void)jlalertDefaultView:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel cancelBlock:(void(^)(void))cancelBlock confirm:(NSString *)confirm confirmBlock:(void(^)(void))confirmBlock;

+ (void)alertCustomView:(UIView *)customView maxWidth:(CGFloat)maxWidth;
@end

NS_ASSUME_NONNULL_END
