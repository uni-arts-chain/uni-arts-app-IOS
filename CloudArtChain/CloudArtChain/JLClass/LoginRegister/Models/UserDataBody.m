//
//  UserDataBody.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "UserDataBody.h"

@implementation UserDataTokens
- (instancetype)initWithToken:(NSString *)token expireAt:(NSString *)expireAt {
    if (self = [super init]) {
        self.token = token;
        self.expire_at = expireAt;
    }
    return self;
}

+ (instancetype)userDataTokensWithToken:(NSString *)token expireAt:(NSString *)expireAt {
    return [[UserDataTokens alloc] initWithToken:token expireAt:expireAt];
}
@end

@implementation UserDataBody
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}

#pragma mark - NSCoding Methods
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (NSString *)getUserDisplayName {
    if (self.display_name.length) {
        return [self dealWithDisplayName];
    } else if(self.email.length) {
        return [self getEmailString];
    } else if (self.phone_number.length) {
        return [self getPhoneNumber];
    } else {
        return @" ";
    }
}

#pragma mark 处理手机注册显示
- (NSString *)dealWithDisplayName {
    if (self.display_name.length) {
        if ([self.display_name hasSuffix:@"@phone.com"]) {
            NSRange range = [self.display_name rangeOfString:@"@phone.com"];
            NSString *displayName = [self.display_name substringToIndex:range.location];
            NSString *preStr = [displayName substringToIndex:5];
            NSString *subStr = [displayName substringFromIndex:displayName.length - 4];
            NSString *phoneNum = [NSString stringWithFormat:@"%@****%@", preStr, subStr];
            return phoneNum;
        }
        return self.display_name;
    }
    return nil;
}

#pragma mark 截取邮箱
- (NSString *)getEmailString {
    NSString *email = [self.email copy];
    if (email.length > 0) {
        NSRange range = [email rangeOfString:@"@"];
        NSUInteger index = 2;
        NSString *preStr = @" ";
        NSString *subStr = [email substringFromIndex:range.location];
        if (range.location >= index) {
            preStr = [email substringToIndex:index];
        } else {
            preStr = [email substringToIndex:range.location];
        }
        email = [NSString stringWithFormat:@"%@***%@", preStr, subStr];
    }
    return email;
}

#pragma mark 处理现实的账号信息
- (NSString *)getShowAccount {
    if (self.email.length) {
        if ([self.email hasSuffix:@"@phone.com"]) {
            NSRange range = [self.email rangeOfString:@"@phone.com"];
            NSString *displayName = [self.email substringToIndex:range.location];
            NSString *preStr = [displayName substringToIndex:5];
            NSString *subStr = [displayName substringFromIndex:displayName.length - 4];
            NSString *phoneNum = [NSString stringWithFormat:@"%@****%@", preStr, subStr];
            return phoneNum;
        } else {
            return [self getEmailString];
        }
    }
    return nil;
}

#pragma mark 截取手机号码
- (NSString *)getPhoneNumber {
    NSString *phoneNum = [self.phone_number copy];
    if (phoneNum.length > 11) {
        phoneNum = [NSString stringWithFormat:@"+%@", phoneNum];
        NSString *preStr = [phoneNum substringToIndex:6];
        NSString *subStr = [phoneNum substringFromIndex:phoneNum.length - 4];
        phoneNum = [NSString stringWithFormat:@"%@****%@", preStr, subStr];
    }
    return phoneNum;
}

- (NSString *)getPhoneNumberWithNoCountryCode {
    NSString *phoneNum = [self.phone_number copy];
    if (phoneNum.length > 11) {
        phoneNum = [phoneNum substringFromIndex:phoneNum.length - 11];
        NSString *preStr = [phoneNum substringToIndex:3];
        NSString *subStr = [phoneNum substringFromIndex:phoneNum.length - 4];
        phoneNum = [NSString stringWithFormat:@"%@****%@", preStr, subStr];
    }
    return phoneNum;
}

// 获取手机号 不带有国家编码
- (NSString *)getPhoneNumberWithoutCountryCode {
    NSString *phoneNum = [self.phone_number copy];
    if ([NSString stringIsEmpty:phoneNum]) {
        return @"";
    }
    if (phoneNum.length > 11) {
        phoneNum = [phoneNum substringFromIndex:phoneNum.length - 11];
    }
    return phoneNum;
}

- (NSString *)getRealNameState {
    NSString * resultStr = nil;
    BOOL aasm_state = self.id_document_validated;
    if (aasm_state) {
        resultStr = @"已认证";
    } else {
        resultStr = @"未认证";
    }
    return resultStr;
}

- (BOOL)isUnverified {
    BOOL aasm_state = self.id_document_validated;
    if (!aasm_state) {
        return YES;
    }
    return NO;
}

- (BOOL)isRegisterPhone {
    if (self.register_type == 1) {
        return YES;
    }
    return NO;
}

- (UserDataTokens *)getToken {
    return [UserDataTokens userDataTokensWithToken:self.token expireAt:self.expire_at];
}

- (NSString *)getAccount {
    if ([NSString stringIsEmpty:self.phone_number]) {
        return self.email;
    }
    return self.phone_number;
}

- (BOOL)isOwnAccount:(NSString *)account {
    if ([NSString stringIsEmpty:account]) {
        return NO;
    }
    if ([account isEqualToString:self.phone_number] || [account isEqualToString:self.email]) {
        return YES;
    }
    return NO;
}
@end
