//
//  JLLoginAndRegisterModel.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/25.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLLoginAndRegisterModel : NSObject
@end

// ==========================================================
#pragma mark /members/user_address_login 用户地址登录
@interface Model_members_user_address_login_Req : Model_Req
/** uart地址 */
@property (nonatomic, strong) NSString *address;
/** 加密内容 */
@property (nonatomic, strong) NSString *message;
/** 加密结果 */
@property (nonatomic, strong) NSString *signature;
/** 推送cid */
@property (nonatomic, strong) NSString *cid;
/** 系统类型 android|ios */
@property (nonatomic, strong) NSString *os;
@end

@interface Model_members_user_address_login_Rsp : Model_Rsp_V1
@property (nonatomic, strong) UserDataBody *body;
@end

// ==========================================================
#pragma mark 用户信息(持久化登录) /members/user_info
@interface Model_members_user_info_Req : Model_Req
@end
@interface Model_members_user_info_Rsp : Model_Rsp_V1
@property (nonatomic, strong) UserDataBody *body;
@end
// ==========================================================
#pragma mark /members/change_user_info 修改用户信息
@interface Model_members_change_user_info_Req : Model_Req
/** 昵称 */
@property (nonatomic, strong) NSString *display_name;
/** 头像 file */
@property (nonatomic, strong) NSString *avatar;
/** 性别(男1，女2) */
@property (nonatomic, strong) NSString *sex;
/** 描叙 */
@property (nonatomic, strong) NSString *desc;
/** 手机号：国家码+手机号 */
@property (nonatomic, strong) NSString *phone_number;
/** 真实姓名 */
@property (nonatomic, strong) NSString *real_name;
/** 证件号 */
@property (nonatomic, strong) NSString *id_document_number;
/** 艺术家头像 file */
@property (nonatomic, strong) NSString *recommend_image;
/** 艺术家描叙 */
@property (nonatomic, strong) NSString *artist_desc;
/** 居住地址 */
@property (nonatomic, strong) NSString *residential_address;
/** 毕业院校 */
@property (nonatomic, strong) NSString *college;
@end
@interface Model_members_change_user_info_Rsp : Model_Rsp_V1
@property (nonatomic, strong) UserDataBody *body;
@end
// ==========================================================
