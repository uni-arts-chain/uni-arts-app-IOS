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
