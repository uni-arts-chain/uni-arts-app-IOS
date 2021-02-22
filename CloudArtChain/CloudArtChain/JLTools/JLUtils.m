//
//  JLUtils.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLUtils.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation JLUtils
+ (UIImage *)image:(UIImage *)image maxSideLength:(CGFloat)maxSideLength
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    
    CGFloat sourceWidth = sourceImage.size.width;
    CGFloat sourceHeight = sourceImage.size.height;
    
    CGSize targetSize;
    
    if (sourceWidth > sourceHeight) {
        
        CGFloat newHeight = sourceHeight * maxSideLength / sourceWidth;
        targetSize = CGSizeMake(maxSideLength, newHeight);
        
    } else {
        
        CGFloat newWidth = sourceWidth * maxSideLength / sourceHeight;
        targetSize = CGSizeMake(newWidth, maxSideLength);
    }
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointZero;
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage ;
}

//给数字字符串每隔3位加一个逗号 123，456，789
+ (NSString *)countNumAndChangeformat:(NSString *)num

{
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0) {
        count++;
        a /= 10;
    }
    if (!num||[num isEqualToString:@""]) {
        return @"0";
    }
    
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}

+ (UIImage *)compressImageTo100KB_ReturnImage:(UIImage *)image {
    NSInteger maxFileSize = 90*1024;//102400;
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}

+ (NSData *)compressImageTo100KB_ReturnData:(UIImage *)image {
    
    NSInteger maxFileSize = 90*1024;
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    return imageData;
}

//去掉string前后的空格
+ (NSString *)trimSpace:(NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

+ (NSString *)MD5ByAStr:(NSString *)aSourceStr {
    const char* cStr = [aSourceStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (NSInteger i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    return ret;
}

#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber {
    NSString *pattern = @"^(13[0-9]|14[0-9]|15[0-9]|16[0-9]|17[0-9]|18[0-9]|19[0-9])\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}

#pragma mark 正则匹配用户密码输入 数字或字母 1-18位
+ (BOOL)checkPasswordInputNumOrLetter:(NSString *)input {
    NSString *pattern = @"^[A-Za-z0-9]{1,18}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:input];
    return isMatch;
}



#pragma 正则匹配用户密码6-18位数字和字母组合  6-18
+ (BOOL)checkPasswordForNumAndLetter:(NSString *) password {
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}

//匹配由字母/数字组成的字符串的正则表达式
+ (BOOL) checkPasswordForNumOrLetter:(NSString *)password {
    NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,18}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}

// 表达式验证邮箱
+ (BOOL)isValidateEmail:(NSString *)email {
    NSString  *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate  *emailTest = [NSPredicate predicateWithFormat : @"SELF MATCHES%@",emailRegex];
    return  [emailTest  evaluateWithObject :email];
}

#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName:(NSString *)userName {
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5]{1,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
}

#pragma 正则匹配用户身份证号15或18位
+ (BOOL)checkUserIdCard:(NSString *)idCard {
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}

#pragma 正则匹员工号,12位的数字
+ (BOOL)checkEmployeeNumber:(NSString *)number {
    NSString *pattern = @"^[0-9]{12}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
}

#pragma 正则匹配URL
+ (BOOL)checkURL:(NSString *) url {
    NSString *pattern = @"^[0-9A-Za-z]{1,50}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:url];
    return isMatch;
}

+ (NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key {
    if (plaintext && key) {
        const char *cKey = [key cStringUsingEncoding:NSASCIIStringEncoding];
        const char *cData = [plaintext cStringUsingEncoding:NSUTF8StringEncoding];// NSASCIIStringEncoding
        unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
        CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
        NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
        const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
        NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
        for (int i = 0; i < HMACData.length; ++i){
            [HMAC appendFormat:@"%02x", buffer[i]];
        }
        return HMAC;
    }else {
        return nil;
    }
}

+ (BOOL)isChineseLanguage{
    
    NSArray *langArr = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    NSString *language = langArr.firstObject;
    
    // （iOS获取的语言字符串比较不稳定）目前框架只处理en、zh-Hans、zh-Hant三种情况，其他按照系统默认处理
//    NSString *language = [NSLocale preferredLanguages].firstObject;
    if ([language hasPrefix:@"en"]) {
        language = @"en";
        return NO;
    } else if ([language hasPrefix:@"zh"]) {
        if ([language rangeOfString:@"Hans"].location != NSNotFound) {
            language = @"zh-Hans"; // 简体中文
            return YES;
        } else { // zh-Hant\zh-HK\zh-TW
            language = @"zh-Hant"; // 繁體中文
            return YES;
        }
    } else {
        language = @"en";
        return NO;
    }
}

+ (BOOL)isRMB{
    
    NSString *priceArr = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppPrice"];
    if (!priceArr) {
        return NO;
    }
    if ([priceArr isEqualToString:@"CNY"]) {
        return NO;
    }else{
        return YES;
    }
    
    return YES;
}

+ (BOOL)isGreenAndRed{
    NSString *priceArr = [[NSUserDefaults standardUserDefaults] valueForKey:@"GreenAndRed"];
    if (!priceArr) {
        return NO;
    }
    if ([priceArr isEqualToString:@"Green"]) {
        return NO;
    }else{
        return YES;
    }
    
    return YES;
    
}


+ (NSString *)getLocalLanguage{
    NSString * language = nil;
    if ([self isChineseLanguage]) {
        language = @"zh-CN";
    }else{
        language = @"en";
    }
    return language;
}

/**
  *  判断字符串中是否存在emoji
  * @param string 字符
  * @return YES(含有表情)
  */
+ (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    return returnValue;
}

/**
  *  判断字符串中是否存在emoji
  * @param string 字符串
  * @return YES(含有表情)
  */
+ (BOOL)hasEmoji:(NSString*)string
{
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

/**
  判断是不是九宫格
  @param string 输入的字符
  @return YES(是九宫格拼音键盘)
  */
+ (BOOL)isNineKeyBoard:(NSString *)string

{
    NSString *other = @"➋➌➍➎➏➐➑➒";
    int len = (int)string.length;
    for(int i=0;i<len;i++)
    {
        if(!([other rangeOfString:string].location != NSNotFound))
            return NO;
    }
    return YES;
}
@end
