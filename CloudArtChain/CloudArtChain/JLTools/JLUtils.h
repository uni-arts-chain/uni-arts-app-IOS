//
//  JLUtils.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLUtils : NSObject

+ (UIImage *)image:(UIImage *)image maxSideLength:(CGFloat)maxSideLength;

//给数字字符串每隔3位加一个逗号 123，456，789
+ (NSString *)countNumAndChangeformat:(NSString *)num;

+ (UIImage *)compressImageTo100KB_ReturnImage:(UIImage *)image;

+ (NSData *)compressImageTo100KB_ReturnData:(UIImage *)image;

//去掉string前后的空格
+ (NSString *)trimSpace:(NSString *)str;

// 是否是否为纯数字
+ (BOOL)isPureInt:(NSString *)string;

+ (NSString *)MD5ByAStr:(NSString *)aSourceStr;

#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber;

#pragma 正则表达式验证邮箱
+ (BOOL)isValidateEmail:(NSString *)email;

#pragma mark 正则匹配用户密码输入 数字或字母 1-18位
+ (BOOL)checkPasswordInputNumOrLetter:(NSString *)input;

#pragma 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPasswordForNumAndLetter:(NSString *) password;

//匹配由字母/数字组成的字符串的正则表达式
+ (BOOL)checkPasswordForNumOrLetter:(NSString *)password;

#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName:(NSString *)userName;

#pragma 正则匹配用户身份证号
+ (BOOL)checkUserIdCard:(NSString *)idCard;

#pragma 正则匹配URL
+ (BOOL)checkURL:(NSString *)url;

+ (NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key;

+ (BOOL)isChineseLanguage;

+ (BOOL)isRMB;

+ (BOOL)isGreenAndRed;



+ (NSString *)getLocalLanguage;

/**
  *  判断字符串中是否存在emoji
  * @param string 字符
  * @return YES(含有表情)
  */
+ (BOOL)stringContainsEmoji:(NSString *)string;

/**
  *  判断字符串中是否存在emoji
  * @param string 字符串
  * @return YES(含有表情)
  */
+ (BOOL)hasEmoji:(NSString*)string;

/**
  判断是不是九宫格
  @param string 输入的字符
  @return YES(是九宫格拼音键盘)
  */
+ (BOOL)isNineKeyBoard:(NSString *)string;

@end
