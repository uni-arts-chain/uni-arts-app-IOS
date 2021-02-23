//
//  JLTool.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLTool.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/PHPhotoLibrary.h>

@implementation JLTool
/// 获取账户信息 如果是手机号码，去除国家编码
/// @param account 账号
+ (NSString *)getAccountWithNoCountryCode:(NSString *)account {
    if (![JLUtils isValidateEmail:account]) {
        if (account.length == 13 && [account hasPrefix:@"86"]) {
            return [account substringFromIndex:2];
        }
    }
    return account;
}

+ (CGFloat)fileSizeWithPath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    BOOL isExist = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    if (isExist) {
        if (isDir) {
            NSEnumerator *childFilesEnumerator = [[fileManager subpathsAtPath:filePath] objectEnumerator];
            NSString* fileName;
            CGFloat folderSize = 0;
            while ((fileName = [childFilesEnumerator nextObject]) != nil){
                NSString* fileAbsolutePath = [filePath stringByAppendingPathComponent:fileName];
                folderSize += [JLTool fileSizeWithPath:fileAbsolutePath];
            }
            return folderSize / 1024.0f / 1024.0f;
        } else {
            CGFloat fileSize = [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
            return fileSize;
        }
    }
    return 0.0f;
}

+ (UIViewController *)currentViewController {
    return [self currentViewController:nil];
}

