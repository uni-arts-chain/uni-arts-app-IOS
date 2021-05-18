//
//  NSString+JLTool.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "NSString+JLTool.h"
#import <CommonCrypto/CommonCrypto.h>
#import "NSDate+Extension.h"

@implementation NSString (JLTool)
//将字典 转换成 json格式的字符串
+ (NSString* )dictionaryToJsonString:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//去除字符串中的空格
- (NSString *)deleteBlankSpace{
    NSString *string = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return string;
}

- (BOOL)isBlankString{
    if (self == nil) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([self isEqualToString:@"(null)"] || [self isEqualToString:@"<null>"] || [self isEqualToString:@"null"]) {
        return YES;
    }
    if ([self length] == 0) {
        return YES;
    }
    return NO;
}


+ (NSString *)hmacsha1:(NSString *)key string:(NSString *)string{
    if (string.length == 0) {
        return nil;
    }
    const char *cData = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [[NSData alloc] initWithBytes:cData length:strlen(cData)];
    return [NSString hmacsha1:key data:data];
}

+ (NSString *)hmacsha1:(NSString *)key data:(NSData *)data{
    if (key.length == 0) {
        return nil;
    }
    
    if (data.length == 0) {
        return nil;
    }
    NSData *key_data = [[NSData alloc] initWithBase64EncodedString:key options:0];
    //const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cKey = (const char *)[key_data bytes];
    //const char *cData = [string cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData =(const char *)[data bytes];
    //Sha256:
    // unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    //CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    //sha1
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC
                                          length:sizeof(cHMAC)];
    
    NSString *hash = [HMAC base64EncodedStringWithOptions:0];
    return hash;
}

+ (NSString *)randomString:(NSInteger)bytes{
    char *data = (char *)malloc(bytes);
    for (int x=0;x<bytes;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:bytes encoding:NSUTF8StringEncoding];
}

+ (NSString *)stringFromHexString:(NSString *)hexString { //
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    //    NSLog(@"解密后:%@",unicodeString);
    return unicodeString;
}

//普通字符串转换为十六进制的。
+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    //    NSLog(@"加密后:%@",hexStr);
    return hexStr;
}

+ (NSString*)MD5:(NSString *) srcString{
    // Create pointer to the string as UTF8
    const char *ptr = [srcString UTF8String];
    if( !ptr )
        return nil;
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x",md5Buffer[i]];
    }
    
    return output;
}

/**
 获取指定宽高的图片路径
 
 @param width 指定宽
 @param height 指定高
 @return 指定宽高路径
 */
- (NSString *)imagePathWithWidth:(CGFloat)width height:(CGFloat)height {
    return [self stringByAppendingString:[NSString stringWithFormat:@"?x-oss-process=image/resize,w_%ld,h_%ld,m_fill",@(width).longValue, @(height).longValue]];
}

/**
 获取指定宽度图片路径
 
 @param width 指定宽
 @return 指定宽图片路径
 */
- (NSString *)imagePathWithWidth:(CGFloat)width {
    return [self stringByAppendingString:[NSString stringWithFormat:@"?x-oss-process=image/resize,w_%ld,limit_0",@(width).longValue]];
}

/**
 获取指定高图片路径
 
 @param height 指定高
 @return 指定高度图片路径
 */
- (NSString *)imagePathWIthHeight:(CGFloat)height {
    return [self stringByAppendingString:[NSString stringWithFormat:@"?x-oss-process=image/resize,h_%ld,limit_0",@(height).longValue]];
}

/**
 设置手机号 344 样式
 
 @return 344样式手机号码
 */
- (NSString *)formatPhoneStyle {
    if (![NSString stringIsEmpty:self] && self.length == 11) {
        return [NSString stringWithFormat:@"%@ %@ %@", [self substringToIndex:3], [self substringWithRange:NSMakeRange(3, 4)], [self substringFromIndex:7]];
    } else {
        return self;
    }
}

/**
 判断字符为空
 
 @return 是否为空字符串
 */
