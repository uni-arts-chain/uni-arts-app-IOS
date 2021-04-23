//
//  JLTool.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLTool : NSObject

/// 获取账户信息 如果是手机号码，去除国家编码
/// @param account 账号
+ (NSString *)getAccountWithNoCountryCode:(NSString *)account;

/// 获取文件大小
/// @param filePath 文件路径
+ (CGFloat)fileSizeWithPath:(NSString *)filePath;

/**
 获取当前视图控制器
 */
+ (UIViewController *)currentViewController;

/**
 获取今天几点的时间

 @param hour s小时
 @param min 分钟
 @return 返回date
 */
+ (NSDate*)getDateFromHour:(NSInteger)hour min:(NSInteger)min;
//时间中间间隔
+ (NSInteger)middleTimeWithFirstDate:(NSDate *)first LastDate:(NSDate *)lastDate;
//时间首尾间隔
+ (NSInteger)countWithTodayFirstDate:(NSDate *)first LastDate:(NSDate *)lastDate;
/** 一分钟前 */
+ (NSDate *)dateOneMinBefore:(NSDate*)data;
/** 30分钟前 */
+ (NSDate *)dateThirtyMinBefore:(NSDate *)data;
/** 一分钟后 */
+ (NSDate *)dateOneMinLater:(NSDate *)data;
/** 30分钟后 */
+ (NSDate *)dateThirtyMinLater:(NSDate *)data;

//attributedHeight;
+ (CGRect)getAdaptionSizeWithAttributedText:(NSMutableAttributedString *)sendAttributedText andFont:(CGFloat)sendFont andLabelWidth:(CGFloat)sendWidth LineSpace:(CGFloat)lineSpace;

/// attributedHeight
/// @param sendAttributedText sendAttributedText文本内容
/// @param sendFont 字体
/// @param sendWidth label宽度
/// @param lineSpace 行间距
+ (CGRect)getAdaptionSizeWithAttributedText:(NSMutableAttributedString *)sendAttributedText font:(UIFont *)sendFont labelWidth:(CGFloat)sendWidth lineSpace:(CGFloat)lineSpace;
//Label自适应高度
+ (CGSize)getAdaptionSizeWithText:(NSString *)sendText andFont:(CGFloat)sendFont andLabelWidth:(CGFloat)sendWidth;

/**
 Label自适应高度

 @param sendText 文本
 @param sendWidth 固定宽度
 @param font 字体样式
 @return labe的大小
 */
+ (CGSize)getAdaptionSizeWithText:(NSString *)sendText labelWidth:(CGFloat)sendWidth font:(UIFont *)font;
//Label自适应宽度
+ (CGSize)getAdaptionSizeWithText:(NSString *)sendText font:(CGFloat )sendFont labelHeight:(CGFloat)sendHeight;

//计算label的高度
+ (CGFloat)textViewHeightWithString:(NSString *)str andFont:(UIFont *)font andWidth:(CGFloat)width;

/**
 Label自适应宽度

 @param sendText 文本
 @param sendHeight 固定高度
 @param font 字体样式
 @return labe的大小
 */
+ (CGSize)getAdaptionSizeWithText:(NSString *)sendText labelHeight:(CGFloat)sendHeight font:(UIFont *)font;

/// 计算Label自适应宽度 - 单行显示
/// @param text label显示文字
/// @param height label高度
/// @param font label字体
+ (CGSize)labelWidth:(NSString *)text height:(CGFloat)height font:(UIFont *)font;

// 获取视频第一帧
+ (UIImage*)getVideoPreViewImage:(NSURL *)path;

/**
 获取视频时长

 @param url url
 @return 时长
 */
+ (NSInteger)getVideoTimeByUrl:(NSURL*)url;
/** 转换时间格式为 yyyy-MM-dd HH:mm */
+ (NSString *)timestampChangesStandarTime:(NSString *)timestamp;

+ (NSString *)setCreatTime:(NSString *)timeStr;

/**
 获取info.plist字典数据

 @return 字典数据
 */
+ (NSDictionary *)getInfoPlist;

/**
 检查相机是否可用

 @param viewController 当前视图控制器
 @return 相机是否可用
 */
+ (BOOL)checkCameraEnableWithController:(UIViewController *)viewController;

/// 检查相册权限是否可用
/// @param viewController 当前视图控制器
+ (BOOL)checkPhotoAuthorizationWithController:(UIViewController *)viewController;


/// 获取UUID生成的时间字符串
+ (NSString *)getUniqueStrByUUID;


+ (CALayer *)getShadowLayer:(CGRect)frame cornerRadius:(CGFloat)cornerRadius backgroundColor:(UIColor *)backgroundColor shadowColor:(UIColor *)shadowColor;

+(NSString*)showNumberCount:(NSDecimalNumber *)decimalNum zoneCount:(NSDecimalNumberHandler *)roundBe;
+(NSMutableAttributedString*)attrForStr:(NSString *)str keyStr:(NSString *)keyStr;

+(NSString*)addZoneAfterData:(NSString *)data zoneCount:(NSInteger)count;

//数字类型转换 12345678 -> 123,456,789
+(NSString*)numberFormatter:(NSString *)numString;

//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
+ (NSString *)firstCharactor:(NSString *)aString;

//格式化倒计时时间
+ (NSString*)getCountDown:(NSInteger)duration;

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

//去除字符串中所带的表情
+ (NSString *)disable_emoji:(NSString *)text;

/**
  判断是不是九宫格
  @param string 输入的字符
  @return YES(是九宫格拼音键盘)
  */
+ (BOOL)isNineKeyBoard:(NSString *)string;

+ (BOOL)isiPhoneX;

+ (UIViewController *)topViewController;

+ (void)resetRootViewControoler:(JLNavigationViewController *)navigationController;

+ (NSString *)getHexStringForData:(NSData *)data;

//通过图片Data数据第一个字节 来获取图片扩展名
+ (NSString *)contentTypeForImageData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