+ (UIViewController *)currentViewController:(UIViewController *)baseVc {
    UIViewController *nav = [self appRootViewController];
    if (baseVc) {
        nav = baseVc;
    }
    if ([nav isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController *nav2 = (UINavigationController *) nav;
        return [nav2.viewControllers lastObject];
    } else  if ([nav isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabvc = (UITabBarController *)nav;
        UIViewController * tabbarChildNav = [tabvc.viewControllers objectAtIndex:tabvc.selectedIndex];
        return [self currentViewController:tabbarChildNav];
    }
    return nav;
}

+ (UIViewController *)appRootViewController {
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    __block UIViewController *topVC;
    dispatch_main_async_safe(^{
        UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        topVC = appRootVC;
        while (topVC.presentedViewController) {
            topVC = topVC.presentedViewController;
        }
        dispatch_semaphore_signal(signal);
    });
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    return topVC;
}

+(NSDate*)getDateFromHour:(NSInteger)hour min:(NSInteger)min {
    NSTimeZone *gmt = [NSTimeZone localTimeZone];
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    [calendar setTimeZone:gmt];
    NSDate *date = [NSDate date];
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:date];
    [components setHour:hour];
    [components setMinute:min];
    [components setSecond: 0];
    NSDate *getDate = [calendar dateFromComponents:components];
    return getDate;
}

+(NSInteger)middleTimeWithFirstDate:(NSDate *)first LastDate:(NSDate *)lastDate {
    NSTimeInterval firstInterval=[first timeIntervalSince1970];
    NSTimeInterval lastInterval=[lastDate timeIntervalSince1970];
    NSInteger middle = (lastInterval - firstInterval) / 60;
    return middle;
}

+ (NSInteger)countWithTodayFirstDate:(NSDate *)first LastDate:(NSDate *)lastDate {
    NSTimeInterval firstInterval = [first timeIntervalSince1970] + 60 * 60 * 12;//后一天的时间
    NSTimeInterval lastInterval = [lastDate timeIntervalSince1970];
    NSInteger last = (firstInterval - lastInterval) / 60;
    
    return last;
}

+ (NSDate *)dateOneMinBefore:(NSDate*)data {
    NSTimeInterval interval= [data timeIntervalSince1970] - 60; // *1000 是精确到毫秒，
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return date;
}

+ (NSDate *)dateThirtyMinBefore:(NSDate *)data {
    NSTimeInterval interval = [data timeIntervalSince1970] - 60 * 30; // 30分钟前
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return date;
}

+ (NSDate *)dateOneMinLater:(NSDate *)data {
    NSTimeInterval interval=[data timeIntervalSince1970] +60; // *1000 是精确到毫秒，
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return date;
}

+ (NSDate *)dateThirtyMinLater:(NSDate *)data {
    NSTimeInterval interval = [data timeIntervalSince1970] + 60 * 30; //30分钟后
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return date;
}

+(CGRect)getAdaptionSizeWithAttributedText:(NSMutableAttributedString *)sendAttributedText andFont:(CGFloat)sendFont andLabelWidth:(CGFloat)sendWidth LineSpace:(CGFloat)lineSpace {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
     paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    [sendAttributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, sendAttributedText.length)];
    [sendAttributedText addAttribute:NSFontAttributeName value:kFontPingFangSCMedium(sendFont) range:NSMakeRange(0, sendAttributedText.length)];
    CGRect abelSize = [sendAttributedText boundingRectWithSize:CGSizeMake(sendWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return abelSize;
}

+ (CGRect)getAdaptionSizeWithAttributedText:(NSMutableAttributedString *)sendAttributedText font:(UIFont *)sendFont labelWidth:(CGFloat)sendWidth lineSpace:(CGFloat)lineSpace {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    [sendAttributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, sendAttributedText.length)];
    [sendAttributedText addAttribute:NSFontAttributeName value:sendFont range:NSMakeRange(0, sendAttributedText.length)];
    CGRect abelSize = [sendAttributedText boundingRectWithSize:CGSizeMake(sendWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return abelSize;
}

//Label自适应高度
+ (CGSize)getAdaptionSizeWithText:(NSString *)sendText andFont:(CGFloat)sendFont andLabelWidth:(CGFloat)sendWidth {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:kFontPingFangSCMedium(sendFont), NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize abelSize = [sendText boundingRectWithSize:CGSizeMake(sendWidth, 1999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return abelSize;
}

//Label自适应高度
+(CGSize) getAdaptionSizeWithText:(NSString *)sendText labelWidth:(CGFloat)sendWidth font:(UIFont *)font {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize abelSize = [sendText boundingRectWithSize:CGSizeMake(sendWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return abelSize;
}

//计算label的高度
+(CGFloat)textViewHeightWithString:(NSString *)str andFont:(UIFont *)font andWidth:(CGFloat)width {
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    textView.font = font;
    textView.text = str;
    [textView sizeToFit];
    
    CGFloat height = textView.contentSize.height;
    
    return height;
}

//Label自适应宽度
+(CGSize) getAdaptionSizeWithText:(NSString *)sendText font:(CGFloat )sendFont labelHeight:(CGFloat)sendHeight {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:kFontPingFangSCMedium(sendFont), NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize abelSize = [sendText boundingRectWithSize:CGSizeMake(999, sendHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return abelSize;
}

//Label自适应宽度
+ (CGSize)getAdaptionSizeWithText:(NSString *)sendText labelHeight:(CGFloat)sendHeight font:(UIFont *)font {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize abelSize = [sendText boundingRectWithSize:CGSizeMake(999, sendHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return abelSize;
}

/// 计算Label自适应宽度 - 单行显示
/// @param text label显示文字
/// @param height label高度
/// @param font label字体
+ (CGSize)labelWidth:(NSString *)text height:(CGFloat)height font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, height)];
    label.numberOfLines = 1;
    label.font = font;
    label.text = text;
    CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName: font}];
    return size;
}

// 获取视频第一帧
+ (UIImage*)getVideoPreViewImage:(NSURL *)path {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

/**
 获取视频时长
 
 @param url url
 @return 时长
 */
+ (NSInteger)getVideoTimeByUrl:(NSURL*)url {
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:url];
    CMTime time = [avUrl duration];
    int seconds = ceil(time.value/time.timescale);
    return seconds;
}


+ (NSString *)timestampChangesStandarTime:(NSString *)timestamp {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timestamp integerValue]/1000];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

//时间排序
+ (NSString *)setCreatTime:(NSString *)timeStr {
    NSDate* dat = [NSDate date];
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    NSString *timeString = @"";
    
    NSTimeInterval cha = now - [timeStr intValue]/1000;
    
    if (cha / 3600 < 1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha / 60];
        timeString = [timeString substringToIndex:timeString.length - 7];
        if ([timeString isEqualToString:@"0"])
        {
            timeString = [NSString stringWithFormat:@"%f", cha / 60];
            timeString = [NSString stringWithFormat:@"%d秒前", (int)([timeString floatValue] * 60)];
        }
        else
        {
            timeString = [NSString stringWithFormat:@"%@分钟前", timeString];
        }
    }
    if (cha / 3600 > 1 && cha / 86400 < 1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha / 3600];
        timeString = [timeString substringToIndex:timeString.length - 7];
        timeString = [NSString stringWithFormat:@"%@小时前", timeString];
    }
    if (cha / 86400 > 1)
    {
        timeString = [JLTool timestampChangesStandarTime:timeStr];
    }
    return timeString;
}



/**
 获取info.plist字典数据

 @return 字典数据
 */
+(NSDictionary *)getInfoPlist {
    NSDictionary *infoDict = [NSBundle mainBundle].localizedInfoDictionary;
    if (!infoDict || !infoDict.count) {
        infoDict = [NSBundle mainBundle].infoDictionary;
    }
    if (!infoDict || !infoDict.count) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        infoDict = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return infoDict ? infoDict : @{};
}

#pragma mark - - 检查相机是否可用
+ (BOOL)checkCameraEnableWithController:(UIViewController *)viewController {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            //请求权限
            dispatch_semaphore_t signal = dispatch_semaphore_create(0);
            __block BOOL userGranted = NO;
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    userGranted = YES;
                    dispatch_semaphore_signal(signal);
                } else {
                    NSLog(@"用户拒绝了访问相机权限!");
                    userGranted = NO;
                    dispatch_semaphore_signal(signal);
                }
            }];
            dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
            return userGranted;
        } else if(status == AVAuthorizationStatusAuthorized) {
            return YES;
        } else if(status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
            NSString *app_Name = [NSString getMyApplicationName];
            NSString *messageString = [NSString stringWithFormat:@"请去-> [设置 - 隐私 - 相机 - %@] 打开访问开关", app_Name];
            [JLAlert jlalertView:@"温馨提示" message:messageString cancel:@"确定"];
            return NO;
        }
    } else {
        //未监测到摄像头
        [JLAlert jlalertView:@"温馨提示" message:@"未检测到您的摄像头" cancel:@"确定"];
        return NO;
    }
    return NO;
}