+ (BOOL)stringIsEmpty:(NSString *)str {
    if (str == nil) {
        return YES;
    }
    if ([str isEqual: [NSNull null]]) {
        return YES;
    }
    if ([str isEqualToString:@""]) {
        return YES;
    }
    
    if ([str isEqualToString:@"nil"]) {
        return YES;
    }
    if ([str isEqualToString:@"<null>"]) {
        return YES;
    }
    if ([str isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([str isEqualToString:@"null"]) {
        return YES;
    }
    return NO;
}

/**
 获取URL中指定的参数
 
 @param name 参数名称
 @return 参数值
 */
- (NSString *)getUrlParamByName:(NSString *)name {
    NSError *error;
    NSString *regTags = [[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)", name];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags options:NSRegularExpressionCaseInsensitive error:&error];
    
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [self substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        return tagValue;
    }
    return @"";
}

/**
 
 获取url中的参数并返回
 
 @return @[NSString:无参数url, NSDictionary:参数字典]
 
 */
- (NSArray*)getParamsArray {
    if(self.length == 0) {
        NSLog(@"链接为空！");
        return @[@"", @{}];
    }
    //先截取问号
    NSArray*allElements = [self componentsSeparatedByString:@"?"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary]; //待set的参数字典
    
    if(allElements.count == 2) {
        //有参数或者?后面为空
        NSString *myUrlString = allElements[0];
        NSString *paramsString = allElements[1];
        //获取参数对
        NSArray*paramsArray = [paramsString componentsSeparatedByString:@"&"];
        if(paramsArray.count >= 2) {
            for(NSInteger i = 0; i < paramsArray.count; i++) {
                NSString *singleParamString = paramsArray[i];
                
                NSArray*singleParamSet = [singleParamString componentsSeparatedByString:@"="];
                if(singleParamSet.count == 2) {
                    NSString*key = singleParamSet[0];
                    NSString*value = singleParamSet[1];
                    if(key.length > 0 || value.length > 0) {
                        [params setObject:value.length > 0 ? value : @"" forKey:key.length > 0 ? key : @""];
                    }
                }
            }
        } else if(paramsArray.count == 1) {
            //无 &。url只有?后一个参数
            
            NSString *singleParamString = paramsArray[0];
            NSArray*singleParamSet = [singleParamString componentsSeparatedByString:@"="];
            if(singleParamSet.count == 2) {
                NSString*key = singleParamSet[0];
                NSString*value = singleParamSet[1];
                if(key.length > 0 || value.length > 0) {
                    [params setObject:value.length > 0 ? value : @"" forKey:key.length > 0 ? key : @""];
                }
            } else {
                //问号后面啥也没有 xxxx?  无需处理
            }
        }
        //整合url及参数
        return @[myUrlString, params];
    } else if (allElements.count > 2) {
        NSLog(@"链接不合法！链接包含多个\"?\"");
        return @[@"", @{}];
    } else {
        NSLog(@"链接不包含参数！");
        return@[self, @{}];
    }
}

/**
 获取App版本号 - BundleVersion
 
 @return BundleVersion版本号
 */
+ (NSString *)getMyApplicationBundleVersion {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    return [info objectForKey:@"CFBundleVersion"];
}

/**
 获取App版本号 - BundleShortVersion
 
 @return BundleShortVersion版本号
 */
+ (NSString *)getMyApplicationBundleShortVersion {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    return [info objectForKey:@"CFBundleShortVersionString"];
}

/**
 获取App版本号 - BundleShortVersion.BundleVersion
 
 @return BundleShortVersion.BundleVersion版本号
 */
+ (NSString *)getMyApplicationBundleFullVersion {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleVersion = [info objectForKey:@"CFBundleVersion"];
    NSString *shortVersion = [info objectForKey:@"CFBundleShortVersionString"];
    return [NSString stringWithFormat:@"%@.%@", shortVersion, bundleVersion];
}

/**
 获取App名称
 
 @return App名称
 */
+ (NSString *)getMyApplicationName {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [info objectForKey:@"CFBundleDisplayName"];
    if ([NSString stringIsEmpty:appName]) {
        appName = [info objectForKey:@"CFBundleName"];
    }
    return appName;
}

/**
 将NSData二进制数据转换成十六进制字符串
 
 @param data 二进制数据
 @return 十六进制字符串
 */
+ (NSString *)convertHexStrFromData:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}

/**
 将十六进制字符串转换成二进制数据
 
 @return 二进制数据NSData
 */
- (NSData *)convertHexStrToData {
    if (!self || [self length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([self length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [self length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [self substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

/**
 获取当前格式的时间字符串
 
 @param formater 格式
 @return 当前格式的时间字符串
 */
+ (NSString *)getCurrentTimeStr:(NSString *)formater {
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSString stringIsEmpty:formater] ? @"yyyyMMddHHmmss" : formater];
    NSDate *timeDate = [NSDate date];
    //得到与当前时间
    NSString *timeDateStr = [dateFormatter stringFromDate:timeDate];
    return timeDateStr;
}

/**
 检查是否为有效的密码设置
 
 @return 是否有效密码
 */
- (BOOL)detectionIsPasswordQualified {
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{8,16}";
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    return [pred evaluateWithObject:self];
}

/**
 消息列表返回特定格式的字符串
 
 @param dateStr 时间
 @return 返回格式化时间
 */
+ (NSString *)customFormatTimeWithTime:(NSString *)dateStr {
    return [self customFormatTimeWithTime:dateStr ShowTodayStr:NO];
}

/**
 返回特定格式的字符串 (带今天的字符串)
 
 @param dateStr 时间
 @return 返回格式化时间
 */
+ (NSString *)customFormatTimeWithShowTodayStrTime:(NSString *)dateStr {
    return [self customFormatTimeWithTime:dateStr ShowTodayStr:YES];
}

/**
 消息列表返回特定格式的字符串
 
 @param dateStr 时间
 @return 返回格式化时间
 */
+ (NSString *)customFormatTimeWithTime:(NSString *)dateStr ShowTodayStr:(BOOL)show {
    if (dateStr.length > 16) {//校园通知
        dateStr = [dateStr substringToIndex:16];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *formatDate = [formatter dateFromString:dateStr];
    NSString *messageDate = nil;
    if ([formatDate isToday]) {
        [formatter setDateFormat:@"HH:mm"];
        messageDate = show ? [NSString stringWithFormat:@"今天 %@",[formatter stringFromDate:formatDate]] : [formatter stringFromDate:formatDate];
    } else if([formatDate isYesterday]) {
        [formatter setDateFormat:@"HH:mm"];
        messageDate = [NSString stringWithFormat:@"昨天 %@",[formatter stringFromDate:formatDate]];
    } else if([formatDate isThisYear]) {
        [formatter setDateFormat:@"MM-dd HH:mm"];
        messageDate = [formatter stringFromDate:formatDate];
    } else {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        messageDate = [formatter stringFromDate:formatDate];
    }
    return  messageDate;
}


//日期和周几的格式
+ (NSString *)customWeekFormatDate:(NSString *)dateStr {
    if (dateStr.length > 10) {
        dateStr = [dateStr substringToIndex:10];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *formatDate = [formatter dateFromString:dateStr];

    NSString *weekStr = [self weekdayStringWithDate:formatDate simple:YES];
    NSString *dateValue = [NSString stringWithFormat:@"%@ %@",dateStr,weekStr];
    
    return dateValue;
}


+ (NSString *)weekdayStringWithDate:(NSDate *)date simple:(BOOL)simple {
    //获取星期几
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = [componets weekday]; //1代表周日，2代表周一，后面依次
    NSArray *weekArray = simple ? @[@"",@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"] : @[@"",@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    NSString *weekStr = weekArray[weekday];
    return weekStr;
}

/// 获取日期加周几
/// @param time 时间字符串 “yyyy-MM-dd”格式
+ (NSArray *)getDateStrAndWeekStr:(NSString *)time {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *formatDate = [formatter dateFromString:time];
    if ([formatDate isToday]) {
        return @[@"今天 ",[NSString weekdayStringWithDate:formatDate simple:YES]];
    } else if ([formatDate isYesterday]) {
        return @[@"昨天 ",[NSString weekdayStringWithDate:formatDate simple:YES]];
    } else {
        return @[[NSString stringWithFormat:@"%@ ",[formatDate stringWithFormat:@"MM-dd"]],[NSString weekdayStringWithDate:formatDate simple:YES]];
    }
}

/**
 通过给定一个时间格式的字符串 获得想要获取的时间格式的字符串

 @param dateStr 日期时间源字符串
 @param sourceFormatStr 日期时间源字符串的时间格式
 @param targetFormatStr 目标日期时间时间格式
 @return 目标字符串
 */
+ (NSString *)getDateFormatString:(NSString *)dateStr sourceFormat:(NSString *)sourceFormatStr targetFormat:(NSString *)targetFormatStr {
    NSDateFormatter *sourceFormatter = [[NSDateFormatter alloc] init];
    [sourceFormatter setDateFormat:sourceFormatStr];
    NSDate *sourceDate = [sourceFormatter dateFromString:dateStr];
    
    if (sourceDate == nil) {
        return @"";
    }
    
    NSString *targetDateStr = [sourceDate dateWithCustomFormat:targetFormatStr];
    return targetDateStr;
}

/**
 *  手机号码验证
 *
 *  @return 是否手机号
 */
- (BOOL)validateMobile {
    NSString *phoneRegex = @"^1\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}


/// 字符串转拼音
- (NSString *)transformToPinyin {
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return [mutableString stringByReplacingOccurrencesOfString:@"'" withString:@""];
}

/// 去除空格和回车
- (NSString *)removeBlankSpace {
    NSString *tempStr = self;
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    return tempStr;
}


/**
 *  字符串转富文本
 */
+ (NSAttributedString *)strToAttriWithStr:(NSString *)htmlStr {
    return [[NSAttributedString alloc] initWithData:[htmlStr dataUsingEncoding: NSUnicodeStringEncoding]
                                                options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                     documentAttributes: nil
                                              error: nil];
}

/**
 *  富文本转html字符串
 */
+ (NSString *)attriToStrWithAttri:(NSAttributedString *)attri {
    NSDictionary *tempDic = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                                  NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]};
        
        NSData *htmlData = [attri dataFromRange:NSMakeRange(0, attri.length)
                             documentAttributes:tempDic
                                          error: nil];
        
        return [[NSString alloc] initWithData:htmlData
                                     encoding:NSUTF8StringEncoding];
}

/**
 *获得富文本的高度
 **/
+ (CGFloat)getAttriHeightWithLabel:(UILabel *)label width:(CGFloat)width {
    CGFloat height = [label.attributedText boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    return height;
}

//urlEncode编码
+ (NSString *)urlEncodeStr:(NSString *)input {
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *upSign = [input stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return upSign;
}
//urlEncode解码
+ (NSString *)decoderUrlEncodeStr: (NSString *) input {
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+" withString:@"" options:NSLiteralSearch range:NSMakeRange(0,[outputStr length])];
    return [outputStr stringByRemovingPercentEncoding];
}

@end
