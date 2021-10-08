//
//  UserDataBody.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//
#import <Foundation/Foundation.h>
@protocol Model_Image_Data @end
@interface Model_Image_Data : Model_Interface
@property (nonatomic, copy) NSString *url;
@end

@interface UserDataTokens : Model_Interface
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *expire_at;
+ (instancetype)userDataTokensWithToken:(NSString *)token expireAt:(NSString *)expireAt;
@end

@interface UserDataBody : Model_Interface <NSSecureCoding>
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *uid;
/** 用户编号 */
@property (nonatomic, strong) NSString *sn;
/** 注册邮箱 */
@property (nonatomic, strong) NSString *email;
/** 名称 */
@property (nonatomic, strong) NSString *display_name;
@property (nonatomic, strong) NSString *jwt_token;
/** 登录token */
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSNumber *session_expiry;
/** 注册手机号码*/
@property (nonatomic, strong) NSString *phone_number;
/** 注册类型 0-邮箱 1-手机 */
@property (nonatomic, assign) NSInteger register_type;
/** 实名认证标志 */
@property (nonatomic, assign) BOOL id_document_validated;
/** 开启两步验证  */
@property (nonatomic, assign) BOOL app_validated;
/** 资金密码设置 */
@property (nonatomic, assign) BOOL pay_password_validated;
@property (nonatomic, assign) BOOL is_large_customer;
@property (nonatomic, strong) NSString *off;
@property (nonatomic, strong) NSString *electricity_off;
/** 推荐码 */
@property (nonatomic, strong) NSString *ref_code;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, assign) BOOL paid;
/** 登录过期时间 */
@property (nonatomic, strong) NSString *expire_at;
/** 阅读协议标志 */
@property (nonatomic, assign) BOOL is_read_agreement;
/** 总算力 */
@property (nonatomic, strong) NSString *total_power_count;
/** 算力等级 */
@property (nonatomic, strong) NSString *mining_level;
/** 邀请等级 */
@property (nonatomic, strong) NSString *invitation_level;
/** 算力等级描述 */
@property (nonatomic, strong) NSString *mining_level_desc;
/** 算力等级算力限制 下限 */
@property (nonatomic, strong) NSString *mining_level_limit;
/** 是否绑定邀请关系 */
@property (nonatomic, assign) BOOL is_binding_invitation;
/** 钱包地址 */
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSDictionary *recommend_image;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSDictionary *avatar;
@property (nonatomic, assign) BOOL is_artist;
@property (nonatomic, strong) NSString *artist_desc;
@property (nonatomic, assign) NSInteger follow_user_size;
@property (nonatomic, assign) NSInteger following_user_size;
@property (nonatomic, assign) BOOL follow_by_me;
@property (nonatomic, assign) NSInteger favorite_art_size;
@property (nonatomic, assign) NSInteger art_size;
@property (nonatomic, strong) NSString *residential_address;
@property (nonatomic, strong) NSString *college;

/// 收款码
@property (nonatomic, copy) NSDictionary *weixin_img;
@property (nonatomic, copy) NSDictionary *alipay_img;

//Cha***@outlook.com
- (NSString*)getUserDisplayName;

- (NSString*)dealWithDisplayName;

//11***@qq.com
- (NSString*)getEmailString;

//显示的账户信息
- (NSString*)getShowAccount;

// 获取手机号码 不带有国家编码
- (NSString *)getPhoneNumberWithNoCountryCode;

//获取手机号
- (NSString*)getPhoneNumber;

// 获取手机号 不带有国家编码
- (NSString *)getPhoneNumberWithoutCountryCode;

//获取实名认证状态
- (NSString*)getRealNameState;

//实名认证未通过或未认证
- (BOOL)isUnverified;

//是否为手机注册
- (BOOL)isRegisterPhone;

- (UserDataTokens *)getToken;

- (NSString *)getAccount;

- (BOOL)isOwnAccount:(NSString *)account;

@end