+ (BOOL)checkPhotoAuthorizationWithController:(UIViewController *)viewController {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        //请求权限
        dispatch_semaphore_t signal = dispatch_semaphore_create(0);
        __block BOOL userGranted = NO;
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    userGranted = YES;
                    dispatch_semaphore_signal(signal);
                }else{
                    NSLog(@"用户拒绝了访问相册权限!");
                    userGranted = NO;
                    dispatch_semaphore_signal(signal);
                }
        }];
        dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
        return userGranted;
    } else if(status == AVAuthorizationStatusAuthorized) {
        return YES;
    } else if(status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
        NSString *app_Name = [NSString getMyApplicationName];
        NSString *messageString = [NSString stringWithFormat:@"请去-> [设置 - 隐私 - 照片 - %@] 打开访问开关", app_Name];
        [JLAlert jlalertView:@"温馨提示" message:messageString cancel:@"确定"];
        return NO;
    } else {
        return NO;
    }
}

+ (NSString *)getRequestIdValue {
    NSInteger timeInterval = [[NSDate date] timeIntervalSince1970];
    NSInteger random = (arc4random() % 999999);
    NSString *dateStr = [NSString stringWithFormat:@"iOS-%ld-%06ld", (long)timeInterval,(long)random];
    NSLog(@"requestId = %@",dateStr);
    return dateStr;
}

+ (NSString *)getUniqueStrByUUID {
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}

+ (CALayer *)getShadowLayer:(CGRect)frame cornerRadius:(CGFloat)cornerRadius backgroundColor:(UIColor *)backgroundColor shadowColor:(UIColor *)shadowColor {
    CALayer *layer = [CALayer layer];
    layer.frame = frame;
    layer.cornerRadius = cornerRadius;
    layer.backgroundColor = backgroundColor.CGColor;
    layer.masksToBounds = NO;
    layer.shadowColor = shadowColor.CGColor;
    layer.shadowOffset = CGSizeMake(0, 1.5f);
    layer.shadowOpacity = 0.16f;
    layer.shadowRadius = 3.0f;
    return layer;
}

