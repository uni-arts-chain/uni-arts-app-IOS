//
//  NSString+JLTool.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (JLTool)
//将字典 转换成 json格式的字符串
+ (NSString *)dictionaryToJsonString:(NSDictionary *)dic;

//去除字符串中的空格
- (NSString *)deleteBlankSpace;

//各种加密解密
+ (NSString *)hmacsha1:(NSString *)key string:(NSString *)string;
+ (NSString *)hmacsha1:(NSString *)key data:(NSData *)data;
+ (NSString *)randomString:(NSInteger)bytes;
+ (NSString *)stringFromHexString:(NSString *)hexString;   //解密
+ (NSString *)hexStringFromString:(NSString *)string;      //加密
+ (NSString*)MD5:(NSString *) srcString;//md5加密

/**
 获取指定宽高的图片路径

 @param width 指定宽
 @param height 指定高
 @return 指定宽高路径
 */
- (NSString *)imagePathWithWidth:(CGFloat)width height:(CGFloat)height;

/**
 获取指定宽度图片路径

 @param width 指定宽
 @return 指定宽图片路径
 */
- (NSString *)imagePathWithWidth:(CGFloat)width;

/**
 获取指定高图片路径

 @param height 指定高
 @return 指定高度图片路径
 */
- (NSString *)imagePathWIthHeight:(CGFloat)height;

/**
 设置手机号 344 样式

 @return 344样式手机号码
 */
- (NSString *)formatPhoneStyle;

/**
 判断字符为空

 @return 是否为空字符串
 */
+ (BOOL)stringIsEmpty:(NSString *)str;

/**
 获取URL中指定的参数
 
 @param name 参数名称
 @return 参数值
 */
- (NSString *)getUrlParamByName:(NSString *)name;


/**
 获取App版本号 - BundleVersion

 @return BundleVersion版本号
 */
+ (NSString *)getMyApplicationBundleVersion;

/**
 获取App版本号 - BundleShortVersion

 @return BundleShortVersion版本号
 */
+ (NSString *)getMyApplicationBundleShortVersion;


/**
 获取App版本号 - BundleShortVersion.BundleVersion

 @return BundleShortVersion.BundleVersion版本号
 */
+ (NSString *)getMyApplicationBundleFullVersion;

/**
 获取App名称

 @return App名称
 */
+ (NSString *)getMyApplicationName;

/**
 将NSData二进制数据转换成十六进制字符串
 
 @param data 二进制数据
 @return 十六进制字符串
 */
+ (NSString *)convertHexStrFromData:(NSData *)data;

/**
 将十六进制字符串转换成二进制数据
 
 @return 二进制数据NSData
 */
- (NSData *)convertHexStrToData;

/**
 获取当前格式的时间字符串

 @param formater 格式
 @return 当前格式的时间字符串
 */
+ (NSString *)getCurrentTimeStr:(NSString *)formater;

/**
 检查是否为有效的密码设置
 
 @return 是否有效密码
 */
- (BOOL)detectionIsPasswordQualified;

/**
 消息列表返回特定格式的字符串
 
 @param dateStr 时间
 @return 返回格式化时间
 */
+ (NSString *)customFormatTimeWithTime:(NSString *)dateStr;

/**
 返回特定格式的字符串 (带今天的字符串)
 
 @param dateStr 时间
 @return 返回格式化时间
 */
+ (NSString *)customFormatTimeWithShowTodayStrTime:(NSString *)dateStr;

/**
 *  手机号码验证
 *
 *  @return 是否手机号
 */
- (BOOL) validateMobile;

/**
 日期和周几的格式  如：2019-05-21 周四

 @param dateStr 日期
 @return 返回格式化时间
 */
+ (NSString *)customWeekFormatDate:(NSString *)dateStr;


/// 返回周几/星期几
/// @param date 日期时间
/// @param simple 是否是周几
+ (NSString *)weekdayStringWithDate:(NSDate *)date simple:(BOOL)simple;



/**
 通过给定一个时间格式的字符串 获得想要获取的时间格式的字符串
 
 @param dateStr 日期时间源字符串
 @param sourceFormatStr 日期时间源字符串的时间格式
 @param targetFormatStr 目标日期时间时间格式
 @return 目标字符串
 */
+ (NSString *)getDateFormatString:(NSString *)dateStr sourceFormat:(NSString *)sourceFormatStr targetFormat:(NSString *)targetFormatStr;

/// 获取日期加周几
/// @param time 时间字符串 “yyyy-MM-dd”格式
+ (NSArray *)getDateStrAndWeekStr:(NSString *)time;


/// 字符串转拼音
- (NSString *)transformToPinyin;

/// 去除空格和回车
- (NSString *)removeBlankSpace;


/**
 *  字符串转富文本
 */
+ (NSAttributedString *)strToAttriWithStr:(NSString *)htmlStr;


/**
 *  富文本转html字符串
 */
+ (NSString *)attriToStrWithAttri:(NSAttributedString *)attri;

/**
 *获得富文本的高度
 **/
+ (CGFloat)getAttriHeightWithLabel:(UILabel *)label width:(CGFloat)width;

+ (NSString *)urlEncodeStr:(NSString *)input;

+ (NSString *)decoderUrlEncodeStr: (NSString *)input;

@end

NS_ASSUME_NONNULL_END
