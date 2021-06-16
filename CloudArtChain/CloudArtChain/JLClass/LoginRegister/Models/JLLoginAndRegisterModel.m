//
//  JLLoginAndRegisterModel.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/25.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLLoginAndRegisterModel.h"

@implementation JLLoginAndRegisterModel
@end

// ==========================================================
#pragma mark /members/user_address_login 用户地址登录
@implementation Model_members_user_address_login_Req

@end

@implementation Model_members_user_address_login_Rsp
- (NSString *)interfacePath {
    return @"/members/user_address_login";
}
@end

// ==========================================================
#pragma mark 用户信息(持久化登录) /members/user_info
@implementation Model_members_user_info_Req
@end
@implementation Model_members_user_info_Rsp
- (NSString *)interfacePath {
    return @"members/user_info";
}
@end
// ==========================================================
#pragma mark /members/change_user_info 修改用户信息
@implementation Model_members_change_user_info_Req

@end
@implementation Model_members_change_user_info_Rsp
- (NSString *)interfacePath {
    return @"members/change_user_info";
}
@end
// ==========================================================
#pragma mark /v1/members/send_sms 发送绑定手机号验证码
@implementation Model_members_send_sms_Req
@end
@implementation Model_members_send_sms_Rsp
- (NSString *)interfacePath {
    return @"members/send_sms";
}
@end
// ==========================================================
#pragma mark /v1/members/bind_phone 绑定手机号码
@implementation Model_members_bind_phone_Req
@end
@implementation Model_members_bind_phone_Rsp
- (NSString *)interfacePath {
    return @"members/bind_phone";
}
@end
// ==========================================================
#pragma mark ------ 移动端
@implementation VersionUpdateBody
@end
#pragma mark 移动端版本信息 /mobile_versions/info
@implementation Model_mobile_versions_info_Req
@end
@implementation Model_mobile_versions_info_Rsp
- (NSString *)interfacePath {
    return @"mobile_versions/info";
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark 移动端版本下载 /mobile_versions/download
@implementation Model_mobile_versions_download_Req
@end
@implementation Model_mobile_versions_download_Rsp
- (NSString *)interfacePath {
    return @"mobile_versions/download";
}
// ==========================================================
@end