//少于8位的就是8位多余的截取
+(NSString*)showNumberCount:(NSDecimalNumber *)decimalNum zoneCount:(NSDecimalNumberHandler *)roundBe{
    NSDecimalNumber *roundedNum = [decimalNum decimalNumberByRoundingAccordingToBehavior:roundBe];
    return [NSString stringWithFormat:@"%@",roundedNum];
}

+(NSMutableAttributedString*)attrForStr:(NSString *)str keyStr:(NSString *)keyStr{
    if (str == nil || str.length == 0 || keyStr == nil || keyStr.length == 0) {
        return nil;
    }
    NSMutableAttributedString *attrStr =[[NSMutableAttributedString alloc]initWithString:str];
    NSDictionary * attrDic =[NSDictionary dictionaryWithObjectsAndKeys:JL_color_gray_101010,NSForegroundColorAttributeName, nil];
    [attrStr setAttributes:attrDic range:[str rangeOfString:keyStr]];
    return attrStr;
}
//小数不足n位的补足n位0
+(NSString*)addZoneAfterData:(NSString *)data zoneCount:(NSInteger)count{
    NSString * newStr = nil;
    if (data==nil || !data.length) {
        return newStr;
    }
    if ([data containsString:@"."]) {
        NSArray * array =[data componentsSeparatedByString:@"."];
        NSString * zoneStr = array[1];
        NSInteger zoneCount = zoneStr.length;
        if (zoneCount == count) {
            newStr = data;
        }else if(zoneCount > count){
            NSString * pointStr = [zoneStr substringWithRange:NSMakeRange(0, count)];
            newStr = [NSString stringWithFormat:@"%@.%@",array[0],pointStr];
        }else{
            newStr = data;
            for (int i = 0; i<count-zoneCount; i++) {
                newStr = [newStr stringByAppendingString:@"0"];
            }
        }
    }else{
        newStr = [NSString stringWithFormat:@"%@.",data];
        for (int i = 0; i<count; i++) {
            newStr = [newStr stringByAppendingString:@"0"];
        }
    }
    return newStr;
}
//数字类型转换 12345678 -> 123,456,789 需要就调用这个方法
+(NSString*)numberFormatter:(NSString *)numString{
    if (!numString.length) {
        return @"--";
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    [formatter setPositiveFormat:@"###,##0.00"];
    NSString *string = [formatter stringFromNumber:[NSNumber numberWithDouble:[numString doubleValue]]];
    
    return string;
}

//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
+ (NSString *)firstCharactor:(NSString *)aString{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}


+ (NSString*)getCountDown:(NSInteger)duration
{
    long hour = duration/60/60;
    NSString *text = @"00:00";
    if (hour>0) {
        long minute = duration/60-hour*60;
        int second = duration%60;
        text = [NSString stringWithFormat:@"%02ld:%02ld:%02d",hour,minute,second];
    }else{
        long minute = duration/60;
        int second = duration%60;
        text = [NSString stringWithFormat:@"%02ld:%02d",minute,second];
    }
    return text;
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

//去除字符串中所带的表情
+ (NSString *)disable_emoji:(NSString *)text{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
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

+ (BOOL)isiPhoneX {
    if (@available(iOS 11.0, *)) {
        return UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom > 0;
    } else {
        return NO;
    }
}

+ (UIViewController *)topViewController:(UIViewController *)rootViewController{
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabController = (UITabBarController *)rootViewController;
        return [self topViewController:tabController.selectedViewController];
    }
    
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self topViewController:[navigationController.viewControllers lastObject]];
    }
    
    if (rootViewController.presentedViewController) {
        return [self topViewController:rootViewController.presentedViewController];
    }
    
    return rootViewController;
}

+ (void)resetRootViewControoler:(JLNavigationViewController *)navigationController {
    [AppSingleton sharedAppSingleton].globalNavController = navigationController;
    [JLViewControllerTool appDelegate].window.rootViewController = navigationController;
}

+ (NSString *)getHexStringForData:(NSData *)data {
    NSUInteger len = [data length];
    char *chars = (char *) [data bytes];
    NSMutableString *hexString = [[NSMutableString alloc] init];
    for (NSUInteger i = 0; i < len; i++) {
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx", chars[i]]];
    }
    return hexString;
}

@end
